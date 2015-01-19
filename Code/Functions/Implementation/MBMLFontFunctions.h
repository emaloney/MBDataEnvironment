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
 A class containing implementations for MBML functions that return information
 about the fonts available at runtine.
 
 See `MBMLFunction` for more information on MBML functions and how they're used.
*/
@interface MBMLFontFunctions : NSObject

/*!
 An MBML function implementation that returns an array of the available
 `UIFont` family names.
 
 This function takes no parameters.
 
 #### Expression usage
 
 The expression:
 
    ^fontFamilyNames()
 
 would return the names of all font families available on the device on which
 the expression is evaluated.
  
 @return    The names of the available font families.
 */
+ (id) fontFamilyNames;

/*!
 An MBML function implementation that returns an array of the available
 `UIFont` family names.
 
 This function takes a single expression as input, the name of the
 font family whose font names are sought.
 
 #### Expression usage
 
 On a first-generation iPad, the expression:
 
    ^fontNamesForFamilyName(Helvetica)
 
 would return an array containing the following font names:
 
 - Helvetica-LightOblique
 - Helvetica
 - Helvetica-Oblique
 - Helvetica-BoldOblique
 - Helvetica-Bold
 - Helvetica-Light
 
 @param     input The function's input parameter.
 
 @return    The names of the fonts available in the given font family.
 */
+ (id) fontNamesForFamilyName:(NSString*)input;

/*!
 An MBML function implementation that returns a `UIFont` instance for the
 given font name and size.
 
 This function takes a two parameters as input:
 
 * The *font name*, a string expression that specifies the name of the font
 requested
 
 * The *font size*, a numeric expression indicating the size of the font to
 return
 
 #### Expression usage
 
    ^fontWithNameAndSize(Helvetica|14)
 
 would return a `UIFont` instance for the font named "Helvetica" at 14-point
 size.
 
 @param     params The function's input parameters.
 
 @return    The requested `UIFont`.
 */
+ (id) fontWithNameAndSize:(NSArray*)params;

/*!
 An MBML function implementation that measures the size of text in a given font.
 
 This function takes a two parameters as input:
 
 * The *text*, a string expression specifying the text to measure
 
 * The *font*, an object expression that yields a `UIFont` instance
 
 The function returns a string containing the size of the specified text in
 "*width*,*height*" format.
 
 #### Expression usage
 
    ^sizeOfTextWithFont(This is my text to measure|^fontWithNameAndSize(Helvetica|14))
 
 would return a `UIFont` instance for the font named "Helvetica" at 14-point
 size.
 
 @param     params The function's input parameters.
 
 @return    The requested `UIFont`.
 */
+ (id) sizeOfTextWithFont:(NSArray*)params;

@end
