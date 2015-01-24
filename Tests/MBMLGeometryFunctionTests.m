//
//  MBMLGeometryFunctionTests.m
//  Mockingbird Data Environment Unit Tests
//
//  Created by Evan Coyne Maloney on 1/23/15.
//  Copyright (c) 2015 Gilt Groupe. All rights reserved.
//

#import "MockingbirdTestSuite.h"



/******************************************************************************/
#pragma mark -
#pragma mark MBMLGeometryFunctionTests class
/******************************************************************************/

@interface MBMLGeometryFunctionTests : MockingbirdTestSuite
@end

@implementation MBMLGeometryFunctionTests

/*
    <Function class="MBMLGeometryFunctions" name="rectOrigin" input="object"/>
    <Function class="MBMLGeometryFunctions" name="rectSize" input="object"/>
    <Function class="MBMLGeometryFunctions" name="rectX" input="object"/>
    <Function class="MBMLGeometryFunctions" name="rectY" input="object"/>
    <Function class="MBMLGeometryFunctions" name="rectWidth" input="object"/>
    <Function class="MBMLGeometryFunctions" name="rectHeight" input="object"/>
    <Function class="MBMLGeometryFunctions" name="insetRect" input="pipedObjects"/>
    <Function class="MBMLGeometryFunctions" name="insetRectTop" input="pipedObjects"/>
    <Function class="MBMLGeometryFunctions" name="insetRectLeft" input="pipedObjects"/>
    <Function class="MBMLGeometryFunctions" name="insetRectBottom" input="pipedObjects"/>
    <Function class="MBMLGeometryFunctions" name="insetRectRight" input="pipedObjects"/>
    <Function class="MBMLGeometryFunctions" name="sizeWidth" input="object"/>
    <Function class="MBMLGeometryFunctions" name="sizeHeight" input="object"/>
    <Function class="MBMLGeometryFunctions" name="pointX" input="object"/>
    <Function class="MBMLGeometryFunctions" name="pointY" input="object"/>
 */

- (void) testRectOrigin
{
    consoleTrace();

    NSString* originStr = [MBExpression asString:@"^rectOrigin($rect)"];
    XCTAssertEqualObjects(originStr, [MBExpression asString:@"$rect:origin"]);

    NSString* altOriginStr = [MBExpression asString:@"^rectOrigin($rect:val)"];
    XCTAssertEqualObjects(originStr, altOriginStr);

    CGPoint origin = [MBStringConversions pointFromString:originStr];
    XCTAssertTrue(CGPointEqualToPoint(origin, (CGPoint){10, 50}));
}

- (void) testRectSize
{
    consoleTrace();

    NSString* sizeStr = [MBExpression asString:@"^rectSize($rect)"];
    XCTAssertEqualObjects(sizeStr, [MBExpression asString:@"$rect:size"]);

    NSString* altSizeStr = [MBExpression asString:@"^rectSize($rect:val)"];
    XCTAssertEqualObjects(sizeStr, altSizeStr);

    CGSize size = [MBStringConversions sizeFromString:sizeStr];
    XCTAssertTrue(CGSizeEqualToSize(size, (CGSize){300, 200}));
}

- (void) testRectX
{
    consoleTrace();

    NSNumber* xNum = [MBExpression asNumber:@"^rectX($rect)"];
    XCTAssertEqualObjects(xNum, [MBExpression asNumber:@"$rect:origin:x"]);

    NSNumber* xNumAlt = [MBExpression asNumber:@"^rectX($rect:val)"];
    XCTAssertEqualObjects(xNum, xNumAlt);

    XCTAssertEqual([xNum doubleValue], 10);
}

- (void) testRectY
{
    consoleTrace();

    NSNumber* yNum = [MBExpression asNumber:@"^rectY($rect)"];
    XCTAssertEqualObjects(yNum, [MBExpression asNumber:@"$rect:origin:y"]);

    NSNumber* yNumAlt = [MBExpression asNumber:@"^rectY($rect:val)"];
    XCTAssertEqualObjects(yNum, yNumAlt);

    XCTAssertEqual([yNum doubleValue], 50);
}

- (void) testRectWidth
{
    consoleTrace();

    NSNumber* widthNum = [MBExpression asNumber:@"^rectWidth($rect)"];
    XCTAssertEqualObjects(widthNum, [MBExpression asNumber:@"$rect:size:width"]);

    NSNumber* altWidthNum = [MBExpression asNumber:@"^rectWidth($rect:val)"];
    XCTAssertEqualObjects(widthNum, altWidthNum);

    XCTAssertEqual([widthNum doubleValue], 300);
}

- (void) testRectHeight
{
    consoleTrace();

    NSNumber* heightNum = [MBExpression asNumber:@"^rectHeight($rect)"];
    XCTAssertEqualObjects(heightNum, [MBExpression asNumber:@"$rect:size:height"]);

    NSNumber* altHeightNum = [MBExpression asNumber:@"^rectHeight($rect:val)"];
    XCTAssertEqualObjects(heightNum, altHeightNum);

    XCTAssertEqual([heightNum doubleValue], 200);
}

- (void) testInsetRect
{
    consoleTrace();

    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];

    NSString* edgeInsetStr = @"-5,-5,15,15";
    [scope setScopedVariable:@"edgeInsets" value:edgeInsetStr];

    UIEdgeInsets edgeInsets = [MBStringConversions edgeInsetsFromString:edgeInsetStr];
    [scope setScopedVariable:@"edgeInsets:val" value:[NSValue valueWithUIEdgeInsets:edgeInsets]];

    CGRect srcRect = [MBStringConversions rectFromExpression:@"$rect:val"];
    UIEdgeInsets insets = [MBStringConversions edgeInsetsFromExpression:@"$edgeInsets:val"];

    CGRect goodInsetRect = UIEdgeInsetsInsetRect(srcRect, insets);
    XCTAssertTrue(CGRectEqualToRect(goodInsetRect, CGRectMake(5, 45, 290, 190)));

    CGRect insetRect1 = [MBStringConversions rectFromExpression:@"^insetRect($rect|$edgeInsets)"];
    XCTAssertTrue(CGRectEqualToRect(insetRect1, goodInsetRect));

    CGRect insetRect2 = [MBStringConversions rectFromExpression:@"^insetRect($rect:val|$edgeInsets)"];
    XCTAssertTrue(CGRectEqualToRect(insetRect2, goodInsetRect));

    CGRect insetRect3 = [MBStringConversions rectFromExpression:@"^insetRect($rect|$edgeInsets:val)"];
    XCTAssertTrue(CGRectEqualToRect(insetRect3, goodInsetRect));

    CGRect insetRect4 = [MBStringConversions rectFromExpression:@"^insetRect($rect:val|$edgeInsets:val)"];
    XCTAssertTrue(CGRectEqualToRect(insetRect4, goodInsetRect));

    [MBScopedVariables exitVariableScope];
}

- (void) testInsetRectTop
{
    consoleTrace();

    CGRect srcRect = [MBStringConversions rectFromExpression:@"$rect:val"];
    UIEdgeInsets insets = UIEdgeInsetsMake(-5, 0, 0, 0);

    CGRect goodInsetRect = UIEdgeInsetsInsetRect(srcRect, insets);
    XCTAssertTrue(CGRectEqualToRect(goodInsetRect, CGRectMake(10, 45, 300, 205)));

    CGRect insetRect1 = [MBStringConversions rectFromExpression:@"^insetRectTop($rect|-5)"];
    XCTAssertTrue(CGRectEqualToRect(insetRect1, goodInsetRect));

    CGRect insetRect2 = [MBStringConversions rectFromExpression:@"^insetRectTop($rect:val|-5)"];
    XCTAssertTrue(CGRectEqualToRect(insetRect2, goodInsetRect));
}

- (void) testInsetRectLeft
{
    consoleTrace();

    CGRect srcRect = [MBStringConversions rectFromExpression:@"$rect:val"];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 5, 0, 0);

    CGRect goodInsetRect = UIEdgeInsetsInsetRect(srcRect, insets);
    XCTAssertTrue(CGRectEqualToRect(goodInsetRect, CGRectMake(15, 50, 295, 200)));

    CGRect insetRect1 = [MBStringConversions rectFromExpression:@"^insetRectLeft($rect|5)"];
    XCTAssertTrue(CGRectEqualToRect(insetRect1, goodInsetRect));

    CGRect insetRect2 = [MBStringConversions rectFromExpression:@"^insetRectLeft($rect:val|5)"];
    XCTAssertTrue(CGRectEqualToRect(insetRect2, goodInsetRect));
}

- (void) testInsetRectBottom
{
    consoleTrace();

    CGRect srcRect = [MBStringConversions rectFromExpression:@"$rect:val"];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, -10, 0);
    
    CGRect goodInsetRect = UIEdgeInsetsInsetRect(srcRect, insets);
    XCTAssertTrue(CGRectEqualToRect(goodInsetRect, CGRectMake(10, 50, 300, 210)));

    CGRect insetRect1 = [MBStringConversions rectFromExpression:@"^insetRectBottom($rect|-10)"];
    XCTAssertTrue(CGRectEqualToRect(insetRect1, goodInsetRect));

    CGRect insetRect2 = [MBStringConversions rectFromExpression:@"^insetRectBottom($rect:val|-10)"];
    XCTAssertTrue(CGRectEqualToRect(insetRect2, goodInsetRect));
}

- (void) testInsetRectRight
{
    consoleTrace();

    CGRect srcRect = [MBStringConversions rectFromExpression:@"$rect:val"];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 15);
    
    CGRect goodInsetRect = UIEdgeInsetsInsetRect(srcRect, insets);
    XCTAssertTrue(CGRectEqualToRect(goodInsetRect, CGRectMake(10, 50, 285, 200)));

    CGRect insetRect1 = [MBStringConversions rectFromExpression:@"^insetRectRight($rect|15)"];
    XCTAssertTrue(CGRectEqualToRect(insetRect1, goodInsetRect));

    CGRect insetRect2 = [MBStringConversions rectFromExpression:@"^insetRectRight($rect:val|15)"];
    XCTAssertTrue(CGRectEqualToRect(insetRect2, goodInsetRect));
}

- (void) testSizeWidth
{
    consoleTrace();

    NSNumber* widthNum = [MBExpression asNumber:@"$rect:size:width"];
    XCTAssertNotNil(widthNum);
    XCTAssertEqual([widthNum doubleValue], 300);

    NSNumber* sizeWidthNum = [MBExpression asNumber:@"^sizeWidth($rect:size)"];
    XCTAssertNotNil(sizeWidthNum);
    XCTAssertEqualObjects(widthNum, sizeWidthNum);

    NSNumber* altSizeWidthNum = [MBExpression asNumber:@"^sizeWidth($rect:size:val)"];
    XCTAssertNotNil(altSizeWidthNum);
    XCTAssertEqualObjects(widthNum, altSizeWidthNum);
}

- (void) testSizeHeight
{
    consoleTrace();

    NSNumber* heightNum = [MBExpression asNumber:@"$rect:size:height"];
    XCTAssertNotNil(heightNum);
    XCTAssertEqual([heightNum doubleValue], 200);

    NSNumber* sizeHeightNum = [MBExpression asNumber:@"^sizeHeight($rect:size)"];
    XCTAssertNotNil(sizeHeightNum);
    XCTAssertEqualObjects(heightNum, sizeHeightNum);

    NSNumber* altSizeHeightNum = [MBExpression asNumber:@"^sizeHeight($rect:size:val)"];
    XCTAssertNotNil(altSizeHeightNum);
    XCTAssertEqualObjects(heightNum, altSizeHeightNum);
}

- (void) testPointX
{
    consoleTrace();

    NSNumber* xNum = [MBExpression asNumber:@"$rect:origin:x"];
    XCTAssertNotNil(xNum);
    XCTAssertEqual([xNum doubleValue], 10);

    NSNumber* xOriginNum = [MBExpression asNumber:@"^pointX($rect:origin)"];
    XCTAssertNotNil(xOriginNum);
    XCTAssertEqualObjects(xNum, xOriginNum);

    NSNumber* xOriginNumAlt = [MBExpression asNumber:@"^pointX($rect:origin:val)"];
    XCTAssertNotNil(xOriginNumAlt);
    XCTAssertEqualObjects(xNum, xOriginNumAlt);
}

- (void) testPointY
{
    consoleTrace();

    NSNumber* yNum = [MBExpression asNumber:@"$rect:origin:y"];
    XCTAssertNotNil(yNum);
    XCTAssertEqual([yNum doubleValue], 50);

    NSNumber* yOriginNum = [MBExpression asNumber:@"^pointY($rect:origin)"];
    XCTAssertNotNil(yOriginNum);
    XCTAssertEqualObjects(yNum, yOriginNum);

    NSNumber* yOriginNumAlt = [MBExpression asNumber:@"^pointY($rect:origin:val)"];
    XCTAssertNotNil(yOriginNumAlt);
    XCTAssertEqualObjects(yNum, yOriginNumAlt);
}

@end
