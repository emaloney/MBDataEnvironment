//
//  VariableExpansionTest.m
//  Mockingbird Library
//
//  Created by Jesse Boyes on 8/9/09.
//  Copyright (c) 2009 Gilt Groupe. All rights reserved.
//

#import <XCTest/XCTest.h>
//#import "MBDataEnvironment.h"
//
//@interface VariableExpansionTest : XCTestCase
//@end
//
//@implementation VariableExpansionTest
//
//- (void) setUp
//{
//}
//
//- (void) tearDown
//{
//}
//
//- (void)testExpandString {
//    
//    [[MBVariableSpace instance] setVariable:@"varName" value:@"Value!"];
//    
//    XCTAssertEqualObjects(@"this Value!", [MBExpression asString:@"this $varName"], @"");    
//}
//
//- (void)testExpandHash {
//    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
//    [dict setObject:@"foo" forKey:@"bar"];
//    [[MBVariableSpace instance] setVariable:@"hashVar" value:dict];
//    
//    XCTAssertEqualObjects(@"foo", [MBExpression asString:@"$hashVar.bar"], @"");    
//}
//
//- (void)testExpandHashInHash {
//    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
//    [dict setObject:@"foo" forKey:@"baz"];
//    NSMutableDictionary * dict2 = [NSMutableDictionary dictionary];
//    [dict2 setObject:dict forKey:@"bar"];
//    [[MBVariableSpace instance] setVariable:@"hashVar2" value:dict2];
//    
//    XCTAssertEqualObjects(@"foo", [MBExpression asString:@"$hashVar2.bar.baz"], @"");    
//}
//
//- (void)testExpandArray {
//    NSMutableArray * items = [NSMutableArray array];
//    [items addObject:@"one"];
//    [items addObject:@"two"];
//    [items addObject:@"three"];
//    [[MBVariableSpace instance] setVariable:@"arrayVar" value:items];
//    XCTAssertEqualObjects(@"one", [MBExpression asString:@"$arrayVar[0]"], @"");
//    XCTAssertEqualObjects(@"two", [MBExpression asString:@"$arrayVar[1]"], @"");
//    XCTAssertEqualObjects(@"three", [MBExpression asString:@"$arrayVar[2]"], @"");
//}
//
//- (void)testExpandArrayNestedExpansion {
//    NSMutableArray * items = [NSMutableArray array];
//    [items addObject:@"one"];
//    [items addObject:@"two"];
//    [items addObject:@"three"];
//    [[MBVariableSpace instance] setVariable:@"arrayVar" value:items];
//    [[MBVariableSpace instance] setVariable:@"index" value:@"2"];
//    XCTAssertEqualObjects(@"a three var", [MBExpression asString:@"a $arrayVar[$index] var"], @"");
//}
//
//- (void)testArraysOfDictionaries {
//    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
//    [dict setObject:@"baz" forKey:@"bar"];
//    NSMutableArray * arr = [NSMutableArray array];
//    [arr addObject:dict];
//    [[MBVariableSpace instance] setVariable:@"foo" value:arr];
//    XCTAssertEqualObjects(@"baz", [MBExpression asString:@"$foo[0].bar"], @"");
//}
//
//- (void)testEmptyVariable {
//    [[MBVariableSpace instance] setVariable:@"emptyVar" value:@""];
//    XCTAssertEqualObjects(@"", [MBExpression asString:@"$emptyVar"], @"");
//}
//
//- (void)testVariableBorderingNonAlphaChar {
//    [[MBVariableSpace instance] setVariable:@"foo" value:@"bar"];
//    XCTAssertEqualObjects(@"%bar%", [MBExpression asString:@"%$foo%"], @"");
//}
//
//- (void)testBooleanEvaluation {
//    [[MBVariableSpace instance] setVariable:@"foo" value:[NSArray array]];
//    XCTAssertEqual(NO, [MBExpression asBoolean:@"$foo.count"], @"Array emptiness evaluation");
//    [[MBVariableSpace instance] setVariable:@"foo" value:[NSArray arrayWithObject:@"Hello"]];
//    XCTAssertEqual(YES, [MBExpression asBoolean:@"$foo.count"], @"Array emptiness evaluation");
//    XCTAssertEqual(NO, [MBExpression asBoolean:@"!$foo.count"], @"Neg. Array emptiness evaluation");
//}
//
//- (void)testAndClause {
//    [[MBVariableSpace instance] setVariable:@"aaa" value:@"T"];
//    [[MBVariableSpace instance] setVariable:@"bbb" value:[NSArray arrayWithObject:@"Hello"]];
//    [[MBVariableSpace instance] setVariable:@"ccc" value:@"F"];
//    XCTAssertEqual(YES, [MBExpression asBoolean:@"$aaa && $bbb.count"], @"true AND true");
//    XCTAssertEqual(NO, [MBExpression asBoolean:@"$ccc && $bbb.count"], @"true AND false");
//    XCTAssertEqual(NO, [MBExpression asBoolean:@"$bbb.count && $ccc"], @"true AND false");
//}
//
//- (void)testEqualityClause {
//    [[MBVariableSpace instance] setVariable:@"aaa" value:@"Something"];
//    [[MBVariableSpace instance] setVariable:@"bbb" value:@"Something"];
//    [[MBVariableSpace instance] setVariable:@"ccc" value:@"Something else"];
//    XCTAssertEqual(YES, [MBExpression asBoolean:@"$aaa == $bbb"], @"equality");
//    XCTAssertEqual(NO, [MBExpression asBoolean:@"$aaa == $ccc"], @"inequality");
//}
//
//- (void)testInequalityClause {
//    [[MBVariableSpace instance] setVariable:@"aaa" value:@"Something"];
//    [[MBVariableSpace instance] setVariable:@"bbb" value:@"Something"];
//    [[MBVariableSpace instance] setVariable:@"ccc" value:@"Something else"];
//    XCTAssertEqual(NO, [MBExpression asBoolean:@"$aaa != $bbb"], @"equality");
//    XCTAssertEqual(YES, [MBExpression asBoolean:@"$aaa != $ccc"], @"inequality");
//}
//
//- (void)testOrClause {
//    [[MBVariableSpace instance] setVariable:@"aaa" value:@"0"];
//    [[MBVariableSpace instance] setVariable:@"bbb" value:[NSArray arrayWithObject:@"Hello"]];
//    [[MBVariableSpace instance] setVariable:@"ccc" value:@"F"];
//    XCTAssertEqual(YES, [MBExpression asBoolean:@"$aaa || $bbb.count"], @"false OR true");
//    XCTAssertEqual(NO, [MBExpression asBoolean:@"$ccc || $aaa"], @"false OR false");
//}
//
//- (void)testCombinationClause {
//    [[MBVariableSpace instance] setVariable:@"aaa" value:@"ASDF"];
//    [[MBVariableSpace instance] setVariable:@"bbb" value:[NSArray arrayWithObject:@"Hello"]];
//    [[MBVariableSpace instance] setVariable:@"ccc" value:@"ASDF"];
//    XCTAssertEqual(YES, [MBExpression asBoolean:@"$aaa && $bbb.count == 1"], @"$aaa && $bbb.count == 1");
//    XCTAssertEqual(NO, [MBExpression asBoolean:@"$aaa && $bbb.count == 2"], @"$aaa && $bbb.count == 2");
//    XCTAssertEqual(YES, [MBExpression asBoolean:@"$aaa || $bbb.count == 2"], @"$aaa || $bbb.count == 2");
//    XCTAssertEqual(YES, [MBExpression asBoolean:@"$aaa == $ccc && $ccc == $aaa"], @"$aaa == $ccc && $ccc == $aaa");
//    XCTAssertEqual(NO, [MBExpression asBoolean:@"$aaa == $ccc && $ccc != $aaa"], @"$aaa == $ccc && $ccc != $aaa");
//}
//
//// TODO: I bet this doesn't work: $array[$innerArray[idx]]
//
//@end
