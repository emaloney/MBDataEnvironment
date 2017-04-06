//
//  MBMLGeometryFunctions.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 7/6/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBAvailability.h>

#if MB_BUILD_UIKIT

#import <Foundation/Foundation.h>

/******************************************************************************/
#pragma mark -
#pragma mark MBMLGeometryFunctions class
/******************************************************************************/

/*!
 This class implements MBML functions for working with geometric values.
 
 These functions are exposed to the Mockingbird environment via 
 `<Function ... />` declarations in the <code>MBDataEnvironmentModule.xml</code>
 file.
 
 For more information on MBML functions, see the `MBMLFunction` class.
 */
@interface MBMLGeometryFunctions : NSObject

/*----------------------------------------------------------------------------*/
#pragma mark Accessing components of rectangles
/*!    @name Accessing components of rectangles                               */
/*----------------------------------------------------------------------------*/

/*!
 Returns the origin point of the given rectangle, as a comma-separated string
 in the format "*`x`*`,`*`y`*".
 
 This Mockingbird function accepts a single parameter, an object expression
 that's expected to yield an `NSString` or an `NSValue` instance. This 
 expression is interpreted as follows:
 
 * If the expression yields a string, it is expected to be a comma-separated
   string in the format "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 * If the expression yields an `NSValue`, it is expected to contain a `CGRect`
   value.
 
 * All other cases are considered errors.

 #### Expression usage
 
     ^rectOrigin(10,20,80,90)
 
 The expression above would return the string "`10,20`".
 
 @param     param The function's input parameter.

 @return    The function result, the origin point of the rectangle expressed
            as a comma-separated string.
 */
+ (id) rectOrigin:(id)param;

/*!
 Returns the size of the given rectangle, as a comma-separated string
 in the format "*`width`*`,`*`height`*".
 
 This Mockingbird function accepts a single parameter, an object expression
 that's expected to yield an `NSString` or an `NSValue` instance. This 
 expression is interpreted as follows:
 
 * If the expression yields a string, it is expected to be a comma-separated
   string in the format "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 * If the expression yields an `NSValue`, it is expected to contain a `CGRect`
   value.
 
 * All other cases are considered errors.

 #### Expression usage

     ^rectSize(10,20,80,90)
 
 The expression above would return the string "`80,90`".
 
 @param     param The function's input parameter.

 @return    The function result, the size of the rectangle expressed
            as a comma-separated string.
 */
+ (id) rectSize:(id)param;

/*!
 Returns an `NSNumber` containing the *x* coordinate of the given rectangle's
 origin point.

 This Mockingbird function accepts a single parameter, an object expression
 that's expected to yield an `NSString` or an `NSValue` instance. This 
 expression is interpreted as follows:
 
 * If the expression yields a string, it is expected to be a comma-separated
   string in the format "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 * If the expression yields an `NSValue`, it is expected to contain a `CGRect`
   value.
 
 * All other cases are considered errors.

 #### Expression usage

     ^rectX(10,20,80,90)
 
 The expression above would return the value `10`.

 @param     param The function's input parameter.

 @return    The function result, the *x* coordinate of the rectangle's origin.
 */
+ (id) rectX:(id)param;

/*!
 Returns an `NSNumber` containing the *y* coordinate of the given rectangle's
 origin point.

 This Mockingbird function accepts a single parameter, an object expression
 that's expected to yield an `NSString` or an `NSValue` instance. This 
 expression is interpreted as follows:
 
 * If the expression yields a string, it is expected to be a comma-separated
   string in the format "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 * If the expression yields an `NSValue`, it is expected to contain a `CGRect`
   value.
 
 * All other cases are considered errors.

 #### Expression usage

     ^rectY(10,20,80,90)
 
 The expression above would return the value `20`.

 @param     param The function's input parameter.

 @return    The function result, the *y* coordinate of the rectangle's origin.
 */
+ (id) rectY:(id)param;

/*!
 Returns an `NSNumber` containing the width of the given rectangle.

 This Mockingbird function accepts a single parameter, an object expression
 that's expected to yield an `NSString` or an `NSValue` instance. This 
 expression is interpreted as follows:
 
 * If the expression yields a string, it is expected to be a comma-separated
   string in the format "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 * If the expression yields an `NSValue`, it is expected to contain a `CGRect`
   value.
 
 * All other cases are considered errors.

 #### Expression usage

     ^rectWidth(10,20,80,90)
 
 The expression above would return the value `80`.

 @param     param The function's input parameter.

 @return    The function result, the width of the rectangle.
 */
+ (id) rectWidth:(id)param;

/*!
 Returns an `NSNumber` containing the height of the given rectangle.

 This Mockingbird function accepts a single parameter, an object expression
 that's expected to yield an `NSString` or an `NSValue` instance. This 
 expression is interpreted as follows:
 
 * If the expression yields a string, it is expected to be a comma-separated
   string in the format "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 * If the expression yields an `NSValue`, it is expected to contain a `CGRect`
   value.
 
 * All other cases are considered errors.

 #### Expression usage

     ^rectHeight(10,20,80,90)
 
 The expression above would return the value `90`.

 @param     param The function's input parameter.

 @return    The function result, the height of the rectangle.
 */
+ (id) rectHeight:(id)param;

/*----------------------------------------------------------------------------*/
#pragma mark Adjusting rectangles
/*!    @name Adjusting rectangles                                             */
/*----------------------------------------------------------------------------*/

/*!
 Adjusts the given rectangle by applying the specified insets to each edge,
 and returns the resulting rectangle as a comma-separated string in the
 format "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 This Mockingbird function accepts two pipe-separated object expressions as
 parameters: the *source rectangle* and the *edge insets*.
 
 The *source rectangle* expression is interpreted as follows:
 
 * If the expression yields a string, it is expected to be a comma-separated
   string in the format "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 * If the expression yields an `NSValue`, it is expected to contain a `CGRect`
   value.

 The *edge insets* expression is interpreted as follows:
 
 * If the expression yields a string, it is expected to be a comma-separated
   string in the format 
   "*`topInset`*`,`*`leftInset`*`,`*`bottomInset`*`,`*`rightInset`*".

 * If the expression yields an `NSValue`, it is expected to contain a
   `UIEdgeInsets` value.
 
 Any other value for either input parameter is considered an error.

 #### Expression usage
 
     ^insetRect(10,10,100,100|-5,-5,15,15)
 
 The expression above would return the string "`5,5,90,90`".
 
 @param     params The function's input parameters.

 @return    A string containing the adjusted rectangle.
 */
+ (id) insetRect:(NSArray*)params;

/*!
 Adjusts the given rectangle by applying an inset to the top edge, and
 returns the resulting rectangle as a comma-separated string in the format
 "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 This Mockingbird function accepts two pipe-separated expressions as
 parameters: the *source rectangle* and the *inset amount*.
 
 The *source rectangle* expression is interpreted as follows:
 
 * If the expression yields a string, it is expected to be a comma-separated
   string in the format "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 * If the expression yields an `NSValue`, it is expected to contain a `CGRect`
   value.

 The *inset amount* is interpreted as a numeric expression indicating the 
 amount by which the edge of the *source rectangle* will be adjusted.

 A negative *inset amount* makes the rectangle taller by moving the top edge
 upwards; a positive value makes the rectangle shorter by lowering the top edge.

 #### Expression usage
 
     ^insetRectTop(10,10,100,100|-5)
 
 The expression above would return the string "`10,5,100,105`".
 
 @param     params The function's input parameters.

 @return    A string containing the adjusted rectangle.
 */
+ (id) insetRectTop:(NSArray*)params;

/*!
 Adjusts the given rectangle by applying an inset to the left edge, and
 returns the resulting rectangle as a comma-separated string in the format
 "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 This Mockingbird function accepts two pipe-separated expressions as
 parameters: the *source rectangle* and the *inset amount*.

 The *source rectangle* expression is interpreted as follows:

 * If the expression yields a string, it is expected to be a comma-separated
 string in the format "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 * If the expression yields an `NSValue`, it is expected to contain a `CGRect`
 value.

 The *inset amount* is interpreted as a numeric expression indicating the
 amount by which the edge of the *source rectangle* will be adjusted.

 A negative *inset amount* makes the rectangle wider by moving the left edge 
 further leftwards; a positive value makes the rectangle narrower by moving the
 left edge rightwards.

 #### Expression usage

     ^insetRectLeft(50,50,50,50|25)
 
 The expression above would return the string "`75,50,25,50`".

 @param     params The function's input parameters.

 @return    A string containing the adjusted rectangle.
 */
+ (id) insetRectLeft:(NSArray*)params;

/*!
 Adjusts the given rectangle by applying an inset to the bottom edge, and
 returns the resulting rectangle as a comma-separated string in the format
 "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 This Mockingbird function accepts two pipe-separated expressions as
 parameters: the *source rectangle* and the *inset amount*.

 The *source rectangle* expression is interpreted as follows:

 * If the expression yields a string, it is expected to be a comma-separated
 string in the format "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 * If the expression yields an `NSValue`, it is expected to contain a `CGRect`
 value.

 The *inset amount* is interpreted as a numeric expression indicating the
 amount by which the edge of the *source rectangle* will be adjusted.

 A negative *inset amount* makes the rectangle taller by moving the bottom
 edge downwards; a positive value makes the rectangle shorter by raising the
 bottom edge.

 #### Expression usage

     ^insetRectBottom(20,20,100,100|25)
 
 The expression above would return the string "`20,20,100,75`".

 @param     params The function's input parameters.

 @return    A string containing the adjusted rectangle.
 */
+ (id) insetRectBottom:(NSArray*)params;

/*!
 Adjusts the given rectangle by applying an inset to the right edge, and
 returns the resulting rectangle as a comma-separated string in the format
 "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 This Mockingbird function accepts two pipe-separated expressions as
 parameters: the *source rectangle* and the *inset amount*.

 The *source rectangle* expression is interpreted as follows:

 * If the expression yields a string, it is expected to be a comma-separated
 string in the format "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 * If the expression yields an `NSValue`, it is expected to contain a `CGRect`
 value.

 The *inset amount* is interpreted as a numeric expression indicating the
 amount by which the edge of the *source rectangle* will be adjusted.

 A negative *inset amount* makes the rectangle larger by moving the right
 edge further rightwards; a positive value makes the rectangle smaller by
 moving the right edge leftwards.

 #### Expression usage

     ^insetRectRight(10,10,50,50|-10)
 
 The expression above would return the string "`10,10,60,50`".

 @param     params The function's input parameters.

 @return    A string containing the adjusted rectangle.
 */
+ (id) insetRectRight:(NSArray*)params;

/*----------------------------------------------------------------------------*/
#pragma mark Accessing the width and height components of sizes
/*!    @name Accessing the width and height components of sizes               */
/*----------------------------------------------------------------------------*/

/*!
 Returns an `NSNumber` containing the width component of the given size.

 This Mockingbird function accepts a single parameter, an object expression
 that's expected to yield an `NSString` or an `NSValue` instance. This 
 expression is interpreted as follows:
 
 * If the expression yields a string, it is expected to be a comma-separated
   string in the format "*`width`*`,`*`height`*".

 * If the expression yields an `NSValue`, it is expected to contain a `CGSize`
   value.
 
 * All other cases are considered errors.

 #### Expression usage
 
     ^sizeWidth(10,20)
 
 The expression above would return the value `10`.

 @param     param The function's input parameter.

 @return    The function result, the width component of the given size.
 */
+ (id) sizeWidth:(id)param;

/*!
 Returns an `NSNumber` containing the height component of the given size.

 This Mockingbird function accepts a single parameter, an object expression
 that's expected to yield an `NSString` or an `NSValue` instance. This 
 expression is interpreted as follows:
 
 * If the expression yields a string, it is expected to be a comma-separated
   string in the format "*`width`*`,`*`height`*".

 * If the expression yields an `NSValue`, it is expected to contain a `CGSize`
   value.
 
 * All other cases are considered errors.

 #### Expression usage
 
     ^sizeHeight(10,20)
 
 The expression above would return the value `20`.

 @param     param The function's input parameter.

 @return    The function result, the height component of the given size.
 */
+ (id) sizeHeight:(id)param;

/*----------------------------------------------------------------------------*/
#pragma mark Accessing the x and y coordinates of points
/*!    @name Accessing the x and y coordinates of points                      */
/*----------------------------------------------------------------------------*/

/*!
 Returns an `NSNumber` containing the *x* coordinate of the given point.

 This Mockingbird function accepts a single parameter, an object expression
 that's expected to yield an `NSString` or an `NSValue` instance. This 
 expression is interpreted as follows:
 
 * If the expression yields a string, it is expected to be a comma-separated
   string in the format "*`x`*`,`*`y`*".

 * If the expression yields an `NSValue`, it is expected to contain a `CGPoint`
   value.
 
 * All other cases are considered errors.

 #### Expression usage

    ^pointX(10,20)

 The expression above would return the value `10`.

 @param     param The function's input parameter.

 @return    The function result, the *x* coordinate of the given point.
 */
+ (id) pointX:(id)param;

/*!
 Returns an `NSNumber` containing the *y* coordinate of the given point.

 This Mockingbird function accepts a single parameter, an object expression
 that's expected to yield an `NSString` or an `NSValue` instance. This 
 expression is interpreted as follows:
 
 * If the expression yields a string, it is expected to be a comma-separated
   string in the format "*`x`*`,`*`y`*".

 * If the expression yields an `NSValue`, it is expected to contain a `CGPoint`
   value.
 
 * All other cases are considered errors.

 #### Expression usage

     ^pointY(10,20)
 
 The expression above would return the value `20`.

 @param     param The function's input parameter.

 @return    The function result, the *y* coordinate of the given point.
 */
+ (id) pointY:(id)param;

@end

#endif
