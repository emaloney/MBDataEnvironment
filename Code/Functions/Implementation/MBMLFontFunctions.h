//
//  MBMLFontFunctions.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 4/30/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************************************/
#pragma mark -
#pragma mark MBMLFontFunctions class
/******************************************************************************/

/*!
 This class implements MBML functions for accessing information about the
 fonts available at runtime.

 These functions are exposed to the Mockingbird environment via
 `<Function ... />` declarations in the <code>MBDataEnvironmentModule.xml</code>
 file.
 
 For more information on MBML functions, see the `MBMLFunction` class.
 */
@interface MBMLFontFunctions : NSObject

/*----------------------------------------------------------------------------*/
#pragma mark Accessing fonts
/*!    @name Accessing fonts                                                  */
/*----------------------------------------------------------------------------*/

/*!
 Returns an array containing the available font family names.
 
 This Mockingbird function takes no parameters.
 
 #### Expression usage
 
 The expression:
 
    ^fontFamilyNames()
 
 returns the names of all font families available on the device on which
 the expression is evaluated.
  
 @return    The names of the available font families.
 */
+ (id) fontFamilyNames;

/*!
 Returns an array containing the available `UIFont` names given a font family
 name.
 
 This Mockingbird function takes a single string expression as input, yielding
 the name of the font family whose font names are sought.
 
 #### Expression usage
 
 The expression:
 
    ^fontNamesForFamilyName(Helvetica)
 
 returns an array containing the following font names:
 
 * Helvetica-LightOblique
 * Helvetica
 * Helvetica-Oblique
 * Helvetica-BoldOblique
 * Helvetica-Bold
 * Helvetica-Light
 
 Results may differ depending on the device type and operating system version.

 @param     familyName The function's input parameter, the font family name.
 
 @return    The names of the fonts available in the given font family.
 */
+ (id) fontNamesForFamilyName:(NSString*)familyName;

/*!
 Returns a `UIFont` instance for the given font name and size.
 
 This Mockingbird function accepts two pipe-separated expressions as input
 parameters:
 
 * The *font name*, a string expression that specifies the name of the font
   requested
 
 * The *font size*, a numeric expression indicating the size of the font to
   return
 
 #### Expression usage
 
 The expression:

    ^fontWithNameAndSize(Helvetica-BoldOblique|14)
 
 returns a `UIFont` instance for the font named "Helvetica-BoldOblique" at
 14-point size.
 
 @param     params The function's input parameters.
 
 @return    The requested `UIFont`, or `nil` if it couldn't be found.
 */
+ (id) fontWithNameAndSize:(NSArray*)params;

/*----------------------------------------------------------------------------*/
#pragma mark Measuring text using a specific font
/*!    @name Measuring text using a specific font                             */
/*----------------------------------------------------------------------------*/

/*!
 Calculates the width of a string given a specific font and size.

 This Mockingbird function accepts two or three pipe-separated expressions as
 input parameters.

 If two parameters are provided, they are interpreted as:

 * The *text*, a string expression specifying the text to measure
 
 * The *font*, an object expression that yields a `UIFont` instance
 
 If three parameters are provided, they are interpreted as:

 * The *text*, a string expression yielding the string whose width is
   to be calculated

 * The *font name*, a string expression providing the name of the font to use
   for calculating the width of *text*

 * The *font size*, a numeric expression providing the size of *font* that will
   be used for calculating the width of *text*

 The function returns an `NSNumber` specifying the width (in points) required
 to display *text* using the given font.

 #### Expression usage

    ^stringWidth(What's the deal with airline peanuts?|^fontWithNameAndSize(Helvetica Neue|23))

 The expression above yields `377.867`. (Exact results may differ depending on the
 device type and operating system version.)

 The expression above is also equivalent to:

    ^stringWidth(What's the deal with airline peanuts?|Helvetica Neue|23)

 @param     params The function's input parameters.

 @return    The width of *text*.
 */
+ (id) stringWidth:(NSArray*)params;

/*!
 Measures the size of width and height needed to render text in a given font.
 
 This Mockingbird function accepts two or three pipe-separated expressions as
 input parameters.
 
 If two parameters are provided, they are interpreted as:

 * The *text*, a string expression specifying the text to measure
 
 * The *font*, an object expression that yields a `UIFont` instance
 
 If three parameters are provided, they are interpreted as:
 
 * The *text*, a string expression specifying the text to measure

 * The *font name*, a string expression providing the name of the font to use
   for calculating the number of lines required to display *text*
 
 * The *font size*, a numeric expression providing the size of *font* that will
   be used for calculating the number of lines required to display *text*

 The function returns a string in "*`width`*`,`*`height`*" format containing
 the size of *text* when rendered in the specified font.

 Note that fractional pixel values may be returned.
 
 #### Expression usage

 The expression:

    ^sizeOfTextWithFont(This is my text to measure|^fontWithNameAndSize(Helvetica|14))
 
 returns the string "`163.379,16.1`", indicating a width of `163.379` pixels
 and a height of `16.1` pixels. (Exact results may differ depending on the
 device type and operating system version.)

 The expression above is also equivalent to:
 
    ^sizeOfTextWithFont(This is my text to measure|Helvetica|14)

 @param     params The function's input parameters.
 
 @return    The size of the text in the given font, as a comma-separated string.
 */
+ (id) sizeOfTextWithFont:(NSArray*)params;

/*!
 Calculates the number of text lines required to fully display a string
 constrained to a specific width.
 
 This Mockingbird function accepts three or four pipe-separated expressions as
 input parameters.

 If three parameters are provided, they are interpreted as:

 * The *text*, a string expression specifying the text to measure
 
 * The *font*, an object expression that yields a `UIFont` instance
 
 * The *width* within which *text* must fit, a numeric expression

 If four parameters are provided, they are interpreted as:
 
 * The *text*, a string expression specifying the text to measure

 * The *font name*, a string expression providing the name of the font to use
   for calculating the number of lines required to display *text*
 
 * The *font size*, a numeric expression providing the size of *font name* that
   will be used for calculating the number of lines required to display *text*

 * The *width* within which *text* must fit, a numeric expression

 The function returns an `NSNumber` specifying the number of text lines
 to fully display *text*.

 #### Expression usage

    ^linesNeededToDrawText(This is my argument|^fontWithNameAndSize(Helvetica-Bold|18)|150)

 The expression above yields an `NSNumber` containing the value `2`, indicating
 that two lines are needed to draw the text "`This is my argument`" with a
 width of 150 points using 18-point Helvetica-Bold.

 The expression above is also equivalent to:
 
    ^linesNeededToDrawText(This is my argument|Helvetica-Bold|18|150)

 @param     params The function's input parameters.

 @return    The number of lines needed to draw the text.
 */
+ (id) linesNeededToDrawText:(NSArray*)params;

@end
