//
//  MBVariableDeclaration.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 9/6/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <RaptureXML/RXMLElement.h>

#import "MBVariableDeclaration.h"
#import "Mockingbird-DataEnvironment.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark Public constants
/******************************************************************************/

NSString* const kMBMLVariableTypeSingleton  = @"singleton";
NSString* const kMBMLVariableTypeDynamic    = @"dynamic";
NSString* const kMBMLVariableTypeMap        = @"map";
NSString* const kMBMLVariableTypeList       = @"list";

/******************************************************************************/
#pragma mark -
#pragma mark MBVariableDeclaration implementation
/******************************************************************************/

@implementation MBVariableDeclaration

/******************************************************************************/
#pragma mark Object lifecycle
/******************************************************************************/

+ (id) dataModelFromXML:(RXMLElement*)xml
{
    NSString* varType = [xml attribute:kMBMLAttributeType];
    if (varType) {
        if ([varType isEqualToString:kMBMLVariableTypeSingleton]) {
            return [[MBSingletonVariableDeclaration alloc] initWithXML:xml];
        }
        else if ([varType isEqualToString:kMBMLVariableTypeDynamic]) {
            return [[MBDynamicVariableDeclaration alloc] initWithXML:xml];
        }
        else if (![varType isEqualToString:kMBMLVariableTypeMap]
                 && ![varType isEqualToString:kMBMLVariableTypeList])
        {
            errorLog(@"Unknown variable type (\"%@\") specified in: %@", varType, xml.xml);
            return nil;
        }
    }
    return [[MBConcreteVariableDeclaration alloc] initWithXML:xml];
}

/******************************************************************************/
#pragma mark Data model support
/******************************************************************************/

+ (NSSet*) supportedAttributes
{
    return [NSSet setWithObjects:kMBMLAttributeName, kMBMLAttributeType, nil];
}

- (BOOL) validateAttributes
{
    if (![super validateAttributes]) {
        return NO;
    }
    
    NSString* type = [self stringValueOfAttribute:kMBMLAttributeType];
    if (type && (![type isEqualToString:kMBMLVariableTypeMap]
                 && ![type isEqualToString:kMBMLVariableTypeList]
                 && ![type isEqualToString:kMBMLVariableTypeSingleton]
                 && ![type isEqualToString:kMBMLVariableTypeDynamic]))
    {
        errorLog(@"%@ got an unexpected value for \"%@\" attribute in: %@", [self class], kMBMLAttributeType, self.simulatedXML);
        return NO;
    }

    return YES;
}

/******************************************************************************/
#pragma mark Property handling
/******************************************************************************/

- (NSString*) name
{
    return [self stringValueOfAttribute:kMBMLAttributeName];
}

- (BOOL) isReadOnly
{
    MBErrorNotImplementedReturn(BOOL);
}

- (BOOL) disallowsValueCaching
{
    MBErrorNotImplementedReturn(BOOL);
}

/******************************************************************************/
#pragma mark Accessing variable values
/******************************************************************************/

- (id) initialValueInVariableSpace:(MBVariableSpace*)space
                             error:(out MBExpressionError**)errPtr;
{
    MBErrorNotImplementedReturn(id);
}

- (id) currentValueInVariableSpace:(MBVariableSpace*)space
                             error:(out MBExpressionError**)errPtr;
{
    MBErrorNotImplementedReturn(id);
}

/******************************************************************************/
#pragma mark Variable value change hook
/******************************************************************************/

- (void) valueChangedTo:(id)value inVariableSpace:(MBVariableSpace*)space
{
}

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBConcreteVariableDeclaration implementation
/******************************************************************************/

@implementation MBConcreteVariableDeclaration
{
    BOOL _isReadOnly;
}

/******************************************************************************/
#pragma mark Data model support
/******************************************************************************/

+ (NSSet*) supportedAttributes
{
    return [NSSet setWithObjects:kMBMLAttributeMutable,
            kMBMLAttributeUserDefaultsName,
            kMBMLAttributeValue,
            kMBMLAttributeLiteral,
            kMBMLAttributeBoolean,
            nil];
}

- (void) populateDataModelFromXML:(RXMLElement*)container
{
    debugTrace();
    
    MBConcreteVariableType type = self.declaredType;
    if (type == MBConcreteVariableTypeList || type == MBConcreteVariableTypeMap) {
        //
        // we're not treating the inner content as a value; if we
        // contain any inner declarations, we should be a list or map
        //
        [container iterate:@"*" usingBlock:^(RXMLElement* child) {
            [self addRelative:[MBVariableDeclaration dataModelFromXML:child]];
        }];
    }
    else if (type == MBConcreteVariableTypeSimple
             && ![self hasAttribute:kMBMLAttributeValue]
             && ![self hasAttribute:kMBMLAttributeBoolean]
             && ![self hasAttribute:kMBMLAttributeLiteral])
    {
        //
        // if a value or literal isn't set yet, we set the value
        // from the string content of the container
        //
        [self setAttribute:container.text forName:kMBMLAttributeValue];
    }
}

- (BOOL) validateAsRelativeOf:(MBDataModel*)relative
                    relatedBy:(NSString *)relationType
                dataModelRoot:(MBDataModel*)root
{
    debugTrace();
    
    if (![super validateAsRelativeOf:relative relatedBy:relationType dataModelRoot:root]) {
        return NO;
    }

    if (self.declaredType == MBConcreteVariableTypeUnknown) {
        NSString* type = [self stringValueOfAttribute:kMBMLAttributeType];
        errorLog(@"\"%@\" is not a supported variable declaration type in: %@", type, self.simulatedXML);
        return NO;
    }

    BOOL shouldHaveName = YES;
    BOOL isContained = (relative != nil);
    if (isContained) {
        if (![relative isKindOfClass:[MBConcreteVariableDeclaration class]]) {
            errorLog(@"Unexpected container class (%@); variable declarations may only be contained by %@ classes. Ignoring: %@", [relative class], [MBConcreteVariableDeclaration class], self.simulatedXML);
            return NO;
        }

        MBConcreteVariableDeclaration* container = (MBConcreteVariableDeclaration*) relative;
        MBConcreteVariableType containerVarType = container.declaredType;
        if (containerVarType != MBConcreteVariableTypeMap && containerVarType != MBConcreteVariableTypeList) {
            errorLog(@"Unexpected container type (%u); variable declarations may only be contained within other variables declared with %@=\"%@\" or %@=\"%@\". Ignoring: %@", containerVarType, kMBMLAttributeType, kMBMLVariableTypeList, kMBMLAttributeType, kMBMLVariableTypeMap, self.simulatedXML);
            return NO;
        }
        
        // lists don't take names for their contained <Var>s
        shouldHaveName = containerVarType != MBConcreteVariableTypeList;
    }
    
    NSString* name = [self stringValueOfAttribute:kMBMLAttributeName];
    if (shouldHaveName) {
        if (!name || !name.length) {
            errorLog(@"%@ requires a \"%@\" attribute in: %@", [self class], kMBMLAttributeName, self.simulatedXML);
            return NO;
        }
    }
    else if (name.length) {
        errorLog(@"%@ can't take a \"%@\" attribute because it is contained in a list; Ignoring: %@", [self class], kMBMLAttributeName, self.simulatedXML);
        return NO;
    }
    
    BOOL hasBooleanAttr = [self hasAttribute:kMBMLAttributeBoolean];
    BOOL hasLiteralAttr = [self hasAttribute:kMBMLAttributeLiteral];
    BOOL hasValueAttr = [self hasAttribute:kMBMLAttributeValue];
    NSUInteger valueAttrs = (hasBooleanAttr ? 1 : 0) + (hasLiteralAttr ? 1 : 0) + (hasValueAttr ? 1 : 0);
    if (valueAttrs > 1) {
        errorLog(@"Variable declarations may contain only one of these attributes: \"%@\"; this declaration will be ignored: %@", [@[kMBMLAttributeValue, kMBMLAttributeBoolean, kMBMLAttributeLiteral] componentsJoinedByString:@"\", \""], self.simulatedXML);
        return NO;
    }
    _isLiteralValue = hasLiteralAttr;
    _isBooleanValue = hasBooleanAttr;
    
    id val = nil;
    if (hasLiteralAttr) {
        val = [self valueOfAttribute:kMBMLAttributeLiteral];
    } else if (hasValueAttr) {
        val = [self valueOfAttribute:kMBMLAttributeValue];
    } else if (hasBooleanAttr) {
        val = [self valueOfAttribute:kMBMLAttributeBoolean];
    }
    if (val != _declaredValue) {
        _declaredValue = val;
    }
    
    _isReadOnly = NO;
    id mutableAttr = [self valueOfAttribute:kMBMLAttributeMutable];
    if (mutableAttr) {
        _isReadOnly = ![MBExpression booleanFromValue:mutableAttr];
    }
    
    return YES;
}

/******************************************************************************/
#pragma mark Property handling
/******************************************************************************/

- (BOOL) isReadOnly
{
    return _isReadOnly;
}

- (BOOL) disallowsValueCaching
{
    return NO;
}

- (MBConcreteVariableType) declaredType
{
    NSString* typeStr = [self stringValueOfAttribute:kMBMLAttributeType];
    if (typeStr) {
        if ([typeStr isEqualToString:kMBMLVariableTypeList]) {
            return MBConcreteVariableTypeList;
        }
        else if ([typeStr isEqualToString:kMBMLVariableTypeMap]) {
            return MBConcreteVariableTypeMap;
        }
        else {
            return MBConcreteVariableTypeUnknown;
        }
    }
    return MBConcreteVariableTypeSimple;
}

- (NSString*) userDefaultsName
{
    return [self stringValueOfAttribute:kMBMLAttributeUserDefaultsName];
}

/******************************************************************************/
#pragma mark MBStringValueCoding support
/******************************************************************************/

- (id) _stringValueCodingDecode:(NSString*)value
{
    if (![value isKindOfClass:[NSString class]]) {
        return value;
    }
    
    if (value.length < 4 || ![value hasPrefix:@"["] || ![value hasSuffix:@"]"]) {
        return value;
    }
    
    NSRange delimiter = [value rangeOfString:@":"];
    if (delimiter.location == NSNotFound || delimiter.location < 2) {
        return value;
    }
    
    NSString* clsName = [value substringWithRange:NSMakeRange(1, delimiter.location-1)];
    Class cls = NSClassFromString(clsName);
    if (!cls) {
        return value;
    }
    
    if (![cls conformsToProtocol:@protocol(MBStringValueCoding)]) {
        return value;
    }
    
    NSString* valueSrc = [value substringWithRange:NSMakeRange(delimiter.location + 1, (value.length - delimiter.location) - 2)];
    id objVal = [cls fromStringValue:valueSrc];
    
    return objVal;
}

- (id) _stringValueCodingEncode:(id)obj
{
    if ([obj conformsToProtocol:@protocol(MBStringValueCoding)]) {
        return [NSString stringWithFormat:@"[%@:%@]", [obj class], [obj stringValue]];
    }
    return obj;
}

/******************************************************************************/
#pragma mark Variable value change hook
/******************************************************************************/

- (void) valueChangedTo:(id)val inVariableSpace:(MBVariableSpace*)space
{
    NSString* defsName = self.userDefaultsName;
    if (defsName) {
        NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
        if (val) {
            val = [self _stringValueCodingEncode:val];
            if (val) {
                [defs setObject:val forKey:defsName];
            }
        }
        else {
            [defs removeObjectForKey:defsName];
        }
        [defs synchronize];
        
        [MBEvents postEvent:[NSString stringWithFormat:@"UserDefault:%@:valueChanged", defsName] fromSender:self];
    }
}

/******************************************************************************/
#pragma mark Accessing variable values
/******************************************************************************/

- (id) _initialValueForSimpleVariableInSpace:(MBVariableSpace*)space
                                       error:(out MBExpressionError**)errPtr
{
    if (_isLiteralValue) {
        // literal value; we don't evaluate the expression
        return _declaredValue;
    }
    else if (_isBooleanValue) {
        // boolean value; evaluate as boolean and return result in an object
        BOOL retVal = [MBExpression asBoolean:_declaredValue
                              inVariableSpace:space
                                 defaultValue:NO
                                        error:errPtr];
        return @(retVal);
    }
    else {
        // regular value; evaluate expression and return result
        return [MBExpression asObject:_declaredValue
                      inVariableSpace:space
                         defaultValue:_declaredValue
                                error:errPtr];
    }
}

- (id) _initialValueForMapVariableInSpace:(MBVariableSpace*)space
                                    error:(out MBExpressionError**)errPtr
{
    NSArray* relatives = [self relativesWithDefaultRelation];
    NSMutableDictionary* map = [NSMutableDictionary dictionaryWithCapacity:relatives.count];
    for (MBVariableDeclaration* decl in relatives) {
        NSString* name = decl.name;
        id val = [decl initialValueInVariableSpace:space error:errPtr];
        if (val) {
            map[name] = val;
        }
    }
    
    if (_isReadOnly) {
        return [NSDictionary dictionaryWithDictionary:map];
    }
    return map;
}

- (id) _initialValueForListVariableInSpace:(MBVariableSpace*)space
                                     error:(out MBExpressionError**)errPtr
{
    NSArray* relatives = [self relativesWithDefaultRelation];
    NSMutableArray* list = [NSMutableArray arrayWithCapacity:relatives.count];
    for (MBVariableDeclaration* decl in [self relativesWithDefaultRelation]) {
        id val = [decl initialValueInVariableSpace:space error:errPtr];
        if (val) {
            [list addObject:val];
        }
    }

    if (_isReadOnly) {
        return [NSArray arrayWithArray:list];
    }
    
    return list;
}

- (id) initialValueInVariableSpace:(MBVariableSpace*)space
                             error:(out MBExpressionError**)errPtr
{
    debugTrace();

    id val = nil;
    NSString* defName = self.userDefaultsName;
    if (defName) {
        val = [[NSUserDefaults standardUserDefaults] objectForKey:defName];
        if (val) {
            val = [self _stringValueCodingDecode:val];
        }
    }
    if (!val) {
        switch (self.declaredType) {
            case MBConcreteVariableTypeMap:
                val = [self _initialValueForMapVariableInSpace:space error:errPtr];
                break;
                
            case MBConcreteVariableTypeList:
                val = [self _initialValueForListVariableInSpace:space error:errPtr];
                break;
                
            case MBConcreteVariableTypeSimple:
            default:
                val = [self _initialValueForSimpleVariableInSpace:space error:errPtr];
                break;
        }
    }
    return val;
}

- (id) currentValueInVariableSpace:(MBVariableSpace*)space
                             error:(out MBExpressionError**)errPtr
{
    debugTrace();
    
    return [space varDictionary][self.name];
}

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBSingletonVariableDeclaration implementation
/******************************************************************************/

@implementation MBSingletonVariableDeclaration

/******************************************************************************/
#pragma mark Data model support
/******************************************************************************/

+ (NSSet*) requiredAttributes
{
    return [NSSet setWithObjects:kMBMLAttributeName, kMBMLAttributeClass, nil];
}

+ (NSSet*) supportedAttributes
{
    return [NSSet setWithObject:kMBMLAttributeMethod];
}

- (BOOL) validateAttributes
{
    if (![super validateAttributes]) {
        return NO;
    }
    
    NSString* clsName = [self stringValueOfAttribute:kMBMLAttributeClass];
    Class cls = NSClassFromString(clsName);
    if (!cls) {
        errorLog(@"%@ couldn't resolve a class from the value (\"%@\") of the \"%@\" attribute in: %@", [self class], clsName, kMBMLAttributeClass, self.simulatedXML);
        return NO;
    }
    
    SEL accessor = @selector(instance);
    NSString* method = [self stringValueOfAttribute:kMBMLAttributeMethod];
    if (method) {
        accessor = NSSelectorFromString(method);
        if (!accessor) {
            errorLog(@"\"%@\" does not appear to be a valid singleton accessor method name in: %@", method, self.simulatedXML);
            return NO;
        }
    }

    if (![cls respondsToSelector:accessor]) {
        errorLog(@"The class \"%@\" does not respond to the selector \"%@\" specified as the singleton's accessor method in: %@", clsName, method, self.simulatedXML);
        return NO;
    }
    
    _implementingClass = cls;
    _singletonAccessor = accessor;
    
    return YES;
}

/******************************************************************************/
#pragma mark Property handling
/******************************************************************************/

- (BOOL) isReadOnly
{
    return YES;
}

- (BOOL) disallowsValueCaching
{
    return YES;
}

/******************************************************************************/
#pragma mark Accessing variable values
/******************************************************************************/

- (id) currentValueInVariableSpace:(MBVariableSpace*)space
                             error:(out MBExpressionError**)errPtr
{
    debugTrace();
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [_implementingClass performSelector:_singletonAccessor];
#pragma clang diagnostic pop
}

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBDynamicVariableDeclaration implementation
/******************************************************************************/

@implementation MBDynamicVariableDeclaration

/******************************************************************************/
#pragma mark Data model support
/******************************************************************************/

+ (NSSet*) requiredAttributes
{
    return [NSSet setWithObjects:kMBMLAttributeName, kMBMLAttributeExpression, nil];
}

/******************************************************************************/
#pragma mark Property handling
/******************************************************************************/

- (BOOL) isReadOnly
{
    return YES;
}

- (BOOL) disallowsValueCaching
{
    return YES;
}

/******************************************************************************/
#pragma mark Accessing variable values
/******************************************************************************/

- (id) currentValueInVariableSpace:(MBVariableSpace*)space
                             error:(out MBExpressionError**)errPtr
{
    debugTrace();

    return [MBExpression asObject:[self stringValueOfAttribute:kMBMLAttributeExpression]
                  inVariableSpace:space
                     defaultValue:nil
                            error:errPtr];
}

@end
