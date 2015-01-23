//
//  ExpressionEvaluatorTests.m
//  MockingbirdTests
//
//  Created by Evan Coyne Maloney on 1/25/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBToolbox.h>
#import "MockingbirdTestSuite.h"
#import "MBExpression.h"
#import "MBVariableSpace.h"

/******************************************************************************/
#pragma mark -
#pragma mark ExpressionEvaluatorTests class
/******************************************************************************/

@interface ExpressionEvaluatorTests : MockingbirdTestSuite
@end

@implementation ExpressionEvaluatorTests

/*
 -^formatCurrencyAmount($tableData[$currentDataSection].local_currency_order_credit|$currencyCode)
 !$user -AND $selectedPackageOption.status != ForSale
 !$user -AND $selectedPackageOption.status == ForSale
 $%.0f
 $%0.2f
 $Build.region != jp
 $Build.region == jp
 $Build.region == us
 $Gilt:storesVisited[$Store:identifier]
 $GiltCity:categoryNamesToIDs[$GiltCity:selectedCategory]
 $GiltCity:categoryNamesToIDs[$item]
 $GiltCity:cityList[0].id
 $GiltCity:offersByID[$GiltCity:offerIDsByGeoloc[$item]].name
 $GiltCity:offersByID[$GiltCity:offerIDsByGeoloc[$item]].status != ForSale
 $GiltCity:offersByID[$GiltCity:offerIDsByGeoloc[$item]].tag_line_short
 */

/******************************************************************************/
#pragma mark Expression tests - variables
/******************************************************************************/

- (void) _testExpressionWithEscapeSequence:(NSString*)str
{
    NSString* result = [MBExpression asString:str];
    XCTAssertNotEqualObjects(str, result, @"looks like the escape sequence was not interpreted correctly: %@", str);
}

// this test is for IOS-339
- (void) testEscapeSequencesInOtherwiseConstantExpressions
{
    [self _testExpressionWithEscapeSequence:@"This\\nshould be\\na newline"];
    [self _testExpressionWithEscapeSequence:@"This\\tis\\ttabtastic!"];
}

- (void) testSimpleBooleanLiteralExpressions
{
    BOOL result = [MBExpression asBoolean:@"T" defaultValue:NO];
    XCTAssertTrue(result, @"expected boolean result of \"T\" to be YES");
    result = [MBExpression asBoolean:@"F" defaultValue:YES];
    XCTAssertTrue(!result, @"expected boolean result of \"F\" to be NO");
    result = [MBExpression asBoolean:@"0" defaultValue:YES];
    XCTAssertTrue(!result, @"expected boolean result of \"0\" to be NO");
    result = [MBExpression asBoolean:@"1" defaultValue:NO];
    XCTAssertTrue(result, @"expected boolean result of \"1\" to be YES");
    result = [MBExpression asBoolean:@"2" defaultValue:NO];
    XCTAssertTrue(result, @"expected boolean result of \"2\" to be YES");
    result = [MBExpression asBoolean:@"3" defaultValue:NO];
    XCTAssertTrue(result, @"expected boolean result of \"3\" to be YES");
    result = [MBExpression asBoolean:@"-1" defaultValue:NO];
    XCTAssertTrue(result, @"expected boolean result of \"-1\" to be YES");
    result = [MBExpression asBoolean:@"-2" defaultValue:NO];
    XCTAssertTrue(result, @"expected boolean result of \"-2\" to be YES");
    result = [MBExpression asBoolean:@"-3" defaultValue:NO];
    XCTAssertTrue(result, @"expected boolean result of \"-3\" to be YES");
    result = [MBExpression asBoolean:@"-0" defaultValue:NO];
    XCTAssertTrue(result, @"expected boolean result of \"-0\" to be YES");
    result = [MBExpression asBoolean:@"Y" defaultValue:NO];
    XCTAssertTrue(result, @"expected boolean result of \"Y\" to be YES");
    result = [MBExpression asBoolean:@"N" defaultValue:YES];
    XCTAssertTrue(result, @"expected boolean result of \"N\" to be YES");  // see: IOS-32
}

- (void) _testBooleanFromValue:(id)val expecting:(BOOL)expecting
{
    BOOL result = [MBExpression booleanFromValue:val];
    XCTAssertTrue(result == expecting, @"expected boolean value of \"%@\" to be %s", [val description], (expecting ? "YES" : "NO"));
}

- (void) testBooleanFromValue
{
    [self _testBooleanFromValue:nil expecting:NO];
    [self _testBooleanFromValue:[NSNull null] expecting:NO];
    [self _testBooleanFromValue:@"" expecting:NO];
    [self _testBooleanFromValue:@" " expecting:YES];
    [self _testBooleanFromValue:@"  " expecting:YES];
    [self _testBooleanFromValue:@"   " expecting:YES];
    [self _testBooleanFromValue:@"    " expecting:YES];
    [self _testBooleanFromValue:@"f" expecting:NO];
    [self _testBooleanFromValue:@"F" expecting:NO];
    [self _testBooleanFromValue:@"0" expecting:NO];
    [self _testBooleanFromValue:@"t" expecting:YES];
    [self _testBooleanFromValue:@"T" expecting:YES];
    [self _testBooleanFromValue:@"1" expecting:YES];
}

- (void) testBooleanNegationOperator
{
    BOOL result = [MBExpression asBoolean:@"!T" defaultValue:YES];
    XCTAssertTrue(!result, @"expected boolean result of \"!T\" to be NO");
    result = [MBExpression asBoolean:@"!F" defaultValue:NO];
    XCTAssertTrue(result, @"expected boolean result of \"!F\" to be YES");
    result = [MBExpression asBoolean:@"!0" defaultValue:NO];
    XCTAssertTrue(result, @"expected boolean result of \"!0\" to be YES");
    result = [MBExpression asBoolean:@"!1" defaultValue:YES];
    XCTAssertTrue(!result, @"expected boolean result of \"!1\" to be NO");
    result = [MBExpression asBoolean:@"!2" defaultValue:YES];
    XCTAssertTrue(!result, @"expected boolean result of \"!2\" to be NO");
    result = [MBExpression asBoolean:@"!3" defaultValue:YES];
    XCTAssertTrue(!result, @"expected boolean result of \"!3\" to be NO");
    result = [MBExpression asBoolean:@"!-1" defaultValue:YES];
    XCTAssertTrue(!result, @"expected boolean result of \"!-1\" to be NO");
    result = [MBExpression asBoolean:@"!-2" defaultValue:YES];
    XCTAssertTrue(!result, @"expected boolean result of \"!-2\" to be NO");
    result = [MBExpression asBoolean:@"!-3" defaultValue:YES];
    XCTAssertTrue(!result, @"expected boolean result of \"!-3\" to be NO");
    result = [MBExpression asBoolean:@"!-0" defaultValue:YES];
    XCTAssertTrue(!result, @"expected boolean result of \"!-0\" to be NO");
}

- (void) _testBooleanAndWithOperator:(NSString*)op
{
    //
    // these tests should all pass when 'op' is a valid "and" operator string (-AND or &&)
    //
    BOOL result = [MBExpression asBoolean:[NSString stringWithFormat:@"T %@ T", op] defaultValue:NO];
    XCTAssertTrue(result, @"expected boolean result of \"T %@ T\" to be YES", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"T %@ F", op] defaultValue:YES];
    XCTAssertTrue(!result, @"expected boolean result of \"T %@ F\" to be NO", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"F %@ F", op] defaultValue:YES];
    XCTAssertTrue(!result, @"expected boolean result of \"F %@ F\" to be NO", op);
    
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"T %@ T %@ T", op, op] defaultValue:NO];
    XCTAssertTrue(result, @"expected boolean result of \"T %@ T %@ T\" to be YES", op, op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"F %@ T %@ T", op, op] defaultValue:YES];
    XCTAssertTrue(!result, @"expected boolean result of \"F %@ T %@ T\" to be NO", op, op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"T %@ F %@ T", op, op] defaultValue:YES];
    XCTAssertTrue(!result, @"expected boolean result of \"T %@ F %@ T\" to be NO", op, op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"T %@ T %@ F", op, op] defaultValue:YES];
    XCTAssertTrue(!result, @"expected boolean result of \"T %@ T %@ F\" to be NO", op, op);
    
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"F %@ F %@ F", op, op] defaultValue:YES];
    XCTAssertTrue(!result, @"expected boolean result of \"F %@ F %@ T\" to be NO", op, op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"F %@ T %@ F", op, op] defaultValue:YES];
    XCTAssertTrue(!result, @"expected boolean result of \"F %@ T %@ F\" to be NO", op, op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"T %@ F %@ F", op, op] defaultValue:YES];
    XCTAssertTrue(!result, @"expected boolean result of \"T %@ F %@ F\" to be NO", op, op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"F %@ F %@ T", op, op] defaultValue:YES];
    XCTAssertTrue(!result, @"expected boolean result of \"F %@ F %@ T\" to be NO", op, op);
}

- (void) testBooleanAndOperator
{
    //
    // test -AND operator
    //
    [self _testBooleanAndWithOperator:@"-AND"];
    [self _testBooleanAndWithOperator:@"&&"];
}

- (void) _testBooleanOrWithOperator:(NSString*)op
{
    //
    // these tests should all pass when 'op' is a valid "or" operator string (-OR or ||)
    //
    BOOL result = [MBExpression asBoolean:[NSString stringWithFormat:@"T %@ T", op] defaultValue:NO];
    XCTAssertTrue(result, @"expected boolean result of \"T %@ T\" to be YES", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"T %@ F", op] defaultValue:NO];
    XCTAssertTrue(result, @"expected boolean result of \"T %@ F\" to be YES", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"F %@ F", op] defaultValue:YES];
    XCTAssertTrue(!result, @"expected boolean result of \"F %@ F\" to be NO", op);
    
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"T %@ T %@ T", op, op] defaultValue:NO];
    XCTAssertTrue(result, @"expected boolean result of \"T %@ T %@ T\" to be YES", op, op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"F %@ T %@ T", op, op] defaultValue:NO];
    XCTAssertTrue(result, @"expected boolean result of \"F %@ T %@ T\" to be YES", op, op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"T %@ F %@ T", op, op] defaultValue:NO];
    XCTAssertTrue(result, @"expected boolean result of \"T %@ F %@ T\" to be YES", op, op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"T %@ T %@ F", op, op] defaultValue:NO];
    XCTAssertTrue(result, @"expected boolean result of \"T %@ T %@ F\" to be YES", op, op);
    
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"F %@ F %@ F", op, op] defaultValue:YES];
    XCTAssertTrue(!result, @"expected boolean result of \"F %@ F %@ F\" to be NO", op, op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"F %@ T %@ F", op, op] defaultValue:NO];
    XCTAssertTrue(result, @"expected boolean result of \"F %@ T %@ F\" to be YES", op, op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"T %@ F %@ F", op, op] defaultValue:NO];
    XCTAssertTrue(result, @"expected boolean result of \"T %@ F %@ F\" to be YES", op, op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"F %@ F %@ T", op, op] defaultValue:NO];
    XCTAssertTrue(result, @"expected boolean result of \"F %@ F %@ T\" to be YES", op, op);
}

- (void) testBooleanOrOperator
{
    //
    // test -OR operator
    //
    [self _testBooleanOrWithOperator:@"-OR"];
    [self _testBooleanOrWithOperator:@"||"];
}

- (void) _testBooleanEqualsWithOperator:(NSString*)op
{
    //
    // these tests should all pass when 'op' is a valid "equals" operator string (-EQ or ==)
    //
    BOOL result = [MBExpression asBoolean:[NSString stringWithFormat:@"$one %@ ^parseInteger(1)", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(1) %@ ^parseInteger(1)", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$two %@ ^parseInteger(2)", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(3) %@ $three", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(-5) %@ $negativeFive", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$negativeEight %@ -8", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$six %@ $six", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$backendDomain %@ m.gilt.com", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"m.gilt.com %@ $backendDomain", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^dictionary($one|$one|$two|$two) %@ ^dictionary($two|$two|$one|$one)", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^array($one|$two) %@ ^array($one|$two)", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
}

- (void) testBooleanEqualsOperator
{
    //
    // test -EQ operator
    //
    [self _testBooleanEqualsWithOperator:@"-EQ"];
    [self _testBooleanEqualsWithOperator:@"=="];
}

- (void) _testBooleanNotEqualsWithOperator:(NSString*)op
{
    //
    // these tests should all pass when 'op' is a valid "not equals" operator string (-NE or !=)
    //
    BOOL result = [MBExpression asBoolean:[NSString stringWithFormat:@"$one %@ $two", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(1) %@ ^parseInteger(2)", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$two %@ $negativeTwo", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(4) %@ $five", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(5) %@ $negativeFive", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$backendDomain %@ yahoo.com", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$six %@ $seven", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^dictionary($one|$one|$two|$one) %@ ^dictionary($one|$one|$two|$two)", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^array($one|$two) %@ ^array($two|$one)", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
}

- (void) testBooleanNotEqualsOperator
{
    //
    // test -NE operator
    //
    [self _testBooleanNotEqualsWithOperator:@"-NE"];
    [self _testBooleanNotEqualsWithOperator:@"!="];
}

- (void) _testBooleanLessThanWithOperator:(NSString*)op
{
    //
    // these tests should all pass when 'op' is a valid "less than" operator string (-LT or <)
    //
    BOOL result = [MBExpression asBoolean:[NSString stringWithFormat:@"$one %@ $two", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(1) %@ ^parseInteger(2)", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$negativeTwo %@ $two", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(-4) %@ $five", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$negativeSix %@ $negativeFive", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"A %@ B", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(6) %@ ^parseInteger(7)", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);   
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(-6) %@ ^parseInteger(7)", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);   
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(-8) %@ ^parseInteger(-7)", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);   
}

- (void) testBooleanLessThanOperator
{
    //
    // test -LT operator
    //
    [self _testBooleanLessThanWithOperator:@"-LT"];
    [self _testBooleanLessThanWithOperator:@"<"];
}

- (void) _testBooleanGreaterThanWithOperator:(NSString*)op
{
    //
    // these tests should all pass when 'op' is a valid "greater than" operator string (-GT or >)
    //
    BOOL result = [MBExpression asBoolean:[NSString stringWithFormat:@"$two %@ $one", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(2) %@ ^parseInteger(1)", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$two %@ $negativeTwo", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$five %@ ^parseInteger(-6)", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$negativeFive %@ $negativeSix", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"B %@ A", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(7) %@ ^parseInteger(6)", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);   
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(-6) %@ ^parseInteger(-7)", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);   
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(-8) %@ ^parseInteger(-100)", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);   
}

- (void) testBooleanGreaterThanOperator
{
    //
    // test -GT operator
    //
    [self _testBooleanGreaterThanWithOperator:@"-GT"];
    [self _testBooleanGreaterThanWithOperator:@">"];
}

- (void) _testBooleanLessThanEqualsWithOperator:(NSString*)op
{
    //
    // these tests should all pass when 'op' is a valid "less than or equal to" operator string (-LTE or <= or =<)
    //
    BOOL result = [MBExpression asBoolean:[NSString stringWithFormat:@"$one %@ $two", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"1 %@ ^parseInteger(2)", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$negativeTwo %@ $two", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(-4) %@ $five", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$negativeSix %@ $negativeFive", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"A %@ A", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"6 %@ 7", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);   
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(-6) %@ 7", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);   
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(-8) %@ -7", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);   
}

- (void) testBooleanLessThanEqualsOperator
{
    //
    // test -LTE operator
    //
    [self _testBooleanLessThanEqualsWithOperator:@"-LTE"];
    [self _testBooleanLessThanEqualsWithOperator:@"<="];
    [self _testBooleanLessThanEqualsWithOperator:@"=<"];
}

- (void) _testBooleanGreaterThanEqualsWithOperator:(NSString*)op
{
    //
    // these tests should all pass when 'op' is a valid "greater than or equal to" operator string (-GTE or >= or =>)
    //
    BOOL result = [MBExpression asBoolean:[NSString stringWithFormat:@"$two %@ $one", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(2) %@ ^parseInteger(1)", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$two %@ ^parseInteger(2)", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$five %@ ^parseInteger(-6)", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$negativeFive %@ $negativeSix", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"A %@ A", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"B %@ A", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"C %@ A", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(7) %@ 6", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);   
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(6) %@ 6", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);   
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(-7) %@ -7", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);   
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(-8) %@ ^parseInteger(-100)", op] defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for %@ operator", op);   
}

- (void) testBooleanGreaterThanEqualsOperator
{
    //
    // test -GTE operator
    //
    [self _testBooleanGreaterThanEqualsWithOperator:@"-GTE"];
    [self _testBooleanGreaterThanEqualsWithOperator:@">="];
    [self _testBooleanGreaterThanEqualsWithOperator:@"=>"];
}

- (void) testStringAndNumberComparisons
{
    //
    // test string/number comparisons
    //
    BOOL result = [MBExpression asBoolean:@"1 == $one" defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for string and number comparison");   
    result = [MBExpression asBoolean:@"$one == 1" defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for string and number comparison");   
    result = [MBExpression asBoolean:@"$negativeOne == -1" defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for string and number comparison");   
    result = [MBExpression asBoolean:@"-1 == $negativeOne" defaultValue:NO];
    XCTAssertTrue(result, @"unexpected boolean result for string and number comparison");   
}

static int shortCircuitHitCounter = 0;

+ (id) dataTransformerWithSideEffect
{
    return [NSNumber numberWithInt:shortCircuitHitCounter++];
}

- (void) testBooleanShortCircuiting
{
    BOOL result = [MBExpression asBoolean:@"T -OR ^dataTransformerWithSideEffect()"];
    XCTAssertTrue(shortCircuitHitCounter == 0, @"test of boolean short-circuiting failed");
    result = [MBExpression asBoolean:@"F -AND ^dataTransformerWithSideEffect()"];
    XCTAssertTrue(shortCircuitHitCounter == 0, @"test of boolean short-circuiting failed");
}

- (void) testSimpleBooleanVariableExpressions
{
}

- (void) testComplexBooleanVariableExpressions
{
    
}

- (void) testSimpleVariableReferences
{
    NSString* orderNum = [[MBVariableSpace instance] variableAsString:@"testOrderNumber"];
    
    //
    // test a few different types of variable references
    //
    NSString* expected = [NSString stringWithFormat:@"[Order #%@]", orderNum];
    NSString* result = [MBExpression asObject:@"[Order #${testOrderNumber}]"];
    XCTAssertTrue([result isKindOfClass:[NSString class]], @"expected object result to be a string");
    XCTAssertTrue([result isEqualToString:expected], @"unexpected test result: %@", result);
    result = [MBExpression asObject:@"[Order #$testOrderNumber]"];
    XCTAssertTrue([result isKindOfClass:[NSString class]], @"expected object result to be a string");
    XCTAssertTrue([result isEqualToString:expected], @"unexpected test result: %@", result);
    result = [MBExpression asObject:@"[Order #${testData.orderNumber}]"];
    XCTAssertTrue([result isKindOfClass:[NSString class]], @"expected object result to be a string");
    XCTAssertTrue([result isEqualToString:expected], @"unexpected test result: %@", result);
    result = [MBExpression asObject:@"[Order #${testData.order_number}]"];
    XCTAssertTrue([result isKindOfClass:[NSString class]], @"expected object result to be a string");
    XCTAssertTrue([result isEqualToString:expected], @"unexpected test result: %@", result);
    result = [MBExpression asObject:@"[Order #${testData.order:number}]"];
    XCTAssertTrue([result isKindOfClass:[NSString class]], @"expected object result to be a string");
    XCTAssertTrue([result isEqualToString:expected], @"unexpected test result: %@", result);
    result = [MBExpression asObject:@"[Order #${testData.order.number}]"];
    XCTAssertTrue([result isKindOfClass:[NSString class]], @"expected object result to be a string");
    XCTAssertTrue([result isEqualToString:expected], @"unexpected test result: %@", result);
    result = [MBExpression asObject:@"[Order #$[testData].order.number]"];
    XCTAssertTrue([result isKindOfClass:[NSString class]], @"expected object result to be a string");
    XCTAssertTrue([result isEqualToString:expected], @"unexpected test result: %@", result);
    result = [MBExpression asObject:@"[Order #$[testData][order].number]"];
    XCTAssertTrue([result isKindOfClass:[NSString class]], @"expected object result to be a string");
    XCTAssertTrue([result isEqualToString:expected], @"unexpected test result: %@", result);
    result = [MBExpression asObject:@"[Order #$[testData][order][number]]"];
    XCTAssertTrue([result isKindOfClass:[NSString class]], @"expected object result to be a string");
    XCTAssertTrue([result isEqualToString:expected], @"unexpected test result: %@", result);

    expected = [[MBVariableSpace instance] variableAsString:@"backendURL"]; 
    result = [MBExpression asObject:@"http://$backendDomain/$backendPath?$backendQueryString"];
    XCTAssertTrue([result isKindOfClass:[NSString class]], @"expected object result to be a string");
    XCTAssertTrue([result isEqualToString:expected], @"unexpected test result: %@", result);
    result = [MBExpression asObject:@"http://${backendDomain}/${backendPath}?${backendQueryString}"];
    XCTAssertTrue([result isKindOfClass:[NSString class]], @"expected object result to be a string");
    XCTAssertTrue([result isEqualToString:expected], @"unexpected test result: %@", result);
    result = [MBExpression asObject:@"http://$[backendDomain]/$[backendPath]?$[backendQueryString]"];
    XCTAssertTrue([result isKindOfClass:[NSString class]], @"expected object result to be a string");
    XCTAssertTrue([result isEqualToString:expected], @"unexpected test result: %@", result);
    result = [MBExpression asObject:@"http://$(backendDomain)/$(backendPath)?$(backendQueryString)"];
    XCTAssertTrue([result isKindOfClass:[NSString class]], @"expected object result to be a string");
    XCTAssertTrue([result isEqualToString:expected], @"unexpected test result: %@", result);
}

- (void) testComplexVariableReferences
{
    //
    // test bracket-quoted notation (treats contents of brackets as a literal name for
    // a top-level MBML variable, allows tokenization of subreferences following
    // the closing bracket)
    //
    NSString* test = [MBExpression asString:@"$[Barrett Test].species"];
    XCTAssertTrue([test isEqualToString:@"cat"], @"expected string result of $[Barrett Test].species to be the string \"cat\"");
    
    //
    // test parentheses-quoted notation (treats contents of parens as a literal name for
    // a top-level MBML variable, prevents tokenization of subreferences following
    // the closing bracket)
    //
    NSDictionary* barrett = [[MBVariableSpace instance] variableForName:@"Barrett Test"];
    test = [MBExpression asObject:@"$(Barrett Test).species"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected object result of $(Barrett Test).species to be a string");
    XCTAssertTrue([test hasPrefix:[barrett description]], @"expected object result of $(Barrett Test).species to begin with [barrett description]");
    XCTAssertTrue([test hasSuffix:@".species"], @"expected object result of $(Barrett Test).species to end in .species");

    NSArray* testArray = [MBExpression asArray:@"$(Barrett Test).species"];
    XCTAssertTrue(testArray.count == 2, @"unexpected array result of $(Barrett Test).species to contain 2 elements");
    XCTAssertEqualObjects([testArray objectAtIndex:0], barrett, @"unexpected result for array evaluation of $(Barrett Test).species");
    XCTAssertTrue([[testArray objectAtIndex:1] isEqualToString:@".species"], @"unexpected result for array evaluation of $(Barrett Test).species");

    //
    // test curly brace-quoted notation (treats contents of curly braces as a
    // variable reference, prevents tokenization of subreferences
    // following the closing curly brace)
    //
    NSArray* nameList = [[MBVariableSpace instance] variableForName:@"nameList"];
    NSNumber* testListCntNum = [MBExpression asObject:@"${nameList.count}"];
    XCTAssertTrue([testListCntNum isKindOfClass:[NSNumber class]], @"expected object result of ${nameList.count} to be a number");
    XCTAssertTrue([testListCntNum integerValue] == nameList.count, @"expected numeric result of ${nameList.count} to be 6");
    NSDictionary* lauren = [nameList objectAtIndex:3];
    NSString* laurenFirstName = [MBExpression asObject:@"${nameList[3].firstName}"];
    XCTAssertTrue([laurenFirstName isKindOfClass:[NSString class]], @"expected object result of ${nameList[3].firstName} to be a string");
    XCTAssertTrue([laurenFirstName isEqualToString:[lauren objectForKey:@"firstName"]], @"unexpected object result of ${nameList[3].firstName}");
    test = [MBExpression asObject:@"${nameList[3]}.firstName"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected object result of ${nameList[3]}.firstName to be a string");
    XCTAssertTrue([test hasPrefix:[lauren description]], @"expected object result of ${nameList[3]}.firstName to begin with [lauren description]");
    XCTAssertTrue([test hasSuffix:@".firstName"], @"expected object result of $(Barrett Test).species to end in .species");
    testArray = [MBExpression asArray:@"${nameList[3]}.firstName"];
    XCTAssertTrue(testArray.count == 2, @"unexpected array result of ${nameList[3]}.firstName to contain 2 elements");
    XCTAssertEqualObjects([testArray objectAtIndex:0], lauren, @"unexpected result for array evaluation of ${nameList[3]}.firstName");
    XCTAssertTrue([[testArray objectAtIndex:1] isEqualToString:@".firstName"], @"unexpected result for array evaluation of ${nameList[3]}.firstName");
}

- (void) testComplexVariableReferenceFailures
{
    //
    // the only variable references that can fail are the ones that use the curly brace 
    // notation, because it is possible for those to fail to tokenize if they
    // contain characters that are not valid variable reference identifier characters
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"${this will fail}" error:&err];
    XCTAssertNotNil(err, @"Expected error for an invalid variable reference");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"${this } fail}" error:&err];
    XCTAssertNotNil(err, @"Expected error for an invalid variable reference");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"${this / fail}" error:&err];
    XCTAssertNotNil(err, @"Expected error for an invalid variable reference");
    logExpectedError(err);
}

/*
 <Debug math="#(5 - 2)"/>
 <Debug math="#(.5 + 0.25)"/>
 <Debug math="#(5 * -1)"/>
 <Debug math="#(5 * - 1)"/>
 <Debug math="#(+9 / +3)"/>
 <Debug math="#($application.networkTimeout / 2)"/>
 <Debug math="#(^count($application) * -1)"/>
 <Debug math="#(4 + 2 * 3)"/>
 <Debug math="#((4 + 2) * 3)"/>
 <Debug math="#(4 + (2 * 3))"/>
 <Debug math="#(4 + (T * 3))"/>
 <Debug math="#(4 + (..3 * 3))"/>
 <Debug math="#(4 + (.3.0 * 3))"/>
 <Debug math="#(4 + (.3-0 * 3))"/>
 <Debug math="#(+4)"/>
 <Debug math="#(+4 - - 1)"/>
 
 
 <Listener name="Gilt:AppStarted" event="AppStarted">
 <PostEvent name="MathBench" afterDelay="10.0"/>
 </Listener>
 
 <Listener name="MathBench">
 <Debug log="Starting MathBench"/>
 <SetVar name="small" literal="5"/>
 <SetVar name="large" literal="50"/>
 
 <!--
 <Debug math="^bench(^repeat(1000|#(2 + 2)))"/>
 <Debug math="^bench(^repeat(1000|^add(2|2)))"/>
 
 <Debug math="^bench(^repeat(1000|#(100 - 50)))"/>
 <Debug math="^bench(^repeat(1000|^subtract(100|50)))"/>
 
 <Debug math="^bench(^repeat(1000|#(2 * 2)))"/>
 <Debug math="^bench(^repeat(1000|^multiply(2|2)))"/>
 
 <Debug math="^bench(^repeat(1000|#(100 / 50)))"/>
 <Debug math="^bench(^repeat(1000|^divide(100|50)))"/>
 -->
 
 <!--
 <Debug math="^bench(^repeat(1000|#($small + $small)))"/>
 <Debug math="^bench(^repeat(1000|^add($small|$small)))"/>
 
 <Debug math="^bench(^repeat(1000|#($large - $small)))"/>
 <Debug math="^bench(^repeat(1000|^subtract($large|$small)))"/>
 
 <Debug math="^bench(^repeat(1000|#($small * $small)))"/>
 <Debug math="^bench(^repeat(1000|^multiply($small|$small)))"/>
 
 <Debug math="^bench(^repeat(1000|#($large / $small)))"/>
 <Debug math="^bench(^repeat(1000|^divide($large|$small)))"/>
 -->
 
 <Debug math="^bench(^repeat(1000|#((($small * 10) + $small) / $large)))"/>
 <Debug math="^bench(^repeat(1000|^divide(^add(^multiply($small|10)|$small)|$large)))"/>
 
 <Debug math="^bench(^repeat(1000|#(((($small * 10) + $small) / $large) + 0.0001)))"/>
 <Debug math="^bench(^repeat(1000|^add(^divide(^add(^multiply($small|10)|$small)|$large)|0.0001)))"/>
 
 <Debug math="^bench(^repeat(1000|#((((($small * 10) + $small) / $large) + 0.0001) - 0.0001)))"/>
 <Debug math="^bench(^repeat(1000|^subtract(^add(^divide(^add(^multiply($small|10)|$small)|$large)|0.0001)|0.0001)))"/>
 
 <Debug math="^bench(^repeat(1000|#((((($small * 10) + $small) / ($large / 10)) + 0.0001) - 0.0001)))"/>
 <Debug math="^bench(^repeat(1000|^subtract(^add(^divide(^add(^multiply($small|10)|$small)|^divide($large|10))|0.0001)|0.0001)))"/>
 
 </Listener>
 
 <!-- ======================================================================= -->

 */

- (void) testMathNotationAddition
{
    XCTAssertEqual([[@"#(1 + 1 + 1)" evaluateAsNumber] integerValue], (NSInteger)3, @"Expected 1 + 1 + 1 to equal 3");
    XCTAssertEqual([[@"#(1 + 1 + (1))" evaluateAsNumber] integerValue], (NSInteger)3, @"Expected 1 + 1 + (1) to equal 3");
    XCTAssertEqual([[@"#(1 + 1 + 1 + 1)" evaluateAsNumber] integerValue], (NSInteger)4, @"Expected 1 + 1 + 1 + 1 to equal 4");
    XCTAssertEqual([[@"#((1 + 1) + (1 + 1))" evaluateAsNumber] integerValue], (NSInteger)4, @"Expected (1 + 1) + (1 + 1) to equal 4");
    XCTAssertEqual([[@"#(2 + 2)" evaluateAsNumber] integerValue], (NSInteger)4, @"Expected 2 + 2 to equal 4");
    XCTAssertEqual([[@"#(2.0 + 2.0)" evaluateAsNumber] integerValue], (NSInteger)4, @"Expected 2 + 2 to equal 4");
    XCTAssertEqual([[@"#(+2 + +2)" evaluateAsNumber] integerValue], (NSInteger)4, @"Expected 2 + 2 to equal 4");
    XCTAssertEqualWithAccuracy((double)[[@"#(2.0001 + 2.0001)" evaluateAsNumber] doubleValue], (double)4.0002, 0.0001, @"Expected (slightly more than) 2 + (slightly more than) 2 to equal (slightly more than) 4");
}

- (void) testMathNotationAdditionFailures
{
    MBExpressionError* err = nil;
    [MBExpression asNumber:@"#(1 +)" error:&err];
    XCTAssertNotNil(err, @"Expected error for an invalid math notation");
    logExpectedError(err);
    err = nil;
    [MBExpression asNumber:@"#(1 1)" error:&err];
    XCTAssertNotNil(err, @"Expected error for an invalid math notation");
    logExpectedError(err);
    err = nil;
    [MBExpression asNumber:@"#(1 + T)" error:&err];
    XCTAssertNotNil(err, @"Expected error for an invalid math notation");
    logExpectedError(err);
    err = nil;
    [MBExpression asNumber:@"#(1 + 1 +)" error:&err];
    XCTAssertNotNil(err, @"Expected error for an invalid math notation");
    logExpectedError(err);
    err = nil;
    [MBExpression asNumber:@"#(+1 ++ 1)" error:&err];
    XCTAssertNotNil(err, @"Expected error for an invalid math notation");
    logExpectedError(err);
    err = nil;
    [MBExpression asNumber:@"#(+1 ++ +1)" error:&err];
    XCTAssertNotNil(err, @"Expected error for an invalid math notation");
    logExpectedError(err);
    err = nil;
    [MBExpression asNumber:@"#(+1 +1)" error:&err];
    XCTAssertNotNil(err, @"Expected error for an invalid math notation");
    logExpectedError(err);
}

- (void) testMathNotationSubtractionFailures
{
}

- (void) testMathNotationMultiplication
{
}

- (void) testMathNotationMultiplicationFailures
{
}

- (void) testMathNotationDivision
{
}

- (void) testMathNotationDivisionFailures
{
}

@end
