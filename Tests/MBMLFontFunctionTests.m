//
//  MBMLFontFunctionTests.m
//  Mockingbird Data Environment Unit Tests
//
//  Created by Evan Coyne Maloney on 1/23/15.
//  Copyright (c) 2015 Gilt Groupe. All rights reserved.
//

#import "MBDataEnvironmentTestSuite.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLFontFunctionTests class
/******************************************************************************/

@interface MBMLFontFunctionTests : MBDataEnvironmentTestSuite
@end

@implementation MBMLFontFunctionTests

/*
    <Function class="MBMLFontFunctions" name="fontFamilyNames" input="none"/>
    <Function class="MBMLFontFunctions" name="fontNamesForFamilyName" input="string"/>
    <Function class="MBMLFontFunctions" name="fontWithNameAndSize" input="pipedObjects"/>
    <Function class="MBMLFontFunctions" name="sizeOfTextWithFont" input="pipedObjects"/>
    <Function class="MBMLFontFunctions" name="linesNeededToDrawText" input="pipedExpressions"/>
    <Function class="MBMLFontFunctions" name="stringWidth" input="pipedObjects"/>
 */
- (void) testFontFamilyNames
{
    consoleTrace();

    // although the font families may differ between devices and OS
    // versions, there are a few common ones we can test for
    // although unlikely, we will need to change this list if any
    // of these fonts are removed from a future version of iOS
    NSArray* expectedFonts = @[@"Courier New",
                               @"Times New Roman",
                               @"Georgia",
                               @"Arial",
                               @"Helvetica",
                               @"Courier"];

    NSArray* fontFamilies = [MBExpression asObject:@"^fontFamilyNames()"];
    XCTAssertNotNil(fontFamilies);
    XCTAssertTrue([fontFamilies isKindOfClass:[NSArray class]]);
    XCTAssertTrue(fontFamilies.count >= expectedFonts.count);

    NSSet* familySet = [NSSet setWithArray:fontFamilies];
    for (NSString* name in expectedFonts) {
        XCTAssertTrue([familySet containsObject:name]);
    }
}

- (void) testFontNamesForFamilyName
{
    consoleTrace();

    // it is possible that some of the fonts for Helvetica may
    // change, but since these are already present, I doubt
    // they will be removed
    NSArray* expectedFonts = @[@"Helvetica-Bold",
                               @"Helvetica",
                               @"Helvetica-LightOblique",
                               @"Helvetica-Oblique",
                               @"Helvetica-BoldOblique",
                               @"Helvetica-Light"];

    NSArray* fontNames = [MBExpression asObject:@"^fontNamesForFamilyName(Helvetica)"];
    XCTAssertNotNil(fontNames);
    XCTAssertTrue([fontNames isKindOfClass:[NSArray class]]);
    XCTAssertTrue(fontNames.count >= expectedFonts.count);

    NSSet* fontSet = [NSSet setWithArray:fontNames];
    for (NSString* name in expectedFonts) {
        XCTAssertTrue([fontSet containsObject:name]);
    }
}

- (void) _testFontWithName:(NSString*)fontName pointSize:(CGFloat)pointSize
{
    NSString* expr = [NSString stringWithFormat:@"^fontWithNameAndSize(%@|%g)", fontName, pointSize];
    UIFont* font = [expr evaluateAsObject];

    XCTAssertNotNil(font);
    XCTAssertTrue([font isKindOfClass:[UIFont class]]);
    XCTAssertEqualObjects(font.fontName, fontName);
    XCTAssertEqual(font.pointSize, pointSize);
}

- (void) testFontWithNameAndSize
{
    consoleTrace();

    // make sure we can get UIFont instances for a few common things
    [self _testFontWithName:@"Helvetica" pointSize:14];
    [self _testFontWithName:@"Helvetica-Bold" pointSize:24];
    [self _testFontWithName:@"Helvetica-Light" pointSize:18.5];
}

- (void) _testSizeOfText:(NSString*)text withFont:(NSString*)fontName pointSize:(CGFloat)pointSize expectedSize:(CGSize)expectedSize
{
    NSString* expr = [NSString stringWithFormat:@"^sizeOfTextWithFont(%@|%@|%g)", text, fontName, pointSize];
    NSString* sizeStr = [expr evaluateAsString];
    XCTAssertNotNil(sizeStr);

    CGSize size = [MBStringConversions sizeFromString:sizeStr];
    XCTAssertFalse(CGSizeEqualToSize(size, CGSizeZero));

    // we apply the accuracy tests because font metrics have been known
    // to change slightly between OS versions
    XCTAssertEqualWithAccuracy(size.width, expectedSize.width, expectedSize.width * 0.01);
    XCTAssertEqualWithAccuracy(size.height, expectedSize.height, expectedSize.height * 0.01);

    // test the alternate way of using this method to ensure we're
    // getting the same results
    NSString* altExpr = [NSString stringWithFormat:@"^sizeOfTextWithFont(%@|^fontWithNameAndSize(%@|%g))", text, fontName, pointSize];
    NSString* altSizeStr = [altExpr evaluateAsString];
    XCTAssertEqualObjects(sizeStr, altSizeStr);
}

- (void) testSizeOfTextWithFont
{
    [self _testSizeOfText:@"Size me up" withFont:@"Helvetica" pointSize:14 expectedSize:(CGSize){70.0342, 16.1}];
    [self _testSizeOfText:@"A different test" withFont:@"Helvetica-Bold" pointSize:20 expectedSize:(CGSize){140.391, 23}];
}

- (void) _testLinesNeededToDrawText:(NSString*)text withFont:(NSString*)fontName pointSize:(CGFloat)pointSize width:(CGFloat)width expectedLines:(NSUInteger)expectedLines
{
    NSString* expr = [NSString stringWithFormat:@"^linesNeededToDrawText(%@|%@|%g|%g)", text, fontName, pointSize, width];
    NSNumber* linesNum = [expr evaluateAsNumber];
    XCTAssertNotNil(linesNum);

    XCTAssertEqual((NSUInteger)[linesNum integerValue], expectedLines);

    // test the alternate way of using this method to ensure we're
    // getting the same results
    NSString* altExpr = [NSString stringWithFormat:@"^linesNeededToDrawText(%@|^fontWithNameAndSize(%@|%g)|%g)", text, fontName, pointSize, width];
    NSNumber* altLinesNum = [altExpr evaluateAsNumber];
    XCTAssertEqualObjects(linesNum, altLinesNum);
}

- (void) testLinesNeededToDrawText
{
    consoleTrace();

    [self _testLinesNeededToDrawText:@"This is my argument" withFont:@"Helvetica-Bold" pointSize:18 width:150 expectedLines:2];
    [self _testLinesNeededToDrawText:@"This is my argument\nThis is my argument\nThis is my argument\nThis is my argument" withFont:@"Helvetica-Oblique" pointSize:64 width:500 expectedLines:8];
}

- (void) _testStringWidthForText:(NSString*)text withFont:(NSString*)fontName pointSize:(CGFloat)pointSize expectedWidth:(CGFloat)expectedWidth
{
    NSString* expr = [NSString stringWithFormat:@"^stringWidth(%@|%@|%g)", text, fontName, pointSize];
    NSNumber* widthNum = [expr evaluateAsNumber];
    XCTAssertNotNil(widthNum);

    CGFloat width = [widthNum doubleValue];
    XCTAssertTrue(width > 0);

    // we apply the accuracy tests because font metrics have been known
    // to change slightly between OS versions
    XCTAssertEqualWithAccuracy(width, expectedWidth, expectedWidth * 0.01);

    // test the alternate way of using this method to ensure we're
    // getting the same results
    NSString* altExpr = [NSString stringWithFormat:@"^stringWidth(%@|^fontWithNameAndSize(%@|%g))", text, fontName, pointSize];
    NSNumber* altWidthNum = [altExpr evaluateAsNumber];
    XCTAssertEqualObjects(widthNum, altWidthNum);
}

- (void) testStringWidth
{
    consoleTrace();

    [self _testStringWidthForText:@"What's the deal with airline peanuts?" withFont:@"Helvetica" pointSize:17 expectedWidth:276.349609375];
    [self _testStringWidthForText:@"same as it ever was \n same as it ever was" withFont:@"Helvetica-BoldOblique" pointSize:14 expectedWidth:134.647460938];
}

@end
