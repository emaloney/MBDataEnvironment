//
//  MBStringConversions.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 7/6/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBToolbox.h>

#import "MBStringConversions.h"
#import "MBExpression.h"
#import "MBDataEnvironmentConstants.h"
#import "MBDataEnvironmentModule.h"

#define DEBUG_LOCAL		0

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

NSString* const kMBMLTextAlignmentLeft                      = @"left";
NSString* const kMBMLTextAlignmentCenter                    = @"center";
NSString* const kMBMLTextAlignmentRight                     = @"right";

NSString* const kMBMLScrollViewIndicatorStyleDefault        = @"default";
NSString* const kMBMLScrollViewIndicatorStyleBlack          = @"black";
NSString* const kMBMLScrollViewIndicatorStyleWhite          = @"white";

NSString* const kMBMLLineBreakByWordWrapping                = @"wordWrap";
NSString* const kMBMLLineBreakByCharWrapping                = @"charWrap";
NSString* const kMBMLLineBreakByClipping                    = @"clip";
NSString* const kMBMLLineBreakByTruncatingHead              = @"headTruncation";
NSString* const kMBMLLineBreakByTruncatingTail              = @"tailTruncation";
NSString* const kMBMLLineBreakByTruncatingMiddle            = @"middleTruncation";

NSString* const kMBMLActivityIndicatorViewStyleWhiteLarge   = @"whiteLarge";
NSString* const kMBMLActivityIndicatorViewStyleWhite        = @"white";
NSString* const kMBMLActivityIndicatorViewStyleGray         = @"gray";

NSString* const kMBMLButtonTypeCustom                       = @"custom";
NSString* const kMBMLButtonTypeRoundedRect                  = @"rounded";
NSString* const kMBMLButtonTypeDetailDisclosure             = @"detailDisclosure";
NSString* const kMBMLButtonTypeInfoLight                    = @"infoLight";
NSString* const kMBMLButtonTypeInfoDark                     = @"infoDark";
NSString* const kMBMLButtonTypeContactAdd                   = @"contactAdd";

NSString* const kMBMLDateFormatterNoStyle                   = @"none";
NSString* const kMBMLDateFormatterShortStyle                = @"short";
NSString* const kMBMLDateFormatterMediumStyle               = @"medium";
NSString* const kMBMLDateFormatterLongStyle                 = @"long";
NSString* const kMBMLDateFormatterFullStyle                 = @"full";

NSString* const kMBMLTextBorderStyleNone                    = @"none";
NSString* const kMBMLTextBorderStyleLine                    = @"line";
NSString* const kMBMLTextBorderStyleBezel                   = @"bezel";
NSString* const kMBMLTextBorderStyleRoundedRect             = @"rounded";

NSString* const kMBMLTableViewStylePlain                    = @"plain";
NSString* const kMBMLTableViewStyleGrouped                  = @"grouped";

NSString* const kMBMLTableViewCellStyleDefault              = @"default";
NSString* const kMBMLTableViewCellStyleValue1               = @"value1";
NSString* const kMBMLTableViewCellStyleValue2               = @"value2";
NSString* const kMBMLTableViewCellStyleSubtitle             = @"subtitle";

NSString* const kMBMLTableViewCellSelectionStyleNone        = @"none";
NSString* const kMBMLTableViewCellSelectionStyleBlue        = @"blue";
NSString* const kMBMLTableViewCellSelectionStyleGray        = @"gray";
NSString* const kMBMLTableViewCellSelectionStyleGradient    = @"gradient";

NSString* const kMBMLTableViewCellAccessoryNone                     = @"none";
NSString* const kMBMLTableViewCellAccessoryDisclosureIndicator      = @"disclosureIndicator";
NSString* const kMBMLTableViewCellAccessoryDetailDisclosureButton   = @"detailDisclosureButton";
NSString* const kMBMLTableViewCellAccessoryCheckmark                = @"checkmark";

NSString* const kMBMLTableViewRowAnimationNone              = @"none";
NSString* const kMBMLTableViewRowAnimationFade              = @"fade";
NSString* const kMBMLTableViewRowAnimationRight             = @"right";
NSString* const kMBMLTableViewRowAnimationLeft              = @"left";
NSString* const kMBMLTableViewRowAnimationTop               = @"top";
NSString* const kMBMLTableViewRowAnimationBottom            = @"bottom";
NSString* const kMBMLTableViewRowAnimationMiddle            = @"middle";

NSString* const kMBMLControlStateNormal                     = @"normal";
NSString* const kMBMLControlStateHighlighted                = @"highlighted";
NSString* const kMBMLControlStateDisabled                   = @"disabled";
NSString* const kMBMLControlStateSelected                   = @"selected";

NSString* const kMBMLViewAnimationOptionLayoutSubviews              = @"layoutSubviews";
NSString* const kMBMLViewAnimationOptionAllowUserInteraction		= @"allowUserInteraction";
NSString* const kMBMLViewAnimationOptionBeginFromCurrentState		= @"beginFromCurrentState";
NSString* const kMBMLViewAnimationOptionRepeat                      = @"repeat";
NSString* const kMBMLViewAnimationOptionAutoreverse                 = @"autoreverse";
NSString* const kMBMLViewAnimationOptionOverrideInheritedDuration	= @"overrideInheritedDuration";
NSString* const kMBMLViewAnimationOptionOverrideInheritedCurve		= @"overrideInheritedCurve";
NSString* const kMBMLViewAnimationOptionAllowAnimatedContent		= @"allowAnimatedContent";
NSString* const kMBMLViewAnimationOptionShowHideTransitionViews		= @"showHideTransitionViews";
NSString* const kMBMLViewAnimationOptionCurveEaseInOut              = @"curveEaseInOut";
NSString* const kMBMLViewAnimationOptionCurveEaseIn                 = @"curveEaseIn";
NSString* const kMBMLViewAnimationOptionCurveEaseOut                = @"curveEaseOut";
NSString* const kMBMLViewAnimationOptionCurveLinear                 = @"curveLinear";
NSString* const kMBMLViewAnimationOptionTransitionNone              = @"transitionNone";
NSString* const kMBMLViewAnimationOptionTransitionFlipFromLeft      = @"transitionFlipFromLeft";
NSString* const kMBMLViewAnimationOptionTransitionFlipFromRight     = @"transitionFlipFromRight";
NSString* const kMBMLViewAnimationOptionTransitionCurlUp            = @"transitionCurlUp";
NSString* const kMBMLViewAnimationOptionTransitionCurlDown          = @"transitionCurlDown";
NSString* const kMBMLViewAnimationOptionTransitionCrossDissolve     = @"transitionCrossDissolve";
NSString* const kMBMLViewAnimationOptionTransitionFlipFromTop       = @"transitionFlipFromTop";
NSString* const kMBMLViewAnimationOptionTransitionFlipFromBottom	= @"transitionFlipFromBottom";

NSString* const kMBMLModalTransitionStyleCoverVertical      = @"coverVertical";
NSString* const kMBMLModalTransitionStyleFlipHorizontal     = @"flipHorizontal";
NSString* const kMBMLModalTransitionStyleCrossDissolve      = @"crossDissolve";
NSString* const kMBMLModalTransitionStylePartialCurl        = @"partialCurl";

NSString* const kMBMLViewContentModeScaleToFill             = @"scaleToFill";
NSString* const kMBMLViewContentModeScaleAspectFit          = @"aspectFit";
NSString* const kMBMLViewContentModeScaleAspectFill         = @"aspectFill";
NSString* const kMBMLViewContentModeRedraw                  = @"redraw";
NSString* const kMBMLViewContentModeCenter                  = @"center";
NSString* const kMBMLViewContentModeTop                     = @"top";
NSString* const kMBMLViewContentModeBottom                  = @"bottom";
NSString* const kMBMLViewContentModeLeft                    = @"left";
NSString* const kMBMLViewContentModeRight                   = @"right";
NSString* const kMBMLViewContentModeTopLeft                 = @"topLeft";
NSString* const kMBMLViewContentModeTopRight                = @"topRight";
NSString* const kMBMLViewContentModeBottomLeft              = @"bottomLeft";
NSString* const kMBMLViewContentModeBottomRight             = @"bottomRight";

NSString* const kMBMLBarStyleDefault                        = @"default";
NSString* const kMBMLBarStyleBlack                          = @"black";
NSString* const kMBMLBarStyleBlackOpaque                    = @"blackOpaque";
NSString* const kMBMLBarStyleBlackTranslucent               = @"blackTranslucent";

NSString* const kMBMLBarButtonSystemItemDone				= @"done";
NSString* const kMBMLBarButtonSystemItemCancel				= @"cancel";
NSString* const kMBMLBarButtonSystemItemEdit				= @"edit";
NSString* const kMBMLBarButtonSystemItemSave				= @"save";
NSString* const kMBMLBarButtonSystemItemAdd	                = @"add";
NSString* const kMBMLBarButtonSystemItemFlexibleSpace		= @"flexibleSpace";
NSString* const kMBMLBarButtonSystemItemFixedSpace			= @"fixedSpace";
NSString* const kMBMLBarButtonSystemItemCompose				= @"compose";
NSString* const kMBMLBarButtonSystemItemReply				= @"reply";
NSString* const kMBMLBarButtonSystemItemAction				= @"action";
NSString* const kMBMLBarButtonSystemItemOrganize			= @"organize";
NSString* const kMBMLBarButtonSystemItemBookmarks			= @"bookmarks";
NSString* const kMBMLBarButtonSystemItemSearch				= @"search";
NSString* const kMBMLBarButtonSystemItemRefresh				= @"refresh";
NSString* const kMBMLBarButtonSystemItemStop				= @"stop";
NSString* const kMBMLBarButtonSystemItemCamera				= @"camera";
NSString* const kMBMLBarButtonSystemItemTrash				= @"trash";
NSString* const kMBMLBarButtonSystemItemPlay				= @"play";
NSString* const kMBMLBarButtonSystemItemPause				= @"pause";
NSString* const kMBMLBarButtonSystemItemRewind				= @"rewind";
NSString* const kMBMLBarButtonSystemItemFastForward			= @"fastForward";
NSString* const kMBMLBarButtonSystemItemUndo				= @"undo";
NSString* const kMBMLBarButtonSystemItemRedo				= @"redo";
NSString* const kMBMLBarButtonSystemItemPageCurl			= @"pageCurl";

NSString* const kMBMLBarButtonItemStylePlain                = @"plain";
NSString* const kMBMLBarButtonItemStyleBordered             = @"bordered";
NSString* const kMBMLBarButtonItemStyleDone                 = @"done";

NSString* const kMBMLStatusBarAnimationNone                 = @"none";
NSString* const kMBMLStatusBarAnimationFade                 = @"fade";
NSString* const kMBMLStatusBarAnimationSlide                = @"slide";

NSString* const kMBMLPopoverArrowDirectionUp                = @"up";
NSString* const kMBMLPopoverArrowDirectionDown              = @"down";
NSString* const kMBMLPopoverArrowDirectionLeft              = @"left";
NSString* const kMBMLPopoverArrowDirectionRight             = @"right";
NSString* const kMBMLPopoverArrowDirectionAny               = @"any";

/******************************************************************************/
#pragma mark -
#pragma mark MBStringConversions implementation
/******************************************************************************/

@implementation MBStringConversions

/******************************************************************************/
#pragma mark Private - error handling
/******************************************************************************/

+ (BOOL) _reportErrorWithMessage:(NSString*)msg to:(NSErrorPtrPtr)errPtr
{
    if (errPtr) {
        *errPtr = [NSError mockingbirdErrorWithDescription:msg code:kMBErrorParseFailed];
    }
    else {
        MBLogError(@"%@ error: %@", [self class], msg);
    }
    return NO; // coding conventions require methods accepting NSError** to return boolean
}

+ (BOOL) _reportCouldNotParse:(NSString*)badValue
                           as:(NSString*)asType
                    expecting:(NSString*)expected
                           to:(NSErrorPtrPtr)errPtr
{
    NSString* errMsg = [NSString stringWithFormat:@"couldn't parse \"%@\" as a %@; expecting %@", badValue, asType, expected];
    return [self _reportErrorWithMessage:errMsg
                                      to:errPtr];
}

+ (BOOL) _reportCouldNotParse:(NSString*)badValue
                           as:(NSString*)asType
           expectingStructure:(NSString*)expected
                           to:(NSErrorPtrPtr)errPtr
{
    return [self _reportCouldNotParse:badValue
                                   as:asType
                            expecting:[NSString stringWithFormat:@"\"%@\" value format", expected]
                                   to:errPtr];
}

+ (BOOL) _reportCouldNotParse:(NSString*)badValue
                           as:(NSString*)asType
          expectingValueAmong:(NSArray*)expected
                           to:(NSErrorPtrPtr)errPtr
{
    return [self _reportCouldNotParse:badValue
                                   as:asType
                            expecting:[NSString stringWithFormat:@"value to be one of: \"%@\"", [expected componentsJoinedByString:@"\", \""]]
                                   to:errPtr];
}

+ (BOOL) _reportCouldNotParseFlag:(NSString*)badFlag
                          inValue:(NSString*)value
                               as:(NSString*)asType
              expectingValueAmong:(NSArray*)expected
                               to:(NSErrorPtrPtr)errPtr
{
    NSString* errMsg = [NSString stringWithFormat:@"couldn't parse flag \"%@\" in value \"%@\" as a %@ bitwise field; each flag must be one of: \"%@\"", badFlag, value, asType, [expected componentsJoinedByString:@"\", \""]];
    return [self _reportErrorWithMessage:errMsg
                                      to:errPtr];
}

+ (BOOL) _reportCouldNotInterpretValue:(NSValue*)value
                                    as:(NSString*)asType
                                    to:(NSErrorPtrPtr)errPtr
{
    NSString* errMsg = [NSString stringWithFormat:@"couldn't extract the type %@ from the the %@ \"%@\"; the type encodings don't match", asType, [value class], value];
    return [self _reportErrorWithMessage:errMsg
                                      to:errPtr];
}

+ (BOOL) _reportCouldNotInterpretObject:(id)obj
                                     as:(NSString*)asType
                                     to:(NSErrorPtrPtr)errPtr
{
    NSString* errMsg = [NSString stringWithFormat:@"couldn't convert the type %@ into a %@; source type must be %@ or %@", [obj class], asType, [NSString class], [NSValue class]];
    return [self _reportErrorWithMessage:errMsg
                                      to:errPtr];
}

+ (void) _logError:(NSError*)err fromExpression:(NSString*)expr
{
    MBLogError(@"%@ error: %@ (offending expression: \"%@\")", [self class], [err localizedDescription], expr);
}

/******************************************************************************/
#pragma mark CGPoint conversions
/******************************************************************************/

+ (CGPoint) pointFromString:(nonnull NSString*)str
{
    return [self pointFromString:str error:nil];
}

+ (CGPoint) pointFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    MBLogDebugTrace();
    
    if (str && str.length > 0) {
        NSArray* dims = [str componentsSeparatedByString:@","];
        if (dims.count == 2) {
            CGFloat x = [dims[0] doubleValue];
            CGFloat y = [dims[1] doubleValue];
            return CGPointMake(x, y);
        }
        else {
            [self _reportCouldNotParse:str
                                    as:MBStringify(CGPoint)
                    expectingStructure:@"x,y"
                                    to:errPtr];
        }
    }
    return CGPointZero;
}

+ (CGPoint) pointFromObject:(nonnull id)obj error:(NSErrorPtrPtr)errPtr
{
    if ([obj isKindOfClass:[NSString class]]) {
        return [self pointFromString:obj error:errPtr];
    }
    else if ([obj isKindOfClass:[NSValue class]]) {
        NSValue* value = (NSValue*)obj;
        if (!strcmp([value objCType], @encode(CGPoint))) {
            return [value CGPointValue];
        }
        else {
            [self _reportCouldNotInterpretValue:value
                                             as:MBStringify(CGPoint)
                                             to:errPtr];
        }
    }
    else {
        [self _reportCouldNotInterpretObject:obj
                                          as:MBStringify(CGPoint)
                                          to:errPtr];
    }
    return CGPointZero;
}

+ (CGPoint) pointFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    CGPoint val = [self pointFromObject:[expr evaluateAsObject] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

+ (nonnull NSString*) stringFromPoint:(CGPoint)val
{
    return [NSString stringWithFormat:@"%g,%g", val.x, val.y];
}

/******************************************************************************/
#pragma mark CGSize conversions
/******************************************************************************/

+ (CGFloat) sizeDimensionFromExpression:(nonnull NSString*)expr
{
    if ([expr isEqualToString:kMBWildcardString]) {
        return UIViewNoIntrinsicMetric;
    }
    
    MBExpressionError* err = nil;
    NSNumber* num = [MBExpression asNumber:expr error:&err];
    if (err) {
        return [self sizeDimensionFromString:[expr evaluateAsString]];
    }
    return [num doubleValue];
}

+ (CGFloat) sizeDimensionFromString:(nonnull NSString*)str
{
    CGFloat dim = UIViewNoIntrinsicMetric;
    if (![str isEqualToString:kMBWildcardString]) {
        dim = [str doubleValue];
    }
    return dim;
}

+ (BOOL) parseString:(nonnull NSString*)sizeStr asSize:(nonnull out CGSize*)sizePtr
{
    MBArgNonNil(sizePtr);
    
    NSArray* dims = [sizeStr componentsSeparatedByString:@","];
    if (dims.count == 2) {
        CGFloat width = [self sizeDimensionFromString:dims[0]];
        CGFloat height = [self sizeDimensionFromString:dims[1]];
        *sizePtr = CGSizeMake(width, height);
        return YES;
    }
    return NO;
}

+ (CGSize) sizeFromString:(nonnull NSString*)str
{
    return [self sizeFromString:str error:nil];
}

+ (CGSize) sizeFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    MBLogDebugTrace();
    
    CGSize retVal = CGSizeZero;
    if (str && str.length > 0) {
        if (![self parseString:str asSize:&retVal]) {
            [self _reportCouldNotParse:str
                                    as:MBStringify(CGSize)
                    expectingStructure:@"width,height"
                                    to:errPtr];
        }
    }
    return retVal;
}

+ (CGSize) sizeFromObject:(nonnull id)obj error:(NSErrorPtrPtr)errPtr
{
    if ([obj isKindOfClass:[NSString class]]) {
        return [self sizeFromString:obj error:errPtr];
    }
    else if ([obj isKindOfClass:[NSValue class]]) {
        NSValue* value = (NSValue*)obj;
        if (!strcmp([value objCType], @encode(CGSize))) {
            return [value CGSizeValue];
        }
        else {
            [self _reportCouldNotInterpretValue:value
                                             as:MBStringify(CGSize)
                                             to:errPtr];
        }
    }
    else {
        [self _reportCouldNotInterpretObject:obj
                                          as:MBStringify(CGSize)
                                          to:errPtr];
    }
    return CGSizeZero;
}

+ (CGSize) sizeFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    CGSize val = [self sizeFromObject:[expr evaluateAsObject] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

+ (nonnull NSString*) stringFromSize:(CGSize)sz
{
    return [NSString stringWithFormat:@"%g,%g", sz.width, sz.height];
}

/******************************************************************************/
#pragma mark CGRect conversions
/******************************************************************************/

+ (BOOL) parseString:(nonnull NSString*)rectStr asRect:(nonnull out CGRect*)rectPtr
{
    MBArgNonNil(rectPtr);
    
    NSArray* dims = [rectStr componentsSeparatedByString:@","];
    if (dims.count == 4) {
        CGFloat x = [dims[0] doubleValue];
        CGFloat y = [dims[1] doubleValue];
        CGFloat width = [self sizeDimensionFromString:dims[2]];
        CGFloat height = [self sizeDimensionFromString:dims[3]];
        *rectPtr = CGRectMake(x, y, width, height);
        return YES;
    }
    return NO;
}

+ (CGRect) rectFromString:(nonnull NSString*)str
{
    return [self rectFromString:str error:nil];
}

+ (CGRect) rectFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    MBLogDebugTrace();
    
    CGRect retVal = CGRectZero;
    if (str && str.length > 0) {
        if (![self parseString:str asRect:&retVal]) {
            [self _reportCouldNotParse:str
                                    as:MBStringify(CGRect)
                    expectingStructure:@"x,y,width,height"
                                    to:errPtr];
        }
    }
    return retVal;
}

+ (CGRect) rectFromObject:(nonnull id)obj error:(NSErrorPtrPtr)errPtr
{
    if ([obj isKindOfClass:[NSString class]]) {
        return [self rectFromString:obj error:errPtr];
    }
    else if ([obj isKindOfClass:[NSValue class]]) {
        NSValue* value = (NSValue*)obj;
        if (!strcmp([value objCType], @encode(CGRect))) {
            return [value CGRectValue];
        }
        else {
            [self _reportCouldNotInterpretValue:value
                                             as:MBStringify(CGRect)
                                             to:errPtr];
        }
    }
    else {
        [self _reportCouldNotInterpretObject:obj
                                          as:MBStringify(CGRect)
                                          to:errPtr];
    }
    return CGRectZero;
}

+ (CGRect) rectFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    CGRect val = [self rectFromObject:[expr evaluateAsObject] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

+ (nonnull NSString*) stringFromRect:(CGRect)rect
{
    return [NSString stringWithFormat:@"%g,%g,%g,%g", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height];
}

/******************************************************************************/
#pragma mark UIOffset conversions
/******************************************************************************/

+ (UIOffset) offsetFromString:(nonnull NSString*)str
{
    return [self offsetFromString:str error:nil];
}

+ (UIOffset) offsetFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    MBLogDebugTrace();
    
    if (str && str.length > 0) {
        NSArray* dims = [str componentsSeparatedByString:@","];
        if (dims.count == 2) {
            CGFloat h = [dims[0] doubleValue];
            CGFloat v = [dims[1] doubleValue];
            return UIOffsetMake(h, v);
        }
        else {
            [self _reportCouldNotParse:str
                                    as:MBStringify(UIOffset)
                    expectingStructure:@"horizontal,vertical"
                                    to:errPtr];
        }
    }
    return UIOffsetZero;
}

+ (UIOffset) offsetFromObject:(nonnull id)obj error:(NSErrorPtrPtr)errPtr
{
    if ([obj isKindOfClass:[NSString class]]) {
        return [self offsetFromString:obj error:errPtr];
    }
    else if ([obj isKindOfClass:[NSValue class]]) {
        NSValue* value = (NSValue*)obj;
        if (!strcmp([value objCType], @encode(UIOffset))) {
            return [value UIOffsetValue];
        }
        else {
            [self _reportCouldNotInterpretValue:value
                                             as:MBStringify(UIOffset)
                                             to:errPtr];
        }
    }
    else {
        [self _reportCouldNotInterpretObject:obj
                                          as:MBStringify(UIOffset)
                                          to:errPtr];
    }
    return UIOffsetZero;
}

+ (UIOffset) offsetFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    UIOffset val = [self offsetFromObject:[expr evaluateAsObject] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

/******************************************************************************/
#pragma mark UIEdgeInsets conversions
/******************************************************************************/

+ (UIEdgeInsets) edgeInsetsFromString:(nonnull NSString*)str
{
    return [self edgeInsetsFromString:str error:nil];
}

+ (UIEdgeInsets) edgeInsetsFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    MBLogDebugTrace();
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    if (str && str.length > 0) {
        NSArray* dims = [str componentsSeparatedByString:@","];
        if (dims.count == 4) {
            CGFloat top = [dims[0] doubleValue];
            CGFloat left = [dims[1] doubleValue];
            CGFloat bottom = [dims[2] doubleValue];
            CGFloat right = [dims[3] doubleValue];
            edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
        }
        else {
            [self _reportCouldNotParse:str
                                    as:MBStringify(UIEdgeInsets)
                    expectingStructure:@"top,left,bottom,right"
                                    to:errPtr];
        }
    }
    return edgeInsets;
}

+ (UIEdgeInsets) edgeInsetsFromObject:(nonnull id)obj error:(NSErrorPtrPtr)errPtr
{
    if ([obj isKindOfClass:[NSString class]]) {
        return [self edgeInsetsFromString:obj error:errPtr];
    }
    else if ([obj isKindOfClass:[NSValue class]]) {
        NSValue* value = (NSValue*)obj;
        if (!strcmp([value objCType], @encode(UIEdgeInsets))) {
            return [value UIEdgeInsetsValue];
        }
        else {
            [self _reportCouldNotInterpretValue:value
                                             as:MBStringify(UIEdgeInsets)
                                             to:errPtr];
        }
    }
    else {
        [self _reportCouldNotInterpretObject:obj
                                          as:MBStringify(UIEdgeInsets)
                                          to:errPtr];
    }
    return UIEdgeInsetsZero;
}

+ (UIEdgeInsets) edgeInsetsFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    UIEdgeInsets val = [self edgeInsetsFromObject:[expr evaluateAsObject] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

/******************************************************************************/
#pragma mark UIColor conversions
/******************************************************************************/

+ (nonnull UIColor*) colorFromString:(nonnull NSString*)str
{
    return [self colorFromString:str error:nil];
}

+ (nonnull UIColor*) colorFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    MBLogDebugTrace();
    
    if (!str || str.length < 1) {
        [self _reportErrorWithMessage:@"couldn't parse an empty string as a color" to:errPtr];
        return [UIColor yellowColor];
    }
    
    // see if we're dealing with one of the expected color names
    if ('#' != [str characterAtIndex:0]) {
        NSString* methodName = [NSString stringWithFormat:@"%@Color", str];
        SEL methodSel = NSSelectorFromString(methodName);
        if ([[UIColor class] respondsToSelector:methodSel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            UIColor* color = [[UIColor class] performSelector:methodSel];
#pragma clang diagnostic pop
            if ([color isKindOfClass:[UIColor class]]) {
                return color;
            }
        }
        [self _reportCouldNotParse:str
                                as:MBStringify(UIColor)
                         expecting:@"#RRGGBB or #RRGGBBAA format, or a UIColor-supported color name"
                                to:errPtr];
        return [UIColor yellowColor];
    }
    NSUInteger value = 0;
    
    for (int idx = 1; idx < str.length; idx++) {
        value <<= 4;
        
        unichar ch = [str characterAtIndex:idx];
        if (ch >= '0' && ch <= '9')
            value += ch - '0';
        else if (ch >= 'a' && ch <= 'f')
            value += 10 + ch - 'a';
        else if (ch >= 'A' && ch <= 'F')
            value += 10 + ch - 'A';
    }
    
    if (str.length == 7) { // No alpha
        value <<= 8;
        value |= 0xff;
    }
    
    return [UIColor colorWithRed:((value >> 24) & 0xFF)/255.0
                           green:((value >> 16) & 0xFF)/255.0
                            blue:((value >> 8) & 0xFF) / 255.0
                           alpha:(value & 0xFF) / 255.0];
}

+ (nonnull UIColor*) colorFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    UIColor* val = [self colorFromString:[expr evaluateAsString] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

/******************************************************************************/
#pragma mark NSLineBreakMode conversions
/******************************************************************************/

+ (NSLineBreakMode) lineBreakModeFromString:(nonnull NSString*)str
{
    return [self lineBreakModeFromString:str error:nil];
}

+ (NSLineBreakMode) lineBreakModeFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    if ([str isEqualToString:kMBMLLineBreakByWordWrapping]) {
        return NSLineBreakByWordWrapping;
    }
    else if ([str isEqualToString:kMBMLLineBreakByCharWrapping]) {
        return NSLineBreakByCharWrapping;
    }
    else if ([str isEqualToString:kMBMLLineBreakByClipping]) {
        return NSLineBreakByClipping;
    }
    else if ([str isEqualToString:kMBMLLineBreakByTruncatingHead]) {
        return NSLineBreakByTruncatingHead;
    }
    else if ([str isEqualToString:kMBMLLineBreakByTruncatingTail]) {
        return NSLineBreakByTruncatingTail;
    }
    else if ([str isEqualToString:kMBMLLineBreakByTruncatingMiddle]) {
        return NSLineBreakByTruncatingMiddle;
    }
    else {
        [self _reportCouldNotParse:str
                                as:MBStringify(NSLineBreakMode)
               expectingValueAmong:@[kMBMLLineBreakByWordWrapping, kMBMLLineBreakByCharWrapping, kMBMLLineBreakByClipping, kMBMLLineBreakByTruncatingHead, kMBMLLineBreakByTruncatingTail, kMBMLLineBreakByTruncatingMiddle]
                                to:errPtr];
    }
    
    return NSLineBreakByWordWrapping;
}

+ (NSLineBreakMode) lineBreakModeFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    NSLineBreakMode val = [self lineBreakModeFromString:[expr evaluateAsString] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

/******************************************************************************/
#pragma mark NSTextAlignment conversions
/******************************************************************************/

+ (NSTextAlignment) textAlignmentFromString:(NSString*)alignStr
{
    return [self textAlignmentFromString:alignStr error:nil];
}

+ (NSTextAlignment) textAlignmentFromString:(NSString*)alignStr error:(NSErrorPtrPtr)errPtr
{
    MBLogDebugTrace();
    
    if ([kMBMLTextAlignmentLeft isEqualToString:alignStr]) {
        return NSTextAlignmentLeft;
    }
    else if ([kMBMLTextAlignmentCenter isEqualToString:alignStr]) {
        return NSTextAlignmentCenter;
    }
    else if ([kMBMLTextAlignmentRight isEqualToString:alignStr]) {
        return NSTextAlignmentRight;
    }
    else {
        [self _reportCouldNotParse:alignStr
                                as:MBStringify(NSTextAlignment)
               expectingValueAmong:@[kMBMLTextAlignmentLeft, kMBMLTextAlignmentCenter, kMBMLTextAlignmentRight]
                                to:errPtr];
        
    }
    return NSTextAlignmentLeft;         // default to left
}

+ (NSTextAlignment) textAlignmentFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    NSTextAlignment val = [self textAlignmentFromString:[expr evaluateAsString] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

/******************************************************************************/
#pragma mark UIScrollViewIndicatorStyle conversions
/******************************************************************************/

+ (UIScrollViewIndicatorStyle) scrollViewIndicatorStyleFromString:(nonnull NSString*)str
{
    return [self scrollViewIndicatorStyleFromString:str error:nil];
}

+ (UIScrollViewIndicatorStyle) scrollViewIndicatorStyleFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    if ([str isEqualToString:kMBMLScrollViewIndicatorStyleDefault]) {
        return UIScrollViewIndicatorStyleDefault;
    }
    else if ([str isEqualToString:kMBMLScrollViewIndicatorStyleBlack]) {
        return UIScrollViewIndicatorStyleBlack;
    }
    else if ([str isEqualToString:kMBMLScrollViewIndicatorStyleWhite]) {
        return UIScrollViewIndicatorStyleWhite;
    }
    else {
        [self _reportCouldNotParse:str
                                as:MBStringify(UIScrollViewIndicatorStyle)
               expectingValueAmong:@[kMBMLScrollViewIndicatorStyleDefault, kMBMLScrollViewIndicatorStyleBlack, kMBMLScrollViewIndicatorStyleWhite]
                                to:errPtr];
    }
    
    return UIScrollViewIndicatorStyleDefault;
}

+ (UIScrollViewIndicatorStyle) scrollViewIndicatorStyleFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    UIScrollViewIndicatorStyle val = [self scrollViewIndicatorStyleFromString:[expr evaluateAsString] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

/******************************************************************************/
#pragma mark UIActivityIndicatorViewStyle conversions
/******************************************************************************/

+ (UIActivityIndicatorViewStyle) activityIndicatorViewStyleFromString:(nonnull NSString*)str
{
    return [self activityIndicatorViewStyleFromString:str error:nil];
}

+ (UIActivityIndicatorViewStyle) activityIndicatorViewStyleFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    if ([str isEqualToString:kMBMLActivityIndicatorViewStyleWhiteLarge]) {
        return UIActivityIndicatorViewStyleWhiteLarge;
    }
    else if ([str isEqualToString:kMBMLActivityIndicatorViewStyleWhite]) {
        return UIActivityIndicatorViewStyleWhite;
    }
    else if ([str isEqualToString:kMBMLActivityIndicatorViewStyleGray]) {
        return UIActivityIndicatorViewStyleGray;
    }
    else {
        [self _reportCouldNotParse:str
                                as:MBStringify(UIActivityIndicatorViewStyle)
               expectingValueAmong:@[kMBMLActivityIndicatorViewStyleWhiteLarge, kMBMLActivityIndicatorViewStyleWhite, kMBMLActivityIndicatorViewStyleGray]
                                to:errPtr];
    }
    
    return UIActivityIndicatorViewStyleWhite;
}

+ (UIActivityIndicatorViewStyle) activityIndicatorViewStyleFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    UIActivityIndicatorViewStyle val = [self activityIndicatorViewStyleFromString:[expr evaluateAsString] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

/******************************************************************************/
#pragma mark UIButtonType conversions
/******************************************************************************/

+ (UIButtonType) buttonTypeFromString:(nonnull NSString*)str
{
    return [self buttonTypeFromString:str error:nil];
}

+ (UIButtonType) buttonTypeFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    if ([str isEqualToString:kMBMLButtonTypeCustom]) {
        return UIButtonTypeCustom;
    }
    else if ([str isEqualToString:kMBMLButtonTypeRoundedRect]) {
        return UIButtonTypeRoundedRect;
    }
    else if ([str isEqualToString:kMBMLButtonTypeDetailDisclosure]) {
        return UIButtonTypeDetailDisclosure;
    }
    else if ([str isEqualToString:kMBMLButtonTypeInfoLight]) {
        return UIButtonTypeInfoLight;
    }
    else if ([str isEqualToString:kMBMLButtonTypeInfoDark]) {
        return UIButtonTypeInfoDark;
    }
    else if ([str isEqualToString:kMBMLButtonTypeContactAdd]) {
        return UIButtonTypeContactAdd;
    }
    else {
        [self _reportCouldNotParse:str
                                as:MBStringify(UIButtonType)
               expectingValueAmong:@[kMBMLButtonTypeCustom, kMBMLButtonTypeRoundedRect, kMBMLButtonTypeDetailDisclosure, kMBMLButtonTypeInfoLight, kMBMLButtonTypeInfoDark, kMBMLButtonTypeContactAdd]
                                to:errPtr];
    }
    
    return UIButtonTypeCustom;      // use custom button type by default
}

+ (UIButtonType) buttonTypeFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    UIButtonType val = [self buttonTypeFromString:[expr evaluateAsString] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

/******************************************************************************/
#pragma mark NSDateFormatterStyle conversions
/******************************************************************************/

+ (NSDateFormatterStyle) dateFormatterStyleFromString:(nonnull NSString*)str
{
    return [self dateFormatterStyleFromString:str error:nil];
}

+ (NSDateFormatterStyle) dateFormatterStyleFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    if ([str isEqualToString:kMBMLDateFormatterNoStyle]) {
        return NSDateFormatterNoStyle;
    }
    else if ([str isEqualToString:kMBMLDateFormatterShortStyle]) {
        return NSDateFormatterShortStyle;
    }
    else if ([str isEqualToString:kMBMLDateFormatterMediumStyle]) {
        return NSDateFormatterMediumStyle;
    }
    else if ([str isEqualToString:kMBMLDateFormatterLongStyle]) {
        return NSDateFormatterLongStyle;
    }
    else if ([str isEqualToString:kMBMLDateFormatterFullStyle]) {
        return NSDateFormatterFullStyle;
    }
    else {
        [self _reportCouldNotParse:str
                                as:MBStringify(NSDateFormatterStyle)
               expectingValueAmong:@[kMBMLDateFormatterNoStyle, kMBMLDateFormatterShortStyle, kMBMLDateFormatterMediumStyle, kMBMLDateFormatterLongStyle, kMBMLDateFormatterFullStyle]
                                to:errPtr];
    }
    
    return NSDateFormatterNoStyle;
}

+ (NSDateFormatterStyle) dateFormatterStyleFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    NSDateFormatterStyle val = [self dateFormatterStyleFromString:[expr evaluateAsString] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

/******************************************************************************/
#pragma mark UITextBorderStyle conversions
/******************************************************************************/

+ (UITextBorderStyle) textBorderStyleFromString:(nonnull NSString*)str
{
    return [self textBorderStyleFromString:str error:nil];
}

+ (UITextBorderStyle) textBorderStyleFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    if ([str isEqualToString:kMBMLTextBorderStyleNone]) {
        return UITextBorderStyleNone;
    }
    else if ([str isEqualToString:kMBMLTextBorderStyleLine]) {
        return UITextBorderStyleLine;
    }
    else if ([str isEqualToString:kMBMLTextBorderStyleBezel]) {
        return UITextBorderStyleBezel;
    }
    else if ([str isEqualToString:kMBMLTextBorderStyleRoundedRect]) {
        return UITextBorderStyleRoundedRect;
    }
    else {
        [self _reportCouldNotParse:str
                                as:MBStringify(UITextBorderStyle)
               expectingValueAmong:@[kMBMLTextBorderStyleNone, kMBMLTextBorderStyleLine, kMBMLTextBorderStyleBezel, kMBMLTextBorderStyleRoundedRect]
                                to:errPtr];
    }
    
    return UITextBorderStyleNone;
}

+ (UITextBorderStyle) textBorderStyleFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    UITextBorderStyle val = [self textBorderStyleFromString:[expr evaluateAsString] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

/******************************************************************************/
#pragma mark UITableViewStyle conversions
/******************************************************************************/

+ (UITableViewStyle) tableViewStyleFromString:(nonnull NSString*)str
{
    return [self tableViewStyleFromString:str error:nil];
}

+ (UITableViewStyle) tableViewStyleFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    if ([str isEqualToString:kMBMLTableViewStylePlain]) {
        return UITableViewStylePlain;
    }
    else if ([str isEqualToString:kMBMLTableViewStyleGrouped]) {
        return UITableViewStyleGrouped;
    }
    else {
        [self _reportCouldNotParse:str
                                as:MBStringify(UITableViewStyle)
               expectingValueAmong:@[kMBMLTableViewStylePlain, kMBMLTableViewStyleGrouped]
                                to:errPtr];
    }
    
    return UITableViewStylePlain;
}

+ (UITableViewStyle) tableViewStyleFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    UITableViewStyle val = [self tableViewStyleFromString:[expr evaluateAsString] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

/******************************************************************************/
#pragma mark UITableViewCell-related conversions
/******************************************************************************/

+ (UITableViewCellStyle) tableViewCellStyleFromString:(nonnull NSString*)str
{
    return [self tableViewCellStyleFromString:str error:nil];
}

+ (UITableViewCellStyle) tableViewCellStyleFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    if ([str isEqualToString:kMBMLTableViewCellStyleDefault]) {
        return UITableViewCellStyleDefault;
    }
    else if ([str isEqualToString:kMBMLTableViewCellStyleValue1]) {
        return UITableViewCellStyleValue1;
    }
    else if ([str isEqualToString:kMBMLTableViewCellStyleValue2]) {
        return UITableViewCellStyleValue2;
    }
    else if ([str isEqualToString:kMBMLTableViewCellStyleSubtitle]) {
        return UITableViewCellStyleSubtitle;
    }
    else {
        [self _reportCouldNotParse:str
                                as:MBStringify(UITableViewCellStyle)
               expectingValueAmong:@[kMBMLTableViewCellStyleDefault, kMBMLTableViewCellStyleValue1, kMBMLTableViewCellStyleValue2, kMBMLTableViewCellStyleSubtitle]
                                to:errPtr];
    }
    
    return UITableViewCellStyleDefault;
}

+ (UITableViewCellStyle) tableViewCellStyleFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    UITableViewCellStyle val = [self tableViewCellStyleFromString:[expr evaluateAsString] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

+ (MBTableViewCellSelectionStyle) tableViewCellSelectionStyleFromString:(nonnull NSString*)str
{
    return [self tableViewCellSelectionStyleFromString:str error:nil];
}

+ (MBTableViewCellSelectionStyle) tableViewCellSelectionStyleFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    if ([str isEqualToString:kMBMLTableViewCellSelectionStyleNone]) {
        return MBTableViewCellSelectionStyleNone;
    }
    else if ([str isEqualToString:kMBMLTableViewCellSelectionStyleBlue]) {
        return MBTableViewCellSelectionStyleBlue;
    }
    else if ([str isEqualToString:kMBMLTableViewCellSelectionStyleGray]) {
        return MBTableViewCellSelectionStyleGray;
    }
    else if ([str isEqualToString:kMBMLTableViewCellSelectionStyleGradient]) {
        return MBTableViewCellSelectionStyleGradient;
    }
    else {
        [self _reportCouldNotParse:str
                                as:MBStringify(UITableViewCellSelectionStyle)
               expectingValueAmong:@[kMBMLTableViewCellSelectionStyleNone, kMBMLTableViewCellSelectionStyleBlue, kMBMLTableViewCellSelectionStyleGray, kMBMLTableViewCellSelectionStyleGradient]
                                to:errPtr];
    }
    
    return MBTableViewCellSelectionStyleBlue;
}

+ (MBTableViewCellSelectionStyle) tableViewCellSelectionStyleFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    MBTableViewCellSelectionStyle val = [self tableViewCellSelectionStyleFromString:[expr evaluateAsString] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

+ (UITableViewCellAccessoryType) tableViewCellAccessoryTypeFromString:(nonnull NSString*)str
{
    return [self tableViewCellAccessoryTypeFromString:str error:nil];
}

+ (UITableViewCellAccessoryType) tableViewCellAccessoryTypeFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    if ([str isEqualToString:kMBMLTableViewCellAccessoryNone]) {
        return UITableViewCellAccessoryNone;
    }
    else if ([str isEqualToString:kMBMLTableViewCellAccessoryDisclosureIndicator]) {
        return UITableViewCellAccessoryDisclosureIndicator;
    }
    else if ([str isEqualToString:kMBMLTableViewCellAccessoryDetailDisclosureButton]) {
        return UITableViewCellAccessoryDetailDisclosureButton;
    }
    else if ([str isEqualToString:kMBMLTableViewCellAccessoryCheckmark]) {
        return UITableViewCellAccessoryCheckmark;
    }
    else {
        [self _reportCouldNotParse:str
                                as:MBStringify(UITableViewCellAccessoryType)
               expectingValueAmong:@[kMBMLTableViewCellAccessoryNone, kMBMLTableViewCellAccessoryDisclosureIndicator, kMBMLTableViewCellAccessoryDetailDisclosureButton, kMBMLTableViewCellAccessoryCheckmark]
                                to:errPtr];
    }
    
    return UITableViewCellAccessoryNone;
}

+ (UITableViewCellAccessoryType) tableViewCellAccessoryTypeFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    UITableViewCellAccessoryType val = [self tableViewCellAccessoryTypeFromString:[expr evaluateAsString] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

/******************************************************************************/
#pragma mark UITableViewRowAnimation conversions
/******************************************************************************/

+ (UITableViewRowAnimation) tableViewRowAnimationFromString:(nonnull NSString*)str
{
    return [self tableViewRowAnimationFromString:str error:nil];
}

+ (UITableViewRowAnimation) tableViewRowAnimationFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    if ([str isEqualToString:kMBMLTableViewRowAnimationNone]) {
        return UITableViewRowAnimationNone;
    }
    else if ([str isEqualToString:kMBMLTableViewRowAnimationFade]) {
        return UITableViewRowAnimationFade;
    }
    else if ([str isEqualToString:kMBMLTableViewRowAnimationRight]) {
        return UITableViewRowAnimationRight;
    }
    else if ([str isEqualToString:kMBMLTableViewRowAnimationLeft]) {
        return UITableViewRowAnimationLeft;
    }
    else if ([str isEqualToString:kMBMLTableViewRowAnimationTop]) {
        return UITableViewRowAnimationTop;
    }
    else if ([str isEqualToString:kMBMLTableViewRowAnimationBottom]) {
        return UITableViewRowAnimationBottom;
    }
    else if ([str isEqualToString:kMBMLTableViewRowAnimationMiddle]) {
        return UITableViewRowAnimationMiddle;
    }
    else {
        [self _reportCouldNotParse:str
                                as:MBStringify(UITableViewRowAnimation)
               expectingValueAmong:@[kMBMLTableViewRowAnimationNone, kMBMLTableViewRowAnimationFade, kMBMLTableViewRowAnimationRight, kMBMLTableViewRowAnimationLeft, kMBMLTableViewRowAnimationTop, kMBMLTableViewRowAnimationBottom, kMBMLTableViewRowAnimationMiddle]
                                to:errPtr];
    }
    
    return UITableViewRowAnimationNone;
}

+ (UITableViewRowAnimation) tableViewRowAnimationFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    UITableViewRowAnimation val = [self tableViewRowAnimationFromString:[expr evaluateAsString] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

/******************************************************************************/
#pragma mark UIControlState conversions
/******************************************************************************/

+ (UIControlState) controlStateFromString:(nonnull NSString*)str
{
    return [self controlStateFromString:str error:nil];
}

+ (UIControlState) controlStateFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    if ([str isEqualToString:kMBMLControlStateNormal]) {
        return UIControlStateNormal;
    }
    else if ([str isEqualToString:kMBMLControlStateHighlighted]) {
        return UIControlStateHighlighted;
    }
    else if ([str isEqualToString:kMBMLControlStateDisabled]) {
        return UIControlStateDisabled;
    }
    else if ([str isEqualToString:kMBMLControlStateSelected]) {
        return UIControlStateSelected;
    }
    else {
        [self _reportCouldNotParse:str
                                as:MBStringify(UIControlState)
               expectingValueAmong:@[kMBMLControlStateNormal, kMBMLControlStateHighlighted, kMBMLControlStateDisabled, kMBMLControlStateSelected]
                                to:errPtr];
    }
    
    return UIControlStateNormal;
}

+ (UIControlState) controlStateFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    UIControlState val = [self controlStateFromString:[expr evaluateAsString] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

/******************************************************************************/
#pragma mark UIViewAnimationOptions conversions
/******************************************************************************/

+ (UIViewAnimationOptions) viewAnimationOptionsFromString:(nonnull NSString*)str
{
    return [self viewAnimationOptionsFromString:str error:nil];
}

+ (UIViewAnimationOptions) viewAnimationOptionsFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    UIViewAnimationOptions options = 0;
    NSArray* flags = [str componentsSeparatedByString:@","];
    for (__strong NSString* flag in flags) {
        flag = MBTrimString(flag);
        if (flag.length > 0) {
            if ([flag isEqualToString:kMBMLViewAnimationOptionLayoutSubviews]) {
                options |= UIViewAnimationOptionLayoutSubviews;
            }
            else if ([flag isEqualToString:kMBMLViewAnimationOptionAllowUserInteraction]) {
                options |= UIViewAnimationOptionAllowUserInteraction;
            }
            else if ([flag isEqualToString:kMBMLViewAnimationOptionBeginFromCurrentState]) {
                options |= UIViewAnimationOptionBeginFromCurrentState;
            }
            else if ([flag isEqualToString:kMBMLViewAnimationOptionRepeat]) {
                options |= UIViewAnimationOptionRepeat;
            }
            else if ([flag isEqualToString:kMBMLViewAnimationOptionAutoreverse]) {
                options |= UIViewAnimationOptionAutoreverse;
            }
            else if ([flag isEqualToString:kMBMLViewAnimationOptionOverrideInheritedDuration]) {
                options |= UIViewAnimationOptionOverrideInheritedDuration;
            }
            else if ([flag isEqualToString:kMBMLViewAnimationOptionOverrideInheritedCurve]) {
                options |= UIViewAnimationOptionOverrideInheritedCurve;
            }
            else if ([flag isEqualToString:kMBMLViewAnimationOptionAllowAnimatedContent]) {
                options |= UIViewAnimationOptionAllowAnimatedContent;
            }
            else if ([flag isEqualToString:kMBMLViewAnimationOptionShowHideTransitionViews]) {
                options |= UIViewAnimationOptionShowHideTransitionViews;
            }
            else if ([flag isEqualToString:kMBMLViewAnimationOptionCurveEaseInOut]) {
                options |= UIViewAnimationOptionCurveEaseInOut;
            }
            else if ([flag isEqualToString:kMBMLViewAnimationOptionCurveEaseIn]) {
                options |= UIViewAnimationOptionCurveEaseIn;
            }
            else if ([flag isEqualToString:kMBMLViewAnimationOptionCurveEaseOut]) {
                options |= UIViewAnimationOptionCurveEaseOut;
            }
            else if ([flag isEqualToString:kMBMLViewAnimationOptionCurveLinear]) {
                options |= UIViewAnimationOptionCurveLinear;
            }
            else if ([flag isEqualToString:kMBMLViewAnimationOptionTransitionNone]) {
                options |= UIViewAnimationOptionTransitionNone;
            }
            else if ([flag isEqualToString:kMBMLViewAnimationOptionTransitionFlipFromLeft]) {
                options |= UIViewAnimationOptionTransitionFlipFromLeft;
            }
            else if ([flag isEqualToString:kMBMLViewAnimationOptionTransitionFlipFromRight]) {
                options |= UIViewAnimationOptionTransitionFlipFromRight;
            }
            else if ([flag isEqualToString:kMBMLViewAnimationOptionTransitionCurlUp]) {
                options |= UIViewAnimationOptionTransitionCurlUp;
            }
            else if ([flag isEqualToString:kMBMLViewAnimationOptionTransitionCurlDown]) {
                options |= UIViewAnimationOptionTransitionCurlDown;
            }
            else if ([flag isEqualToString:kMBMLViewAnimationOptionTransitionCrossDissolve]) {
                options |= UIViewAnimationOptionTransitionCrossDissolve;
            }
            else if ([flag isEqualToString:kMBMLViewAnimationOptionTransitionFlipFromBottom]) {
                options |= UIViewAnimationOptionTransitionFlipFromBottom;
            }
            else if ([flag isEqualToString:kMBMLViewAnimationOptionTransitionFlipFromBottom]) {
                options |= UIViewAnimationOptionTransitionFlipFromBottom;
            }
            else {
                [self _reportCouldNotParseFlag:flag
                                       inValue:str
                                            as:MBStringify(UIViewAnimationOptions)
                           expectingValueAmong:@[kMBMLViewAnimationOptionLayoutSubviews, kMBMLViewAnimationOptionAllowUserInteraction, kMBMLViewAnimationOptionBeginFromCurrentState, kMBMLViewAnimationOptionRepeat, kMBMLViewAnimationOptionAutoreverse, kMBMLViewAnimationOptionOverrideInheritedDuration, kMBMLViewAnimationOptionOverrideInheritedCurve, kMBMLViewAnimationOptionAllowAnimatedContent, kMBMLViewAnimationOptionShowHideTransitionViews, kMBMLViewAnimationOptionCurveEaseInOut, kMBMLViewAnimationOptionCurveEaseIn, kMBMLViewAnimationOptionCurveEaseOut, kMBMLViewAnimationOptionCurveLinear, kMBMLViewAnimationOptionTransitionNone, kMBMLViewAnimationOptionTransitionFlipFromLeft, kMBMLViewAnimationOptionTransitionFlipFromRight, kMBMLViewAnimationOptionTransitionCurlUp, kMBMLViewAnimationOptionTransitionCurlDown, kMBMLViewAnimationOptionTransitionCrossDissolve, kMBMLViewAnimationOptionTransitionFlipFromBottom, kMBMLViewAnimationOptionTransitionFlipFromBottom]
                                            to:errPtr];
            }
        }
    }
    return options;
}

+ (UIViewAnimationOptions) viewAnimationOptionsFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    UIViewAnimationOptions val = [self viewAnimationOptionsFromString:[expr evaluateAsString] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

/******************************************************************************/
#pragma mark UIModalTransitionStyle conversions
/******************************************************************************/

+ (UIModalTransitionStyle) modalTransitionStyleFromString:(nonnull NSString*)str
{
    return [self modalTransitionStyleFromString:str error:nil];
}

+ (UIModalTransitionStyle) modalTransitionStyleFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    if ([str isEqualToString:kMBMLModalTransitionStyleCoverVertical]) {
        return UIModalTransitionStyleCoverVertical;
    }
    else if ([str isEqualToString:kMBMLModalTransitionStyleFlipHorizontal]) {
        return UIModalTransitionStyleFlipHorizontal;
    }
    else if ([str isEqualToString:kMBMLModalTransitionStyleCrossDissolve]) {
        return UIModalTransitionStyleCrossDissolve;
    }
    else if ([str isEqualToString:kMBMLModalTransitionStylePartialCurl]) {
        return UIModalTransitionStylePartialCurl;
    }
    else {
        [self _reportCouldNotParse:str
                                as:MBStringify(UIModalTransitionStyle)
               expectingValueAmong:@[kMBMLModalTransitionStyleCoverVertical, kMBMLModalTransitionStyleFlipHorizontal, kMBMLModalTransitionStyleCrossDissolve, kMBMLModalTransitionStylePartialCurl]
                                to:errPtr];
    }
    
    return UIModalTransitionStyleCoverVertical;
}

+ (UIModalTransitionStyle) modalTransitionStyleFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    UIModalTransitionStyle val = [self modalTransitionStyleFromString:[expr evaluateAsString] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

/******************************************************************************/
#pragma mark UIViewContentMode conversions
/******************************************************************************/

+ (UIViewContentMode) viewContentModeFromString:(nonnull NSString*)str
{
    return [self viewContentModeFromString:str error:nil];
}

+ (UIViewContentMode) viewContentModeFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    if ([str isEqualToString:kMBMLViewContentModeScaleToFill]) {
        return UIViewContentModeScaleToFill;
    }
    else if ([str isEqualToString:kMBMLViewContentModeScaleAspectFit]) {
        return UIViewContentModeScaleAspectFit;
    }
    else if ([str isEqualToString:kMBMLViewContentModeScaleAspectFill]) {
        return UIViewContentModeScaleAspectFill;
    }
    else if ([str isEqualToString:kMBMLViewContentModeRedraw]) {
        return UIViewContentModeRedraw;
    }
    else if ([str isEqualToString:kMBMLViewContentModeCenter]) {
        return UIViewContentModeCenter;
    }
    else if ([str isEqualToString:kMBMLViewContentModeTop]) {
        return UIViewContentModeTop;
    }
    else if ([str isEqualToString:kMBMLViewContentModeBottom]) {
        return UIViewContentModeBottom;
    }
    else if ([str isEqualToString:kMBMLViewContentModeLeft]) {
        return UIViewContentModeLeft;
    }
    else if ([str isEqualToString:kMBMLViewContentModeRight]) {
        return UIViewContentModeRight;
    }
    else if ([str isEqualToString:kMBMLViewContentModeTopLeft]) {
        return UIViewContentModeTopLeft;
    }
    else if ([str isEqualToString:kMBMLViewContentModeTopRight]) {
        return UIViewContentModeTopRight;
    }
    else if ([str isEqualToString:kMBMLViewContentModeBottomLeft]) {
        return UIViewContentModeBottomLeft;
    }
    else if ([str isEqualToString:kMBMLViewContentModeBottomRight]) {
        return UIViewContentModeBottomRight;
    }
    else {
        [self _reportCouldNotParse:str
                                as:MBStringify(UIViewContentMode)
               expectingValueAmong:@[kMBMLViewContentModeScaleToFill, kMBMLViewContentModeScaleAspectFit, kMBMLViewContentModeScaleAspectFill, kMBMLViewContentModeRedraw, kMBMLViewContentModeCenter, kMBMLViewContentModeTop, kMBMLViewContentModeBottom, kMBMLViewContentModeLeft, kMBMLViewContentModeRight, kMBMLViewContentModeTopLeft, kMBMLViewContentModeTopRight, kMBMLViewContentModeBottomLeft, kMBMLViewContentModeBottomRight]
                                to:errPtr];
    }
    
    return UIViewContentModeScaleToFill;
}

+ (UIViewContentMode) viewContentModeFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    UIViewContentMode val = [self viewContentModeFromString:[expr evaluateAsString] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

/******************************************************************************/
#pragma mark UIBarStyle conversions
/******************************************************************************/

+ (UIBarStyle) barStyleFromString:(nonnull NSString*)str
{
    return [self barStyleFromString:str error:nil];
}

+ (UIBarStyle) barStyleFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    if ([str isEqualToString:kMBMLBarStyleDefault]) {
        return UIBarStyleDefault;
    }
    else if ([str isEqualToString:kMBMLBarStyleBlack]) {
        return UIBarStyleBlack;
    }
    else if ([str isEqualToString:kMBMLBarStyleBlackOpaque]) {
        return UIBarStyleBlackOpaque;
    }
    else if ([str isEqualToString:kMBMLBarStyleBlackTranslucent]) {
        return UIBarStyleBlackTranslucent;
    }
    else {
        [self _reportCouldNotParse:str
                                as:MBStringify(UIBarStyle)
               expectingValueAmong:@[kMBMLBarStyleDefault, kMBMLBarStyleBlack, kMBMLBarStyleBlackOpaque, kMBMLBarStyleBlackTranslucent]
                                to:errPtr];
    }
    
    return UIBarStyleDefault;
}

+ (UIBarStyle) barStyleFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    UIBarStyle val = [self barStyleFromString:[expr evaluateAsString] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

/******************************************************************************/
#pragma mark UIBarButtonSystemItem conversions
/******************************************************************************/

+ (UIBarButtonSystemItem) barButtonSystemItemFromString:(nonnull NSString*)str
{
    return [self barButtonSystemItemFromString:str error:nil];
}

+ (UIBarButtonSystemItem) barButtonSystemItemFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    if ([str isEqualToString:kMBMLBarButtonSystemItemDone]) {
        return UIBarButtonSystemItemDone;
    }
    else if ([str isEqualToString:kMBMLBarButtonSystemItemCancel]) {
        return UIBarButtonSystemItemCancel;
    }
    else if ([str isEqualToString:kMBMLBarButtonSystemItemEdit]) {
        return UIBarButtonSystemItemEdit;
    }
    else if ([str isEqualToString:kMBMLBarButtonSystemItemSave]) {
        return UIBarButtonSystemItemSave;
    }
    else if ([str isEqualToString:kMBMLBarButtonSystemItemAdd]) {
        return UIBarButtonSystemItemAdd;
    }
    else if ([str isEqualToString:kMBMLBarButtonSystemItemFlexibleSpace]) {
        return UIBarButtonSystemItemFlexibleSpace;
    }
    else if ([str isEqualToString:kMBMLBarButtonSystemItemFixedSpace]) {
        return UIBarButtonSystemItemFixedSpace;
    }
    else if ([str isEqualToString:kMBMLBarButtonSystemItemCompose]) {
        return UIBarButtonSystemItemCompose;
    }
    else if ([str isEqualToString:kMBMLBarButtonSystemItemReply]) {
        return UIBarButtonSystemItemReply;
    }
    else if ([str isEqualToString:kMBMLBarButtonSystemItemAction]) {
        return UIBarButtonSystemItemAction;
    }
    else if ([str isEqualToString:kMBMLBarButtonSystemItemOrganize]) {
        return UIBarButtonSystemItemOrganize;
    }
    else if ([str isEqualToString:kMBMLBarButtonSystemItemBookmarks]) {
        return UIBarButtonSystemItemBookmarks;
    }
    else if ([str isEqualToString:kMBMLBarButtonSystemItemSearch]) {
        return UIBarButtonSystemItemSearch;
    }
    else if ([str isEqualToString:kMBMLBarButtonSystemItemRefresh]) {
        return UIBarButtonSystemItemRefresh;
    }
    else if ([str isEqualToString:kMBMLBarButtonSystemItemStop]) {
        return UIBarButtonSystemItemStop;
    }
    else if ([str isEqualToString:kMBMLBarButtonSystemItemCamera]) {
        return UIBarButtonSystemItemCamera;
    }
    else if ([str isEqualToString:kMBMLBarButtonSystemItemTrash]) {
        return UIBarButtonSystemItemTrash;
    }
    else if ([str isEqualToString:kMBMLBarButtonSystemItemPlay]) {
        return UIBarButtonSystemItemPlay;
    }
    else if ([str isEqualToString:kMBMLBarButtonSystemItemPause]) {
        return UIBarButtonSystemItemPause;
    }
    else if ([str isEqualToString:kMBMLBarButtonSystemItemRewind]) {
        return UIBarButtonSystemItemRewind;
    }
    else if ([str isEqualToString:kMBMLBarButtonSystemItemFastForward]) {
        return UIBarButtonSystemItemFastForward;
    }
    else if ([str isEqualToString:kMBMLBarButtonSystemItemUndo]) {
        return UIBarButtonSystemItemUndo;
    }
    else if ([str isEqualToString:kMBMLBarButtonSystemItemRedo]) {
        return UIBarButtonSystemItemRedo;
    }
    else if ([str isEqualToString:kMBMLBarButtonSystemItemPageCurl]) {
        return UIBarButtonSystemItemPageCurl;
    }
    else {
        [self _reportCouldNotParse:str
                                as:MBStringify(UIBarButtonSystemItem)
               expectingValueAmong:@[kMBMLBarButtonSystemItemDone, kMBMLBarButtonSystemItemCancel, kMBMLBarButtonSystemItemEdit, kMBMLBarButtonSystemItemSave, kMBMLBarButtonSystemItemAdd, kMBMLBarButtonSystemItemFlexibleSpace, kMBMLBarButtonSystemItemFixedSpace, kMBMLBarButtonSystemItemCompose, kMBMLBarButtonSystemItemCamera, kMBMLBarButtonSystemItemTrash, kMBMLBarButtonSystemItemPlay, kMBMLBarButtonSystemItemPause, kMBMLBarButtonSystemItemRewind, kMBMLBarButtonSystemItemFastForward, kMBMLBarButtonSystemItemUndo, kMBMLBarButtonSystemItemRedo, kMBMLBarButtonSystemItemPageCurl]
                                to:errPtr];
    }
    
    return UIBarButtonSystemItemDone;
}

+ (UIBarButtonSystemItem) barButtonSystemItemFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    UIBarButtonSystemItem val = [self barButtonSystemItemFromString:[expr evaluateAsString] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

/******************************************************************************/
#pragma mark UIBarButtonItemStyle conversions
/******************************************************************************/

+ (UIBarButtonItemStyle) barButtonItemStyleFromString:(nonnull NSString*)str
{
    return [self barButtonItemStyleFromString:str error:nil];
}

+ (UIBarButtonItemStyle) barButtonItemStyleFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    if ([str isEqualToString:kMBMLBarButtonItemStylePlain]) {
        return UIBarButtonItemStylePlain;
    }
    else if ([str isEqualToString:kMBMLBarButtonItemStyleBordered]) {
        [[MBDataEnvironmentModule log] issueDeprecationWarningWithFormat:@"The UIBarButtonItemStyleBordered value (specified by the string \"%@\") is deprecated by Apple in the latest versions of iOS. UIBarButtonItemStylePlain will be returned instead.", str];
        return UIBarButtonItemStylePlain;
    }
    else if ([str isEqualToString:kMBMLBarButtonItemStyleDone]) {
        return UIBarButtonItemStyleDone;
    }
    else {
        [self _reportCouldNotParse:str
                                as:MBStringify(UIBarButtonItemStyle)
               expectingValueAmong:@[kMBMLBarButtonItemStylePlain, kMBMLBarButtonItemStyleBordered, kMBMLBarButtonItemStyleDone]
                                to:errPtr];
    }
    
    return UIBarButtonItemStylePlain;
}

+ (UIBarButtonItemStyle) barButtonItemStyleFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    UIBarButtonItemStyle val = [self barButtonItemStyleFromString:[expr evaluateAsString] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

/******************************************************************************/
#pragma mark UIStatusBarAnimation conversions
/******************************************************************************/

+ (UIStatusBarAnimation) statusBarAnimationFromString:(nonnull NSString*)str
{
    return [self statusBarAnimationFromString:str error:nil];
}

+ (UIStatusBarAnimation) statusBarAnimationFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    if ([str isEqualToString:kMBMLStatusBarAnimationNone]) {
        return UIStatusBarAnimationNone;
    }
    else if ([str isEqualToString:kMBMLStatusBarAnimationFade]) {
        return UIStatusBarAnimationFade;
    }
    else if ([str isEqualToString:kMBMLStatusBarAnimationSlide]) {
        return UIStatusBarAnimationSlide;
    }
    else {
        [self _reportCouldNotParse:str
                                as:MBStringify(UIStatusBarAnimation)
               expectingValueAmong:@[kMBMLStatusBarAnimationNone, kMBMLStatusBarAnimationFade, kMBMLStatusBarAnimationSlide]
                                to:errPtr];
    }
    
    return UIStatusBarAnimationNone;
}

+ (UIStatusBarAnimation) statusBarAnimationFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    UIStatusBarAnimation val = [self statusBarAnimationFromString:[expr evaluateAsString] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

/******************************************************************************/
#pragma mark UIPopoverArrowDirection conversions
/******************************************************************************/

+ (UIPopoverArrowDirection) popoverArrowDirectionFromString:(nonnull NSString*)str
{
    return [self popoverArrowDirectionFromString:str error:nil];
}

+ (UIPopoverArrowDirection) popoverArrowDirectionFromString:(nonnull NSString*)str error:(NSErrorPtrPtr)errPtr
{
    if ([str isEqualToString:kMBMLPopoverArrowDirectionUp]) {
        return UIPopoverArrowDirectionUp;
    }
    else if ([str isEqualToString:kMBMLPopoverArrowDirectionDown]) {
        return UIPopoverArrowDirectionDown;
    }
    else if ([str isEqualToString:kMBMLPopoverArrowDirectionLeft]) {
        return UIPopoverArrowDirectionLeft;
    }
    else if ([str isEqualToString:kMBMLPopoverArrowDirectionRight]) {
        return UIPopoverArrowDirectionRight;
    }
    else if ([str isEqualToString:kMBMLPopoverArrowDirectionAny]) {
        return UIPopoverArrowDirectionAny;
    }
    else {
        [self _reportCouldNotParse:str
                                as:MBStringify(UIStatusBarAnimation)
               expectingValueAmong:@[kMBMLPopoverArrowDirectionUp, kMBMLPopoverArrowDirectionDown, kMBMLPopoverArrowDirectionLeft, kMBMLPopoverArrowDirectionRight, kMBMLPopoverArrowDirectionAny]
                                to:errPtr];
    }
    
    return UIPopoverArrowDirectionAny;
}

+ (UIPopoverArrowDirection) popoverArrowDirectionFromExpression:(nonnull NSString*)expr
{
    NSError* err = nil;
    UIPopoverArrowDirection val = [self popoverArrowDirectionFromString:[expr evaluateAsString] error:&err];
    if (err) {
        [self _logError:err fromExpression:expr];
    }
    return val;
}

@end
