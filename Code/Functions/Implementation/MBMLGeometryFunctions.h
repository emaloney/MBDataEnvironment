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

@interface MBMLGeometryFunctions : NSObject

/******************************************************************************/
#pragma mark Working with rectangles
/******************************************************************************/

/*!
 Returns the origin point of a rectangle. 
 
 This function accepts a single parameter, a comma-separated string 
 specifying the rectangle in the format:
 
 <code><i>origin-x</i>,<i>origin-y</i>,<i>width</i>,<i>height</i></code>
 
 The return value contains the rectangle's origin as a comma-separated string 
 in the format:
 
 <code><i>origin-x</i>,<i>origin-y</i></code>

 <b>Template example:</b>
 
 <pre>^rectOrigin(10,20,80,90)</pre>
 
 The expression above would return the string "<code>10,20</code>".
 */
+ (id) rectOrigin:(NSString*)param;

/*!
 Returns the size of a rectangle. 
 
 This function accepts a single parameter, a comma-separated string 
 specifying the rectangle in the format:
 
 <code><i>origin-x</i>,<i>origin-y</i>,<i>width</i>,<i>height</i></code>
 
 The return value contains the rectangle's size as a comma-separated string 
 in the format:
 
 <code><i>width</i>,<i>height</i></code>
 
 <b>Template example:</b>
 
 <pre>^rectSize(10,20,80,90)</pre>
 
 The expression above would return the string "<code>80,90</code>".
 */
+ (id) rectSize:(NSString*)param;

/*!
 Returns the X coordinate of a rectangle's origin. 
 
 This function accepts a single parameter, a comma-separated string 
 specifying the rectangle in the format:
 
 <code><i>origin-x</i>,<i>origin-y</i>,<i>width</i>,<i>height</i></code>
 
 The return value is a number containing the value of the rectangle's origin
 X coordinate.
 
 <b>Template example:</b>
 
 <pre>^rectX(10,20,80,90)</pre>
 
 The expression above would return the string "<code>10</code>".
 */
+ (id) rectX:(NSString*)param;

/*!
 Returns the Y coordinate of a rectangle's origin. 
 
 This function accepts a single parameter, a comma-separated string 
 specifying the rectangle in the format:
 
 <code><i>origin-x</i>,<i>origin-y</i>,<i>width</i>,<i>height</i></code>
 
 The return value is a number containing the value of the rectangle's origin
 Y coordinate.
 
 <b>Template example:</b>
 
 <pre>^rectY(10,20,80,90)</pre>
 
 The expression above would return the string "<code>20</code>".
 */
+ (id) rectY:(NSString*)param;

/*!
 Returns the rectangle's width. 
 
 This function accepts a single parameter, a comma-separated string 
 specifying the rectangle in the format:
 
 <code><i>origin-x</i>,<i>origin-y</i>,<i>width</i>,<i>height</i></code>
 
 The return value is a number containing the value of the rectangle's width.
 
 <b>Template example:</b>
 
 <pre>^rectWidth(10,20,80,90)</pre>
 
 The expression above would return the string "<code>80</code>".
 */
+ (id) rectWidth:(NSString*)param;

/*!
 Returns the rectangle's height. 
 
 This function accepts a single parameter, a comma-separated string 
 specifying the rectangle in the format:
 
 <code><i>origin-x</i>,<i>origin-y</i>,<i>width</i>,<i>height</i></code>
 
 The return value is a number containing the value of the rectangle's height.
 
 <b>Template example:</b>
 
 <pre>^rectHeight(10,20,80,90)</pre>
 
 The expression above would return the string "<code>90</code>".
 */
+ (id) rectHeight:(NSString*)param;

/*!
 Adjusts a rectangle by applying insets to each edge. 
 
 This function accepts two pipe-separated parameters. The first parameter
 is a comma-separated string specifying the rectangle to be modified, in the
 format:
 
 <code><i>origin-x</i>,<i>origin-y</i>,<i>width</i>,<i>height</i></code>
 
 The second parameter is a comma-separated string specifying the insets to apply
 to the rectangle, in the format:
 
 <code><i>topInset</i>,<i>leftInset</i>,<i>bottomInset</i>,<i>rightInset</i></code>
 
 Positive inset values adjust the rectangle by making it smaller at the specified
 edge, whereas negative inset values make the rectangle larger.
 
 The return value is a string containing the new rectangle, in comma-separated
 coordinate format.
 
 <b>Template example:</b>
 
 <pre>^insetRect(10,10,100,100|-5,-5,15,15)</pre>
 
 The expression above would return the string "<code>5,5,90,90</code>".
 */
+ (id) insetRect:(NSArray*)params;

/*!
 Adjusts a rectangle by applying an inset to the top edge. 
 
 This function accepts two pipe-separated parameters. The first parameter
 is a comma-separated string specifying the rectangle to be modified, in the
 format:
 
 <code><i>origin-x</i>,<i>origin-y</i>,<i>width</i>,<i>height</i></code>
 
 The second parameter is the inset amount. A negative value makes the rectangle
 taller by moving the top edge upwards; a positive value makes the rectangle
 shorter by lowering the top edge.
 
 The return value is a string containing the new rectangle, in comma-separated
 coordinate format.
 
 <b>Template example:</b>
 
 <pre>^insetRectTop(10,10,100,100|-5)</pre>
 
 The expression above would return the string "<code>10,5,100,105</code>".
 */
+ (id) insetRectTop:(NSArray*)params;

/*!
 Adjusts a rectangle by applying an inset to the left edge. 
 
 This function accepts two pipe-separated parameters. The first parameter
 is a comma-separated string specifying the rectangle to be modified, in the
 format:
 
 <code><i>origin-x</i>,<i>origin-y</i>,<i>width</i>,<i>height</i></code>
 
 The second parameter is the inset amount. A negative value makes the rectangle
 wider by moving the left edge further leftwards; a positive value makes the
 rectangle narrower by moving the left edge rightwards.
 
 The return value is a string containing the new rectangle, in comma-separated
 coordinate format.
 
 <b>Template example:</b>
 
 <pre>^insetRectLeft(50,50,50,50|25)</pre>
 
 The expression above would return the string "<code>75,50,25,50</code>".
 */
+ (id) insetRectLeft:(NSArray*)params;

/*!
 Adjusts a rectangle by applying an inset to the top edge. 
 
 This function accepts two pipe-separated parameters. The first parameter
 is a comma-separated string specifying the rectangle to be modified, in the
 format:
 
 <code><i>origin-x</i>,<i>origin-y</i>,<i>width</i>,<i>height</i></code>
 
 The second parameter is the inset amount. A negative value makes the rectangle
 taller by moving the bottom edge downwards; a positive value makes the rectangle
 shorter by raising the bottom edge.
 
 The return value is a string containing the new rectangle, in comma-separated
 coordinate format.
 
 <b>Template example:</b>
 
 <pre>^insetRectBottom(20,20,100,100|25)</pre>
 
 The expression above would return the string "<code>20,20,100,75</code>".
 */
+ (id) insetRectBottom:(NSArray*)params;

/*!
 Adjusts a rectangle by applying an inset to the right edge. 
 
 This function accepts two pipe-separated parameters. The first parameter
 is a comma-separated string specifying the rectangle to be modified, in the
 format:
 
 <code><i>origin-x</i>,<i>origin-y</i>,<i>width</i>,<i>height</i></code>
 
 The second parameter is the inset amount. A negative value makes the rectangle
 larger by moving the right edge further rightwards; a positive value makes the
 rectangle smaller by moving the right edge leftwards.
 
 The return value is a string containing the new rectangle, in comma-separated
 coordinate format.
 
 <b>Template example:</b>
 
 <pre>^insetRectRight(10,10,50,50|-10)</pre>
 
 The expression above would return the string "<code>10,10,60,50</code>".
 */
+ (id) insetRectRight:(NSArray*)params;

/******************************************************************************/
#pragma mark Working with sizes
/******************************************************************************/

/*!
 Returns the width component of a size. 
 
 This function accepts a single parameter, a comma-separated string 
 specifying the size in the format:
 
 <code><i>width</i>,<i>height</i></code>
 
 The return value is a number containing the width.
 
 <b>Template example:</b>
 
 <pre>^sizeWidth(10,20)</pre>
 
 The expression above would return the string "<code>10</code>".
 */
+ (id) sizeWidth:(NSString*)param;

/*!
 Returns the height component of a size. 
 
 This function accepts a single parameter, a comma-separated string 
 specifying the size in the format:
 
 <code><i>width</i>,<i>height</i></code>
 
 The return value is a number containing the height.
 
 <b>Template example:</b>
 
 <pre>^sizeHeight(10,20)</pre>
 
 The expression above would return the string "<code>20</code>".
 */
+ (id) sizeHeight:(NSString*)param;

/******************************************************************************/
#pragma mark Working with points
/******************************************************************************/

/*!
 Returns the X coordinate of a point. 
 
 This function accepts a single parameter, a comma-separated string 
 specifying the point in the format:
 
 <code><i>x</i>,<i>y</i></code>
 
 The return value is a number containing the X coordinate.
 
 <b>Template example:</b>
 
 <pre>^pointX(10,20)</pre>
 
 The expression above would return the string "<code>10</code>".
 */
+ (id) pointX:(NSString*)param;

/*!
 Returns the Y coordinate of a point. 
 
 This function accepts a single parameter, a comma-separated string 
 specifying the point in the format:
 
 <code><i>x</i>,<i>y</i></code>
 
 The return value is a number containing the Y coordinate.
 
 <b>Template example:</b>
 
 <pre>^pointY(10,20)</pre>
 
 The expression above would return the string "<code>20</code>".
 */
+ (id) pointY:(NSString*)param;

@end
