//
//  MBMLGeometryFunctions.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 7/6/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

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
 Returns the origin point of a rectangle. 
 
 This Mockingbird function accepts a single parameter, a comma-separated string 
 specifying the rectangle in the format:
 "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 The return value contains the rectangle's origin as a comma-separated string 
 in the format: "*`origin-x`*`,`*`origin-y`*"

 #### Expression usage
 
     ^rectOrigin(10,20,80,90)
 
 The expression above would return the string "`10,20`".
 
 @param     rect The function's input parameter, a rectangle expressed as
            a comma-separated string.

 @return    The function result, the origin point of the rectangle expressed
            as a comma-separated string.
 */
+ (id) rectOrigin:(NSString*)rect;

/*!
 Returns the size of a rectangle. 
 
 This Mockingbird function accepts a single parameter, a comma-separated string
 specifying the rectangle in the format:
 "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 The return value contains the rectangle's size as a comma-separated string
 in the format: "*`width`*`,`*`height`*".

 #### Expression usage
 
     ^rectSize(10,20,80,90)
 
 The expression above would return the string "`80,90`".
 
 @param     rect The function's input parameter, a rectangle expressed as
            a comma-separated string.

 @return    The function result, the size of the rectangle expressed
            as a comma-separated string.
 */
+ (id) rectSize:(NSString*)rect;

/*!
 Returns the X coordinate of a rectangle's origin. 
 
 This Mockingbird function accepts a single parameter, a comma-separated string
 specifying the rectangle in the format:
 "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 The return value is an `NSNumber` containing the rectangle's origin X
 coordinate.

 #### Expression usage
 
     ^rectX(10,20,80,90)
 
 The expression above would return the value `10`.

 @param     rect The function's input parameter, a rectangle expressed as
            a comma-separated string.

 @return    The function result, the origin X coordinate of the rectangle.
 */
+ (id) rectX:(NSString*)rect;

/*!
 Returns the Y coordinate of a rectangle's origin.
 
 This Mockingbird function accepts a single parameter, a comma-separated string
 specifying the rectangle in the format:
 "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 The return value is an `NSNumber` containing the rectangle's origin Y
 coordinate.
 
 #### Expression usage
 
     ^rectY(10,20,80,90)
 
 The expression above would return the value `20`.

 @param     rect The function's input parameter, a rectangle expressed as
            a comma-separated string.

 @return    The function result, the origin Y coordinate of the rectangle.
 */
+ (id) rectY:(NSString*)rect;

/*!
 Returns the rectangle's width. 
 
 This Mockingbird function accepts a single parameter, a comma-separated string
 specifying the rectangle in the format:
 "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 The return value is an `NSNumber` containing the rectangle's width.

 #### Expression usage
 
     ^rectWidth(10,20,80,90)
 
 The expression above would return the value `80`.

 @param     rect The function's input parameter, a rectangle expressed as
            a comma-separated string.

 @return    The function result, the width of the rectangle.
 */
+ (id) rectWidth:(NSString*)rect;

/*!
 Returns the rectangle's width. 
 
 This Mockingbird function accepts a single parameter, a comma-separated string
 specifying the rectangle in the format:
 "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 The return value is an `NSNumber` containing the rectangle's height.

 #### Expression usage
 
     ^rectHeight(10,20,80,90)
 
 The expression above would return the value `90`.

 @param     rect The function's input parameter, a rectangle expressed as
            a comma-separated string.

 @return    The function result, the height of the rectangle.
 */
+ (id) rectHeight:(NSString*)rect;

/*----------------------------------------------------------------------------*/
#pragma mark Adjusting rectangles
/*!    @name Adjusting rectangles                                             */
/*----------------------------------------------------------------------------*/

/*!
 Adjusts a rectangle by applying insets to each edge. 
 
 This Mockingbird function accepts two pipe-separated parameters:
 
 * The *rectangle* to be adjusted, a string expression yielding a 
   comma-separated string specifying the rectangle in the format:
   "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 * The *edge insets* to apply to *rectangle*. Edge insets are expressed as a
   string expression yielding a comma-separated in the format:
   "*`topInset`*`,`*`leftInset`*`,`*`bottomInset`*`,`*`rightInset`*".

 Positive inset values adjust the rectangle by making it smaller at the specified
 edge, whereas negative inset values make the rectangle larger.
 
 The return value is a comma-separated string specifying the adjusted rectangle.
 
 #### Expression usage
 
     ^insetRect(10,10,100,100|-5,-5,15,15)
 
 The expression above would return the string "`5,5,90,90`".
 
 @param     params The function's input parameters.

 @return    A string containing the adjusted rectangle.
 */
+ (id) insetRect:(NSArray*)params;

/*!
 Adjusts a rectangle by applying an inset to the top edge. 
 
 This Mockingbird function accepts two pipe-separated parameters:
 
 * The *rectangle* to be adjusted, a string expression yielding a 
   comma-separated string specifying the rectangle in the format:
   "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 * The *inset amount*, a numeric expression indicating the amount by which
   the edge of *rectangle* will be adjusted.

 A negative *inset amount* makes the rectangle taller by moving the top edge
 upwards; a positive value makes the rectangle shorter by lowering the top edge.
 
 The return value is a comma-separated string specifying the adjusted rectangle.

 #### Expression usage
 
     ^insetRectTop(10,10,100,100|-5)
 
 The expression above would return the string "`10,5,100,105`".
 
 @param     params The function's input parameters.

 @return    A string containing the adjusted rectangle.
 */
+ (id) insetRectTop:(NSArray*)params;

/*!
 Adjusts a rectangle by applying an inset to the left edge. 

 This Mockingbird function accepts two pipe-separated parameters:
 
 * The *rectangle* to be adjusted, a string expression yielding a 
   comma-separated string specifying the rectangle in the format:
   "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 * The *inset amount*, a numeric expression indicating the amount by which
   the edge of *rectangle* will be adjusted.

 A negative *inset amount* makes the rectangle wider by moving the left edge 
 further leftwards; a positive value makes the rectangle narrower by moving the
 left edge rightwards.
 
 The return value is a comma-separated string specifying the adjusted rectangle.

 #### Expression usage
 
     ^insetRectLeft(50,50,50,50|25)
 
 The expression above would return the string "`75,50,25,50`".

 @param     params The function's input parameters.

 @return    A string containing the adjusted rectangle.
 */
+ (id) insetRectLeft:(NSArray*)params;

/*!
 Adjusts a rectangle by applying an inset to the bottom edge.
 
 This Mockingbird function accepts two pipe-separated parameters:
 
 * The *rectangle* to be adjusted, a string expression yielding a 
   comma-separated string specifying the rectangle in the format:
   "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 * The *inset amount*, a numeric expression indicating the amount by which
   the edge of *rectangle* will be adjusted.

 A negative *inset amount* makes the rectangle taller by moving the bottom
 edge downwards; a positive value makes the rectangle shorter by raising the
 bottom edge.
 
 The return value is a comma-separated string specifying the adjusted rectangle.

 #### Expression usage
 
     ^insetRectBottom(20,20,100,100|25)
 
 The expression above would return the string "`20,20,100,75`".

 @param     params The function's input parameters.

 @return    A string containing the adjusted rectangle.
 */
+ (id) insetRectBottom:(NSArray*)params;

/*!
 Adjusts a rectangle by applying an inset to the right edge. 
 
 This Mockingbird function accepts two pipe-separated parameters:
 
 * The *rectangle* to be adjusted, a string expression yielding a 
   comma-separated string specifying the rectangle in the format:
   "*`origin-x`*`,`*`origin-y`*`,`*`width`*`,`*`height`*".

 * The *inset amount*, a numeric expression indicating the amount by which
   the edge of *rectangle* will be adjusted.

 A negative *inset amount* makes the rectangle larger by moving the right
 edge further rightwards; a positive value makes the rectangle smaller by
 moving the right edge leftwards.
 
 The return value is a comma-separated string specifying the adjusted rectangle.

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
 Returns the width component of a size. 

 This Mockingbird function accepts a single parameter, the *size expression*
 yielding a comma-separated string specifying the size in the format:
 "*`width`*`,`*`height`*".

 The return value is an `NSNumber` instance containing the width component
 of the *size expression*.
 
 #### Expression usage
 
     ^sizeWidth(10,20)
 
 The expression above would return the value `10`.

 @param     size The *size expression*.

 @return    The width component of *size expression*.
 */
+ (id) sizeWidth:(NSString*)size;

/*!
 Returns the height component of a size.

 This Mockingbird function accepts a single parameter, the *size expression*
 yielding a comma-separated string specifying the size in the format:
 "*`width`*`,`*`height`*".

 The return value is an `NSNumber` instance containing the height component
 of the *size expression*.
 
 #### Expression usage
 
     ^sizeWidth(10,20)
 
 The expression above would return the value `20`.

 @param     size The *size expression*.

 @return    The height component of *size expression*.
 */
+ (id) sizeHeight:(NSString*)size;

/*----------------------------------------------------------------------------*/
#pragma mark Accessing the x and y coordinates of points
/*!    @name Accessing the x and y coordinates of points                      */
/*----------------------------------------------------------------------------*/

/******************************************************************************/
#pragma mark Working with points
/******************************************************************************/

/*!
 Returns the X coordinate of a point. 
 
 This Mockingbird function accepts a single parameter, the *point expression*
 yielding a comma-separated string specifying the point in the format:
 "*`x`*`,`*`y`*".

 The return value is an `NSNumber` instance containing the X coordinate
 of the *point expression*.

 #### Expression usage
 
     ^pointX(10,20)
 
 The expression above would return the value `10`.

 @param     point The *point expression*.

 @return    The X coordinate of *point expression*.
 */
+ (id) pointX:(NSString*)point;

/*!
 Returns the Y coordinate of a point. 
 
 This Mockingbird function accepts a single parameter, the *point expression*
 yielding a comma-separated string specifying the point in the format:
 "*`x`*`,`*`y`*".

 The return value is an `NSNumber` instance containing the Y coordinate
 of the *point expression*.

 #### Expression usage
 
     ^pointY(10,20)
 
 The expression above would return the value `20`.

 @param     point The *point expression*.

 @return    The Y coordinate of *point expression*.
 */
+ (id) pointY:(NSString*)point;

@end
