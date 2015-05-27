//
//  MBAttributeValidator.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 4/15/14.
//  Copyright (c) 2014 Evan Coyne Maloney. All rights reserved.
//

#import <MBToolbox/MBDebug.h>

#import "MBAttributeValidator.h"

#define DEBUG_LOCAL     0

/******************************************************************************/
#pragma mark -
#pragma mark MBAttributeValidator private interface
/******************************************************************************/

@interface MBAttributeValidator ()
@property(nonatomic, readwrite) MBDataModel* model;
@end

/******************************************************************************/
#pragma mark -
#pragma mark MBAttributeValidator implementation
/******************************************************************************/

@implementation MBAttributeValidator
{
    NSMutableArray* _errors;
}

/******************************************************************************/
#pragma mark Object lifecycle
/******************************************************************************/

+ (nonnull instancetype) validatorForDataModel:(MBDataModel*)model
{
    MBAttributeValidator* validator = [self new];
    validator.model = model;
    return validator;
}

/******************************************************************************/
#pragma mark Error message helpers
/******************************************************************************/

- (void) _addErrorWithFormat:(NSString*)format, ...
{
    va_list args;
    va_start(args, format);
    NSString* error = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    if (!_errors) {
        _errors = [NSMutableArray new];
    }
    [_errors addObject:error];
}

- (NSString*) _attributeListFromEnumeration:(NSObject<NSFastEnumeration>*)attrs
{
    NSMutableArray* list = [NSMutableArray new];
    for (NSString* attr in attrs) {
        [list addObject:attr];
    }
    return [NSString stringWithFormat:@"\"%@\"", [list componentsJoinedByString:@"\", \""]];
}

/******************************************************************************/
#pragma mark Validation helpers
/******************************************************************************/

- (NSUInteger) _countAttributesWithValues:(NSObject<NSFastEnumeration>*)attrs
{
    debugTrace();

    NSUInteger count = 0;
    for (NSString* attr in attrs) {
        if ([self.model hasAttribute:attr]) {
            count++;
        }
    }
    return count;
}

/******************************************************************************/
#pragma mark Performing validation
/******************************************************************************/

- (BOOL) require:(nonnull NSString*)attr1 or:(nonnull NSString*)attr2
{
    return [self require:attr1 or:attr2 butNotBoth:YES];
}

- (BOOL) require:(nonnull NSString*)attr1 or:(nonnull NSString*)attr2 butNotBoth:(BOOL)onlyAllowOne
{
    debugTrace();

    BOOL satisfied = YES;
    if (![self.model hasAttribute:attr1] && ![self.model hasAttribute:attr2]) {
        [self _addErrorWithFormat:@"A value for either the \"%@\" or the \"%@\" attribute is required", attr1, attr2];
        satisfied = NO;
    }
    else if (onlyAllowOne && [self.model hasAttribute:attr1] && [self.model hasAttribute:attr2]) {
        [self _addErrorWithFormat:@"Can't have values for both the \"%@\" and the \"%@\" attributes", attr1, attr2];
        satisfied = NO;
    }
    return satisfied;
}

- (BOOL) requireAtLeastOneOf:(nonnull NSObject<NSFastEnumeration>*)attrs
{
    debugTrace();

    BOOL hasAtLeastOne = NO;
    for (NSString* attr in attrs) {
        if ([self.model hasAttribute:attr]) {
            hasAtLeastOne = YES;
            break;
        }
    }
    if (!hasAtLeastOne) {
        [self _addErrorWithFormat:@"Requires at least one of the following attributes to be set: %@", [self _attributeListFromEnumeration:attrs]];
    }
    return hasAtLeastOne;
}

- (BOOL) requireExactlyOneOf:(nonnull NSObject<NSFastEnumeration>*)attrs
{
    debugTrace();

    NSUInteger count = [self _countAttributesWithValues:attrs];
    if (count != 1) {
        [self _addErrorWithFormat:@"Only one of the following attributes are allowed to be set: %@", [self _attributeListFromEnumeration:attrs]];
    }
    return (count == 1);
}

/******************************************************************************/
#pragma mark Checking validation results
/******************************************************************************/

- (BOOL) validate
{
    if (_errors.count == 0) {
        return YES;
    }

    for (NSString* errorMsg in _errors) {
        errorLog(@"%@", errorMsg);
    }

    return NO;
}

- (NSArray*) validationErrorMessages
{
    return [_errors copy];
}

@end

