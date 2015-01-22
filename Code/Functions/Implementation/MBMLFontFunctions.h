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
 fonts available at runtine.

 These functions are exposed to the Mockingbird environment via
 `<Function ... />` declarations in the <code>MBDataEnvironmentModule.xml</code>
 file.
 
 For more information on MBML functions, see the `MBMLFunction` class.
 */
@interface MBMLFontFunctions : NSObject

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

/*!
 Measures the size of width and height needed to render text in a given font.
 
 This Mockingbird function accepts two pipe-separated expressions as input
 parameters:

 * The *text*, a string expression specifying the text to measure
 
 * The *font*, an object expression that yields a `UIFont` instance
 
 The function returns a string in "*`width`*`,`*`height`*" format containing 
 the size of *text* when rendered in *font*

 Note that fractional pixel values may be returned.
 
 #### Expression usage

 The expression:

    ^sizeOfTextWithFont(This is my text to measure|^fontWithNameAndSize(Helvetica|14))
 
 returns the string "`163.379,16.1`", indicating a width of `163.379` pixels
 and a height of `16.1` pixels.

 Results may differ depending on the device type and operating system version.

 @param     params The function's input parameters.
 
 @return    The size of the text in the given font, as a comma-separated string.
 */
+ (id) sizeOfTextWithFont:(NSArray*)params;

@end
