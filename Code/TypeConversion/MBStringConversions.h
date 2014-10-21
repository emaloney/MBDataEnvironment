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

// an extension of UITableViewCellSelectionStyle that adds support for gradients
typedef enum : NSInteger {
    MBTableViewCellSelectionStyleNone       = UITableViewCellSelectionStyleNone,
    MBTableViewCellSelectionStyleBlue       = UITableViewCellSelectionStyleBlue,
    MBTableViewCellSelectionStyleGray       = UITableViewCellSelectionStyleGray,
    MBTableViewCellSelectionStyleGradient   = NSIntegerMax
} MBTableViewCellSelectionStyle;

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

// this is returned as the color when colorFromString: fails
#define kInvalidColorSpecification      [UIColor yellowColor]

// NSTextAlignment
extern NSString* const kMBMLTextAlignmentLeft;                      // @"left" for UIScrollViewIndicatorStyleDefault
extern NSString* const kMBMLTextAlignmentCenter;                    // @"center" for UIScrollViewIndicatorStyleWhite
extern NSString* const kMBMLTextAlignmentRight;                     // @"right" for UIScrollViewIndicatorStyleWhite

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

@interface MBStringConversions : NSObject

/*******************************************************************************
 @name CGPoint conversions
 ******************************************************************************/

+ (CGPoint) pointFromString:(NSString*)str;
+ (CGPoint) pointFromString:(NSString*)str error:(NSError**)errPtr;
+ (CGPoint) pointFromObject:(id)obj error:(NSError**)errPtr;
+ (CGPoint) pointFromExpression:(NSString*)expr;

+ (NSString*) stringFromPoint:(CGPoint)pt;

/*******************************************************************************
 @name CGSize conversions
 ******************************************************************************/

/*----------------------------------------------------------------------------*/
#pragma mark Parsing size dimensions from strings
/*!    @name Parsing size dimensions from strings                             */
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

+ (CGSize) sizeFromString:(NSString*)str;
+ (CGSize) sizeFromString:(NSString*)str error:(NSError**)errPtr;
+ (CGSize) sizeFromObject:(id)obj error:(NSError**)errPtr;
+ (CGSize) sizeFromExpression:(NSString*)expr;

+ (NSString*) stringFromSize:(CGSize)sz;

/*******************************************************************************
 @name CGRect conversions
 ******************************************************************************/

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

+ (CGRect) rectFromString:(NSString*)str;
+ (CGRect) rectFromString:(NSString*)str error:(NSError**)errPtr;
+ (CGRect) rectFromObject:(id)obj error:(NSError**)errPtr;
+ (CGRect) rectFromExpression:(NSString*)expr;

+ (NSString*) stringFromRect:(CGRect)rect;

/*******************************************************************************
 @name UIOffset conversions
 ******************************************************************************/

+ (UIOffset) offsetFromString:(NSString*)str;
+ (UIOffset) offsetFromString:(NSString*)str error:(NSError**)errPtr;
+ (UIOffset) offsetFromObject:(id)obj error:(NSError**)errPtr;
+ (UIOffset) offsetFromExpression:(NSString*)expr;

/*******************************************************************************
 @name UIEdgeInsets conversions
 ******************************************************************************/

+ (UIEdgeInsets) edgeInsetsFromString:(NSString*)str;
+ (UIEdgeInsets) edgeInsetsFromString:(NSString*)str error:(NSError**)errPtr;
+ (UIEdgeInsets) edgeInsetsFromObject:(id)obj error:(NSError**)errPtr;
+ (UIEdgeInsets) edgeInsetsFromExpression:(NSString*)expr;

/*******************************************************************************
 @name UIColor conversions
 ******************************************************************************/

+ (UIColor*) colorFromString:(NSString*)str;
+ (UIColor*) colorFromString:(NSString*)str error:(NSError**)errPtr;
+ (UIColor*) colorFromExpression:(NSString*)expr;

/*******************************************************************************
 @name NSLineBreakMode conversions
 ******************************************************************************/

+ (NSLineBreakMode) lineBreakModeFromString:(NSString*)str;
+ (NSLineBreakMode) lineBreakModeFromString:(NSString*)str error:(NSError**)errPtr;
+ (NSLineBreakMode) lineBreakModeFromExpression:(NSString*)expr;

/*******************************************************************************
 @name NSTextAlignment conversions
 ******************************************************************************/

+ (NSTextAlignment) textAlignmentFromString:(NSString*)str;
+ (NSTextAlignment) textAlignmentFromString:(NSString*)str error:(NSError**)errPtr;
+ (NSTextAlignment) textAlignmentFromExpression:(NSString*)expr;

/*******************************************************************************
 @name UIScrollViewIndicatorStyle conversions
 ******************************************************************************/

+ (UIScrollViewIndicatorStyle) scrollViewIndicatorStyleFromString:(NSString*)str;
+ (UIScrollViewIndicatorStyle) scrollViewIndicatorStyleFromString:(NSString*)str error:(NSError**)errPtr;
+ (UIScrollViewIndicatorStyle) scrollViewIndicatorStyleFromExpression:(NSString*)expr;

/*******************************************************************************
 @name UIActivityIndicatorViewStyle conversions
 ******************************************************************************/

+ (UIActivityIndicatorViewStyle) activityIndicatorViewStyleFromString:(NSString*)str;
+ (UIActivityIndicatorViewStyle) activityIndicatorViewStyleFromString:(NSString*)str error:(NSError**)errPtr;
+ (UIActivityIndicatorViewStyle) activityIndicatorViewStyleFromExpression:(NSString*)expr;

/*******************************************************************************
 @name UIButtonType conversions
 ******************************************************************************/

+ (UIButtonType) buttonTypeFromString:(NSString*)str;
+ (UIButtonType) buttonTypeFromString:(NSString*)str error:(NSError**)errPtr;
+ (UIButtonType) buttonTypeFromExpression:(NSString*)expr;

/*******************************************************************************
 @name NSDateFormatterStyle conversions
 ******************************************************************************/

+ (NSDateFormatterStyle) dateFormatterStyleFromString:(NSString*)str;
+ (NSDateFormatterStyle) dateFormatterStyleFromString:(NSString*)str error:(NSError**)errPtr;
+ (NSDateFormatterStyle) dateFormatterStyleFromExpression:(NSString*)expr;

/*******************************************************************************
 @name UITextBorderStyle conversions
 ******************************************************************************/

+ (UITextBorderStyle) textBorderStyleFromString:(NSString*)str;
+ (UITextBorderStyle) textBorderStyleFromString:(NSString*)str error:(NSError**)errPtr;
+ (UITextBorderStyle) textBorderStyleFromExpression:(NSString*)expr;

/*******************************************************************************
 @name UITableViewStyle conversions
 ******************************************************************************/

+ (UITableViewStyle) tableViewStyleFromString:(NSString*)str;
+ (UITableViewStyle) tableViewStyleFromString:(NSString*)str error:(NSError**)errPtr;
+ (UITableViewStyle) tableViewStyleFromExpression:(NSString*)expr;

/*******************************************************************************
 @name UITableViewCell-related conversions
 ******************************************************************************/

+ (UITableViewCellStyle) tableViewCellStyleFromString:(NSString*)str;
+ (UITableViewCellStyle) tableViewCellStyleFromString:(NSString*)str error:(NSError**)errPtr;
+ (UITableViewCellStyle) tableViewCellStyleFromExpression:(NSString*)expr;

// MBTableViewCellSelectionStyle is cast-compatible with UITableViewCellSelectionStyle but adds MBTableViewCellSelectionStyleGradient
+ (MBTableViewCellSelectionStyle) tableViewCellSelectionStyleFromString:(NSString*)str;
+ (MBTableViewCellSelectionStyle) tableViewCellSelectionStyleFromString:(NSString*)str error:(NSError**)errPtr;
+ (MBTableViewCellSelectionStyle) tableViewCellSelectionStyleFromExpression:(NSString*)expr;
                                                                  
+ (UITableViewCellAccessoryType) tableViewCellAccessoryTypeFromString:(NSString*)str;
+ (UITableViewCellAccessoryType) tableViewCellAccessoryTypeFromString:(NSString*)str error:(NSError**)errPtr;
+ (UITableViewCellAccessoryType) tableViewCellAccessoryTypeFromExpression:(NSString*)expr;

/*******************************************************************************
 @name UITableViewRowAnimation conversions
 ******************************************************************************/

+ (UITableViewRowAnimation) tableViewRowAnimationFromString:(NSString*)str;
+ (UITableViewRowAnimation) tableViewRowAnimationFromString:(NSString*)str error:(NSError**)errPtr;
+ (UITableViewRowAnimation) tableViewRowAnimationFromExpression:(NSString*)expr;

/*******************************************************************************
 @name UIControlState conversions
 ******************************************************************************/

+ (UIControlState) controlStateFromString:(NSString*)str;
+ (UIControlState) controlStateFromString:(NSString*)str error:(NSError**)errPtr;
+ (UIControlState) controlStateFromExpression:(NSString*)expr;

/*******************************************************************************
 @name UIViewAnimationOptions conversions
 ******************************************************************************/

+ (UIViewAnimationOptions) viewAnimationOptionsFromString:(NSString*)str;
+ (UIViewAnimationOptions) viewAnimationOptionsFromString:(NSString*)str error:(NSError**)errPtr;
+ (UIViewAnimationOptions) viewAnimationOptionsFromExpression:(NSString*)expr;

/*******************************************************************************
 @name UIModalTransitionStyle conversions
 ******************************************************************************/

+ (UIModalTransitionStyle) modalTransitionStyleFromString:(NSString*)str;
+ (UIModalTransitionStyle) modalTransitionStyleFromString:(NSString*)str error:(NSError**)errPtr;
+ (UIModalTransitionStyle) modalTransitionStyleFromExpression:(NSString*)expr;

/*******************************************************************************
 @name UIViewContentMode conversions
 ******************************************************************************/

+ (UIViewContentMode) viewContentModeFromString:(NSString*)str;
+ (UIViewContentMode) viewContentModeFromString:(NSString*)str error:(NSError**)errPtr;
+ (UIViewContentMode) viewContentModeFromExpression:(NSString*)expr;

/*******************************************************************************
 @name UIBarStyle conversions
 ******************************************************************************/

+ (UIBarStyle) barStyleFromString:(NSString*)str;
+ (UIBarStyle) barStyleFromString:(NSString*)str error:(NSError**)errPtr;
+ (UIBarStyle) barStyleFromExpression:(NSString*)expr;

/*******************************************************************************
 @name UIBarButtonSystemItem conversions
 ******************************************************************************/

+ (UIBarButtonSystemItem) barButtonSystemItemFromString:(NSString*)str;
+ (UIBarButtonSystemItem) barButtonSystemItemFromString:(NSString*)str error:(NSError**)errPtr;
+ (UIBarButtonSystemItem) barButtonSystemItemFromExpression:(NSString*)expr;

/*******************************************************************************
 @name UIBarButtonItemStyle conversions
 ******************************************************************************/

+ (UIBarButtonItemStyle) barButtonItemStyleFromString:(NSString*)str;
+ (UIBarButtonItemStyle) barButtonItemStyleFromString:(NSString*)str error:(NSError**)errPtr;
+ (UIBarButtonItemStyle) barButtonItemStyleFromExpression:(NSString*)expr;

/*******************************************************************************
 @name UIStatusBarAnimation conversions
 ******************************************************************************/

+ (UIStatusBarAnimation) statusBarAnimationFromString:(NSString*)str;
+ (UIStatusBarAnimation) statusBarAnimationFromString:(NSString*)str error:(NSError**)errPtr;
+ (UIStatusBarAnimation) statusBarAnimationFromExpression:(NSString*)expr;

/*******************************************************************************
 @name UIPopoverArrowDirection conversions
 ******************************************************************************/

+ (UIPopoverArrowDirection) popoverArrowDirectionFromString:(NSString*)str;
+ (UIPopoverArrowDirection) popoverArrowDirectionFromString:(NSString*)str error:(NSError**)errPtr;
+ (UIPopoverArrowDirection) popoverArrowDirectionFromExpression:(NSString*)expr;

@end
