//
//  MBStringConversions.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 7/6/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/******************************************************************************/
#pragma mark Types
/******************************************************************************/

/*!
 Extends `UITableViewCellSelectionStyle` by providing a value representing
 a custom gradient cell selection style.
 */
typedef NS_ENUM(NSInteger, MBTableViewCellSelectionStyle)
{
    /*! Equivalent to `UITableViewCellSelectionStyleNone`. */
    MBTableViewCellSelectionStyleNone       = UITableViewCellSelectionStyleNone,

    /*! Equivalent to `UITableViewCellSelectionStyleBlue`. */
    MBTableViewCellSelectionStyleBlue       = UITableViewCellSelectionStyleBlue,

    /*! Equivalent to `UITableViewCellSelectionStyleGray`. */
    MBTableViewCellSelectionStyleGray       = UITableViewCellSelectionStyleGray,

    /*! Represents a custom cell selection style using a gradient. */
    MBTableViewCellSelectionStyleGradient   = NSIntegerMax
};

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

// NSTextAlignment
extern NSString* const kMBMLTextAlignmentLeft;                      // @"left" for NSTextAlignmentLeft
extern NSString* const kMBMLTextAlignmentCenter;                    // @"center" for NSTextAlignmentCenter
extern NSString* const kMBMLTextAlignmentRight;                     // @"right" for NSTextAlignmentRight

// UIScrollViewIndicatorStyle
extern NSString* const kMBMLScrollViewIndicatorStyleDefault;        // @"default" for UIScrollViewIndicatorStyleDefault
extern NSString* const kMBMLScrollViewIndicatorStyleBlack;          // @"black" for UIScrollViewIndicatorStyleBlack
extern NSString* const kMBMLScrollViewIndicatorStyleWhite;          // @"white" for UIScrollViewIndicatorStyleWhite

// NSLineBreakMode
extern NSString* const kMBMLLineBreakByWordWrapping;                // @"wordWrap" for NSLineBreakByWordWrapping
extern NSString* const kMBMLLineBreakByCharWrapping;                // @"charWrap" for NSLineBreakByCharWrapping
extern NSString* const kMBMLLineBreakByClipping;                    // @"clip" for NSLineBreakByClipping
extern NSString* const kMBMLLineBreakByTruncatingHead;              // @"headTruncation" for NSLineBreakByTruncatingHead
extern NSString* const kMBMLLineBreakByTruncatingTail;              // @"tailTruncation" for NSLineBreakByTruncatingTail
extern NSString* const kMBMLLineBreakByTruncatingMiddle;            // @"middleTruncation" for NSLineBreakByTruncatingMiddle

// UIActivityIndicatorViewStyle
extern NSString* const kMBMLActivityIndicatorViewStyleWhiteLarge;   // @"whiteLarge" for UIActivityIndicatorViewStyleWhiteLarge
extern NSString* const kMBMLActivityIndicatorViewStyleWhite;        // @"white" for UIActivityIndicatorViewStyleWhite
extern NSString* const kMBMLActivityIndicatorViewStyleGray;         // @"gray" for UIActivityIndicatorViewStyleGray

// UIButtonType
extern NSString* const kMBMLButtonTypeCustom;                       // @"custom" for UIButtonTypeCustom
extern NSString* const kMBMLButtonTypeRoundedRect;                  // @"rounded" for UIButtonTypeRoundedRect
extern NSString* const kMBMLButtonTypeDetailDisclosure;             // @"detailDisclosure" for UIButtonTypeDetailDisclosure
extern NSString* const kMBMLButtonTypeInfoLight;                    // @"infoLight" for UIButtonTypeInfoLight
extern NSString* const kMBMLButtonTypeInfoDark;                     // @"infoDark" for UIButtonTypeInfoDark
extern NSString* const kMBMLButtonTypeContactAdd;                   // @"contactAdd" for UIButtonTypeContactAdd

// NSDateFormatterStyle
extern NSString* const kMBMLDateFormatterNoStyle;                   // @"none" for NSDateFormatterNoStyle
extern NSString* const kMBMLDateFormatterShortStyle;                // @"short" for NSDateFormatterShortStyle
extern NSString* const kMBMLDateFormatterMediumStyle;               // @"medium" for NSDateFormatterMediumStyle
extern NSString* const kMBMLDateFormatterLongStyle;                 // @"long" for NSDateFormatterLongStyle
extern NSString* const kMBMLDateFormatterFullStyle;                 // @"full" for NSDateFormatterFullStyle

// UITextBorderStyle
extern NSString* const kMBMLTextBorderStyleNone;                    // @"none" for UITextBorderStyleNone
extern NSString* const kMBMLTextBorderStyleLine;                    // @"line" for UITextBorderStyleNone
extern NSString* const kMBMLTextBorderStyleBezel;                   // @"bezel" for UITextBorderStyleBezel
extern NSString* const kMBMLTextBorderStyleRoundedRect;             // @"rounded" for UITextBorderStyleRoundedRect

// UITableViewStyle
extern NSString* const kMBMLTableViewStylePlain;                    // @"plain" for UITableViewStylePlain
extern NSString* const kMBMLTableViewStyleGrouped;                  // @"grouped" for UITableViewStyleGrouped

// UITableViewCellStyle
extern NSString* const kMBMLTableViewCellStyleDefault;              // @"default" for UITableViewCellStyleDefault
extern NSString* const kMBMLTableViewCellStyleValue1;               // @"value1" for UITableViewCellStyleValue1
extern NSString* const kMBMLTableViewCellStyleValue2;               // @"value2" for UITableViewCellStyleValue2
extern NSString* const kMBMLTableViewCellStyleSubtitle;             // @"subtitle" for UITableViewCellStyleSubtitle

// UITableViewCellSelectionStyle
extern NSString* const kMBMLTableViewCellSelectionStyleNone;        // @"none" for UITableViewCellSelectionStyleNone
extern NSString* const kMBMLTableViewCellSelectionStyleBlue;        // @"blue" for UITableViewCellSelectionStyleBlue
extern NSString* const kMBMLTableViewCellSelectionStyleGray;        // @"gray" for UITableViewCellSelectionStyleGray
extern NSString* const kMBMLTableViewCellSelectionStyleGradient;    // @"gradient" for custom gradient (not natively supported as a UITableViewCellSelectionStyle)

// UITableViewCellAccessoryType
extern NSString* const kMBMLTableViewCellAccessoryNone;                     // @"none" for UITableViewCellAccessoryNone
extern NSString* const kMBMLTableViewCellAccessoryDisclosureIndicator;      // @"disclosureIndicator" for UITableViewCellAccessoryDisclosureIndicator
extern NSString* const kMBMLTableViewCellAccessoryDetailDisclosureButton;   // @"detailDisclosureButton" for UITableViewCellAccessoryDetailDisclosureButton
extern NSString* const kMBMLTableViewCellAccessoryCheckmark;                // @"checkmark" for UITableViewCellAccessoryCheckmark

// UITableViewRowAnimation
extern NSString* const kMBMLTableViewRowAnimationNone;              // @"none" for UITableViewRowAnimationNone
extern NSString* const kMBMLTableViewRowAnimationFade;              // @"fade" for UITableViewRowAnimationFade
extern NSString* const kMBMLTableViewRowAnimationRight;             // @"right" for UITableViewRowAnimationRight
extern NSString* const kMBMLTableViewRowAnimationLeft;              // @"left" for UITableViewRowAnimationLeft
extern NSString* const kMBMLTableViewRowAnimationTop;               // @"top" for UITableViewRowAnimationTop
extern NSString* const kMBMLTableViewRowAnimationBottom;            // @"bottom" for UITableViewRowAnimationBottom
extern NSString* const kMBMLTableViewRowAnimationMiddle;            // @"middle" for UITableViewRowAnimationMiddle

// UIControlState
extern NSString* const kMBMLControlStateNormal;                     // @"normal" for UIControlStateNormal
extern NSString* const kMBMLControlStateHighlighted;                // @"highlighted" for UIControlStateHighlighted
extern NSString* const kMBMLControlStateDisabled;                   // @"disabled" for UIControlStateDisabled
extern NSString* const kMBMLControlStateSelected;                   // @"selected" for UIControlStateSelected

// UIViewAnimationOptions (bit field; multiple comma-separated values specified and they will be bitwise ORed together)
extern NSString* const kMBMLViewAnimationOptionLayoutSubviews;              // @"layoutSubviews" for UIViewAnimationOptionLayoutSubviews
extern NSString* const kMBMLViewAnimationOptionAllowUserInteraction;		// @"allowUserInteraction" for UIViewAnimationOptionAllowUserInteraction
extern NSString* const kMBMLViewAnimationOptionBeginFromCurrentState;		// @"beginFromCurrentState" for UIViewAnimationOptionBeginFromCurrentState
extern NSString* const kMBMLViewAnimationOptionRepeat;                      // @"repeat" for UIViewAnimationOptionRepeat
extern NSString* const kMBMLViewAnimationOptionAutoreverse;                 // @"autoreverse" for UIViewAnimationOptionAutoreverse
extern NSString* const kMBMLViewAnimationOptionOverrideInheritedDuration;   // @"overrideInheritedDuration" for UIViewAnimationOptionOverrideInheritedDuration
extern NSString* const kMBMLViewAnimationOptionOverrideInheritedCurve;		// @"overrideInheritedCurve" for UIViewAnimationOptionOverrideInheritedCurve
extern NSString* const kMBMLViewAnimationOptionAllowAnimatedContent;		// @"allowAnimatedContent" for UIViewAnimationOptionAllowAnimatedContent
extern NSString* const kMBMLViewAnimationOptionShowHideTransitionViews;		// @"showHideTransitionViews" for UIViewAnimationOptionShowHideTransitionViews
extern NSString* const kMBMLViewAnimationOptionCurveEaseInOut;              // @"curveEaseInOut" for UIViewAnimationOptionCurveEaseInOut
extern NSString* const kMBMLViewAnimationOptionCurveEaseIn;                 // @"curveEaseIn" for UIViewAnimationOptionCurveEaseIn
extern NSString* const kMBMLViewAnimationOptionCurveEaseOut;                // @"curveEaseOut" for UIViewAnimationOptionCurveEaseOut
extern NSString* const kMBMLViewAnimationOptionCurveLinear;                 // @"curveLinear" for UIViewAnimationOptionCurveLinear
extern NSString* const kMBMLViewAnimationOptionTransitionNone;              // @"transitionNone" for UIViewAnimationOptionTransitionNone
extern NSString* const kMBMLViewAnimationOptionTransitionFlipFromLeft;		// @"transitionFlipFromLeft" for UIViewAnimationOptionTransitionFlipFromLeft
extern NSString* const kMBMLViewAnimationOptionTransitionFlipFromRight;		// @"transitionFlipFromRight" for UIViewAnimationOptionTransitionFlipFromRight
extern NSString* const kMBMLViewAnimationOptionTransitionCurlUp;            // @"transitionCurlUp" for UIViewAnimationOptionTransitionCurlUp
extern NSString* const kMBMLViewAnimationOptionTransitionCurlDown;          // @"transitionCurlDown" for UIViewAnimationOptionTransitionCurlDown
extern NSString* const kMBMLViewAnimationOptionTransitionCrossDissolve;		// @"transitionCrossDissolve" for UIViewAnimationOptionTransitionCrossDissolve
extern NSString* const kMBMLViewAnimationOptionTransitionFlipFromTop;		// @"transitionFlipFromTop" for UIViewAnimationOptionTransitionFlipFromTop
extern NSString* const kMBMLViewAnimationOptionTransitionFlipFromBottom;    // @"transitionFlipFromBottom" for UIViewAnimationOptionTransitionFlipFromBottom

// UIModalTransitionStyle 
extern NSString* const kMBMLModalTransitionStyleCoverVertical;      // @"coverVertical" for UIModalTransitionStyleCoverVertical
extern NSString* const kMBMLModalTransitionStyleFlipHorizontal;     // @"flipHorizontal" for UIModalTransitionStyleFlipHorizontal
extern NSString* const kMBMLModalTransitionStyleCrossDissolve;      // @"crossDissolve" for UIModalTransitionStyleCrossDissolve
extern NSString* const kMBMLModalTransitionStylePartialCurl;        // @"partialCurl" for UIModalTransitionStylePartialCurl

// UIViewContentMode
extern NSString* const kMBMLViewContentModeScaleToFill;             // @"scaleToFill" for UIViewContentModeScaleToFill
extern NSString* const kMBMLViewContentModeScaleAspectFit;          // @"aspectFit" for UIViewContentModeScaleAspectFit
extern NSString* const kMBMLViewContentModeScaleAspectFill;         // @"aspectFill" for UIViewContentModeScaleAspectFill
extern NSString* const kMBMLViewContentModeRedraw;                  // @"redraw" for UIViewContentModeRedraw
extern NSString* const kMBMLViewContentModeCenter;                  // @"center" for UIViewContentModeCenter
extern NSString* const kMBMLViewContentModeTop;                     // @"top" for UIViewContentModeTop
extern NSString* const kMBMLViewContentModeBottom;                  // @"bottom" for UIViewContentModeBottom
extern NSString* const kMBMLViewContentModeLeft;                    // @"left" for UIViewContentModeLeft
extern NSString* const kMBMLViewContentModeRight;                   // @"right" for UIViewContentModeRight
extern NSString* const kMBMLViewContentModeTopLeft;                 // @"topLeft" for UIViewContentModeTopLeft
extern NSString* const kMBMLViewContentModeTopRight;                // @"topRight" for UIViewContentModeTopRight
extern NSString* const kMBMLViewContentModeBottomLeft;              // @"bottomLeft" for UIViewContentModeBottomLeft
extern NSString* const kMBMLViewContentModeBottomRight;             // @"bottomRight" for UIViewContentModeBottomRight

// UIBarStyle
extern NSString* const kMBMLBarStyleDefault;                        // @"default" for UIBarStyleDefault
extern NSString* const kMBMLBarStyleBlack;                          // @"black" for UIBarStyleBlack
extern NSString* const kMBMLBarStyleBlackOpaque;                    // @"blackOpaque" for UIBarStyleBlackOpaque
extern NSString* const kMBMLBarStyleBlackTranslucent;				// @"blackTranslucent" for UIBarStyleBlackTranslucent

// UIBarButtonSystemItem
extern NSString* const kMBMLBarButtonSystemItemDone;				// @"done" for UIBarButtonSystemItemDone
extern NSString* const kMBMLBarButtonSystemItemCancel;				// @"cancel" for UIBarButtonSystemItemCancel
extern NSString* const kMBMLBarButtonSystemItemEdit;				// @"edit" for UIBarButtonSystemItemEdit
extern NSString* const kMBMLBarButtonSystemItemSave;				// @"save" for UIBarButtonSystemItemSave
extern NSString* const kMBMLBarButtonSystemItemAdd;                 // @"add" for UIBarButtonSystemItemAdd
extern NSString* const kMBMLBarButtonSystemItemFlexibleSpace;		// @"flexibleSpace" for UIBarButtonSystemItemFlexibleSpace
extern NSString* const kMBMLBarButtonSystemItemFixedSpace;			// @"fixedSpace" for UIBarButtonSystemItemFixedSpace
extern NSString* const kMBMLBarButtonSystemItemCompose;				// @"compose" for UIBarButtonSystemItemCompose
extern NSString* const kMBMLBarButtonSystemItemReply;				// @"reply" for UIBarButtonSystemItemReply
extern NSString* const kMBMLBarButtonSystemItemAction;				// @"action" for UIBarButtonSystemItemAction
extern NSString* const kMBMLBarButtonSystemItemOrganize;			// @"organize" for UIBarButtonSystemItemOrganize
extern NSString* const kMBMLBarButtonSystemItemBookmarks;			// @"bookmarks" for UIBarButtonSystemItemBookmarks
extern NSString* const kMBMLBarButtonSystemItemSearch;				// @"search" for UIBarButtonSystemItemSearch
extern NSString* const kMBMLBarButtonSystemItemRefresh;				// @"refresh" for UIBarButtonSystemItemRefresh
extern NSString* const kMBMLBarButtonSystemItemStop;				// @"stop" for UIBarButtonSystemItemStop
extern NSString* const kMBMLBarButtonSystemItemCamera;				// @"camera" for UIBarButtonSystemItemCamera
extern NSString* const kMBMLBarButtonSystemItemTrash;				// @"trash" for UIBarButtonSystemItemTrash
extern NSString* const kMBMLBarButtonSystemItemPlay;				// @"play" for UIBarButtonSystemItemPlay
extern NSString* const kMBMLBarButtonSystemItemPause;				// @"pause" for UIBarButtonSystemItemPause
extern NSString* const kMBMLBarButtonSystemItemRewind;				// @"rewind" for UIBarButtonSystemItemRewind
extern NSString* const kMBMLBarButtonSystemItemFastForward;			// @"fastForward" for UIBarButtonSystemItemFastForward
extern NSString* const kMBMLBarButtonSystemItemUndo;				// @"undo" for UIBarButtonSystemItemUndo
extern NSString* const kMBMLBarButtonSystemItemRedo;				// @"redo" for UIBarButtonSystemItemRedo
extern NSString* const kMBMLBarButtonSystemItemPageCurl;			// @"pageCurl" for UIBarButtonSystemItemPageCurl

// UIBarButtonItemStyle
extern NSString* const kMBMLBarButtonItemStylePlain;				// @"plain" for UIBarButtonItemStylePlain
extern NSString* const kMBMLBarButtonItemStyleBordered;				// @"bordered" for UIBarButtonItemStyleBordered
extern NSString* const kMBMLBarButtonItemStyleDone;                 // @"done" for UIBarButtonItemStyleDone

// UIStatusBarAnimation
extern NSString* const kMBMLStatusBarAnimationNone;                 // @"none" for UIStatusBarAnimationNone
extern NSString* const kMBMLStatusBarAnimationFade;                 // @"fade" for UIStatusBarAnimationFade
extern NSString* const kMBMLStatusBarAnimationSlide;                // @"slide" for UIStatusBarAnimationSlide

// UIPopoverArrowDirection
extern NSString* const kMBMLPopoverArrowDirectionUp;                // @"up" for UIPopoverArrowDirectionUp
extern NSString* const kMBMLPopoverArrowDirectionDown;              // @"down" for UIPopoverArrowDirectionDown
extern NSString* const kMBMLPopoverArrowDirectionLeft;              // @"left" for UIPopoverArrowDirectionLeft
extern NSString* const kMBMLPopoverArrowDirectionRight;             // @"right" for UIPopoverArrowDirectionRight
extern NSString* const kMBMLPopoverArrowDirectionAny;               // @"any" for UIPopoverArrowDirectionAny

/******************************************************************************/
#pragma mark -
#pragma mark MBStringConversions class
/******************************************************************************/

/*!
 This class provides an interface for converting between strings, expression
 results, and values of other types, such as:
 
 * `CGFloat`
 * `CGPoint`
 * `CGRect`
 * `CGSize`
 * `NSDateFormatterStyle`
 * `NSLineBreakMode`
 * `NSTextAlignment`
 * `UIActivityIndicatorViewStyle`
 * `UIBarButtonItemStyle`
 * `UIBarButtonSystemItem`
 * `UIBarStyle`
 * `UIButtonType`
 * `UIColor`
 * `UIControlState`
 * `UIEdgeInsets`
 * `UIModalTransitionStyle`
 * `UIOffset`
 * `UIPopoverArrowDirection`
 * `UIScrollViewIndicatorStyle`
 * `UIStatusBarAnimation`
 * `UITableViewCellAccessoryType`
 * `UITableViewCellSelectionStyle`
 * `UITableViewCellStyle`
 * `UITableViewRowAnimation`
 * `UITableViewStyle`
 * `UITextBorderStyle`
 * `UIViewAnimationOptions`
 * `UIViewContentMode`

 */
@interface MBStringConversions : NSObject

/*----------------------------------------------------------------------------*/
#pragma mark CGPoint conversions
/*!    @name CGPoint conversions                                              */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to interpret a string as a `CGPoint` value.

 The input will be parsed as a comma-separating string in the format
 "*`x`*,*`y`*" where *`x`* and *`y`* are interpreted as
 floating-point numbers and used to populate the respective fields of the
 returned `CGPoint`.

 @param     str The string to interpret.

 @return    The `CGPoint` value that corresponds with `str`.
            Returns `CGPointZero` and logs an error to the
            console if `str` couldn't be interpreted.
 */
+ (CGPoint) pointFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `CGPoint` value.

 The input will be parsed as a comma-separating string in the format
 "*`x`*,*`y`*" where *`x`* and *`y`* are interpreted as
 floating-point numbers and used to populate the respective fields of the
 returned `CGPoint`.

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `CGPoint` value that corresponds with `str`.
            Returns `CGPointZero` if `str` couldn't be interpreted.
 */
+ (CGPoint) pointFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Attempts to interpret an arbitrary object value as a `CGPoint`.
 
 The input object is interpreted as follows:
 
 * If it is an `NSString`, handling will be passed to `pointFromString:error:`
 * If it is an `NSValue` containing a `CGPoint`, the underlying value is
   returned
 * All other cases are considered errors
 
 @param     obj The object to be interpreted.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `CGPoint` value that corresponds with `obj`. Returns
            `CGPointZero` if `obj` couldn't be interpreted.
 */
+ (CGPoint) pointFromObject:(id)obj error:(NSError**)errPtr;

/*!
 Evaluates an object expression and attempts to interpret the result as a
 `CGPoint` value using the `pointFromObject:error:` method.

 @param     expr The expression whose result will be interpreted.

 @return    The `CGPoint` value that corresponds with the
            result of evaluating `expr` as a string. Returns
            `CGPointZero` and logs an error to the
            console if the expression result couldn't be interpreted.
 */
+ (CGPoint) pointFromExpression:(NSString*)expr;

/*!
 Converts a `CGPoint` value into a string that can be parsed by
 `pointFromString:`.
 
 @param     val The value to convert into a string.
 
 @return    A string representation of `val`; never `nil`.
 */
+ (NSString*) stringFromPoint:(CGPoint)val;

/*----------------------------------------------------------------------------*/
#pragma mark CGSize conversions
/*!    @name CGSize conversions                                               */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to interpret a string as a `CGSize` value.

 The input will be parsed as a comma-separating string in the format
 "*`width`*,*`height`*" where *`width`* and *`height`* are interpreted as
 floating-point numbers and used to populate the respective fields of the
 returned `CGSize`.

 @param     str The string to interpret.

 @return    The `CGSize` value that corresponds with `str`.
            Returns `CGPointZero` and logs an error to the
            console if `str` couldn't be interpreted.
 */
+ (CGSize) sizeFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `CGSize` value.

 The input will be parsed as a comma-separating string in the format
 "*`width`*,*`height`*" where *`width`* and *`height`* are interpreted as
 floating-point numbers and used to populate the respective fields of the
 returned `CGSize`.

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `CGSize` value that corresponds with `str`.
            Returns `CGPointZero` if `str` couldn't be interpreted.
 */
+ (CGSize) sizeFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Attempts to interpret an arbitrary object value as a `CGSize`.
 
 The input object is interpreted as follows:
 
 * If it is an `NSString`, handling will be passed to `sizeFromString:error:`
 * If it is an `NSValue` containing a `CGSize`, the underlying value is
   returned
 * All other cases are considered errors
 
 @param     obj The object to be interpreted.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `CGSize` value that corresponds with `obj`. Returns
            `CGSizeZero` if `obj` couldn't be interpreted.
 */
+ (CGSize) sizeFromObject:(id)obj error:(NSError**)errPtr;

/*!
 Evaluates an object expression and attempts to interpret the result as a
 `CGSize` value using the `sizeFromObject:error:` method.

 @param     expr The expression whose result will be interpreted.

 @return    The `CGSize` value that corresponds with the
            result of evaluating `expr` as a string. Returns
            `CGSizeZero` and logs an error to the
            console if the expression result couldn't be interpreted.
 */
+ (CGSize) sizeFromExpression:(NSString*)expr;

/*!
 Converts a `CGSize` value into a string that can be parsed by 
 `sizeFromString:`.
 
 @param     val The value to convert into a string.
 
 @return    A string representation of `val`; never `nil`.
 */
+ (NSString*) stringFromSize:(CGSize)val;

/*----------------------------------------------------------------------------*/
#pragma mark CGRect conversions
/*!    @name CGRect conversions                                               */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to interpret a string as a `CGRect` value.

 The input will be parsed as a comma-separating string in the format
 "*`x`*,*`y`*,*`width`*,*`height`*" where *`x`*, *`y`*, *`width`* and *`height`*
 are interpreted as floating-point numbers and used to populate the respective
 fields of the returned `CGRect`.

 @param     str The string to interpret.

 @return    The `CGRect` value that corresponds with `str`.
            Returns `CGRectZero` and logs an error to the
            console if `str` couldn't be interpreted.
 */
+ (CGRect) rectFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `CGRect` value.

 The input will be parsed as a comma-separating string in the format
 "*`x`*,*`y`*,*`width`*,*`height`*" where *`x`*, *`y`*, *`width`* and *`height`*
 are interpreted as floating-point numbers and used to populate the respective
 fields of the returned `CGRect`.

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `CGRect` value that corresponds with `str`.
            Returns `CGRectZero` if `str` couldn't be interpreted.
 */
+ (CGRect) rectFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Attempts to interpret an arbitrary object value as a `CGRect`.
 
 The input object is interpreted as follows:
 
 * If it is an `NSString`, handling will be passed to `rectFromString:error:`
 * If it is an `NSValue` containing a `CGRect`, the underlying value is
   returned
 * All other cases are considered errors
 
 @param     obj The object to be interpreted.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `CGRect` value that corresponds with `obj`. Returns
            `CGRectZero` if `obj` couldn't be interpreted.
 */
+ (CGRect) rectFromObject:(id)obj error:(NSError**)errPtr;

/*!
 Evaluates an object expression and attempts to interpret the result as a
 `CGRect` value using the `rectFromObject:error:` method.

 @param     expr The expression whose result will be interpreted.

 @return    The `CGRect` value that corresponds with the
            result of evaluating `expr` as a string. Returns
            `CGRectZero` and logs an error to the
            console if the expression result couldn't be interpreted.
 */
+ (CGRect) rectFromExpression:(NSString*)expr;

/*!
 Converts a `CGRect` value into a string that can be parsed by
 `rectFromString:`.
 
 @param     val The value to convert into a string.
 
 @return    A string representation of `val`; never `nil`.
 */
+ (NSString*) stringFromRect:(CGRect)val;

/*----------------------------------------------------------------------------*/
#pragma mark Parsing strings containing UIViewNoIntrinsicMetric wildcards
/*!    @name Parsing strings containing UIViewNoIntrinsicMetric wildcards     */
/*----------------------------------------------------------------------------*/

/*!
 Evaluates an expression as a dimension value, resulting in a `CGFloat`
 representing that value.
 
 Used to convert expressions into values for `width` and `height` dimensions.
 Since these dimensions may be specified as wildcards (meaning that their
 values are derived programmatically during layout), this method may return
 `UIViewNoIntrinsicMetric` to indicate that the passed-in expression evaluated
 to the wildcard ('`*`') character.
 
 @param     expr An expression specifying a numeric value, or the wildcard
            string ("`*`").
 
 @return    A numerical representation of `expr`. Will be
            `UIViewNoIntrinsicMetric` if `str` evaluates to the wildcard string.
 */
+ (CGFloat) sizeDimensionFromExpression:(NSString*)expr;

/*!
 Parses a string-based dimension value into a `CGFloat` representing that
 value.

 Used to convert strings into values for the `width` and `height` dimensions.
 Since these dimensions may be specified as wildcards (meaning that their
 values are derived programmatically during layout), this method may return
 `UIViewNoIntrinsicMetric` to indicate that the passed-in string contained only
 the wildcard ('`*`') character.

 @param     str Contains a string specifying a numeric value, or the wildcard
            string ("`*`").

 @return    A numerical representation of `str`. Will be
            `UIViewNoIntrinsicMetric` if `str` was the wildcard
            string.
 */
+ (CGFloat) sizeDimensionFromString:(NSString*)str;

/*!
 Parses a `CGSize` from a comma-separated string containing two components:
 a *width* and a *height*.

 Either dimension may be specified as a wildcard (meaning that its value
 is derived programmatically during layout). When a wildcard character ('`*`')
 is specified as the value for a given dimension, that dimension is set to
 `UIViewNoIntrinsicMetric`.

 @param     sizeStr A string following the format "*width*,*height*" where
            each dimension is specified as a number or a wildcard character.

 @param     sizePtr If the string to be parsed is in the expected format,
            on exit, the `CGSize` at the memory address `sizePtr` will be
            updated to reflect the value of the size dimensions parsed from
            `sizeStr`. No modification occurs if the method returns `NO`.
            This parameter must not be `nil`.

 @return    `YES` on success; `NO` if the input string is not in the expected
            format.
 */
+ (BOOL) parseString:(NSString*)sizeStr asSize:(CGSize*)sizePtr;

/*!
 Parses a `CGRect` from a comma-separated string containing four components:
 the *x* and *y* coordinates of the rectangle's origin, followed by the *width*
 and *height* dimensions of the rectangle.

 The width and height dimensions may be specified as wildcards (meaning that
 their values are derived programmatically during layout). When a wildcard
 character ('`*`') is specified as the value for the width or height, that
 dimension is set to `UIViewNoIntrinsicMetric`.

 @param     rectStr A string following the format
            "*originX*,*originY*,*width*,*height*". The *originX* and *originY*
            values must be specified numerically. The *width* and *height*
            dimensions can either be specified as a number or a wildcard
            character.

 @param     rectPtr If the string to be parsed is in the expected format,
            on exit, the `CGRect` at the memory address `rectPtr` will be
            updated to reflect the value of the rectangle parsed from
            `rectStr`. No modification occurs if the method returns `NO`.
            This parameter must not be `nil`.

 @return    `YES` on success; `NO` if the input string is not in the expected
            format.
 */
+ (BOOL) parseString:(NSString*)rectStr asRect:(CGRect*)rectPtr;

/*----------------------------------------------------------------------------*/
#pragma mark UIOffset conversions
/*!    @name UIOffset conversions                                             */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to interpret a string as a `UIOffset` value.

 The input will be parsed as a comma-separating string in the format
 "*`horizontal`*,*`vertical`*" where *`horizontal`* and *`vertical`* are 
 interpreted as floating-point numbers and used to populate the respective 
 fields of the returned `UIOffset`.

 @param     str The string to interpret.

 @return    The `UIOffset` value that corresponds with `str`.
            Returns `UIOffsetZero` and logs an error to the
            console if `str` couldn't be interpreted.
 */
+ (UIOffset) offsetFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `UIOffset` value.

 The input will be parsed as a comma-separating string in the format
 "*`horizontal`*,*`vertical`*" where *`horizontal`* and *`vertical`* are
 interpreted as floating-point numbers and used to populate the respective
 fields of the returned `UIOffset`.

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `UIOffset` value that corresponds with `str`.
            Returns `UIOffsetZero` if `str` couldn't be interpreted.
 */
+ (UIOffset) offsetFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Attempts to interpret an arbitrary object value as a `UIOffset`.
 
 The input object is interpreted as follows:
 
 * If it is an `NSString`, handling will be passed to `offsetFromString:error:`
 * If it is an `NSValue` containing a `UIOffset`, the underlying value is
   returned
 * All other cases are considered errors
 
 @param     obj The object to be interpreted.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `UIOffset` value that corresponds with `obj`. Returns
            `UIOffsetZero` if `obj` couldn't be interpreted.
 */
+ (UIOffset) offsetFromObject:(id)obj error:(NSError**)errPtr;

/*!
 Evaluates an object expression and attempts to interpret the result as a
 `UIOffset` value using the `offsetFromObject:error:` method.

 @param     expr The expression whose result will be interpreted.

 @return    The `UIOffset` value that corresponds with the
            result of evaluating `expr` as a string. Returns
            `UIOffsetZero` and logs an error to the
            console if the expression result couldn't be interpreted.
 */
+ (UIOffset) offsetFromExpression:(NSString*)expr;

/*----------------------------------------------------------------------------*/
#pragma mark UIEdgeInsets conversions
/*!    @name UIEdgeInsets conversions                                         */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to interpret a string as a `UIEdgeInsets` value.

 The input will be parsed as a comma-separating string in the format
 "*`top`*,*`left`*,*`bottom`*,*`right`*" where
 *`top`*, *`left`*, *`bottom`* and *`right`* are interpreted as floating-point
 numbers and used to populate the respective fields of the returned
 `UIEdgeInsets`.

 @param     str The string to interpret.

 @return    The `UIEdgeInsets` value that corresponds with `str`.
            Returns `UIEdgeInsetsZero` and logs an error to the
            console if `str` couldn't be interpreted.
 */
+ (UIEdgeInsets) edgeInsetsFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `UIEdgeInsets` value.

 The input will be parsed as a comma-separating string in the format
 "*`top`*,*`left`*,*`bottom`*,*`right`*" where 
 *`top`*, *`left`*, *`bottom`* and *`right`* are interpreted as floating-point
 numbers and used to populate the respective fields of the returned 
 `UIEdgeInsets`.

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `UIEdgeInsets` value that corresponds with `str`.
            Returns `UIEdgeInsetsZero` if `str` couldn't be interpreted.
 */
+ (UIEdgeInsets) edgeInsetsFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Attempts to interpret an arbitrary object value as a `UIEdgeInsets`.
 
 The input object is interpreted as follows:
 
 * If it is an `NSString`, handling will be passed to `offsetFromString:error:`
 * If it is an `NSValue` containing a `UIEdgeInsets`, the underlying value is
   returned
 * All other cases are considered errors
 
 @param     obj The object to be interpreted.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `UIEdgeInsets` value that corresponds with `obj`. Returns
            `UIEdgeInsetsZero` if `obj` couldn't be interpreted.
 */
+ (UIEdgeInsets) edgeInsetsFromObject:(id)obj error:(NSError**)errPtr;

/*!
 Evaluates an object expression and attempts to interpret the result as a
 `UIEdgeInsets` value using the `edgeInsetsFromObject:error:` method.

 @param     expr The expression whose result will be interpreted.

 @return    The `UIEdgeInsets` value that corresponds with the
            result of evaluating `expr` as a string. Returns
            `UIEdgeInsetsZero` and logs an error to the
            console if the expression result couldn't be interpreted.
 */
+ (UIEdgeInsets) edgeInsetsFromExpression:(NSString*)expr;

/*----------------------------------------------------------------------------*/
#pragma mark UIColor conversions
/*!    @name UIColor conversions                                              */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to interpret a string as a `UIColor` value.

 This method can accept *named colors* as well as color values specified in 
 hexadecimal notation, commonly referred to as *web colors*.
 
 ##### Named colors

 Named colors utilize the `UIColor` convention of providing a class method
 with a selector following the format: *`name`*`Color`. The value returned by any
 `UIColor` class method named in this way can be referenced simply as *`name`*.

 In other words, passing the input string "white" will return
 `[`<code>UIColor whiteColor</code>`]`, "clear" will return
 `[`<code>UIColor clearColor</code>`]`, and "darkGray" will return
 `[`<code>UIColor darkGrayColor</code>`]`.
 
 This applies to all `UIColor` class methods following that naming convention,
 including ones added through class categories. This means you can introduce
 your own custom named colors simply by creating a `UIColor` category that
 adds an implementation to return the appropriate `UIColor`.
 
 ##### Web colors

 Web colors are specified with a leading *hash sign* (`#`) followed by
 6 or 8 hexadecimal digits specifying 3 or 4 *color channels*, respectively.
 
 Each *color channel* is specified with a two-digit case-insensitive
 hexadecimal value between `00` and `FF` in the format `#`*`RRGGBB`* or 
 `#`*`RRGGBBAA`* where:
 
 * *`RR`* specifies the red component of the color
 * *`GG`* specifies the green component of the color
 * *`BB`* specifies the blue component of the color
 * The optional *`AA`* specifies the color's alpha channel, which determines its opacity

 @param     str The string to interpret.
 
 @return    The `UIColor` value that corresponds with the
            result of evaluating `expr` as a string. Returns
            `[`<code>UIColor yellowColor</code>`]` and logs an error to the
            console if the expression result couldn't be interpreted.
 */
+ (UIColor*) colorFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `UIColor` value.

 This method can accept *named colors* as well as color values specified in 
 hexadecimal notation, commonly referred to as *web colors*.
 
 ##### Named colors

 Named colors utilize the `UIColor` convention of providing a class method
 with a selector following the format: *`name`*`Color`. The value returned by any
 `UIColor` class method named in this way can be referenced simply as *`name`*.

 In other words, passing the input string "white" will return
 `[`<code>UIColor whiteColor</code>`]`, "clear" will return
 `[`<code>UIColor clearColor</code>`]`, and "darkGray" will return
 `[`<code>UIColor darkGrayColor</code>`]`.
 
 This applies to all `UIColor` class methods following that naming convention,
 including ones added through class categories. This means you can introduce
 your own custom named colors simply by creating a `UIColor` category that
 adds an implementation to return the appropriate `UIColor`.
 
 ##### Web colors

 Web colors are specified with a leading *hash sign* (`#`) followed by
 6 or 8 hexadecimal digits specifying 3 or 4 *color channels*, respectively.
 
 Each *color channel* is specified with a two-digit case-insensitive
 hexadecimal value between `00` and `FF` in the format `#`*`RRGGBB`* or 
 `#`*`RRGGBBAA`* where:
 
 * *`RR`* specifies the red component of the color
 * *`GG`* specifies the green component of the color
 * *`BB`* specifies the blue component of the color
 * The optional *`AA`* specifies the color's alpha channel, which determines its opacity

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `UIColor` value that corresponds with the
            result of evaluating `expr` as a string. Returns
            `[`<code>UIColor yellowColor</code>`]` if the expression result 
            couldn't be interpreted.
 */
+ (UIColor*) colorFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Evaluates a string expression and attempts to interpret the result as a
 `UIColor` value using the `colorFromString:` method.

 @param     expr The expression whose result will be interpreted.

 @return    The `UIColor` value that corresponds with the
            result of evaluating `expr` as a string. Returns
            `[`<code>UIColor yellowColor</code>`]` and logs an error to the
            console if the expression result couldn't be interpreted.
 */
+ (UIColor*) colorFromExpression:(NSString*)expr;

/*----------------------------------------------------------------------------*/
#pragma mark NSLineBreakMode conversions
/*!    @name NSLineBreakMode conversions                                      */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to interpret a string as a `NSLineBreakMode` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLLineBreakByWordWrapping` ("wordWrap") = `NSLineBreakByWordWrapping`
 * `kMBMLLineBreakByCharWrapping` ("charWrap") = `NSLineBreakByCharWrapping`
 * `kMBMLLineBreakByClipping` ("clip") = `NSLineBreakByClipping`
 * `kMBMLLineBreakByTruncatingHead` ("headTruncation") = `NSLineBreakByTruncatingHead`
 * `kMBMLLineBreakByTruncatingTail` ("tailTruncation") = `NSLineBreakByTruncatingTail`
 * `kMBMLLineBreakByTruncatingMiddle` ("middleTruncation") = `NSLineBreakByTruncatingMiddle`

 @param     str The string to interpret.

 @return    The `NSLineBreakMode` value that corresponds with `str`.
            Returns `NSLineBreakByWordWrapping` and logs an error to the
            console if `str` isn't recognized.
 */
+ (NSLineBreakMode) lineBreakModeFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `NSLineBreakMode` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLLineBreakByWordWrapping` ("wordWrap") = `NSLineBreakByWordWrapping`
 * `kMBMLLineBreakByCharWrapping` ("charWrap") = `NSLineBreakByCharWrapping`
 * `kMBMLLineBreakByClipping` ("clip") = `NSLineBreakByClipping`
 * `kMBMLLineBreakByTruncatingHead` ("headTruncation") = `NSLineBreakByTruncatingHead`
 * `kMBMLLineBreakByTruncatingTail` ("tailTruncation") = `NSLineBreakByTruncatingTail`
 * `kMBMLLineBreakByTruncatingMiddle` ("middleTruncation") = `NSLineBreakByTruncatingMiddle`

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `NSLineBreakMode` value that corresponds with `str`.
            Returns `NSLineBreakByWordWrapping` if `str` isn't
            recognized.
 */
+ (NSLineBreakMode) lineBreakModeFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Evaluates a string expression and attempts to interpret the result as a
 `NSLineBreakMode` value using the `textAlignmentFromExpression:` method.

 @param     expr The expression whose result will be interpreted.

 @return    The `NSLineBreakMode` value that corresponds with the
            result of evaluating `expr` as a string. Returns
            `NSLineBreakByWordWrapping` and logs an error to the
            console if the expression result couldn't be interpreted.
 */
+ (NSLineBreakMode) lineBreakModeFromExpression:(NSString*)expr;

/*----------------------------------------------------------------------------*/
#pragma mark NSTextAlignment conversions
/*!    @name NSTextAlignment conversions                                      */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to interpret a string as a `NSTextAlignment` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLTextAlignmentLeft` ("left") = `NSTextAlignmentLeft`
 * `kMBMLTextAlignmentCenter` ("center") = `NSTextAlignmentCenter`
 * `kMBMLTextAlignmentRight` ("right") = `NSTextAlignmentRight`

 @param     str The string to interpret.

 @return    The `NSTextAlignment` value that corresponds with `str`.
            Returns `NSTextAlignmentLeft` and logs an error to the
            console if `str` isn't recognized.
 */
+ (NSTextAlignment) textAlignmentFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `NSTextAlignment` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLTextAlignmentLeft` ("left") = `NSTextAlignmentLeft`
 * `kMBMLTextAlignmentCenter` ("center") = `NSTextAlignmentCenter`
 * `kMBMLTextAlignmentRight` ("right") = `NSTextAlignmentRight`

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `NSTextAlignment` value that corresponds with `str`.
            Returns `NSTextAlignmentLeft` if `str` isn't
            recognized.
 */
+ (NSTextAlignment) textAlignmentFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Evaluates a string expression and attempts to interpret the result as a
 `NSTextAlignment` value using the `textAlignmentFromExpression:` method.

 @param     expr The expression whose result will be interpreted.

 @return    The `NSTextAlignment` value that corresponds with the
            result of evaluating `expr` as a string. Returns
            `NSTextAlignmentLeft` and logs an error to the
            console if the expression result couldn't be interpreted.
 */
+ (NSTextAlignment) textAlignmentFromExpression:(NSString*)expr;

/*----------------------------------------------------------------------------*/
#pragma mark UIScrollViewIndicatorStyle conversions
/*!    @name UIScrollViewIndicatorStyle conversions                           */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to interpret a string as a `UIScrollViewIndicatorStyle` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLScrollViewIndicatorStyleDefault` ("default") = `UIScrollViewIndicatorStyleDefault`
 * `kMBMLScrollViewIndicatorStyleBlack` ("black") = `UIScrollViewIndicatorStyleBlack`
 * `kMBMLScrollViewIndicatorStyleWhite` ("white") = `UIScrollViewIndicatorStyleWhite`

 @param     str The string to interpret.

 @return    The `UIScrollViewIndicatorStyle` value that corresponds with `str`.
            Returns `UIScrollViewIndicatorStyleDefault` and logs an error to the
            console if `str` isn't recognized.
 */
+ (UIScrollViewIndicatorStyle) scrollViewIndicatorStyleFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `UIScrollViewIndicatorStyle` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLScrollViewIndicatorStyleDefault` ("default") = `UIScrollViewIndicatorStyleDefault`
 * `kMBMLScrollViewIndicatorStyleBlack` ("black") = `UIScrollViewIndicatorStyleBlack`
 * `kMBMLScrollViewIndicatorStyleWhite` ("white") = `UIScrollViewIndicatorStyleWhite`

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `UIScrollViewIndicatorStyle` value that corresponds with `str`.
            Returns `UIScrollViewIndicatorStyleDefault` if `str` isn't
            recognized.
 */
+ (UIScrollViewIndicatorStyle) scrollViewIndicatorStyleFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Evaluates a string expression and attempts to interpret the result as a
 `UIScrollViewIndicatorStyle` value using the
 `scrollViewIndicatorStyleFromString:` method.

 @param     expr The expression whose result will be interpreted.

 @return    The `UIScrollViewIndicatorStyle` value that corresponds with the
            result of evaluating `expr` as a string. Returns 
            `UIScrollViewIndicatorStyleDefault` and logs an error to the
            console if the expression result couldn't be interpreted.
 */
+ (UIScrollViewIndicatorStyle) scrollViewIndicatorStyleFromExpression:(NSString*)expr;

/*----------------------------------------------------------------------------*/
#pragma mark UIActivityIndicatorViewStyle conversions
/*!    @name UIActivityIndicatorViewStyle conversions                         */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to interpret a string as a `UIActivityIndicatorViewStyle` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLActivityIndicatorViewStyleWhiteLarge` ("whiteLarge") = `UIActivityIndicatorViewStyleWhiteLarge`
 * `kMBMLActivityIndicatorViewStyleWhite` ("white") = `UIActivityIndicatorViewStyleWhite`
 * `kMBMLActivityIndicatorViewStyleGray` ("gray") = `UIActivityIndicatorViewStyleGray`

 @param     str The string to interpret.

 @return    The `UIActivityIndicatorViewStyle` value that corresponds with 
            `str`. Returns `UIActivityIndicatorViewStyleWhite` and logs an error 
            to the console if `str` isn't recognized.
 */
+ (UIActivityIndicatorViewStyle) activityIndicatorViewStyleFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `UIActivityIndicatorViewStyle` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLActivityIndicatorViewStyleWhiteLarge` ("whiteLarge") = `UIActivityIndicatorViewStyleWhiteLarge`
 * `kMBMLActivityIndicatorViewStyleWhite` ("white") = `UIActivityIndicatorViewStyleWhite`
 * `kMBMLActivityIndicatorViewStyleGray` ("gray") = `UIActivityIndicatorViewStyleGray`

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `UIActivityIndicatorViewStyle` value that corresponds with
            `str`. Returns `UIActivityIndicatorViewStyleWhite` if `str` isn't
            recognized.
 */
+ (UIActivityIndicatorViewStyle) activityIndicatorViewStyleFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Evaluates a string expression and attempts to interpret the result as a
 `UIActivityIndicatorViewStyle` value using the 
 `activityIndicatorViewStyleFromString:` method.

 @param     expr The expression whose result will be interpreted.

 @return    The `UIActivityIndicatorViewStyle` value that corresponds with the
            result of evaluating `expr` as a string. Returns 
            `UIActivityIndicatorViewStyleWhite` and logs an error to the
            console if the expression result couldn't be interpreted.
 */
+ (UIActivityIndicatorViewStyle) activityIndicatorViewStyleFromExpression:(NSString*)expr;

/*----------------------------------------------------------------------------*/
#pragma mark UIButtonType conversions
/*!    @name UIButtonType conversions                                         */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to interpret a string as a `UIButtonType` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLButtonTypeCustom` ("custom") = `UIButtonTypeCustom`
 * `kMBMLButtonTypeRoundedRect` ("rounded") = `UIButtonTypeRoundedRect`
 * `kMBMLButtonTypeDetailDisclosure` ("detailDisclosure") = `UIButtonTypeDetailDisclosure`
 * `kMBMLButtonTypeInfoLight` ("infoLight") = `UIButtonTypeInfoLight`
 * `kMBMLButtonTypeInfoDark` ("infoDark") = `UIButtonTypeInfoDark`
 * `kMBMLButtonTypeContactAdd` ("contactAdd") = `UIButtonTypeContactAdd`

 @param     str The string to interpret.

 @return    The `UIButtonType` value that corresponds with `str`.
            Returns `UIButtonTypeCustom` and logs an error to the
            console if `str` isn't recognized.
 */
+ (UIButtonType) buttonTypeFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `UIButtonType` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLButtonTypeCustom` ("custom") = `UIButtonTypeCustom`
 * `kMBMLButtonTypeRoundedRect` ("rounded") = `UIButtonTypeRoundedRect`
 * `kMBMLButtonTypeDetailDisclosure` ("detailDisclosure") = `UIButtonTypeDetailDisclosure`
 * `kMBMLButtonTypeInfoLight` ("infoLight") = `UIButtonTypeInfoLight`
 * `kMBMLButtonTypeInfoDark` ("infoDark") = `UIButtonTypeInfoDark`
 * `kMBMLButtonTypeContactAdd` ("contactAdd") = `UIButtonTypeContactAdd`

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `UIButtonType` value that corresponds with `str`.
            Returns `UIButtonTypeCustom` if `str` isn't
            recognized.
 */
+ (UIButtonType) buttonTypeFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Evaluates a string expression and attempts to interpret the result as a
 `UIButtonType` value using the `buttonTypeFromString:`
 method.

 @param     expr The expression whose result will be interpreted.

 @return    The `UIButtonType` value that corresponds with the
            result of evaluating `expr` as a string. Returns 
            `UIButtonTypeCustom` and logs an error to the
            console if the expression result couldn't be interpreted.
 */
+ (UIButtonType) buttonTypeFromExpression:(NSString*)expr;

/*----------------------------------------------------------------------------*/
#pragma mark NSDateFormatterStyle conversions
/*!    @name NSDateFormatterStyle conversions                                 */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to interpret a string as a `NSDateFormatterStyle` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLDateFormatterNoStyle` ("none") = `NSDateFormatterNoStyle`
 * `kMBMLDateFormatterShortStyle` ("short") = `NSDateFormatterShortStyle`
 * `kMBMLDateFormatterMediumStyle` ("medium") = `NSDateFormatterMediumStyle`
 * `kMBMLDateFormatterLongStyle` ("long") = `NSDateFormatterLongStyle`
 * `kMBMLDateFormatterFullStyle` ("full") = `NSDateFormatterFullStyle`

 @param     str The string to interpret.

 @return    The `NSDateFormatterStyle` value that corresponds with `str`.
            Returns `NSDateFormatterNoStyle` and logs an error to the
            console if `str` isn't recognized.
 */
+ (NSDateFormatterStyle) dateFormatterStyleFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `NSDateFormatterStyle` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLDateFormatterNoStyle` ("none") = `NSDateFormatterNoStyle`
 * `kMBMLDateFormatterShortStyle` ("short") = `NSDateFormatterShortStyle`
 * `kMBMLDateFormatterMediumStyle` ("medium") = `NSDateFormatterMediumStyle`
 * `kMBMLDateFormatterLongStyle` ("long") = `NSDateFormatterLongStyle`
 * `kMBMLDateFormatterFullStyle` ("full") = `NSDateFormatterFullStyle`

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `NSDateFormatterStyle` value that corresponds with `str`.
            Returns `NSDateFormatterNoStyle` if `str` isn't
            recognized.
 */
+ (NSDateFormatterStyle) dateFormatterStyleFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Evaluates a string expression and attempts to interpret the result as a
 `NSDateFormatterStyle` value using the `dateFormatterStyleFromString:`
 method.

 @param     expr The expression whose result will be interpreted.

 @return    The `NSDateFormatterStyle` value that corresponds with the
            result of evaluating `expr` as a string. Returns 
            `NSDateFormatterNoStyle` and logs an error to the
            console if the expression result couldn't be interpreted.
 */
+ (NSDateFormatterStyle) dateFormatterStyleFromExpression:(NSString*)expr;

/*----------------------------------------------------------------------------*/
#pragma mark UITextBorderStyle conversions
/*!    @name UITextBorderStyle conversions                                    */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to interpret a string as a `UITextBorderStyle` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLTextBorderStyleNone` ("none") = `UITextBorderStyleNone`
 * `kMBMLTextBorderStyleLine` ("line") = `UITextBorderStyleNone`
 * `kMBMLTextBorderStyleBezel` ("bezel") = `UITextBorderStyleBezel`
 * `kMBMLTextBorderStyleRoundedRect` ("rounded") = `UITextBorderStyleRoundedRect`

 @param     str The string to interpret.

 @return    The `UITextBorderStyle` value that corresponds with `str`.
            Returns `UITextBorderStyleNone` and logs an error to the
            console if `str` isn't recognized.
 */
+ (UITextBorderStyle) textBorderStyleFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `UITextBorderStyle` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLTextBorderStyleNone` ("none") = `UITextBorderStyleNone`
 * `kMBMLTextBorderStyleLine` ("line") = `UITextBorderStyleNone`
 * `kMBMLTextBorderStyleBezel` ("bezel") = `UITextBorderStyleBezel`
 * `kMBMLTextBorderStyleRoundedRect` ("rounded") = `UITextBorderStyleRoundedRect`

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `UITextBorderStyle` value that corresponds with `str`.
            Returns `UITextBorderStyleNone` if `str` isn't
            recognized.
 */
+ (UITextBorderStyle) textBorderStyleFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Evaluates a string expression and attempts to interpret the result as a
 `UITextBorderStyle` value using the `textBorderStyleFromString:`
 method.

 @param     expr The expression whose result will be interpreted.

 @return    The `UITextBorderStyle` value that corresponds with the
            result of evaluating `expr` as a string. Returns 
            `UITextBorderStyleNone` and logs an error to the
            console if the expression result couldn't be interpreted.
 */
+ (UITextBorderStyle) textBorderStyleFromExpression:(NSString*)expr;

/*----------------------------------------------------------------------------*/
#pragma mark UITableViewStyle conversions
/*!    @name UITableViewStyle conversions                                     */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to interpret a string as a `UITableViewStyle` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLTableViewStylePlain` ("plain") = `UITableViewStylePlain`
 * `kMBMLTableViewStyleGrouped` ("grouped") = `UITableViewStyleGrouped`

 @param     str The string to interpret.

 @return    The `UITableViewStyle` value that corresponds with `str`.
            Returns `UITableViewStylePlain` and logs an error to the
            console if `str` isn't recognized.
 */
+ (UITableViewStyle) tableViewStyleFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `UITableViewStyle` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLTableViewStylePlain` ("plain") = `UITableViewStylePlain`
 * `kMBMLTableViewStyleGrouped` ("grouped") = `UITableViewStyleGrouped`

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `UITableViewStyle` value that corresponds with `str`.
            Returns `UITableViewStylePlain` if `str` isn't
            recognized.
 */
+ (UITableViewStyle) tableViewStyleFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Evaluates a string expression and attempts to interpret the result as a
 `UITableViewStyle` value using the `tableViewStyleFromString:`
 method.

 @param     expr The expression whose result will be interpreted.

 @return    The `UITableViewStyle` value that corresponds with the
            result of evaluating `expr` as a string. Returns 
            `UITableViewStylePlain` and logs an error to the
            console if the expression result couldn't be interpreted.
 */
+ (UITableViewStyle) tableViewStyleFromExpression:(NSString*)expr;

/*----------------------------------------------------------------------------*/
#pragma mark UITableViewCell-related conversions
/*!    @name UITableViewCell-related conversions                              */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to interpret a string as a `UITableViewCellStyle` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLTableViewCellStyleDefault` ("default") = `UITableViewCellStyleDefault`
 * `kMBMLTableViewCellStyleValue1` ("value1") = `UITableViewCellStyleValue1`
 * `kMBMLTableViewCellStyleValue2` ("value2") = `UITableViewCellStyleValue2`
 * `kMBMLTableViewCellStyleSubtitle` ("subtitle") = `UITableViewCellStyleSubtitle`

 @param     str The string to interpret.

 @return    The `UITableViewCellStyle` value that corresponds with `str`.
            Returns `UITableViewCellStyleDefault` and logs an error to the
            console if `str` isn't recognized.
 */
+ (UITableViewCellStyle) tableViewCellStyleFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `UITableViewCellStyle` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLTableViewCellStyleDefault` ("default") = `UITableViewCellStyleDefault`
 * `kMBMLTableViewCellStyleValue1` ("value1") = `UITableViewCellStyleValue1`
 * `kMBMLTableViewCellStyleValue2` ("value2") = `UITableViewCellStyleValue2`
 * `kMBMLTableViewCellStyleSubtitle` ("subtitle") = `UITableViewCellStyleSubtitle`

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `UITableViewCellStyle` value that corresponds with `str`.
            Returns `UITableViewCellStyleDefault` if `str` isn't
            recognized.
 */
+ (UITableViewCellStyle) tableViewCellStyleFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Evaluates a string expression and attempts to interpret the result as a
 `UITableViewCellStyle` value using the `tableViewCellStyleFromString:`
 method.

 @param     expr The expression whose result will be interpreted.

 @return    The `UITableViewCellStyle` value that corresponds with the
            result of evaluating `expr` as a string. Returns 
            `UITableViewCellStyleDefault` and logs an error to the
            console if the expression result couldn't be interpreted.
 */
+ (UITableViewCellStyle) tableViewCellStyleFromExpression:(NSString*)expr;

/*!
 Attempts to interpret a string as an `MBTableViewCellSelectionStyle` value,
 a special type that is cast-compatible with  `UITableViewCellSelectionStyle`
 but adds the value `MBTableViewCellSelectionStyleGradient` to represent a
 custom cell selection style using a gradient.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLTableViewCellSelectionStyleNone` ("none") = `UITableViewCellSelectionStyleNone`
 * `kMBMLTableViewCellSelectionStyleBlue` ("blue") = `UITableViewCellSelectionStyleBlue`
 * `kMBMLTableViewCellSelectionStyleGray` ("gray") = `UITableViewCellSelectionStyleGray`
 * `kMBMLTableViewCellSelectionStyleGradient` ("gradient") = `MBTableViewCellSelectionStyleGradient`

 @param     str The string to interpret.

 @return    The `MBTableViewCellSelectionStyle` value that corresponds with the
            result of evaluating `expr` as a string. Returns 
            `UITableViewCellSelectionStyleBlue` and logs an error to the
            console if the expression result couldn't be interpreted.
 */
+ (MBTableViewCellSelectionStyle) tableViewCellSelectionStyleFromString:(NSString*)str;

/*!
 Attempts to interpret a string as an `MBTableViewCellSelectionStyle` value,
 a special type that is cast-compatible with  `UITableViewCellSelectionStyle`
 but adds the value `MBTableViewCellSelectionStyleGradient` to represent a
 custom cell selection style using a gradient.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLTableViewCellSelectionStyleNone` ("none") = `UITableViewCellSelectionStyleNone`
 * `kMBMLTableViewCellSelectionStyleBlue` ("blue") = `UITableViewCellSelectionStyleBlue`
 * `kMBMLTableViewCellSelectionStyleGray` ("gray") = `UITableViewCellSelectionStyleGray`
 * `kMBMLTableViewCellSelectionStyleGradient` ("gradient") = `MBTableViewCellSelectionStyleGradient`

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `MBTableViewCellSelectionStyle` value that corresponds with
            `str`. Returns `UITableViewCellSelectionStyleBlue` if `str` isn't
            recognized.
 */
+ (MBTableViewCellSelectionStyle) tableViewCellSelectionStyleFromString:(NSString*)str error:(NSError**)errPtr;


/*!
 Evaluates a string expression and attempts to interpret the result as an
 `MBTableViewCellSelectionStyle` value using the
 `tableViewCellSelectionStyleFromString:` method.

 @param     expr The expression whose result will be interpreted.

 @return    The `MBTableViewCellSelectionStyle` value that corresponds with the
            result of evaluating `expr` as a string. Returns 
            `UITableViewCellSelectionStyleBlue` and logs an error to the
            console if the expression result couldn't be interpreted.
 */
+ (MBTableViewCellSelectionStyle) tableViewCellSelectionStyleFromExpression:(NSString*)expr;









/*!
 Attempts to interpret a string as a `UITableViewCellAccessoryType` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLTableViewCellAccessoryNone` ("none") = `UITableViewCellAccessoryNone`
 * `kMBMLTableViewCellAccessoryDisclosureIndicator` ("disclosureIndicator") = `UITableViewCellAccessoryDisclosureIndicator`
 * `kMBMLTableViewCellAccessoryDetailDisclosureButton` ("detailDisclosureButton") = `UITableViewCellAccessoryDetailDisclosureButton`
 * `kMBMLTableViewCellAccessoryCheckmark` ("checkmark") = `UITableViewCellAccessoryCheckmark`

 @param     str The string to interpret.

 @return    The `UITableViewCellAccessoryType` value that corresponds with 
            `str`. Returns `UITableViewCellAccessoryNone` and logs an error to
            the console if `str` isn't recognized.
 */
+ (UITableViewCellAccessoryType) tableViewCellAccessoryTypeFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `UITableViewCellAccessoryType` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLTableViewCellAccessoryNone` ("none") = `UITableViewCellAccessoryNone`
 * `kMBMLTableViewCellAccessoryDisclosureIndicator` ("disclosureIndicator") = `UITableViewCellAccessoryDisclosureIndicator`
 * `kMBMLTableViewCellAccessoryDetailDisclosureButton` ("detailDisclosureButton") = `UITableViewCellAccessoryDetailDisclosureButton`
 * `kMBMLTableViewCellAccessoryCheckmark` ("checkmark") = `UITableViewCellAccessoryCheckmark`

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `UITableViewCellAccessoryType` value that corresponds with 
            `str`. Returns `UITableViewCellAccessoryNone` if `str` isn't
            recognized.
 */
+ (UITableViewCellAccessoryType) tableViewCellAccessoryTypeFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Evaluates a string expression and attempts to interpret the result as a
 `UITableViewCellAccessoryType` value using the 
 `tableViewCellAccessoryTypeFromString:` method.

 @param     expr The expression whose result will be interpreted.

 @return    The `UITableViewCellAccessoryType` value that corresponds with the
            result of evaluating `expr` as a string. Returns 
            `UITableViewCellAccessoryNone` and logs an error to the
            console if the expression result couldn't be interpreted.
 */
+ (UITableViewCellAccessoryType) tableViewCellAccessoryTypeFromExpression:(NSString*)expr;

/*----------------------------------------------------------------------------*/
#pragma mark UITableViewRowAnimation conversions
/*!    @name UITableViewRowAnimation conversions                              */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to interpret a string as a `UITableViewRowAnimation` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLTableViewRowAnimationNone` ("none") = `UITableViewRowAnimationNone`
 * `kMBMLTableViewRowAnimationFade` ("fade") = `UITableViewRowAnimationFade`
 * `kMBMLTableViewRowAnimationRight` ("right") = `UITableViewRowAnimationRight`
 * `kMBMLTableViewRowAnimationLeft` ("left") = `UITableViewRowAnimationLeft`
 * `kMBMLTableViewRowAnimationTop` ("top") = `UITableViewRowAnimationTop`
 * `kMBMLTableViewRowAnimationBottom` ("bottom") = `UITableViewRowAnimationBottom`
 * `kMBMLTableViewRowAnimationMiddle` ("middle") = `UITableViewRowAnimationMiddle`

 @param     str The string to interpret.

 @return    The `UITableViewRowAnimation` value that corresponds with `str`.
            Returns `UITableViewRowAnimationNone` and logs an error to the
            console if `str` isn't recognized.
 */
+ (UITableViewRowAnimation) tableViewRowAnimationFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `UITableViewRowAnimation` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLTableViewRowAnimationNone` ("none") = `UITableViewRowAnimationNone`
 * `kMBMLTableViewRowAnimationFade` ("fade") = `UITableViewRowAnimationFade`
 * `kMBMLTableViewRowAnimationRight` ("right") = `UITableViewRowAnimationRight`
 * `kMBMLTableViewRowAnimationLeft` ("left") = `UITableViewRowAnimationLeft`
 * `kMBMLTableViewRowAnimationTop` ("top") = `UITableViewRowAnimationTop`
 * `kMBMLTableViewRowAnimationBottom` ("bottom") = `UITableViewRowAnimationBottom`
 * `kMBMLTableViewRowAnimationMiddle` ("middle") = `UITableViewRowAnimationMiddle`

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `UITableViewRowAnimation` value that corresponds with `str`.
            Returns `UITableViewRowAnimationNone` if `str` isn't
            recognized.
 */
+ (UITableViewRowAnimation) tableViewRowAnimationFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Evaluates a string expression and attempts to interpret the result as a
 `UITableViewRowAnimation` value using the `tableViewRowAnimationFromString:`
 method.

 @param     expr The expression whose result will be interpreted.

 @return    The `UITableViewRowAnimation` value that corresponds with the
            result of evaluating `expr` as a string. Returns 
            `UITableViewRowAnimationNone` and logs an error to the
            console if the expression result couldn't be interpreted.
 */
+ (UITableViewRowAnimation) tableViewRowAnimationFromExpression:(NSString*)expr;

/*----------------------------------------------------------------------------*/
#pragma mark UIControlState conversions
/*!    @name UIControlState conversions                                       */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to interpret a string as a `UIControlState` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLControlStateNormal` ("normal") = `UIControlStateNormal`
 * `kMBMLControlStateHighlighted` ("highlighted") = `UIControlStateHighlighted`
 * `kMBMLControlStateDisabled` ("disabled") = `UIControlStateDisabled`
 * `kMBMLControlStateSelected` ("selected") = `UIControlStateSelected`

 @param     str The string to interpret.

 @return    The `UIControlState` value that corresponds with `str`.
            Returns `UIControlStateNormal` and logs an error to the
            console if `str` isn't recognized.
 */
+ (UIControlState) controlStateFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `UIControlState` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLControlStateNormal` ("normal") = `UIControlStateNormal`
 * `kMBMLControlStateHighlighted` ("highlighted") = `UIControlStateHighlighted`
 * `kMBMLControlStateDisabled` ("disabled") = `UIControlStateDisabled`
 * `kMBMLControlStateSelected` ("selected") = `UIControlStateSelected`

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `UIControlState` value that corresponds with `str`.
            Returns `UIControlStateNormal` if `str` isn't
            recognized.
 */
+ (UIControlState) controlStateFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Evaluates a string expression and attempts to interpret the result as a
 `UIControlState` value using the `controlStateFromString:`
 method.

 @param     expr The expression whose result will be interpreted.

 @return    The `UIControlState` value that corresponds with the
            result of evaluating `expr` as a string. Returns 
            `UIControlStateNormal` and logs an error to the
            console if the expression result couldn't be interpreted.
 */
+ (UIControlState) controlStateFromExpression:(NSString*)expr;

/*----------------------------------------------------------------------------*/
#pragma mark UIViewAnimationOptions conversions
/*!    @name UIViewAnimationOptions conversions                               */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to interpret a string as a `UIViewAnimationOptions` value.

 `UIViewAnimationOptions` is constructed as a *bit flag*, which means each
 individual value can be combined to indicate the selection of multiple options.

 The input string expects a comma-separated list containing zero or more
 *flags*. Whitespace between commas and flags is permitted but not required.

 The following string constants show the accepted flags, along with their
 corresponding values:

 * `kMBMLViewAnimationOptionLayoutSubviews` ("layoutSubviews") = `UIViewAnimationOptionLayoutSubviews`
 * `kMBMLViewAnimationOptionAllowUserInteraction` ("allowUserInteraction") = `UIViewAnimationOptionAllowUserInteraction`
 * `kMBMLViewAnimationOptionBeginFromCurrentState` ("beginFromCurrentState") = `UIViewAnimationOptionBeginFromCurrentState`
 * `kMBMLViewAnimationOptionRepeat` ("repeat") = `UIViewAnimationOptionRepeat`
 * `kMBMLViewAnimationOptionAutoreverse` ("autoreverse") = `UIViewAnimationOptionAutoreverse`
 * `kMBMLViewAnimationOptionOverrideInheritedDuration` ("overrideInheritedDuration") = `UIViewAnimationOptionOverrideInheritedDuration`
 * `kMBMLViewAnimationOptionOverrideInheritedCurve` ("overrideInheritedCurve") = `UIViewAnimationOptionOverrideInheritedCurve`
 * `kMBMLViewAnimationOptionAllowAnimatedContent` ("allowAnimatedContent") = `UIViewAnimationOptionAllowAnimatedContent`
 * `kMBMLViewAnimationOptionShowHideTransitionViews` ("showHideTransitionViews") = `UIViewAnimationOptionShowHideTransitionViews`
 * `kMBMLViewAnimationOptionCurveEaseInOut` ("curveEaseInOut") = `UIViewAnimationOptionCurveEaseInOut`
 * `kMBMLViewAnimationOptionCurveEaseIn` ("curveEaseIn") = `UIViewAnimationOptionCurveEaseIn`
 * `kMBMLViewAnimationOptionCurveEaseOut` ("curveEaseOut") = `UIViewAnimationOptionCurveEaseOut`
 * `kMBMLViewAnimationOptionCurveLinear` ("curveLinear") = `UIViewAnimationOptionCurveLinear`
 * `kMBMLViewAnimationOptionTransitionNone` ("transitionNone") = `UIViewAnimationOptionTransitionNone`
 * `kMBMLViewAnimationOptionTransitionFlipFromLeft` ("transitionFlipFromLeft") = `UIViewAnimationOptionTransitionFlipFromLeft`
 * `kMBMLViewAnimationOptionTransitionFlipFromRight` ("transitionFlipFromRight") = `UIViewAnimationOptionTransitionFlipFromRight`
 * `kMBMLViewAnimationOptionTransitionCurlUp` ("transitionCurlUp") = `UIViewAnimationOptionTransitionCurlUp`
 * `kMBMLViewAnimationOptionTransitionCurlDown` ("transitionCurlDown") = `UIViewAnimationOptionTransitionCurlDown`
 * `kMBMLViewAnimationOptionTransitionCrossDissolve` ("transitionCrossDissolve") = `UIViewAnimationOptionTransitionCrossDissolve`
 * `kMBMLViewAnimationOptionTransitionFlipFromTop` ("transitionFlipFromTop") = `UIViewAnimationOptionTransitionFlipFromTop`
 * `kMBMLViewAnimationOptionTransitionFlipFromBottom` ("transitionFlipFromBottom") = `UIViewAnimationOptionTransitionFlipFromBottom`

 @param     str The string to interpret.

 @return    The `UIViewAnimationOptions` value that corresponds with the
            result of evaluating `expr` as a string. Returns 
            `0` and logs an error to the console if the expression result
            couldn't be interpreted.
 */
+ (UIViewAnimationOptions) viewAnimationOptionsFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `UIViewAnimationOptions` value.

 `UIViewAnimationOptions` is constructed as a *bit flag*, which means each
 individual value can be combined to indicate the selection of multiple options.
 
 The input string expects a comma-separated list containing zero or more
 *flags*. Whitespace between commas and flags is permitted but not required.
 
 The following string constants show the accepted flags, along with their
 corresponding values:

 * `kMBMLViewAnimationOptionLayoutSubviews` ("layoutSubviews") = `UIViewAnimationOptionLayoutSubviews`
 * `kMBMLViewAnimationOptionAllowUserInteraction` ("allowUserInteraction") = `UIViewAnimationOptionAllowUserInteraction`
 * `kMBMLViewAnimationOptionBeginFromCurrentState` ("beginFromCurrentState") = `UIViewAnimationOptionBeginFromCurrentState`
 * `kMBMLViewAnimationOptionRepeat` ("repeat") = `UIViewAnimationOptionRepeat`
 * `kMBMLViewAnimationOptionAutoreverse` ("autoreverse") = `UIViewAnimationOptionAutoreverse`
 * `kMBMLViewAnimationOptionOverrideInheritedDuration` ("overrideInheritedDuration") = `UIViewAnimationOptionOverrideInheritedDuration`
 * `kMBMLViewAnimationOptionOverrideInheritedCurve` ("overrideInheritedCurve") = `UIViewAnimationOptionOverrideInheritedCurve`
 * `kMBMLViewAnimationOptionAllowAnimatedContent` ("allowAnimatedContent") = `UIViewAnimationOptionAllowAnimatedContent`
 * `kMBMLViewAnimationOptionShowHideTransitionViews` ("showHideTransitionViews") = `UIViewAnimationOptionShowHideTransitionViews`
 * `kMBMLViewAnimationOptionCurveEaseInOut` ("curveEaseInOut") = `UIViewAnimationOptionCurveEaseInOut`
 * `kMBMLViewAnimationOptionCurveEaseIn` ("curveEaseIn") = `UIViewAnimationOptionCurveEaseIn`
 * `kMBMLViewAnimationOptionCurveEaseOut` ("curveEaseOut") = `UIViewAnimationOptionCurveEaseOut`
 * `kMBMLViewAnimationOptionCurveLinear` ("curveLinear") = `UIViewAnimationOptionCurveLinear`
 * `kMBMLViewAnimationOptionTransitionNone` ("transitionNone") = `UIViewAnimationOptionTransitionNone`
 * `kMBMLViewAnimationOptionTransitionFlipFromLeft` ("transitionFlipFromLeft") = `UIViewAnimationOptionTransitionFlipFromLeft`
 * `kMBMLViewAnimationOptionTransitionFlipFromRight` ("transitionFlipFromRight") = `UIViewAnimationOptionTransitionFlipFromRight`
 * `kMBMLViewAnimationOptionTransitionCurlUp` ("transitionCurlUp") = `UIViewAnimationOptionTransitionCurlUp`
 * `kMBMLViewAnimationOptionTransitionCurlDown` ("transitionCurlDown") = `UIViewAnimationOptionTransitionCurlDown`
 * `kMBMLViewAnimationOptionTransitionCrossDissolve` ("transitionCrossDissolve") = `UIViewAnimationOptionTransitionCrossDissolve`
 * `kMBMLViewAnimationOptionTransitionFlipFromTop` ("transitionFlipFromTop") = `UIViewAnimationOptionTransitionFlipFromTop`
 * `kMBMLViewAnimationOptionTransitionFlipFromBottom` ("transitionFlipFromBottom") = `UIViewAnimationOptionTransitionFlipFromBottom`

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `UIViewAnimationOptions` value that corresponds with the
            result of evaluating `expr` as a string. Returns `0` if the
            expression result couldn't be interpreted.
 */
+ (UIViewAnimationOptions) viewAnimationOptionsFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Evaluates a string expression and attempts to interpret the result as a
 `UIViewAnimationOptions` value using the `viewAnimationOptionsFromString:`
 method.

 @param     expr The expression whose result will be interpreted.

 @return    The `UIViewAnimationOptions` value that corresponds with the
            result of evaluating `expr` as a string. Returns 
            `0` and logs an error to the console if the expression result
            couldn't be interpreted.
 */
+ (UIViewAnimationOptions) viewAnimationOptionsFromExpression:(NSString*)expr;

/*----------------------------------------------------------------------------*/
#pragma mark UIModalTransitionStyle conversions
/*!    @name UIModalTransitionStyle conversions                               */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to interpret a string as a `UIModalTransitionStyle` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLModalTransitionStyleCoverVertical` ("coverVertical") = `UIModalTransitionStyleCoverVertical`
 * `kMBMLModalTransitionStyleFlipHorizontal` ("flipHorizontal") = `UIModalTransitionStyleFlipHorizontal`
 * `kMBMLModalTransitionStyleCrossDissolve` ("crossDissolve") = `UIModalTransitionStyleCrossDissolve`
 * `kMBMLModalTransitionStylePartialCurl` ("partialCurl") = `UIModalTransitionStylePartialCurl`

 @param     str The string to interpret.

 @return    The `UIModalTransitionStyle` value that corresponds with `str`.
            Returns `UIModalTransitionStyleCoverVertical` and logs an error to
            the console if `str` isn't recognized.
 */
+ (UIModalTransitionStyle) modalTransitionStyleFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `UIModalTransitionStyle` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLModalTransitionStyleCoverVertical` ("coverVertical") = `UIModalTransitionStyleCoverVertical`
 * `kMBMLModalTransitionStyleFlipHorizontal` ("flipHorizontal") = `UIModalTransitionStyleFlipHorizontal`
 * `kMBMLModalTransitionStyleCrossDissolve` ("crossDissolve") = `UIModalTransitionStyleCrossDissolve`
 * `kMBMLModalTransitionStylePartialCurl` ("partialCurl") = `UIModalTransitionStylePartialCurl`

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `UIModalTransitionStyle` value that corresponds with `str`.
            Returns `UIModalTransitionStyleCoverVertical` if `str` isn't
            recognized.
 */
+ (UIModalTransitionStyle) modalTransitionStyleFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Evaluates a string expression and attempts to interpret the result as a
 `UIModalTransitionStyle` value using the `modalTransitionStyleFromString:`
 method.

 @param     expr The expression whose result will be interpreted.

 @return    The `UIModalTransitionStyle` value that corresponds with the
            result of evaluating `expr` as a string. Returns 
            `UIModalTransitionStyleCoverVertical` and logs an error to the 
            console if the expression result couldn't be interpreted.
 */
+ (UIModalTransitionStyle) modalTransitionStyleFromExpression:(NSString*)expr;

/*----------------------------------------------------------------------------*/
#pragma mark UIViewContentMode conversions
/*!    @name UIViewContentMode conversions                                    */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to interpret a string as a `UIViewContentMode` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLViewContentModeScaleToFill` ("scaleToFill") = `UIViewContentModeScaleToFill`
 * `kMBMLViewContentModeScaleAspectFit` ("aspectFit") = `UIViewContentModeScaleAspectFit`
 * `kMBMLViewContentModeScaleAspectFill` ("aspectFill") = `UIViewContentModeScaleAspectFill`
 * `kMBMLViewContentModeRedraw` ("redraw") = `UIViewContentModeRedraw`
 * `kMBMLViewContentModeCenter` ("center") = `UIViewContentModeCenter`
 * `kMBMLViewContentModeTop` ("top") = `UIViewContentModeTop`
 * `kMBMLViewContentModeBottom` ("bottom") = `UIViewContentModeBottom`
 * `kMBMLViewContentModeLeft` ("left") = `UIViewContentModeLeft`
 * `kMBMLViewContentModeRight` ("right") = `UIViewContentModeRight`
 * `kMBMLViewContentModeTopLeft` ("topLeft") = `UIViewContentModeTopLeft`
 * `kMBMLViewContentModeTopRight` ("topRight") = `UIViewContentModeTopRight`
 * `kMBMLViewContentModeBottomLeft` ("bottomLeft") = `UIViewContentModeBottomLeft`
 * `kMBMLViewContentModeBottomRight` ("bottomRight") = `UIViewContentModeBottomRight`

 @param     str The string to interpret.

 @return    The `UIViewContentMode` value that corresponds with `str`.
            Returns `UIViewContentModeScaleToFill` and logs an error to the
            console if `str` isn't recognized.
 */
+ (UIViewContentMode) viewContentModeFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `UIViewContentMode` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLViewContentModeScaleToFill` ("scaleToFill") = `UIViewContentModeScaleToFill`
 * `kMBMLViewContentModeScaleAspectFit` ("aspectFit") = `UIViewContentModeScaleAspectFit`
 * `kMBMLViewContentModeScaleAspectFill` ("aspectFill") = `UIViewContentModeScaleAspectFill`
 * `kMBMLViewContentModeRedraw` ("redraw") = `UIViewContentModeRedraw`
 * `kMBMLViewContentModeCenter` ("center") = `UIViewContentModeCenter`
 * `kMBMLViewContentModeTop` ("top") = `UIViewContentModeTop`
 * `kMBMLViewContentModeBottom` ("bottom") = `UIViewContentModeBottom`
 * `kMBMLViewContentModeLeft` ("left") = `UIViewContentModeLeft`
 * `kMBMLViewContentModeRight` ("right") = `UIViewContentModeRight`
 * `kMBMLViewContentModeTopLeft` ("topLeft") = `UIViewContentModeTopLeft`
 * `kMBMLViewContentModeTopRight` ("topRight") = `UIViewContentModeTopRight`
 * `kMBMLViewContentModeBottomLeft` ("bottomLeft") = `UIViewContentModeBottomLeft`
 * `kMBMLViewContentModeBottomRight` ("bottomRight") = `UIViewContentModeBottomRight`

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `UIViewContentMode` value that corresponds with `str`.
            Returns `UIViewContentModeScaleToFill` if `str` isn't recognized.
 */
+ (UIViewContentMode) viewContentModeFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Evaluates a string expression and attempts to interpret the result as a
 `UIViewContentMode` value using the `viewContentModeFromString:`
 method.

 @param     expr The expression whose result will be interpreted.

 @return    The `UIViewContentMode` value that corresponds with the
            result of evaluating `expr` as a string. Returns 
            `UIViewContentModeScaleToFill` and logs an error to the console
            if the expression result couldn't be interpreted.
 */
+ (UIViewContentMode) viewContentModeFromExpression:(NSString*)expr;

/*----------------------------------------------------------------------------*/
#pragma mark UIBarStyle conversions
/*!    @name UIBarStyle conversions                                           */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to interpret a string as a `UIBarStyle` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLBarStyleDefault` ("default") = `UIBarStyleDefault`
 * `kMBMLBarStyleBlack` ("black") = `UIBarStyleBlack`
 * `kMBMLBarStyleBlackOpaque` ("blackOpaque") = `UIBarStyleBlackOpaque`
 * `kMBMLBarStyleBlackTranslucent` ("blackTranslucent") = `UIBarStyleBlackTranslucent`

 @param     str The string to interpret.

 @return    The `UIBarStyle` value that corresponds with `str`.
            Returns `UIBarStyleDefault` and logs an error to the
            console if `str` isn't recognized.
 */
+ (UIBarStyle) barStyleFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `UIBarStyle` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLBarStyleDefault` ("default") = `UIBarStyleDefault`
 * `kMBMLBarStyleBlack` ("black") = `UIBarStyleBlack`
 * `kMBMLBarStyleBlackOpaque` ("blackOpaque") = `UIBarStyleBlackOpaque`
 * `kMBMLBarStyleBlackTranslucent` ("blackTranslucent") = `UIBarStyleBlackTranslucent`

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `UIBarStyle` value that corresponds with `str`.
            Returns `UIBarStyleDefault` if `str` isn't recognized.
 */
+ (UIBarStyle) barStyleFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Evaluates a string expression and attempts to interpret the result as a
 `UIBarStyle` value using the `barStyleFromString:`
 method.

 @param     expr The expression whose result will be interpreted.

 @return    The `UIBarStyle` value that corresponds with the
            result of evaluating `expr` as a string. Returns 
            `UIBarStyleDefault` and logs an error to the console
            if the expression result couldn't be interpreted.
 */
+ (UIBarStyle) barStyleFromExpression:(NSString*)expr;

/*----------------------------------------------------------------------------*/
#pragma mark UIBarButtonSystemItem conversions
/*!    @name UIBarButtonSystemItem conversions                                */
/*----------------------------------------------------------------------------*/

/*!
 * `kMBMLBarButtonSystemItemDone` ("done") = `UIBarButtonSystemItemDone`
 * `kMBMLBarButtonSystemItemCancel` ("cancel") = `UIBarButtonSystemItemCancel`
 * `kMBMLBarButtonSystemItemEdit` ("edit") = `UIBarButtonSystemItemEdit`
 * `kMBMLBarButtonSystemItemSave` ("save") = `UIBarButtonSystemItemSave`
 * `kMBMLBarButtonSystemItemAdd` ("add") = `UIBarButtonSystemItemAdd`
 * `kMBMLBarButtonSystemItemFlexibleSpace` ("flexibleSpace") = `UIBarButtonSystemItemFlexibleSpace`
 * `kMBMLBarButtonSystemItemFixedSpace` ("fixedSpace") = `UIBarButtonSystemItemFixedSpace`
 * `kMBMLBarButtonSystemItemCompose` ("compose") = `UIBarButtonSystemItemCompose`
 * `kMBMLBarButtonSystemItemReply` ("reply") = `UIBarButtonSystemItemReply`
 * `kMBMLBarButtonSystemItemAction` ("action") = `UIBarButtonSystemItemAction`
 * `kMBMLBarButtonSystemItemOrganize` ("organize") = `UIBarButtonSystemItemOrganize`
 * `kMBMLBarButtonSystemItemBookmarks` ("bookmarks") = `UIBarButtonSystemItemBookmarks`
 * `kMBMLBarButtonSystemItemSearch` ("search") = `UIBarButtonSystemItemSearch`
 * `kMBMLBarButtonSystemItemRefresh` ("refresh") = `UIBarButtonSystemItemRefresh`
 * `kMBMLBarButtonSystemItemStop` ("stop") = `UIBarButtonSystemItemStop`
 * `kMBMLBarButtonSystemItemCamera` ("camera") = `UIBarButtonSystemItemCamera`
 * `kMBMLBarButtonSystemItemTrash` ("trash") = `UIBarButtonSystemItemTrash`
 * `kMBMLBarButtonSystemItemPlay` ("play") = `UIBarButtonSystemItemPlay`
 * `kMBMLBarButtonSystemItemPause` ("pause") = `UIBarButtonSystemItemPause`
 * `kMBMLBarButtonSystemItemRewind` ("rewind") = `UIBarButtonSystemItemRewind`
 * `kMBMLBarButtonSystemItemFastForward` ("fastForward") = `UIBarButtonSystemItemFastForward`
 * `kMBMLBarButtonSystemItemUndo` ("undo") = `UIBarButtonSystemItemUndo`
 * `kMBMLBarButtonSystemItemRedo` ("redo") = `UIBarButtonSystemItemRedo`
 * `kMBMLBarButtonSystemItemPageCurl` ("pageCurl") = `UIBarButtonSystemItemPageCurl`

 @param     str The string to interpret.

 @return    The `UIBarButtonSystemItem` value that corresponds with `str`.
            Returns `UIBarButtonSystemItemDone` and logs an error to the
            console if `str` isn't recognized.
 */
+ (UIBarButtonSystemItem) barButtonSystemItemFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `UIBarButtonSystemItem` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLBarButtonSystemItemDone` ("done") = `UIBarButtonSystemItemDone`
 * `kMBMLBarButtonSystemItemCancel` ("cancel") = `UIBarButtonSystemItemCancel`
 * `kMBMLBarButtonSystemItemEdit` ("edit") = `UIBarButtonSystemItemEdit`
 * `kMBMLBarButtonSystemItemSave` ("save") = `UIBarButtonSystemItemSave`
 * `kMBMLBarButtonSystemItemAdd` ("add") = `UIBarButtonSystemItemAdd`
 * `kMBMLBarButtonSystemItemFlexibleSpace` ("flexibleSpace") = `UIBarButtonSystemItemFlexibleSpace`
 * `kMBMLBarButtonSystemItemFixedSpace` ("fixedSpace") = `UIBarButtonSystemItemFixedSpace`
 * `kMBMLBarButtonSystemItemCompose` ("compose") = `UIBarButtonSystemItemCompose`
 * `kMBMLBarButtonSystemItemReply` ("reply") = `UIBarButtonSystemItemReply`
 * `kMBMLBarButtonSystemItemAction` ("action") = `UIBarButtonSystemItemAction`
 * `kMBMLBarButtonSystemItemOrganize` ("organize") = `UIBarButtonSystemItemOrganize`
 * `kMBMLBarButtonSystemItemBookmarks` ("bookmarks") = `UIBarButtonSystemItemBookmarks`
 * `kMBMLBarButtonSystemItemSearch` ("search") = `UIBarButtonSystemItemSearch`
 * `kMBMLBarButtonSystemItemRefresh` ("refresh") = `UIBarButtonSystemItemRefresh`
 * `kMBMLBarButtonSystemItemStop` ("stop") = `UIBarButtonSystemItemStop`
 * `kMBMLBarButtonSystemItemCamera` ("camera") = `UIBarButtonSystemItemCamera`
 * `kMBMLBarButtonSystemItemTrash` ("trash") = `UIBarButtonSystemItemTrash`
 * `kMBMLBarButtonSystemItemPlay` ("play") = `UIBarButtonSystemItemPlay`
 * `kMBMLBarButtonSystemItemPause` ("pause") = `UIBarButtonSystemItemPause`
 * `kMBMLBarButtonSystemItemRewind` ("rewind") = `UIBarButtonSystemItemRewind`
 * `kMBMLBarButtonSystemItemFastForward` ("fastForward") = `UIBarButtonSystemItemFastForward`
 * `kMBMLBarButtonSystemItemUndo` ("undo") = `UIBarButtonSystemItemUndo`
 * `kMBMLBarButtonSystemItemRedo` ("redo") = `UIBarButtonSystemItemRedo`
 * `kMBMLBarButtonSystemItemPageCurl` ("pageCurl") = `UIBarButtonSystemItemPageCurl`

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `UIBarButtonSystemItem` value that corresponds with `str`.
            Returns `UIBarButtonSystemItemDone` if `str` isn't recognized.
 */
+ (UIBarButtonSystemItem) barButtonSystemItemFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Evaluates a string expression and attempts to interpret the result as a
 `UIBarButtonSystemItem` value using the `barButtonSystemItemFromString:`
 method.

 @param     expr The expression whose result will be interpreted.

 @return    The `UIBarButtonSystemItem` value that corresponds with the
            result of evaluating `expr` as a string. Returns 
            `UIBarButtonSystemItemDone` and logs an error to the console
            if the expression result couldn't be interpreted.
 */
+ (UIBarButtonSystemItem) barButtonSystemItemFromExpression:(NSString*)expr;

/*----------------------------------------------------------------------------*/
#pragma mark UIBarButtonItemStyle conversions
/*!    @name UIBarButtonItemStyle conversions                                 */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to interpret a string as a `UIBarButtonItemStyle` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLBarButtonItemStylePlain` ("plain") = `UIBarButtonItemStylePlain`
 * **Deprecated:** `kMBMLBarButtonItemStyleBordered` ("bordered") = `UIBarButtonItemStyleBordered`
 * `kMBMLBarButtonItemStyleDone` ("done") = `UIBarButtonItemStyleDone`

 @param     str The string to interpret.

 @return    The `UIBarButtonItemStyle` value that corresponds with `str`.
            Returns `UIBarButtonItemStylePlain` and logs an error to the
            console if `str` isn't recognized.
 */
+ (UIBarButtonItemStyle) barButtonItemStyleFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `UIBarButtonItemStyle` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLBarButtonItemStylePlain` ("plain") = `UIBarButtonItemStylePlain`
 * **Deprecated:** `kMBMLBarButtonItemStyleBordered` ("bordered") = `UIBarButtonItemStyleBordered`
 * `kMBMLBarButtonItemStyleDone` ("done") = `UIBarButtonItemStyleDone`

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `UIBarButtonItemStyle` value that corresponds with `str`.
            Returns `UIBarButtonItemStylePlain` if `str` isn't recognized.
 */
+ (UIBarButtonItemStyle) barButtonItemStyleFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Evaluates a string expression and attempts to interpret the result as a
 `UIBarButtonItemStyle` value using the `barButtonItemStyleFromString:`
 method.

 @param     expr The expression whose result will be interpreted.

 @return    The `UIBarButtonItemStyle` value that corresponds with the
            result of evaluating `expr` as a string. Returns 
            `UIBarButtonItemStylePlain` and logs an error to the console
            if the expression result couldn't be interpreted.
 */
+ (UIBarButtonItemStyle) barButtonItemStyleFromExpression:(NSString*)expr;

/*----------------------------------------------------------------------------*/
#pragma mark UIStatusBarAnimation conversions
/*!    @name UIStatusBarAnimation conversions                                 */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to interpret a string as a `UIStatusBarAnimation` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLStatusBarAnimationNone` ("none") = `UIStatusBarAnimationNone`
 * `kMBMLStatusBarAnimationFade` ("fade") = `UIStatusBarAnimationFade`
 * `kMBMLStatusBarAnimationSlide` ("slide") = `UIStatusBarAnimationSlide`

 @param     str The string to interpret.
 
 @return    The `UIStatusBarAnimation` value that corresponds with `str`.
            Returns `UIStatusBarAnimationNone` and logs an error to the
            console if `str` isn't recognized.
 */
+ (UIStatusBarAnimation) statusBarAnimationFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `UIStatusBarAnimation` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLStatusBarAnimationNone` ("none") = `UIStatusBarAnimationNone`
 * `kMBMLStatusBarAnimationFade` ("fade") = `UIStatusBarAnimationFade`
 * `kMBMLStatusBarAnimationSlide` ("slide") = `UIStatusBarAnimationSlide`

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `UIStatusBarAnimation` value that corresponds with `str`.
            Returns `UIStatusBarAnimationNone` if `str` isn't recognized.
 */
+ (UIStatusBarAnimation) statusBarAnimationFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Evaluates a string expression and attempts to interpret the result as a
 `UIStatusBarAnimation` value using the `statusBarAnimationFromString:`
 method.

 @param     expr The expression whose result will be interpreted.

 @return    The `UIStatusBarAnimation` value that corresponds with the
            result of evaluating `expr` as a string. Returns 
            `UIStatusBarAnimationNone` and logs an error to the console
            if the expression result couldn't be interpreted.
 */
+ (UIStatusBarAnimation) statusBarAnimationFromExpression:(NSString*)expr;

/*----------------------------------------------------------------------------*/
#pragma mark UIPopoverArrowDirection conversions
/*!    @name UIPopoverArrowDirection conversions                              */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to interpret a string as a `UIPopoverArrowDirection` value.
 
 The following string constants show the accepted inputs, along with their
 corresponding values:
 
 * `kMBMLPopoverArrowDirectionUp` ("up") = `UIPopoverArrowDirectionUp`
 * `kMBMLPopoverArrowDirectionDown` ("down") = `UIPopoverArrowDirectionDown`
 * `kMBMLPopoverArrowDirectionLeft` ("left") = `UIPopoverArrowDirectionLeft`
 * `kMBMLPopoverArrowDirectionRight` ("right") = `UIPopoverArrowDirectionRight`
 * `kMBMLPopoverArrowDirectionAny` ("any") = `UIPopoverArrowDirectionAny`

 @param     str The string to interpret.
 
 @return    The `UIPopoverArrowDirection` value that corresponds with `str`.
            Returns `UIPopoverArrowDirectionAny` logs an error to the console 
            if `str` isn't recognized.
 */
+ (UIPopoverArrowDirection) popoverArrowDirectionFromString:(NSString*)str;

/*!
 Attempts to interpret a string as a `UIPopoverArrowDirection` value.

 The following string constants show the accepted inputs, along with their
 corresponding values:

 * `kMBMLPopoverArrowDirectionUp` ("up") = `UIPopoverArrowDirectionUp`
 * `kMBMLPopoverArrowDirectionDown` ("down") = `UIPopoverArrowDirectionDown`
 * `kMBMLPopoverArrowDirectionLeft` ("left") = `UIPopoverArrowDirectionLeft`
 * `kMBMLPopoverArrowDirectionRight` ("right") = `UIPopoverArrowDirectionRight`
 * `kMBMLPopoverArrowDirectionAny` ("any") = `UIPopoverArrowDirectionAny`

 @param     str The string to interpret.

 @param     errPtr An optional pointer to a memory location for storing an
            `NSError` instance in the event of a problem interpreting `str`.
            May be `nil`.

 @return    The `UIPopoverArrowDirection` value that corresponds with `str`.
            Returns `UIPopoverArrowDirectionAny` if `str` isn't recognized.
 */
+ (UIPopoverArrowDirection) popoverArrowDirectionFromString:(NSString*)str error:(NSError**)errPtr;

/*!
 Evaluates a string expression and attempts to interpret the result as a
 `UIPopoverArrowDirection` value using the `popoverArrowDirectionFromString:`
 method.

 @param     expr The expression whose result will be interpreted.

 @return    The `UIPopoverArrowDirection` value that corresponds with the
            result of evaluating `expr` as a string. Returns 
            `UIPopoverArrowDirectionAny` and logs an error to the console
            if the expression result couldn't be interpreted.
 */
+ (UIPopoverArrowDirection) popoverArrowDirectionFromExpression:(NSString*)expr;

@end
