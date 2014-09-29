//
//  MBDataModel.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 8/22/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <RaptureXML/RXMLElement.h>
#import <MBToolbox/NSString+MBIndentation.h>
#import <MBToolbox/NSError+MBToolbox.h>

#import "MBDataModel.h"
#import "MBExpression.h"
#import "MBEnvironment.h"
#import "MBDataEnvironment.h"

#define DEBUG_LOCAL         0
#define DEBUG_VERBOSE		0

/******************************************************************************/
#pragma mark Public constants
/******************************************************************************/

NSString* const kMBDataModelDefaultRelation = @"child";

/******************************************************************************/
#pragma mark Private constants
/******************************************************************************/

#define kMBDataModelInitialAttributeCapacity    10
#define kMBDataModelAttributeOrderArchiveKey    @"_ordr"
#define kMBDataModelAttributesArchiveKey        @"_attr"
#define kMBDataModelRelativesArchiveKey         @"_rels"
#define kMBDataModelContentArchiveKey           @"_ctnt"
#define kMBDataModelXMLTagName                  @"_xtag"

/******************************************************************************/
#pragma mark -
#pragma mark MBDataModel implementation
/******************************************************************************/

@implementation MBDataModel
{
    BOOL _isValid;
    BOOL _needsValidation;
    BOOL _inSetValue;
    NSString* _xmlTagName;
    NSMutableArray* _attributeOrder;
    NSMutableDictionary* _objectAttributes;
    NSMutableDictionary* _relationTypeToRelatives;
}

/******************************************************************************/
#pragma mark Object lifecycle
/******************************************************************************/

+ (id) dataModelFromXML:(RXMLElement*)xml
{
    return [[self alloc] initWithXML:xml];
}

- (id) init
{
    debugTrace();
    
    self = [super init];
    if (self) {
        _isValid = NO;
        _needsValidation = YES;
    }
    return self;
}

- (id) initWithXML:(RXMLElement*)el
{
    self = [self init];
    if (self) {
        [self amendDataModelWithXML:el];
        
        [self dataModelDidLoad];
    }
    return self;
}

- (id) initWithAttributes:(NSDictionary*)attrs
{
    self = [self init];
    if (self) {
        [self addAttributesFromDictionary:attrs];
        
        [self dataModelDidLoad];
    }
    return self;
}

/******************************************************************************/
#pragma mark NSCopying support
/******************************************************************************/

- (void) cloneDataModel:(MBDataModel*)copyFrom
{
    [self cloneDataModel:copyFrom withZone:nil];
}

- (void) cloneDataModel:(MBDataModel*)copyFrom withZone:(NSZone*)zone
{
    _xmlTagName = copyFrom->_xmlTagName;
    if ([copyFrom->_content conformsToProtocol:@protocol(NSMutableCopying)]) {
        self.content = [copyFrom->_content mutableCopyWithZone:zone];
    }
    else if ([copyFrom->_content conformsToProtocol:@protocol(NSCopying)]) {
        self.content = [copyFrom->_content copyWithZone:zone];
    }
    else {
        self.content = copyFrom->_content;
    }
    _attributeOrder = [copyFrom->_attributeOrder mutableCopyWithZone:zone];
    [self addAttributesFromDictionary:copyFrom->_objectAttributes];
    
    for (NSString* relation in [copyFrom currentRelationTypes]) {
        for (MBDataModel* relative in [copyFrom relativesWithRelationType:relation]) {
            MBDataModel* relativeCopy = [relative copyWithZone:zone];
            [self _addRelative:relativeCopy withRelationType:relation];
        }
    }
    
    [self dataModelDidLoad];
}

- (id) copyWithZone:(NSZone*)zone
{
    return [self mutableCopyWithZone:zone];
}

- (id) mutableCopyWithZone:(NSZone*)zone
{
    debugTrace();
    
    MBDataModel* copy = [[[self class] allocWithZone:zone] init];
    [copy cloneDataModel:self withZone:zone];
    return copy;
}

/******************************************************************************/
#pragma mark Class posing
/******************************************************************************/

- (id) poseAsClass:(Class)cls
{
    debugTrace();
    
    if ([cls isSubclassOfClass:[MBDataModel class]]) {
        if ([[self class] isSubclassOfClass:cls]) {
            return self;
        }
        MBDataModel* newModel = [cls new];
        [newModel cloneDataModel:self];
        newModel->_xmlTagName = [[newModel class] dataEntityName];
        return newModel;
    }
    return nil;
}

/******************************************************************************/
#pragma mark NSCoding support
/******************************************************************************/

- (id) initWithCoder:(NSCoder*)coder
{
    debugTrace();
    
    if ([coder allowsKeyedCoding]) {
        self = [self init];
        if (self) {
            _needsValidation = YES;     // force re-validation after deserialization
            _xmlTagName = [coder decodeObjectForKey:kMBDataModelXMLTagName];
            _attributeOrder = [coder decodeObjectForKey:kMBDataModelAttributeOrderArchiveKey];
            _objectAttributes = [coder decodeObjectForKey:kMBDataModelAttributesArchiveKey];
            _relationTypeToRelatives = [coder decodeObjectForKey:kMBDataModelRelativesArchiveKey];
            _content = [coder decodeObjectForKey:kMBDataModelContentArchiveKey];

            [self dataModelDidLoad];
        }
        return self;
    }
    else {
        [NSException raise:NSInvalidUnarchiveOperationException
                    format:@"The %@ class is only compatible with keyed coding", [self class]];
    }
    return nil;
}

- (void) encodeWithCoder:(NSCoder*)coder
{
    debugTrace();
    
    if ([coder allowsKeyedCoding]) {
        [coder encodeObject:_xmlTagName forKey:kMBDataModelXMLTagName];
        [coder encodeObject:_attributeOrder forKey:kMBDataModelAttributeOrderArchiveKey];
        [coder encodeObject:_objectAttributes forKey:kMBDataModelAttributesArchiveKey];
        [coder encodeObject:_relationTypeToRelatives forKey:kMBDataModelRelativesArchiveKey];
        [coder encodeObject:_content forKey:kMBDataModelContentArchiveKey];
    }
    else {
        [NSException raise:NSInvalidArchiveOperationException
                    format:@"The %@ class is only compatible with keyed coding", [self class]];
    }
}

/******************************************************************************/
#pragma mark XML convenience
/******************************************************************************/

+ (RXMLElement*) xmlFromFile:(NSString*)filePath error:(NSError**)errPtr
{
    NSError* err = nil;
    @try {
        NSData* data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingUncached error:&err];
        RXMLElement* xml = nil;
        if (data) {
            xml = [self xmlFromData:data error:&err];
        }
        if (xml && !err) {
            return xml;
        }
        if (!err) {
            err = [NSError mockingbirdErrorWithDescription:@"Failed to parse XML data" code:kMBErrorParseFailed];
        }
    }
    @catch (NSException* ex) {
        errorLog(@"%@ caught exception thrown while trying to process XML data: %@", [self class], ex);
        err = [NSError mockingbirdErrorWithException:ex];
    }
    if (err) {
        err = [err errorByAddingUserInfoKey:kMBErrorUserInfoKeyFilePath value:filePath];
        if (errPtr) {
            *errPtr = err;
        } else {
            errorLog(@"%@ failed to parse XML data due to error: %@", [self class], err);
        }
    }
    return nil;
}

+ (RXMLElement*) xmlFromData:(NSData*)xmlData error:(NSError**)errPtr
{
    NSError* err = nil;
    @try {
        RXMLElement* root = [RXMLElement elementFromXMLData:xmlData];
        if (root && root.isValid) {
            return root;
        }
        err = [NSError mockingbirdErrorWithDescription:@"Failed to parse XML data" code:kMBErrorParseFailed];
    }
    @catch (NSException* ex) {
        errorLog(@"%@ caught exception thrown while trying to process XML data: %@", [self class], ex);
        err = [NSError mockingbirdErrorWithException:ex];
    }
    if (err) {
        if (errPtr) {
            *errPtr = err;
        } else {
            errorLog(@"%@ failed to parse XML data due to error: %@", [self class], err);
        }
    }
    return nil;
}

/******************************************************************************/
#pragma mark XML representation
/******************************************************************************/

- (NSString*) xmlTagName
{
    return _xmlTagName ?: [[self class] dataEntityName];
}

+ (NSString*) dataEntityName
{
    NSString* name = [self description];
    NSArray* classPrefixes = [MBEnvironment supportedLibraryClassPrefixes];
    for (NSString* prefix in classPrefixes) {
        if ([name hasPrefix:prefix]) {
            name = [name substringFromIndex:prefix.length];
            break;
        }
    }
    return name;
}

- (void) _addSimulatedXMLForEntity:(NSString*)entityName
                    withAttributes:(NSDictionary*)attributes
                           inOrder:(NSArray*)attributeOrder
                          toString:(NSMutableString*)desc
{
    if (!attributeOrder) {
        attributeOrder = [attributes allKeys];
    }
    
    [desc appendFormat:@"%@", entityName];
    for (NSString* attrName in attributeOrder) {
        [desc appendString:@" "];
        NSString* attrVal = [attributes[attrName] description];
        [desc appendFormat:@"%@=\"%@\"", attrName, attrVal];
    }
}

- (NSString*) _simulatedXMLWithRelationTypesShown:(BOOL)showRelationTypes
{
    NSString* entityName = self.xmlTagName;
    NSMutableString* desc = [NSMutableString string];
    [desc appendString:@"<"];
    [self _addSimulatedXMLForEntity:entityName
                    withAttributes:_objectAttributes
                           inOrder:_attributeOrder
                          toString:desc];
    
    BOOL hasContent = NO;
    NSString* content = [self.content description];
    if (content.length) {
        if (!hasContent) {
            [desc appendString:@">"];
            hasContent = YES;
        }
        [desc appendString:content];
    }

    BOOL hasRelatives = NO;
    NSArray* relationTypes = [self currentRelationTypes];
    for (NSString* relationType in relationTypes) {
        NSArray* relatives = [self relativesWithRelationType:relationType];
        NSUInteger relativeCnt = relatives.count;
        if (relativeCnt > 0) {
            if (!hasRelatives) {
                if (!hasContent) {
                    [desc appendString:@">"];
                }
                hasRelatives = YES;
            }
            if (showRelationTypes) {
                BOOL isDefaultRelation = [relationType isEqualToString:[[self class] defaultRelationType]];
                [desc appendFormat:@"\n\t<!-- %lu object%@ with relation type \"%@\"%@: -->",
                    (unsigned long)relativeCnt, (relativeCnt == 1 ? @"" : @"s"), relationType, (isDefaultRelation ? @" (default)" : @"")];
            }
            for (MBDataModel* related in relatives) {
                [desc appendString:@"\n"];
                [desc appendString:[[related simulatedXML] stringByIndentingEachLineWithTab]];
            }
        }
    }
    
    if (!hasRelatives && !hasContent) {
        [desc appendString:@"/>"];
    }
    if (hasRelatives) {
        [desc appendString:@"\n"];
    }
    if (hasRelatives || hasContent) {
        [desc appendFormat:@"</%@>", entityName];
    }
    
    return desc;
}

- (NSString*) simulatedXML
{
    return [self _simulatedXMLWithRelationTypesShown:NO];
}

- (NSString*) debuggingXML
{
    return [self _simulatedXMLWithRelationTypesShown:YES];
}

- (NSString*) debugDescriptor
{
    return [NSString stringWithFormat:@"<%@>", self.xmlTagName];
}

- (void) addDescriptionFieldsTo:(MBFieldListFormatter*)fmt
{
    [super addDescriptionFieldsTo:fmt];

    for (NSString* attrName in _attributeOrder) {
        [fmt setField:attrName value:self[attrName]];
    }
}

/******************************************************************************/
#pragma mark Data model enforcement
/******************************************************************************/

+ (NSSet*) requiredAttributes
{
    // no explicitly-required attributes at this level;
    // subclasses may declare them
    return nil;
}

+ (NSSet*) supportedAttributes
{
    // no explicitly-supported attributes at this level;
    // subclasses may declare them
    return nil;
}

+ (NSSet*) unsupportedAttributes
{
    // no explicitly-unsupported attributes at this level;
    // subclasses may declare them
    return nil;
}

- (NSString*) implementingClassAttributeName
{
    return nil;
}

- (void) _addRequiredAttributesForClass:(Class)cls toSet:(NSMutableSet**)setPtr
{
    while ([cls respondsToSelector:@selector(requiredAttributes)]) {
        NSSet* clsAttrs = [cls requiredAttributes];
        if (clsAttrs && clsAttrs.count) {
            if (!*setPtr) {
                *setPtr = [NSMutableSet set];
            }
            [*setPtr unionSet:clsAttrs];
        }
        cls = [cls superclass];
    }
}

- (void) _removeUnsupportedAttributesForClass:(Class)cls fromSet:(NSMutableSet*)set
{
    if (set) {
        while ([cls respondsToSelector:@selector(unsupportedAttributes)]) {
            NSSet* attrs = [cls unsupportedAttributes];
            if (attrs && attrs.count) {
                [set minusSet:attrs];
            }
            cls = [cls superclass];
        }
    }
}

- (NSSet*) requiredAttributes
{
    debugTrace();

    NSMutableSet* required = nil;
    [self _addRequiredAttributesForClass:[self class] toSet:&required];
    [self _removeUnsupportedAttributesForClass:[self class] fromSet:required];

    NSString* clsNameAttr = [self implementingClassAttributeName];
    if (clsNameAttr) {
        NSString* clsName = [self evaluateAsString:clsNameAttr];
        if (clsName) {
            Class cls = NSClassFromString(clsName);
            if (cls) {
                [self _addRequiredAttributesForClass:cls toSet:&required];
                [self _removeUnsupportedAttributesForClass:cls fromSet:required];
            } else {
                errorLog(@"%@ couldn't find class named \"%@\" specified in the \"%@\" attribute of: %@", [self class], clsName, clsNameAttr, self.simulatedXML);
                [self markDataModelInvalid];
            }
        }
    }
    return required;
}

- (void) _addSupportedAttributesForClass:(Class)cls toSet:(NSMutableSet**)setPtr
{
    while ([cls respondsToSelector:@selector(supportedAttributes)]) {
        NSSet* clsAttrs = [cls supportedAttributes];
        if (clsAttrs && clsAttrs.count) {
            if (!*setPtr) {
                *setPtr = [NSMutableSet set];
            }
            [*setPtr unionSet:clsAttrs];
        }
        cls = [cls superclass];
    }
}

- (NSSet*) ignoredAttributes
{
    debugTrace();

    NSMutableSet* supported = nil;
    [self _addRequiredAttributesForClass:[self class] toSet:&supported];
    [self _addSupportedAttributesForClass:[self class] toSet:&supported];
    [self _removeUnsupportedAttributesForClass:[self class] fromSet:supported];
    
    NSString* clsNameAttr = [self implementingClassAttributeName];
    if (clsNameAttr) {
        NSString* clsName = [self evaluateAsString:clsNameAttr];
        if (clsName) {
            Class cls = NSClassFromString(clsName);
            if (cls) {
                [self _addRequiredAttributesForClass:cls toSet:&supported];
                [self _addSupportedAttributesForClass:cls toSet:&supported];
                [self _removeUnsupportedAttributesForClass:cls fromSet:supported];
            }
            else {
                errorLog(@"%@ couldn't find class named \"%@\" specified in the \"%@\" attribute of: %@", [self class], clsName, clsNameAttr, self.simulatedXML);
                [self markDataModelInvalid];
            }
        }
    }
    
    NSMutableSet* rejected = nil;
    if (supported && supported.count > 0) {
        for (NSString* attr in [self attributeNames]) {
            if (![supported containsObject:attr]) {
                if (!rejected) {
                    rejected = [NSMutableSet set];
                }
                [rejected addObject:attr];
            }
        }
    }
    return rejected;
}

- (void) deprecateAttribute:(NSString*)deprecatedAttribute inFavorOf:(NSString*)newAttribute
{
    id deprecatedValue = [self valueOfAttribute:deprecatedAttribute];
    if (deprecatedValue) {
        [self removeAttribute:deprecatedAttribute];
        if ([self hasAttribute:newAttribute]) {
            [[MBDataEnvironment log] issueDeprecationWarningWithFormat:@"The <%@> attribute \"%@\" is deprecated in favor of \"%@\"; the value of \"%@\" will be ignored because there is already a value for \"%@\"", self.xmlTagName, deprecatedAttribute, newAttribute, deprecatedAttribute, newAttribute];
        }
        else {
            [[MBDataEnvironment log] issueDeprecationWarningWithFormat:@"The <%@> attribute \"%@\" is deprecated in favor of \"%@\"", self.xmlTagName, deprecatedAttribute, newAttribute];
            [self setAttribute:deprecatedValue forName:newAttribute];
        }
    }
}

/******************************************************************************/
#pragma mark Data model validation
/******************************************************************************/

- (BOOL) validateDataModel
{
    debugTrace();
        
    // validate the data model
    _isValid = [self validateAsRelativeOf:nil relatedBy:nil dataModelRoot:self];

    _needsValidation = NO;

    return _isValid;
}

- (BOOL) validateDataModelIfNeeded
{
    debugTrace();
    
    if (_needsValidation) {
        return [self validateDataModel];
    }
    return _isValid;
}

- (BOOL) validateAttributes
{
    debugTrace();
 
    // error out on a missing required attribute
    BOOL missingRequired = NO;
    NSSet* requiredAttrs = [self requiredAttributes];
    if (requiredAttrs && requiredAttrs.count > 0) {
        NSMutableSet* missingAttributes = [requiredAttrs mutableCopy];
        for (NSString* attrName in _attributeOrder) {
            [missingAttributes removeObject:attrName];
        }
        for (NSString* required in missingAttributes) {
            missingRequired = YES;
            errorLog(@"%@ requires the attribute \"%@\" but it was not found in: %@", [self class], required, self.simulatedXML);
        }
    }
    if (missingRequired) {
        return NO;
    }
    
    // warn about ignored attributes
    NSSet* rejectedAttrs = [self ignoredAttributes];
    for (NSString* rejected in rejectedAttrs) {
        errorLog(@"%@ does not support the attribute \"%@\" found in: %@", [self class], rejected, self.simulatedXML);
    }
    
    return YES;
}

- (BOOL) validateAsRelativeOf:(MBDataModel*)relative
                    relatedBy:(NSString*)relationType
                dataModelRoot:(MBDataModel*)root
{
    debugTrace();
    
    if (![self validateAttributes]) {
        return NO;
    }
    
    for (NSString* relation in _relationTypeToRelatives) {
        NSArray* relatives = _relationTypeToRelatives[relation];
        for (MBDataModel* relative in relatives) {
            // we don't bubble up invalid nodes; this allows us to
            // isolate the invalidity to the smallest responsible node
            [relative validateAsRelativeOf:self
                                 relatedBy:relation
                             dataModelRoot:root];
        }
    }

    return YES;
}

- (void) markDataModelNeedsValidation
{
    _needsValidation = YES;
}

- (BOOL) doesDataModelNeedValidation
{
    return _needsValidation;
}

- (void) markDataModelInvalid
{
    _isValid = NO;
}

- (BOOL) isDataModelValid
{
    return _isValid && !_needsValidation;
}

/******************************************************************************/
#pragma mark Populating the data model
/******************************************************************************/

- (void) amendDataModelWithXML:(RXMLElement*)xml
{
    debugTrace();
    
    if (!_xmlTagName) {
        _xmlTagName = xml.tag;
    }
    
    [self addAttributesFromXML:xml];
    
    [self populateDataModelFromXML:xml];
}

- (BOOL) amendDataModelWithXMLFromFile:(NSString*)filePath
{
    return [self amendDataModelWithXMLFromFile:filePath error:nil];
}

- (BOOL) amendDataModelWithXMLFromFile:(NSString*)filePath error:(NSError**)errPtr
{
    debugTrace();
    
    RXMLElement* xml = [[self class] xmlFromFile:filePath error:errPtr];
    if (xml) {
        [self amendDataModelWithXML:xml];
        [self didAmendDataModelWithXMLFromFile:filePath];
        return YES;
    }
    return NO;
}

- (BOOL) amendDataModelWithXMLFromData:(NSData*)xmlData
{
    return [self amendDataModelWithXMLFromData:xmlData error:nil];
}

- (BOOL) amendDataModelWithXMLFromData:(NSData*)xmlData error:(NSError**)errPtr
{
    debugTrace();
    
    RXMLElement* xml = [[self class] xmlFromData:xmlData error:errPtr];
    if (xml) {
        [self amendDataModelWithXML:xml];
        return YES;
    }
    return NO;
}

- (void) addAttributesFromXML:(RXMLElement*)node
{
    debugTrace();
    
    for (NSString* attrName in [node attributeNames]) {
        [self setAttribute:[node attribute:attrName] forName:attrName];
    }
}

- (void) addAttributesFromDictionary:(NSDictionary*)dict
{
    debugTrace();
    
    for (NSString* attrName in dict) {
        [self setAttribute:dict[attrName] forName:attrName];
    }
}

- (void) overlayAttributesFromDictionary:(NSDictionary*)dict
{
    debugTrace();
    
    for (NSString* attrName in dict) {
        if (![self hasAttribute:attrName]) {
            [self setAttribute:dict[attrName] forName:attrName];
        }
    }
}

- (void) populateDataModelFromXML:(RXMLElement*)container
{
    debugTrace();
    
    [container iterate:@"*" usingBlock:^(RXMLElement* el) {
        NSString* tag = el.tag;
        NSString* relationType = [self relationTypeForTag:tag];
        if (!relationType) {
            errorLog(@"The <%@> tag (implemented by the %@ class) does not support containing the <%@> XML tag; this will be ignored: %@", [[self class] dataEntityName], [self class], tag, el.xml);
        }
        else {
            Class relCls = nil;
            if ([self shouldAutomaticallyAddRelativeOfType:relationType fromTag:tag]) {
                relCls = [self implementingClassForRelativeOfType:relationType fromTag:tag];
            }
            if (relCls) {
                [self _addRelative:[[relCls alloc] initWithXML:el] withRelationType:relationType];
            }
            else {
                errorLog(@"The <%@> tag (implemented by the %@ class) doesn't recognize the contained <%@> tag and is ignoring the following XML: %@", [[self class] dataEntityName], [self class], el.tag, el.xml);
            }
        }
    }];
}

- (void) dataModelDidLoad
{
    debugTrace();
}

- (void) didAmendDataModelWithXMLFromFile:(NSString*)filePath
{
    debugTrace();
}

/******************************************************************************/
#pragma mark Copying data model attributes
/******************************************************************************/

- (NSDictionary*) objectAttributes
{
    debugTrace();

    return [_objectAttributes copy];
}

- (void) addAttributesToDictionary:(NSMutableDictionary*)dict
{
    debugTrace();
    
    if (_objectAttributes) {
        [dict addEntriesFromDictionary:_objectAttributes];
    }
}

/******************************************************************************/
#pragma mark Accessing data model values
/******************************************************************************/

- (BOOL) hasStringContent
{
    NSString* stringContent = self.content;
    if (stringContent && [stringContent isKindOfClass:[NSString class]] && stringContent.length > 0) {
        NSCharacterSet* nonWhitespaceChars = [[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet];
        NSRange found = [stringContent rangeOfCharacterFromSet:nonWhitespaceChars];
        return (found.location != NSNotFound);
    }
    return NO;
}

- (NSUInteger) countAttributes
{
    verboseDebugTrace();
    
    return _objectAttributes.count;
}

- (NSArray*) attributeNames
{
    verboseDebugTrace();
    
    return [_attributeOrder copy];
}

- (BOOL) hasAttribute:(NSString*)attrName
{
    verboseDebugTrace();
        
    return _objectAttributes[attrName] != nil;
}

- (id) valueOfAttribute:(NSString*)attrName
{
    verboseDebugTrace();
    
    return _objectAttributes[attrName];
}

- (NSString*) stringValueOfAttribute:(NSString*)attrName
{
    verboseDebugTrace();
    
    return [_objectAttributes[attrName] description];
}

- (NSNumber*) numberValueOfAttribute:(NSString*)attrName
{
    verboseDebugTrace();

    return [MBExpression numberFromValue:_objectAttributes[attrName]];
}

- (BOOL) booleanValueOfAttribute:(NSString*)attrName
{
    verboseDebugTrace();

    return [MBExpression booleanFromValue:_objectAttributes[attrName]];
}

- (NSInteger) integerValueOfAttribute:(NSString*)attrName
{
    verboseDebugTrace();

    NSNumber* numVal = _objectAttributes[attrName];
    if (numVal && [numVal isKindOfClass:[NSNumber class]]) {
        return [numVal integerValue];
    }
    return 0;
}

- (double) doubleValueOfAttribute:(NSString*)attrName
{
    verboseDebugTrace();

    NSNumber* numVal = _objectAttributes[attrName];
    if (numVal && [numVal isKindOfClass:[NSNumber class]]) {
        return [numVal doubleValue];
    }
    return 0;
}

/******************************************************************************/
#pragma mark Keyed subscripting support
/******************************************************************************/

- (id) objectForKeyedSubscript:(NSString*)key
{
    if ([key isKindOfClass:[NSString class]]) {
        return [self valueOfAttribute:key];
    }
    else {
        errorLog(@"The %@ class only supports keyed subscripting using %@-based keys; instead got a key of type %@ with the value: %@", [self class], [NSString class], [key class], key);
    }
    return nil;
}

- (void) setObject:(id)obj forKeyedSubscript:(NSString*)key
{
    if ([key isKindOfClass:[NSString class]]) {
        [self setAttribute:obj forName:key];
    }
    else {
        errorLog(@"The %@ class only supports keyed subscripting using %@-based keys; instead got a key of type %@ with the value: %@", [self class], [NSString class], [key class], key);
    }
}

/******************************************************************************/
#pragma mark Performing expression evaluation on attribute values
/******************************************************************************/

- (id) evaluateAsObject:(NSString*)attrName
{
    verboseDebugTrace();
    
    NSString* expr = [self stringValueOfAttribute:attrName];
    if (expr) {
        return [expr evaluateAsObject];
    }
    return nil;
}

- (id) evaluateAsObject:(NSString*)attrName defaultValue:(id)def
{
    verboseDebugTrace();

    return [MBExpression asObject:[self stringValueOfAttribute:attrName]
                                        defaultValue:def];
}

- (NSString*) evaluateAsString:(NSString*)attrName
{
    verboseDebugTrace();
    
    return [self evaluateAsString:attrName defaultValue:nil];
}

- (NSString*) evaluateAsString:(NSString*)attrName defaultValue:(NSString*)def
{
    verboseDebugTrace();

    return [MBExpression asString:[self stringValueOfAttribute:attrName]
                                        defaultValue:def];
}

- (NSDecimalNumber*) evaluateAsNumber:(NSString*)attrName;
{
    verboseDebugTrace();
    
    return [self evaluateAsNumber:attrName defaultValue:nil];
}

- (NSDecimalNumber*) evaluateAsNumber:(NSString*)attrName defaultValue:(NSDecimalNumber*)def
{
    verboseDebugTrace();

    return [MBExpression asNumber:[self stringValueOfAttribute:attrName]
                                        defaultValue:def];
}

- (BOOL) evaluateAsBoolean:(NSString*)attrName
{
    verboseDebugTrace();
    
    return [self evaluateAsBoolean:attrName defaultValue:NO];
}

- (BOOL) evaluateAsBoolean:(NSString*)attrName defaultValue:(BOOL)def
{
    verboseDebugTrace();

    return [MBExpression asBoolean:[self stringValueOfAttribute:attrName]
                                         defaultValue:def];
}

/******************************************************************************/
#pragma mark Setting data model attribute values
/******************************************************************************/

- (void) setValue:(id)val forKey:(NSString*)attrName
{
    debugTrace();
    
    if (!_inSetValue) {
        _inSetValue = YES;
        @try {
            [super setValue:val forKey:attrName];
        }
        @finally {
            _inSetValue = NO;
        }
    }
}

- (void) setAttribute:(id)attrVal forName:(NSString*)attrName
{
    debugTrace();
    
    if (attrVal) {
        if (!_attributeOrder) {
            _attributeOrder = [[NSMutableArray alloc] initWithCapacity:kMBDataModelInitialAttributeCapacity];
        }
        if (!_objectAttributes) {
            _objectAttributes = [[NSMutableDictionary alloc] initWithCapacity:kMBDataModelInitialAttributeCapacity];
        }
        if (![_attributeOrder containsObject:attrName]) {
            [_attributeOrder addObject:attrName];
        }
        _objectAttributes[attrName] = attrVal;
    } else {
        [_attributeOrder removeObject:attrName];
        [_objectAttributes removeObjectForKey:attrName];
    }

    [self setValue:attrVal forKey:attrName];
    
    _needsValidation = YES;
}

- (void) setBooleanAttribute:(BOOL)attrVal forName:(NSString*)attrName;
{
    [self setAttribute:@(attrVal) forName:attrName];
}

- (void) setIntegerAttribute:(NSInteger)attrVal forName:(NSString*)attrName;
{
    [self setAttribute:@(attrVal) forName:attrName];
}

- (void) setDoubleAttribute:(double)attrVal forName:(NSString*)attrName
{
    [self setAttribute:@(attrVal) forName:attrName];
}

/******************************************************************************/
#pragma mark Renaming and removing attributes
/******************************************************************************/

- (void) renameAttribute:(NSString*)oldName to:(NSString*)newName
{
    id val = [self valueOfAttribute:oldName];
    [self removeAttribute:oldName];
    if (newName) {
        [self setAttribute:val forName:newName];
    }
}

- (void) removeAttribute:(NSString*)attrName
{
    [self setAttribute:nil forName:attrName];
}

/******************************************************************************/
#pragma mark Related objects
/******************************************************************************/

+ (NSString*) defaultRelationType
{
    debugTrace();
    
    return kMBDataModelDefaultRelation;
}

- (NSArray*) currentRelationTypes
{
    verboseDebugTrace();
    
    return [_relationTypeToRelatives allKeys];
}

- (NSUInteger) countRelatives
{
    verboseDebugTrace();

    NSUInteger num = 0;
    for (NSString* relations in _relationTypeToRelatives) {
        NSArray* related = _relationTypeToRelatives[relations];
        num += related.count;
    }
    return num;
}

- (NSUInteger) countRelativesWithRelationType:(NSString*)relation
{
    verboseDebugTrace();

    if (!relation) {
        relation = [[self class] defaultRelationType];
    }

    return [_relationTypeToRelatives[relation] count];
}

- (NSUInteger) countRelativesWithDefaultRelation
{
    verboseDebugTrace();

    return [_relationTypeToRelatives[[[self class] defaultRelationType]] count];
}

- (NSArray*) allRelatives
{
    debugTrace();

    // figure out the ideal capacity for the array we'll return
    NSUInteger relativeCnt = 0;
    for (NSString* relationType in _relationTypeToRelatives) {
        relativeCnt += [_relationTypeToRelatives[relationType] count];
    }

    NSMutableArray* relatives = [NSMutableArray arrayWithCapacity:relativeCnt];
    for (NSString* relationType in _relationTypeToRelatives) {
        [relatives addObjectsFromArray:_relationTypeToRelatives[relationType]];
    }
    return relatives;
}

- (NSArray*) relativesWithRelationType:(NSString*)relation
{
    debugTrace();
    
    if (!relation) {
        relation = [[self class] defaultRelationType];
    }

    return [NSArray arrayWithArray:_relationTypeToRelatives[relation]];
}

- (NSArray*) relativesWithDefaultRelation
{
    debugTrace();
    
    return [NSArray arrayWithArray:_relationTypeToRelatives[[[self class] defaultRelationType]]];
}

- (MBDataModel*) firstRelativeWithDefaultRelation
{
    debugTrace();
    
    return [_relationTypeToRelatives[[[self class] defaultRelationType]] firstObject];
}

- (MBDataModel*) firstRelativeWithRelationType:(NSString*)relation
{
    debugTrace();
    
    if (!relation) {
        relation = [[self class] defaultRelationType];
    }

    return [_relationTypeToRelatives[relation] firstObject];
}

- (void) _addRelative:(MBDataModel*)relative withRelationType:(NSString*)relation
{
    if (!relation) {
        relation = [[self class] defaultRelationType];
    }
    
    NSMutableArray* related = nil;
    if (!_relationTypeToRelatives) {
        _relationTypeToRelatives = [NSMutableDictionary new];
    } else {
        related = _relationTypeToRelatives[relation];
    }
    if (!related) {
        related = [NSMutableArray array];
        _relationTypeToRelatives[relation] = related;
    }
    [related addObject:relative];
    relative.containingRelative = self;
    
    _needsValidation = YES;
}

- (void) addRelative:(MBDataModel*)relative
{
    debugTrace();

    [self _addRelative:relative withRelationType:nil];
    
    [self dataModelDidAddOrRemoveRelatives];
}

- (void) addRelative:(MBDataModel*)relative withRelationType:(NSString*)relation
{
    debugTrace();

    [self _addRelative:relative withRelationType:relation];
    
    [self dataModelDidAddOrRemoveRelatives];
}

- (void) addRelatives:(NSObject<NSFastEnumeration>*)relatives
{
    debugTrace();

    for (MBDataModel* relative in relatives) {
        [self _addRelative:relative withRelationType:nil];
    }

    [self dataModelDidAddOrRemoveRelatives];
}

- (void) addRelatives:(NSObject<NSFastEnumeration>*)relatives withRelationType:(NSString*)relation
{
    debugTrace();

    for (MBDataModel* relative in relatives) {
        [self _addRelative:relative withRelationType:relation];
    }

    [self dataModelDidAddOrRemoveRelatives];
}

- (void) _removeRelative:(MBDataModel*)relative withRelationType:(NSString*)relation
{
    NSMutableArray* relatedList = _relationTypeToRelatives[relation];
    if (relatedList) {
        NSUInteger index = [relatedList indexOfObject:relative];
        if (index != NSNotFound) {
            MBDataModel* related = relatedList[index];
            related.containingRelative = nil;
            [relatedList removeObjectAtIndex:index];
            
            if (!relatedList.count) {
                [_relationTypeToRelatives removeObjectForKey:relation];
            }
        }
    }
    
    _needsValidation = YES;
}

- (void) removeRelative:(MBDataModel*)relative
{
    debugTrace();
    
    for (NSString* relation in _relationTypeToRelatives) {
        [self _removeRelative:relative withRelationType:relation];
    }
    
    [self dataModelDidAddOrRemoveRelatives];
}

- (void) removeRelative:(MBDataModel*)relative withRelationType:(NSString*)relation
{
    debugTrace();

    [self _removeRelative:relative withRelationType:relation];
    
    [self dataModelDidAddOrRemoveRelatives];
}

- (void) addRelativeOfClass:(Class)relCls forElement:(RXMLElement*)element
{
    debugTrace();

    [self addRelativeOfClass:relCls
            withRelationType:element.tag
                  forElement:element];
}

- (void) addRelativeOfClass:(Class)relCls
           withRelationType:(NSString*)relation
                 forElement:(RXMLElement*)element
{
    debugTrace();
    
    if ([relCls instancesRespondToSelector:@selector(initWithXML:)]) {
        if (!relation) {
            relation = [[self class] defaultRelationType];
        }
        
        [self _addRelative:[[relCls alloc] initWithXML:element] withRelationType:relation];
    }
    else {
        errorLog(@"Instances of class %@ must implement the method initWithXML: in order to be used by %@ in this way", relCls, [self class]);
    }
}

- (void) addRelativeOfClass:(Class)relCls
            forFirstChildOf:(RXMLElement*)container
                  havingTag:(NSString*)tagName
{
    [self addRelativeOfClass:relCls
            withRelationType:tagName
             forFirstChildOf:container
                   havingTag:tagName];
}

- (void) addRelativeOfClass:(Class)relCls
           withRelationType:(NSString*)relation
            forFirstChildOf:(RXMLElement*)container
                  havingTag:(NSString*)tagName
{
    debugTrace();
    
    RXMLElement* child = [container child:tagName];
    if (child) {
        [self addRelativeOfClass:relCls
                withRelationType:relation
                      forElement:child];
    }
}

- (void) addRelativeOfClass:(Class)relCls
             forEachChildOf:(RXMLElement*)container
{
    debugTrace();

    [self addRelativeOfClass:relCls
            withRelationType:nil
              forEachChildOf:container];
}

- (void) addRelativeOfClass:(Class)relCls
           withRelationType:(NSString*)relation
             forEachChildOf:(RXMLElement*)container
{
    debugTrace();
    
    if ([relCls instancesRespondToSelector:@selector(initWithXML:)]) {
        if (!relation) {
            relation = [[self class] defaultRelationType];
        }
        
        [container iterate:@"*" usingBlock:^(RXMLElement* el) {
            [self _addRelative:[[relCls alloc] initWithXML:el] withRelationType:relation];
        }];

        [self dataModelDidAddOrRemoveRelatives];
    }
    else {
        errorLog(@"Instances of class %@ must implement the method initWithXML: in order to be used by %@ in this way", relCls, [self class]);
    }
}

- (void) addRelativeOfClass:(Class)relCls
             forEachChildOf:(RXMLElement*)container
                  havingTag:(NSString*)tagName
{
    [self addRelativeOfClass:relCls
            withRelationType:tagName
              forEachChildOf:container
                   havingTag:tagName];
}

- (void) addRelativeOfClass:(Class)relCls
           withRelationType:(NSString*)relation
             forEachChildOf:(RXMLElement*)container
                  havingTag:(NSString*)tagName
{
    debugTrace();

    if ([relCls instancesRespondToSelector:@selector(initWithXML:)]) {
        if (!relation) {
            relation = [[self class] defaultRelationType];
        }
        
        [container iterate:tagName usingBlock:^(RXMLElement* el) {
            [self _addRelative:[[relCls alloc] initWithXML:el] withRelationType:relation];
        }];
        
        [self dataModelDidAddOrRemoveRelatives];
    }
    else {
        errorLog(@"Instances of class %@ must implement the method initWithXML: in order to be used by %@ in this way", relCls, [self class]);
    }
}

/******************************************************************************/
#pragma mark Building out the data model automatically
/******************************************************************************/

- (NSString*) relationTypeForTag:(NSString*)tagName
{
    return [[self class] defaultRelationType];
}

- (BOOL) shouldAutomaticallyAddRelativeOfType:(NSString*)relationType fromTag:(NSString*)tagName
{
    return YES;
}

- (Class) implementingClassForRelativeOfType:(NSString*)relationType fromTag:(NSString*)tagName
{
    return [MBDataModel class];
}

/******************************************************************************/
#pragma mark Notification of changes to the set of relatives
/******************************************************************************/

- (void) dataModelDidAddOrRemoveRelatives
{
    debugTrace();
}

/******************************************************************************/
#pragma mark Key/value coding support
/******************************************************************************/

- (void) setValue:(id)value forUndefinedKey:(NSString*)key
{
    debugLog(@"[%@@%p setValue:forKey:] called for undefined key: %@", [self class], self, key);
}

- (id) valueForUndefinedKey:(NSString*)key
{
    debugTrace();

    return [self valueOfAttribute:key];
}

@end
