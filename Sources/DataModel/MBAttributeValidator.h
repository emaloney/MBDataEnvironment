//
//  MBAttributeValidator.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 4/15/14.
//  Copyright (c) 2014 Evan Coyne Maloney. All rights reserved.
//

#import "MBDataModel.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBAttributeValidator class
/******************************************************************************/

/*!
 `MBAttributeValidator` instances can be used to verify that a given
 `MBDataModel` contains an expected set of values.
 */
@interface MBAttributeValidator : NSObject

/*!
 Returns a new `MBAttributeValidator` to be used for validating the specified
 `MBDataModel`.
 
 @param     model The `MBDataModel` to be validated.
 
 @return    An `MBAttributeValidator` that can be used to validate `model`.
 */
+ (nonnull instancetype) validatorForDataModel:(nonnull MBDataModel*)model;

/*! Returns the `MBDataModel` that the receiver was constructed to validate. */
@property(nonnull, nonatomic, readonly) MBDataModel* model;

/*! Returns an array of `NSString`s containing error messages for any problems
    encountered during validation. Will be `nil` if no validation errors
    have occurred. */
@property(nullable, nonatomic, readonly) NSArray* validationErrorMessages;

/*!
 Requires that the data model contain either `attr1` or `attr2` but not
 both.

 @param     attr1 The name of the first attribute.

 @param     attr2 The name of the second attribute.
 
 @return    `YES` if the validation requirement was satisfied; `NO` otherwise.
 */
- (BOOL) require:(nonnull NSString*)attr1 or:(nonnull NSString*)attr2;

/*!
 Requires that the data model contain either `attr1` or `attr2`.

 @param     attr1 The name of the first attribute.

 @param     attr2 The name of the second attribute.
 
 @param     onlyAllowOne If `YES`, the requirement will be satisfied only
            if `attr1` or `attr2` exists but not both. If `NO`, the requirement
            will be satisfied if either `attr1` or `attr2` is present *or*
            if both are present.
 
 @return    `YES` if the validation requirement was satisfied; `NO` otherwise.
 */
- (BOOL) require:(nonnull NSString*)attr1 or:(nonnull NSString*)attr2 butNotBoth:(BOOL)onlyAllowOne;

/*!
 Requires at least one of a set of attribute names to be present in the data
 model. Validation will fail if none of the specified attributes are present.
 
 @param     attrs An enumeration of `NSString`s representing the attribute names
            to validate.
 
 @return    `YES` if the validation requirement was satisfied; `NO` otherwise.
 */
- (BOOL) requireAtLeastOneOf:(nonnull NSObject<NSFastEnumeration>*)attrs;

/*!
 Requires exactly one of a set of attribute names to be present in the data
 model. Validation will fail if none of the specified attributes are present,
 or if more than one is present.
 
 @param     attrs An enumeration of `NSString`s representing the attribute names
            to validate.
 
 @return    `YES` if the validation requirement was satisfied; `NO` otherwise.
 */
- (BOOL) requireExactlyOneOf:(nonnull NSObject<NSFastEnumeration>*)attrs;

/*!
 Returns `YES` if all validation requirements were satisfied.
 
 If validation did not succeed, the error messages contained in 
 `validationErrorMessages` will be logged to the console.
 
 @return    `YES` if validation succeeded; `NO` otherwise.
 */
- (BOOL) validate;

@end
