//
//  ExpressionEvaluatorTests.m
//  MockingbirdTests
//
//  Created by Evan Coyne Maloney on 1/25/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBToolbox.h>
#import "MBDataEnvironmentTestSuite.h"
#import "MBExpression.h"
#import "MBVariableSpace.h"
#import "MBMLFunction.h"

/******************************************************************************/
#pragma mark -
#pragma mark ExpressionEvaluatorTests class
/******************************************************************************/

@interface ExpressionEvaluatorTests : MBDataEnvironmentTestSuite
@end

@implementation ExpressionEvaluatorTests

/******************************************************************************/
#pragma mark Expression tests - variables
/******************************************************************************/

- (void) _testExpressionWithEscapeSequence:(NSString*)str
{
    NSString* result = [MBExpression asString:str];
    XCTAssertNotEqualObjects(str, result);
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
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:@"F" defaultValue:YES];
    XCTAssertTrue(!result);
    result = [MBExpression asBoolean:@"0" defaultValue:YES];
    XCTAssertTrue(!result);
    result = [MBExpression asBoolean:@"1" defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:@"2" defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:@"3" defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:@"-1" defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:@"-2" defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:@"-3" defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:@"-0" defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:@"Y" defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:@"N" defaultValue:YES];
    XCTAssertTrue(result);  // see: IOS-32
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
    XCTAssertTrue(!result);
    result = [MBExpression asBoolean:@"!F" defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:@"!0" defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:@"!1" defaultValue:YES];
    XCTAssertTrue(!result);
    result = [MBExpression asBoolean:@"!2" defaultValue:YES];
    XCTAssertTrue(!result);
    result = [MBExpression asBoolean:@"!3" defaultValue:YES];
    XCTAssertTrue(!result);
    result = [MBExpression asBoolean:@"!-1" defaultValue:YES];
    XCTAssertTrue(!result);
    result = [MBExpression asBoolean:@"!-2" defaultValue:YES];
    XCTAssertTrue(!result);
    result = [MBExpression asBoolean:@"!-3" defaultValue:YES];
    XCTAssertTrue(!result);
    result = [MBExpression asBoolean:@"!-0" defaultValue:YES];
    XCTAssertTrue(!result);
}

- (void) _testBooleanAndWithOperator:(NSString*)op
{
    //
    // these tests should all pass when 'op' is a valid "and" operator string (-AND or &&)
    //
    BOOL result = [MBExpression asBoolean:[NSString stringWithFormat:@"T %@ T", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"T %@ F", op] defaultValue:YES];
    XCTAssertTrue(!result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"F %@ F", op] defaultValue:YES];
    XCTAssertTrue(!result);
    
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"T %@ T %@ T", op, op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"F %@ T %@ T", op, op] defaultValue:YES];
    XCTAssertTrue(!result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"T %@ F %@ T", op, op] defaultValue:YES];
    XCTAssertTrue(!result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"T %@ T %@ F", op, op] defaultValue:YES];
    XCTAssertTrue(!result);
    
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"F %@ F %@ F", op, op] defaultValue:YES];
    XCTAssertTrue(!result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"F %@ T %@ F", op, op] defaultValue:YES];
    XCTAssertTrue(!result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"T %@ F %@ F", op, op] defaultValue:YES];
    XCTAssertTrue(!result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"F %@ F %@ T", op, op] defaultValue:YES];
    XCTAssertTrue(!result);
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
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"T %@ F", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"F %@ F", op] defaultValue:YES];
    XCTAssertTrue(!result);
    
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"T %@ T %@ T", op, op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"F %@ T %@ T", op, op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"T %@ F %@ T", op, op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"T %@ T %@ F", op, op] defaultValue:NO];
    XCTAssertTrue(result);
    
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"F %@ F %@ F", op, op] defaultValue:YES];
    XCTAssertTrue(!result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"F %@ T %@ F", op, op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"T %@ F %@ F", op, op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"F %@ F %@ T", op, op] defaultValue:NO];
    XCTAssertTrue(result);
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
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(1) %@ ^parseInteger(1)", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$two %@ ^parseInteger(2)", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(3) %@ $three", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(-5) %@ $negativeFive", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$negativeEight %@ -8", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$six %@ $six", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$backendDomain %@ m.gilt.com", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"m.gilt.com %@ $backendDomain", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^dictionary($one|$one|$two|$two) %@ ^dictionary($two|$two|$one|$one)", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^array($one|$two) %@ ^array($one|$two)", op] defaultValue:NO];
    XCTAssertTrue(result);
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
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(1) %@ ^parseInteger(2)", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$two %@ $negativeTwo", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(4) %@ $five", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(5) %@ $negativeFive", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$backendDomain %@ yahoo.com", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$six %@ $seven", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^dictionary($one|$one|$two|$one) %@ ^dictionary($one|$one|$two|$two)", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^array($one|$two) %@ ^array($two|$one)", op] defaultValue:NO];
    XCTAssertTrue(result);
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
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(1) %@ ^parseInteger(2)", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$negativeTwo %@ $two", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(-4) %@ $five", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$negativeSix %@ $negativeFive", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"A %@ B", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(6) %@ ^parseInteger(7)", op] defaultValue:NO];
    XCTAssertTrue(result);   
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(-6) %@ ^parseInteger(7)", op] defaultValue:NO];
    XCTAssertTrue(result);   
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(-8) %@ ^parseInteger(-7)", op] defaultValue:NO];
    XCTAssertTrue(result);   
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
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(2) %@ ^parseInteger(1)", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$two %@ $negativeTwo", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$five %@ ^parseInteger(-6)", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$negativeFive %@ $negativeSix", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"B %@ A", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(7) %@ ^parseInteger(6)", op] defaultValue:NO];
    XCTAssertTrue(result);   
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(-6) %@ ^parseInteger(-7)", op] defaultValue:NO];
    XCTAssertTrue(result);   
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(-8) %@ ^parseInteger(-100)", op] defaultValue:NO];
    XCTAssertTrue(result);   
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
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"1 %@ ^parseInteger(2)", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$negativeTwo %@ $two", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(-4) %@ $five", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$negativeSix %@ $negativeFive", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"A %@ A", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"6 %@ 7", op] defaultValue:NO];
    XCTAssertTrue(result);   
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(-6) %@ 7", op] defaultValue:NO];
    XCTAssertTrue(result);   
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(-8) %@ -7", op] defaultValue:NO];
    XCTAssertTrue(result);   
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
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(2) %@ ^parseInteger(1)", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$two %@ ^parseInteger(2)", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$five %@ ^parseInteger(-6)", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"$negativeFive %@ $negativeSix", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"A %@ A", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"B %@ A", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"C %@ A", op] defaultValue:NO];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(7) %@ 6", op] defaultValue:NO];
    XCTAssertTrue(result);   
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(6) %@ 6", op] defaultValue:NO];
    XCTAssertTrue(result);   
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(-7) %@ -7", op] defaultValue:NO];
    XCTAssertTrue(result);   
    result = [MBExpression asBoolean:[NSString stringWithFormat:@"^parseInteger(-8) %@ ^parseInteger(-100)", op] defaultValue:NO];
    XCTAssertTrue(result);   
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
    XCTAssertTrue(result);   
    result = [MBExpression asBoolean:@"$one == 1" defaultValue:NO];
    XCTAssertTrue(result);   
    result = [MBExpression asBoolean:@"$negativeOne == -1" defaultValue:NO];
    XCTAssertTrue(result);   
    result = [MBExpression asBoolean:@"-1 == $negativeOne" defaultValue:NO];
    XCTAssertTrue(result);   
}

static int shortCircuitHitCounter = 0;

+ (id) functionWithSideEffect
{
    return [NSNumber numberWithInt:shortCircuitHitCounter++];
}

- (void) testBooleanShortCircuiting
{
    MBMLFunction* func = [[MBMLFunction alloc] initWithName:@"functionWithSideEffect"
                                                  inputType:MBMLFunctionInputNone
                                                 outputType:MBMLFunctionOutputObject
                                          implementingClass:[self class]
                                             methodSelector:@selector(functionWithSideEffect)];

    XCTAssertTrue([[MBVariableSpace instance] declareFunction:func]);

    BOOL result = [MBExpression asBoolean:@"T -OR ^()"];
    XCTAssertTrue(shortCircuitHitCounter == 0);
    result = [MBExpression asBoolean:@"F -AND ^functionWithSideEffect()"];
    XCTAssertTrue(shortCircuitHitCounter == 0);
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
    XCTAssertTrue([result isKindOfClass:[NSString class]]);
    XCTAssertTrue([result isEqualToString:expected]);
    result = [MBExpression asObject:@"[Order #$testOrderNumber]"];
    XCTAssertTrue([result isKindOfClass:[NSString class]]);
    XCTAssertTrue([result isEqualToString:expected]);
    result = [MBExpression asObject:@"[Order #${testData.orderNumber}]"];
    XCTAssertTrue([result isKindOfClass:[NSString class]]);
    XCTAssertTrue([result isEqualToString:expected]);
    result = [MBExpression asObject:@"[Order #${testData.order_number}]"];
    XCTAssertTrue([result isKindOfClass:[NSString class]]);
    XCTAssertTrue([result isEqualToString:expected]);
    result = [MBExpression asObject:@"[Order #${testData.order:number}]"];
    XCTAssertTrue([result isKindOfClass:[NSString class]]);
    XCTAssertTrue([result isEqualToString:expected]);
    result = [MBExpression asObject:@"[Order #${testData.order.number}]"];
    XCTAssertTrue([result isKindOfClass:[NSString class]]);
    XCTAssertTrue([result isEqualToString:expected]);
    result = [MBExpression asObject:@"[Order #$[testData].order.number]"];
    XCTAssertTrue([result isKindOfClass:[NSString class]]);
    XCTAssertTrue([result isEqualToString:expected]);
    result = [MBExpression asObject:@"[Order #$[testData][order].number]"];
    XCTAssertTrue([result isKindOfClass:[NSString class]]);
    XCTAssertTrue([result isEqualToString:expected]);
    result = [MBExpression asObject:@"[Order #$[testData][order][number]]"];
    XCTAssertTrue([result isKindOfClass:[NSString class]]);
    XCTAssertTrue([result isEqualToString:expected]);

    expected = [[MBVariableSpace instance] variableAsString:@"backendURL"]; 
    result = [MBExpression asObject:@"http://$backendDomain/$backendPath?$backendQueryString"];
    XCTAssertTrue([result isKindOfClass:[NSString class]]);
    XCTAssertTrue([result isEqualToString:expected]);
    result = [MBExpression asObject:@"http://${backendDomain}/${backendPath}?${backendQueryString}"];
    XCTAssertTrue([result isKindOfClass:[NSString class]]);
    XCTAssertTrue([result isEqualToString:expected]);
    result = [MBExpression asObject:@"http://$[backendDomain]/$[backendPath]?$[backendQueryString]"];
    XCTAssertTrue([result isKindOfClass:[NSString class]]);
    XCTAssertTrue([result isEqualToString:expected]);
    result = [MBExpression asObject:@"http://$(backendDomain)/$(backendPath)?$(backendQueryString)"];
    XCTAssertTrue([result isKindOfClass:[NSString class]]);
    XCTAssertTrue([result isEqualToString:expected]);
}

- (void) testComplexVariableReferences
{
    //
    // test bracket-quoted notation (treats contents of brackets as a literal name for
    // a top-level MBML variable, allows tokenization of subreferences following
    // the closing bracket)
    //
    NSString* test = [MBExpression asString:@"$[Barrett Test].species"];
    XCTAssertTrue([test isEqualToString:@"cat"]);
    
    //
    // test parentheses-quoted notation (treats contents of parens as a literal name for
    // a top-level MBML variable, prevents tokenization of subreferences following
    // the closing bracket)
    //
    NSDictionary* barrett = [MBVariableSpace instance][@"Barrett Test"];
    test = [MBExpression asObject:@"$(Barrett Test).species"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertTrue([test hasPrefix:[barrett description]]);
    XCTAssertTrue([test hasSuffix:@".species"]);

    NSArray* testArray = [MBExpression asArray:@"$(Barrett Test).species"];
    XCTAssertTrue(testArray.count == 2);
    XCTAssertEqualObjects(testArray[0], barrett);
    XCTAssertTrue([testArray[1] isEqualToString:@".species"]);

    //
    // test curly brace-quoted notation (treats contents of curly braces as a
    // variable reference, prevents tokenization of subreferences
    // following the closing curly brace)
    //
    NSArray* nameList = [MBVariableSpace instance][@"nameList"];
    NSNumber* testListCntNum = [MBExpression asObject:@"${nameList.count}"];
    XCTAssertTrue([testListCntNum isKindOfClass:[NSNumber class]]);
    XCTAssertTrue([testListCntNum integerValue] == nameList.count);
    NSDictionary* lauren = nameList[3];
    NSString* laurenFirstName = [MBExpression asObject:@"${nameList[3].firstName}"];
    XCTAssertTrue([laurenFirstName isKindOfClass:[NSString class]]);
    XCTAssertTrue([laurenFirstName isEqualToString:[lauren objectForKey:@"firstName"]]);
    test = [MBExpression asObject:@"${nameList[3]}.firstName"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertTrue([test hasPrefix:[lauren description]]);
    XCTAssertTrue([test hasSuffix:@".firstName"]);
    testArray = [MBExpression asArray:@"${nameList[3]}.firstName"];
    XCTAssertTrue(testArray.count == 2);
    XCTAssertEqualObjects(testArray[0], lauren);
    XCTAssertTrue([testArray[1] isEqualToString:@".firstName"]);
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
    expectError(err);

    err = nil;
    [MBExpression asObject:@"${this } fail}" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"${this / fail}" error:&err];
}

- (void) testMathNotationAddition
{
    XCTAssertEqual([[@"#(1 + 1 + 1)" evaluateAsNumber] integerValue], (NSInteger)3);
    XCTAssertEqual([[@"#(1 + 1 + (1))" evaluateAsNumber] integerValue], (NSInteger)3);
    XCTAssertEqual([[@"#(1 + 1 + 1 + 1)" evaluateAsNumber] integerValue], (NSInteger)4);
    XCTAssertEqual([[@"#((1 + 1) + (1 + 1))" evaluateAsNumber] integerValue], (NSInteger)4);
    XCTAssertEqual([[@"#(2 + 2)" evaluateAsNumber] integerValue], (NSInteger)4);
    XCTAssertEqual([[@"#(2.0 + 2.0)" evaluateAsNumber] integerValue], (NSInteger)4);
    XCTAssertEqual([[@"#(+2 + +2)" evaluateAsNumber] integerValue], (NSInteger)4);
    XCTAssertEqualWithAccuracy((double)[[@"#(2.0001 + 2.0001)" evaluateAsNumber] doubleValue], (double)4.0002, 0.0001);
}

- (void) testMathNotationAdditionFailures
{
    MBExpressionError* err = nil;
    [MBExpression asNumber:@"#(1 +)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(1 1)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(1 + T)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(1 + 1 +)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(+1 ++ 1)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(+1 ++ +1)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(+1 +1)" error:&err];
    expectError(err);
}

- (void) testMathNotationSubtraction
{
    XCTAssertEqual([[@"#(1 - 1 - 1)" evaluateAsNumber] integerValue], (NSInteger)-1);
    XCTAssertEqual([[@"#(1 - 1 - (1))" evaluateAsNumber] integerValue], (NSInteger)-1);
    XCTAssertEqual([[@"#(1 - 1 - 1 - 1)" evaluateAsNumber] integerValue], (NSInteger)-2);
    XCTAssertEqual([[@"#((1 - 1) - (1 - 1))" evaluateAsNumber] integerValue], (NSInteger)0);
    XCTAssertEqual([[@"#(2 - 1)" evaluateAsNumber] integerValue], (NSInteger)1);
    XCTAssertEqual([[@"#(2000 - 1499.50)" evaluateAsNumber] doubleValue], (double)500.5);
    XCTAssertEqual([[@"#(-2 - -2)" evaluateAsNumber] integerValue], (NSInteger)0);
}

- (void) testMathNotationSubtractionFailures
{
    MBExpressionError* err = nil;
    [MBExpression asNumber:@"#(1 -)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(1 -1)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(1 - T)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(1 - 1 -)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(+1 -- 1)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(-1 -- -1)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(-1 -1)" error:&err];
    expectError(err);
}

- (void) testMathNotationMultiplication
{
    XCTAssertEqual([[@"#(2 * 2)" evaluateAsNumber] integerValue], (NSInteger)4);
    XCTAssertEqual([[@"#(100 * 2.5)" evaluateAsNumber] integerValue], (NSInteger)250);
    XCTAssertEqual([[@"#(3.234 * 1.225)" evaluateAsNumber] doubleValue], (double)3.96165);
}

- (void) testMathNotationMultiplicationFailures
{
    MBExpressionError* err = nil;
    [MBExpression asNumber:@"#(0 ** 0)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(1 * T)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(1 * 1 *)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(+1 ** 1)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(+1 ** +1)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(*1 *1)" error:&err];
    expectError(err);
}

- (void) testMathNotationDivision
{
    XCTAssertEqual([[@"#(21 / 3)" evaluateAsNumber] integerValue], (NSInteger)7);
    XCTAssertEqual([[@"#(0 / 10)" evaluateAsNumber] integerValue], (NSInteger)0);
}

- (void) testMathNotationDivisionFailures
{
    MBExpressionError* err = nil;
    [MBExpression asNumber:@"#(0 / 0)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(1 / T)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(1 / 1 /)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(+1 // 1)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(+1 // +1)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(/1 /1)" error:&err];
    expectError(err);
}

- (void) testMathNotationModulo
{
    XCTAssertEqual([[@"#(21 % 2)" evaluateAsNumber] integerValue], (NSInteger)1);
    XCTAssertEqual([[@"#(0 % 10)" evaluateAsNumber] integerValue], (NSInteger)0);
    XCTAssertEqual([[@"#(25 % 10)" evaluateAsNumber] integerValue], (NSInteger)5);
}

- (void) testMathNotationModuloFailures
{
    MBExpressionError* err = nil;
    [MBExpression asNumber:@"#(0 % 0)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(1 % T)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(1 % 1 %)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(+1 %% 1)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(+1 %% +1)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(%1 %1)" error:&err];
    expectError(err);
}

@end
