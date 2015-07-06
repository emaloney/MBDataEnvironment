//
//  MBVariableDeclaration.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 9/6/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <RaptureXML@Gilt/RXMLElement.h>

#import "MBVariableDeclaration.h"
#import "MBVariableSpace.h"

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

+ (instancetype) dataModelFromXML:(RXMLElement*)xml
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
            MBLogError(@"Unknown variable type (\"%@\") specified in: %@", varType, xml.xml);
            return nil;
        }
    }
    return [[MBConcreteVariableDeclaration alloc] initWithXML:xml];
}

/******************************************************************************/
#pragma mark Data model support
/******************************************************************************/

+ (nullable NSSet*) supportedAttributes
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
        MBLogError(@"%@ got an unexpected value for \"%@\" attribute in: %@", [self class], kMBMLAttributeType, self.simulatedXML);
        return NO;
    }

    return YES;
}

/******************************************************************************/
#pragma mark Property handling
/******************************************************************************/

- (nullable NSString*) name
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

- (nullable id) initialValueInVariableSpace:(nonnull MBVariableSpace*)space
                                      error:(MBExpressionErrorPtrPtr)errPtr
{
    MBErrorNotImplementedReturn(id);
}

- (nullable id) currentValueInVariableSpace:(nonnull MBVariableSpace*)space
                                      error:(MBExpressionErrorPtrPtr)errPtr
{
    MBErrorNotImplementedReturn(id);
}

/******************************************************************************/
#pragma mark Variable value change hook
/******************************************************************************/

- (void) valueChangedTo:(nullable id)value inVariableSpace:(nonnull MBVariableSpace*)space
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

+ (nullable NSSet*) supportedAttributes
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
    MBLogDebugTrace();
    
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
    MBLogDebugTrace();
    
    if (![super validateAsRelativeOf:relative relatedBy:relationType dataModelRoot:root]) {
        return NO;
    }

    if (self.declaredType == MBConcreteVariableTypeUnknown) {
        NSString* type = [self stringValueOfAttribute:kMBMLAttributeType];
        MBLogError(@"\"%@\" is not a supported variable declaration type in: %@", type, self.simulatedXML);
        return NO;
    }

    BOOL shouldHaveName = YES;
    BOOL isContained = (relative != nil);
    if (isContained) {
        if (![relative isKindOfClass:[MBConcreteVariableDeclaration class]]) {
            MBLogError(@"Unexpected container class (%@); variable declarations may only be contained by %@ classes. Ignoring: %@", [relative class], [MBConcreteVariableDeclaration class], self.simulatedXML);
            return NO;
        }

        MBConcreteVariableDeclaration* container = (MBConcreteVariableDeclaration*) relative;
        MBConcreteVariableType containerVarType = container.declaredType;
        if (containerVarType != MBConcreteVariableTypeMap && containerVarType != MBConcreteVariableTypeList) {
            MBLogError(@"Unexpected container type (%u); variable declarations may only be contained within other variables declared with %@=\"%@\" or %@=\"%@\". Ignoring: %@", (unsigned int)containerVarType, kMBMLAttributeType, kMBMLVariableTypeList, kMBMLAttributeType, kMBMLVariableTypeMap, self.simulatedXML);
            return NO;
        }
        
        // lists don't take names for their contained <Var>s
        shouldHaveName = containerVarType != MBConcreteVariableTypeList;
    }
    
    NSString* name = [self stringValueOfAttribute:kMBMLAttributeName];
    if (shouldHaveName) {
        if (!name || !name.length) {
            MBLogError(@"%@ requires a \"%@\" attribute in: %@", [self class], kMBMLAttributeName, self.simulatedXML);
            return NO;
        }
    }
    else if (name.length) {
        MBLogError(@"%@ can't take a \"%@\" attribute because it is contained in a list; Ignoring: %@", [self class], kMBMLAttributeName, self.simulatedXML);
        return NO;
    }
    
    BOOL hasBooleanAttr = [self hasAttribute:kMBMLAttributeBoolean];
    BOOL hasLiteralAttr = [self hasAttribute:kMBMLAttributeLiteral];
    BOOL hasValueAttr = [self hasAttribute:kMBMLAttributeValue];
    NSUInteger valueAttrs = (hasBooleanAttr ? 1 : 0) + (hasLiteralAttr ? 1 : 0) + (hasValueAttr ? 1 : 0);
    if (valueAttrs > 1) {
        MBLogError(@"Variable declarations may contain only one of these attributes: \"%@\"; this declaration will be ignored: %@", [@[kMBMLAttributeValue, kMBMLAttributeBoolean, kMBMLAttributeLiteral] componentsJoinedByString:@"\", \""], self.simulatedXML);
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
#pragma mark Variable value change hook
/******************************************************************************/

- (void) valueChangedTo:(nullable id)value inVariableSpace:(nonnull MBVariableSpace*)space
{
    NSString* defsName = self.userDefaultsName;
    if (defsName) {
        NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
        if (value) {
            [defs setObject:value forKey:defsName];
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
                                       error:(MBExpressionErrorPtrPtr)errPtr
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
                                    error:(MBExpressionErrorPtrPtr)errPtr
{
    NSArray* relatives = [self relativesWithDefaultRelation];
    NSMutableDictionary* map = [NSMutableDictionary dictionaryWithCapacity:relatives.count];
    for (MBVariableDeclaration* decl in relatives) {
        if (!decl.disallowsValueCaching) {
            NSString* name = decl.name;
            id val = [decl initialValueInVariableSpace:space error:errPtr];
            if (val) {
                map[name] = val;
            }
        }
    }
    
    if (_isReadOnly) {
        return [NSDictionary dictionaryWithDictionary:map];
    }
    return map;
}

- (id) _initialValueForListVariableInSpace:(MBVariableSpace*)space
                                     error:(MBExpressionErrorPtrPtr)errPtr
{
    NSArray* relatives = [self relativesWithDefaultRelation];
    NSMutableArray* list = [NSMutableArray arrayWithCapacity:relatives.count];
    for (MBVariableDeclaration* decl in [self relativesWithDefaultRelation]) {
        if (!decl.disallowsValueCaching) {
            id val = [decl initialValueInVariableSpace:space error:errPtr];
            if (val) {
                [list addObject:val];
            }
        }
    }

    if (_isReadOnly) {
        return [NSArray arrayWithArray:list];
    }
    
    return list;
}

- (nullable id) initialValueInVariableSpace:(nonnull MBVariableSpace*)space
                                      error:(MBExpressionErrorPtrPtr)errPtr
{
    MBLogDebugTrace();

    id val = nil;
    NSString* defName = self.userDefaultsName;
    if (defName) {
        val = [[NSUserDefaults standardUserDefaults] objectForKey:defName];
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

- (nullable id) currentValueInVariableSpace:(nonnull MBVariableSpace*)space
                                      error:(MBExpressionErrorPtrPtr)errPtr
{
    MBLogDebugTrace();
    
    return space[self.name];
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

+ (nullable NSSet*) requiredAttributes
{
    return [NSSet setWithObjects:kMBMLAttributeName, kMBMLAttributeClass, nil];
}

+ (nullable NSSet*) supportedAttributes
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
        MBLogError(@"%@ couldn't resolve a class from the value (\"%@\") of the \"%@\" attribute in: %@", [self class], clsName, kMBMLAttributeClass, self.simulatedXML);
        return NO;
    }
    
    SEL accessor = @selector(instance);
    NSString* method = [self stringValueOfAttribute:kMBMLAttributeMethod];
    if (method) {
        accessor = NSSelectorFromString(method);
        if (!accessor) {
            MBLogError(@"\"%@\" does not appear to be a valid singleton accessor method name in: %@", method, self.simulatedXML);
            return NO;
        }
    }

    if (![cls respondsToSelector:accessor]) {
        MBLogError(@"The class \"%@\" does not respond to the selector \"%@\" specified as the singleton's accessor method in: %@", clsName, method, self.simulatedXML);
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

- (nullable id) currentValueInVariableSpace:(nonnull MBVariableSpace*)space
                                      error:(MBExpressionErrorPtrPtr)errPtr
{
    MBLogDebugTrace();
    
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

+ (nullable NSSet*) requiredAttributes
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

- (nullable id) currentValueInVariableSpace:(nonnull MBVariableSpace*)space
                                      error:(MBExpressionErrorPtrPtr)errPtr
{
    MBLogDebugTrace();

    return [MBExpression asObject:[self stringValueOfAttribute:kMBMLAttributeExpression]
                  inVariableSpace:space
                     defaultValue:nil
                            error:errPtr];
}

@end
