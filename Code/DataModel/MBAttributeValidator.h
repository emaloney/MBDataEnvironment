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

@interface MBAttributeValidator : NSObject

+ (instancetype) validatorForDataModel:(MBDataModel*)model;

@property(nonatomic, readonly) MBDataModel* model;
@property(nonatomic, readonly) MBDataModel* validationErrorMessages;

// method names: require___, (permit___ | allow___) 


- (BOOL) require:(NSString*)attr1 or:(NSString*)attr2;
- (BOOL) require:(NSString*)attr1 or:(NSString*)attr2 butNotBoth:(BOOL)onlyAllowOne;

- (BOOL) requireAtLeastOneOf:(NSObject<NSFastEnumeration>*)attrs;

- (BOOL) requireExactlyOneOf:(NSObject<NSFastEnumeration>*)attrs;

- (BOOL) validate;

@end
