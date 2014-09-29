//
//  MBMLFunction.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 9/15/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import "MBDataModel.h"
#import "MBExpressionError.h"

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

//!< functions are called as ^functionName(optional-parameters) from MBML
extern NSString* const kMBMLFunctionInputNone;                  //!< @"none" - function takes no input parameters
extern NSString* const kMBMLFunctionInputRaw;                   //!< @"raw" - function takes as input the raw (uninterpreted) string between the parentheses
extern NSString* const kMBMLFunctionInputString;                //!< @"string" - function takes as input an expression that will be evaluated as a string
extern NSString* const kMBMLFunctionInputObject;                //!< @"object" - function takes as input an expression that will be evaluated as an object
extern NSString* const kMBMLFunctionInputMath;                  //!< @"math" - function takes as input an expression that will be evaluated as a math expression
extern NSString* const kMBMLFunctionInputPipedExpressions;      //!< @"pipedExpressions" - function input is parsed as an expression (but not interpreted) and split at pipe delimeters in the outermost parenthetical scope, resulting in an array of one or more expressions 
extern NSString* const kMBMLFunctionInputPipedStrings;          //!< @"pipedStrings" - function input is first parsed as an expression (but not interpreted) and split at pipe delimeters in the outermost parenthetical scope; then, template string expansion is performed on each item resulting in an array
extern NSString* const kMBMLFunctionInputPipedObjects;          //!< @"pipedObjects" - function input is first parsed as an expression (but not interpreted) and split at pipe delimeters in the outermost parenthetical scope; then, each item is evaluated as an object expression resulting in an array
extern NSString* const kMBMLFunctionInputPipedMath;             //!< @"pipedMath" - function input is first parsed as an expression (but not interpreted) and split at pipe delimeters in the outermost parenthetical scope; then, each item is evaluated as a math expression resulting in an array

extern NSString* const kMBMLFunctionOutputNone;                 //!< @"none" - function output (if any) is ignored
extern NSString* const kMBMLFunctionOutputObject;               //!< @"object" - function returns an object (type 'id'); this is the default if no output type is specified

extern NSString* const kMBMLFunctionInputParameterName;

/******************************************************************************/
#pragma mark Enumerations
/******************************************************************************/

typedef enum : NSUInteger {
    MBMLFunctionInputUnset = 0,
    MBMLFunctionInputNone,
    MBMLFunctionInputRaw,
    MBMLFunctionInputString,
    MBMLFunctionInputObject,
    MBMLFunctionInputMath,
    MBMLFunctionInputPipedExpressions,
    MBMLFunctionInputPipedStrings,
    MBMLFunctionInputPipedObjects,
    MBMLFunctionInputPipedMath,
    MBMLFunctionInputDefault = MBMLFunctionInputObject
} MBMLFunctionInputType;

typedef enum : NSUInteger {
    MBMLFunctionOutputUnset = 0,
    MBMLFunctionOutputNone,
    MBMLFunctionOutputObject,
    MBMLFunctionOutputDefault = MBMLFunctionOutputObject
} MBMLFunctionOutputType;

/******************************************************************************/
#pragma mark -
#pragma mark MBMLFunction class
/******************************************************************************/

/*!
 Represents an Objective-C method that is exposed to the Mockingbird environment
 as an MBML function.
 
 Functions allow native Objective-C code to be called from MBML. When an MBML
 expression containing a function call is evaluated, the implementing method
 of the function is executed, and the value returned by the method (if any) is
 passed back to MBML.
 
 Functions may take zero or more input parameters, and they may return an
 optional result.
 
 ** Calling Functions **
 
 In MBML, a function call can be embedded within an MBML expression. Function
 calls start with a caret character ("`^`"), followed by the name of the 
 function, and end in a list of zero or pipe-separated parameters contained in 
 parentheses.
 
 For example, to call a function that creates an array, you could write:
 
    ^array(pizza|pasta|sushi|lobster)
 
 The function above would return an `NSArray` instance containing four items:
 the strings "pizza", "pasta", "sushi" and "lobster".
 
 Because this particular expression returns an object, we can access values in
 the returned object as if it were a regular MBML object reference. To access
 the fourth element in the (zero-based-indexed) array, you would write:
 
    ^array(pizza|pasta|sushi|lobster)[3]
 
 This expression return the value "lobster".
 
 ** Implementing MBML Functions **
 
 MBML functions are implemented as Objective-C class methods. MBML functions 
 that accept multiple parameters will receive those values in an array. The
 `MBMLFunction` class handles the marshalling of parameters to the function
 implementation. Precisely how this is done depends on how the function is
 declared within MBML:
 
 ** Declaring Functions **

 A standard set of MBML functions is declared in Mockingbird, and it is included
 by default. You can also add your own function implementations, which must be
 explicitly declared in order to expose them to the MBML environment.
 
 A function declaration looks like:
 
    <Function name="functionName" class="ImplementingClass" method="methodName" input="inputType" output="outputType"/>

 The `<Function>` tag accepts the following attributes:
 
 * `name` - The name of the function as it will be invoked in MBML (eg., a
 function with the name `foo` and taking no parameters is called from within
 MBML as "`^foo()`".)
 
 * `class` - Specifies the name of the Objective-C class that implements the
 function.
 
 * `method` - The implementing method. This attribute is optional if the
 method is the same as the function name. Unlike with Objective-C selectors, 
 colons are *not* considered part of the method and therefore should not be
 included in the declaration.
 
 * `input` - Specifies the type of input the function expects. The
 `MBMLFunction` class will marshal input parameters accordingly.
 
 * `output` - Specifies the type of output returned by the function.
 
 ** Function Input **
 
 The `input` attribute of the `<Function>` declaration in MBML accepts the
 following values:
 
 * `none` - The function accepts no input parameters. The implementing
 method should take no parameters.
 
 * `raw` - The function accepts a single uninterpreted string as input. The
 implementing method should take an `NSString` parameter.
 
 * `string` - The function accepts as input an MBML expression yielding a
 string. Prior to executing the implementing method, the `MBMLFunction` will
 evaluate the input parameter as a string expression. The implementing method
 should take an `NSString` parameter.
 
 * `object` - The function accepts as input an MBML expression yielding an
 object. Prior to executing the implementing method, the `MBMLFunction` will
 evaluate the input parameter as an object expression. The implementing method
 should take an `NSObject` or `id` parameter.
 
 * `math` - The function accepts as input an MBML math expression yielding
 a numeric value. Prior to executing the implementing method, the `MBMLFunction` 
 will evaluate the input parameter as a math expression. The implementing method
 should take an `NSNumber` parameter.
 
 * `pipedExpressions` - The function accepts zero or more MBML expressions as
 input. Prior to executing the implementing method, the `MBMLFunction` will
 split the input at the pipe character ("`|`") resulting in an `NSArray`,
 which is then passed to the implementing method.
 
 * `pipedStrings` - The function accepts zero or more MBML expressions 
 yielding strings as input. Prior to executing the implementing method, the
 `MBMLFunction` will split the input at the pipe character ("`|`") and then
 evaluate each resulting expression as a string expression. The results are
 placed into an `NSArray` which is then passed to the implementing method.
 
 * `pipedObjects` - The function accepts zero or more MBML expressions 
 yielding objects as input. Prior to executing the implementing method, the
 `MBMLFunction` will split the input at the pipe character ("`|`") and then
 evaluate each resulting expression as an object expression. The results are
 placed into an `NSArray` which is then passed to the implementing method.
 
 * `pipedMath` - The function accepts zero or more MBML math expressions 
 yielding numbers as input. Prior to executing the implementing method, the
 `MBMLFunction` will split the input at the pipe character ("`|`") and then
 evaluate each resulting expression as a math expression. The results are
 placed into an `NSArray` which is then passed to the implementing method.
 
 ** Function Output **

 The `output` attribute of the `<Function>` declaration in MBML accepts the
 following values:

 * `none` - The function returns no output.
 
 * `object` - The function returns an arbitrary Objective-C object.
 
 ** Parameter Validation **
 
 `MBMLFunction` declares a number of parmater validation methods to simplify
 error reporting on behalf of function implementations. When a function
 is passed input it isn't expecting, the validation methods provide a mechanism
 to report descriptive errors in a standardized way.
 
 Here's an example of the validation code for a hypothetical function that
 takes 2 or 3 parameters and expects the second parameter to be an expression
 that evaluates to an `NSString` instance:
 
    + (id) hypotheticalFunction:(NSArray*)params
    {
         MBMLFunctionError* err = nil;
         NSUInteger paramCnt = [MBMLFunction validateParameter:params countIsAtLeast:2 andAtMost:3 error:&err];
         NSString* key = [MBMLFunction validateParameter:params isStringAtIndex:1 error:&err];
         if (err) return err;
 
        ... function implementation here...
    }

 As you can see, MBML functions return `MBMLFunctionError` instances when an
 error occurs. The function execution infrastructure handles this automatically
 to report errors to the console to simplify debugging.
 */
@interface MBMLFunction : MBDataModel

/*----------------------------------------------------------------------------*/
#pragma mark Properties
/*!    @name Properties                                                       */
/*----------------------------------------------------------------------------*/

/*!
 Returns the name of the function. A function's name determines how it is
 invoked from within MBML. For example, the expression:
 
    ^functionName(param1|param2)
 
 would invoke the function named `functionName` and pass it two parameters:
 `param1` and `param2`.
 */
@property(nonatomic, readonly) NSString* name;

/*!
 Returns the input type of the function. The input type determines the
 format of the parameters (if any) expected by the function.
 */
@property(nonatomic, readonly) MBMLFunctionInputType inputType;

/*!
 Returns the output type of the function. Functions return either an object
 or no output.
 */
@property(nonatomic, readonly) MBMLFunctionOutputType outputType;

/*----------------------------------------------------------------------------*/
#pragma mark Function parameter validation (high-level)
/*!    @name Function parameter validation (high-level)                       */
/*----------------------------------------------------------------------------*/

/*!
 Validates a function's parameter list array to ensure that it contains the
 expected number of parameters. Validation will fail if the parameter list
 doesn't contain the exact number of parameters expected.
 
 @param     params An array containing the function's input parameters.
 
 @param     expectedCnt The exact number of parameters expected by the function.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    The number of parameters contained in the array, or `0` if
            parameter validation fails.
 */
+ (NSUInteger) validateParameter:(NSArray*)params countIs:(NSUInteger)expectedCnt error:(MBMLFunctionError**)errPtr;

/*!
 Validates a function's parameter list array to ensure that it contains the
 expected number of parameters. Validation will fail if the parameter list
 contains fewer than the expected number of parameters.
 
 @param     params An array containing the function's input parameters.
 
 @param     expectedCnt The minimum number of parameters expected by the
            function.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `errPtr` already contains an error object, further
            parameter validation will **not** be performed.

 @return    The number of parameters contained in the array, or `0` if
            parameter validation fails.
 */
+ (NSUInteger) validateParameter:(NSArray*)params countIsAtLeast:(NSUInteger)expectedCnt error:(MBMLFunctionError**)errPtr;

/*!
 Validates a function's parameter list array to ensure that it contains the
 expected number of parameters. Validation will fail if the parameter list
 contains more than the expected number of parameters.
 
 @param     params An array containing the function's input parameters.
 
 @param     expectedCnt The maximum number of parameters expected by the
            function.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    The number of parameters contained in the array, or `0` if
            parameter validation fails.
 */
+ (NSUInteger) validateParameter:(NSArray*)params countIsAtMost:(NSUInteger)expectedCnt error:(MBMLFunctionError**)errPtr;

/*!
 Validates a function's parameter list array to ensure that it contains the
 expected number of parameters. Validation will fail if the parameter list
 contains fewer than or more than the expected number of parameters.
 
 @param     params An array containing the function's input parameters.
 
 @param     minCnt The minimum number of parameters expected by the
            function.
 
 @param     maxCnt The maximum number of parameters expected by the
            function.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    The number of parameters contained in the array, or `0` if
            parameter validation fails.
 */
+ (NSUInteger) validateParameter:(NSArray*)params countIsAtLeast:(NSUInteger)minCnt andAtMost:(NSUInteger)maxCnt error:(MBMLFunctionError**)errPtr;

/*!
 Validates a function's parameter list array to ensure that a given index is
 within range for the array. Validation will fail if the array index is
 greater than the last index in the array.
 
 @param     params An array containing the function's input parameters.
 
 @param     idx The array index that's expected to be within range for the
            parameter array.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    The number of parameters contained in the array, or `0` if
            parameter validation fails.
 */
+ (NSUInteger) validateParameter:(NSArray*)params indexIsInRange:(NSUInteger)idx error:(MBMLFunctionError**)errPtr;

/*!
 Validates a function's parameter list array to ensure that an object at a
 given array index is of an expected class. Validation will fail if the 
 parameter at that array index is not a kind of the expected class.
 
 @param     params An array containing the function's input parameters.
 
 @param     idx The array index of the parameter being validated.
 
 @param     cls The expected class of the parameter at the given array index.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the parameter at the given array index is
            returned. If validation fails, `nil` is returned.
 
 @warning   For performance reasons, this method does not attempt to validate
            the provided array index, and an exception will occur if the index
            is out-of-range for the parameter array. Therefore, to avoid 
            problems, you should always validate array indexes prior to calling
            this method.
 */
+ (id) validateParameter:(NSArray*)params objectAtIndex:(NSUInteger)idx isKindOfClass:(Class)cls error:(MBMLFunctionError**)errPtr;

/*!
 Validates a function's parameter list array to ensure that an object at a
 given array index is among a list of expected classes. Validation will fail
 if the parameter at the specified index is not a kind of one of the expected
 classes.
 
 @param     params An array containing the function's input parameters.
 
 @param     idx The array index of the parameter being validated.
 
 @param     classes An array of classes against which to validate the parameter
            at the specified index. Validation succeeds if the parameter is
            an instance of one of those classes.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the parameter at the given array index is
            returned. If validation fails, `nil` is returned.
  
 @warning   For performance reasons, this method does not attempt to validate
            the provided array index, and an exception will occur if the index
            is out-of-range for the parameter array. Therefore, to avoid 
            problems, you should always validate array indexes prior to calling
            this method.
*/
+ (Class) validateParameter:(NSArray*)params objectAtIndex:(NSUInteger)idx isOneKindOfClass:(NSArray*)classes error:(MBMLFunctionError**)errPtr;

/*!
 Validates a function's parameter list array to ensure that an object at a
 given array index is a string. Validation will fail if the parameter at the
 specified index is not an `NSString` instance.
 
 @param     params An array containing the function's input parameters.
 
 @param     idx The array index of the parameter being validated.
  
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the string at the given array index is
            returned. If validation fails, `nil` is returned.
  
 @warning   For performance reasons, this method does not attempt to validate
            the provided array index, and an exception will occur if the index
            is out-of-range for the parameter array. Therefore, to avoid 
            problems, you should always validate array indexes prior to calling
            this method.
*/
+ (NSString*) validateParameter:(NSArray*)params isStringAtIndex:(NSUInteger)idx error:(MBMLFunctionError**)errPtr;

/*!
 Validates a function's parameter list array to ensure that an object at a
 given array index is a number. Validation will fail if the parameter at the
 specified index is not a numeric value.
 
 @param     params An array containing the function's input parameters.
 
 @param     idx The array index of the parameter being validated.
  
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the number at the given array index is
            returned. If validation fails, `nil` is returned.
  
 @warning   For performance reasons, this method does not attempt to validate
            the provided array index, and an exception will occur if the index
            is out-of-range for the parameter array. Therefore, to avoid 
            problems, you should always validate array indexes prior to calling
            this method.
*/
+ (NSDecimalNumber*) validateParameter:(NSArray*)params containsNumberAtIndex:(NSUInteger)idx error:(MBMLFunctionError**)errPtr;

/*!
 Validates a function's parameter list array to ensure that an object at a
 given array index is an array. Validation will fail if the parameter at the
 specified index is not an `NSArray` instance.
 
 @param     params An array containing the function's input parameters.
 
 @param     idx The array index of the parameter being validated.
  
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the array at the given array index is
            returned. If validation fails, `nil` is returned.
  
 @warning   For performance reasons, this method does not attempt to validate
            the provided array index, and an exception will occur if the index
            is out-of-range for the parameter array. Therefore, to avoid 
            problems, you should always validate array indexes prior to calling
            this method.
*/
+ (NSArray*) validateParameter:(NSArray*)params isArrayAtIndex:(NSUInteger)idx error:(MBMLFunctionError**)errPtr;

/*!
 Validates a function's parameter list array to ensure that an object at a
 given array index is a dictionary. Validation will fail if the parameter at the
 specified index is not an `NSDictionary` instance.
 
 @param     params An array containing the function's input parameters.
 
 @param     idx The array index of the parameter being validated.
  
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the dictionary at the given array index is
            returned. If validation fails, `nil` is returned.
  
 @warning   For performance reasons, this method does not attempt to validate
            the provided array index, and an exception will occur if the index
            is out-of-range for the parameter array. Therefore, to avoid 
            problems, you should always validate array indexes prior to calling
            this method.
*/
+ (NSDictionary*) validateParameter:(NSArray*)params isDictionaryAtIndex:(NSUInteger)idx error:(MBMLFunctionError**)errPtr;

/*!
 Validates a function's input parameter to ensure that the object is an instance
 of an expected class. Validation will fail if the parameter is not a kind of
 the expected class.
 
 @param     param The function's input parameter.
 
 @param     cls The expected class of the input parameter.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the parameter object is returned. If 
            validation fails, `nil` is returned.
 */
+ (id) validateParameter:(id)param isKindOfClass:(Class)cls error:(MBMLFunctionError**)errPtr;

/*!
 Validates a function's input parameter to ensure that the object's class is
 among a list of expected classes. Validation will fail if the is not a kind
 of one of the expected classes.
 
 @param     param The function's input parameter.
 
 @param     classes An array of classes against which to validate the parameter.
            Validation succeeds if the parameter is an instance of one of those
            classes.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the parameter object is returned. If 
            validation fails, `nil` is returned.
 */
+ (Class) validateParameter:(id)param isOneKindOfClass:(NSArray*)classes error:(MBMLFunctionError**)errPtr;

/*!
 Validates a function's input parameter to ensure that the object responds
 to the provided selector. Validation will fail if the object does not
 respond to that selector.
 
 @param     param The function's input parameter.
 
 @param     selector The selector to test against the input parameter.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the parameter object is returned. If 
            validation fails, `nil` is returned.
 */
+ (id<NSObject>) validateParameter:(id<NSObject>)param respondsToSelector:(SEL)selector error:(MBMLFunctionError**)errPtr;

/*!
 Validates a function's input parameter to ensure that it is a string. 
 Validation will fail if the parameter is not an `NSString` instance.
 
 @param     param The function's input parameter.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the parameter string is returned. If 
            validation fails, `nil` is returned.
 */
+ (NSString*) validateParameterIsString:(id)param error:(MBMLFunctionError**)errPtr;

/*!
 Validates a function's input parameter to ensure it contains a numeric value. 
 Validation will fail if the parameter is not a number.
 
 @param     param The function's input parameter.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the parameter number is returned. If 
            validation fails, `nil` is returned.
 */
+ (NSDecimalNumber*) validateParameterContainsNumber:(id)param error:(MBMLFunctionError**)errPtr;

/*!
 Validates a function's input parameter to ensure it is an array. 
 Validation will fail if the parameter is not an `NSArray` instance.
 
 @param     param The function's input parameter.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the parameter array is returned. If 
            validation fails, `nil` is returned.
 */
+ (NSArray*) validateParameterIsArray:(id)param error:(MBMLFunctionError**)errPtr;

/*!
 Validates a function's input parameter to ensure it is a dictionary. 
 Validation will fail if the parameter is not an `NSDictionary` instance.
 
 @param     param The function's input parameter.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the parameter dictionary is returned. If 
            validation fails, `nil` is returned.
 */
+ (NSDictionary*) validateParameterIsDictionary:(id)param error:(MBMLFunctionError**)errPtr;

/*----------------------------------------------------------------------------*/
#pragma mark Function parameter validation (mid-level)
/*!    @name Function parameter validation (mid-level)                        */
/*----------------------------------------------------------------------------*/

/*!
 Validates an expression parameter (i.e., a parameter of a function whose
 `<Function>` is declared as `type="pipedExpressions"`) to ensure that the
 expression at the specified array index yields an `NSString` when evaluated.
  
 @param     params An array containing the function's input parameters.
 
 @param     idx The array index of the parameter being validated.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the string resulting from evaluating the
            expression at the specified parameter index is returned. If 
            validation fails, `nil` is returned.

 @warning   For performance reasons, this method does not attempt to validate
            the provided array index, and an exception will occur if the index
            is out-of-range for the parameter array. Therefore, to avoid 
            problems, you should always validate array indexes prior to calling
            this method.
 */
+ (NSString*) validateExpression:(NSArray*)params isStringAtIndex:(NSUInteger)idx error:(MBMLFunctionError**)errPtr;

/*!
 Validates an expression parameter (i.e., a parameter of a function whose
 `<Function>` is declared as `type="pipedExpressions"`) to ensure that the
 expression at the specified array index yields a numeric value when evaluated.
  
 @param     params An array containing the function's input parameters.
 
 @param     idx The array index of the parameter being validated.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the number resulting from evaluating the
            expression at the specified parameter index is returned. If 
            validation fails, `nil` is returned.

 @warning   For performance reasons, this method does not attempt to validate
            the provided array index, and an exception will occur if the index
            is out-of-range for the parameter array. Therefore, to avoid 
            problems, you should always validate array indexes prior to calling
            this method.
 */
+ (NSDecimalNumber*) validateExpression:(NSArray*)params containsNumberAtIndex:(NSUInteger)idx error:(MBMLFunctionError**)errPtr;

/*!
 Validates an expression parameter (i.e., a parameter of a function whose
 `<Function>` is declared as `type="pipedExpressions"`) to ensure that the
 expression at the specified array index yields an `NSArray` when evaluated.
  
 @param     params An array containing the function's input parameters.
 
 @param     idx The array index of the parameter being validated.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the array resulting from evaluating the
            expression at the specified parameter index is returned. If 
            validation fails, `nil` is returned.

 @warning   For performance reasons, this method does not attempt to validate
            the provided array index, and an exception will occur if the index
            is out-of-range for the parameter array. Therefore, to avoid 
            problems, you should always validate array indexes prior to calling
            this method.
 */
+ (NSArray*) validateExpression:(NSArray*)params isArrayAtIndex:(NSUInteger)idx error:(MBMLFunctionError**)errPtr;

/*!
 Validates an expression parameter (i.e., a parameter of a function whose
 `<Function>` is declared as `type="pipedExpressions"`) to ensure that the
 expression at the specified array index yields an `NSDictionary` when
 evaluated.
  
 @param     params An array containing the function's input parameters.
 
 @param     idx The array index of the parameter being validated.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the dictionary resulting from evaluating 
            the expression at the specified parameter index is returned. If 
            validation fails, `nil` is returned.

 @warning   For performance reasons, this method does not attempt to validate
            the provided array index, and an exception will occur if the index
            is out-of-range for the parameter array. Therefore, to avoid 
            problems, you should always validate array indexes prior to calling
            this method.
 */
+ (NSDictionary*) validateExpression:(NSArray*)params isDictionaryAtIndex:(NSUInteger)idx error:(MBMLFunctionError**)errPtr;

/*----------------------------------------------------------------------------*/
#pragma mark Function execution
/*!    @name Function execution                                               */
/*----------------------------------------------------------------------------*/

/*!
 Called to execute the function.
 
 @param     input The input parameter(s) for the function.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if function execution fails.
 
 @return    The function's return value. `nil` is returned if an error occurred
            while executing the function.
 */
- (id) executeWithInput:(id)input error:(MBExpressionError**)errPtr;

/*----------------------------------------------------------------------------*/
#pragma mark Debugging output
/*!    @name Debugging output                                                 */
/*----------------------------------------------------------------------------*/

/*!
 Returns a human-readable description of the receiver.
 */
- (NSString*) functionDescription;

@end
