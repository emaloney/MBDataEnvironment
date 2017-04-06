//
//  MBMLFunction.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 9/15/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import "MBConditionalDeclaration.h"
#import "MBExpressionError.h"

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

//!< functions are called as ^functionName(optional-parameters) from MBML
extern NSString* const  __nonnull kMBMLFunctionInputNone;                  //!< @"none" - function takes no input parameters
extern NSString* const  __nonnull kMBMLFunctionInputRaw;                   //!< @"raw" - function takes as input the raw (uninterpreted) string between the parentheses
extern NSString* const  __nonnull kMBMLFunctionInputString;                //!< @"string" - function takes as input an expression that will be evaluated as a string
extern NSString* const  __nonnull kMBMLFunctionInputObject;                //!< @"object" - function takes as input an expression that will be evaluated as an object
extern NSString* const  __nonnull kMBMLFunctionInputMath;                  //!< @"math" - function takes as input an expression that will be evaluated as a math expression
extern NSString* const  __nonnull kMBMLFunctionInputPipedExpressions;      //!< @"pipedExpressions" - function input is parsed as an expression (but not interpreted) and split at pipe delimeters in the outermost parenthetical scope, resulting in an array of one or more expressions 
extern NSString* const  __nonnull kMBMLFunctionInputPipedStrings;          //!< @"pipedStrings" - function input is first parsed as an expression (but not interpreted) and split at pipe delimeters in the outermost parenthetical scope; then, string evaluation is performed on each item resulting in an array
extern NSString* const  __nonnull kMBMLFunctionInputPipedObjects;          //!< @"pipedObjects" - function input is first parsed as an expression (but not interpreted) and split at pipe delimeters in the outermost parenthetical scope; then, each item is evaluated as an object expression resulting in an array
extern NSString* const  __nonnull kMBMLFunctionInputPipedMath;             //!< @"pipedMath" - function input is first parsed as an expression (but not interpreted) and split at pipe delimeters in the outermost parenthetical scope; then, each item is evaluated as a math expression resulting in an array

extern NSString* const  __nonnull kMBMLFunctionOutputNone;                 //!< @"none" - function output (if any) is ignored
extern NSString* const  __nonnull kMBMLFunctionOutputObject;               //!< @"object" - function returns an object (type 'id'); this is the default if no output type is specified

extern NSString* const  __nonnull kMBMLFunctionInputParameterName;

/******************************************************************************/
#pragma mark Enumerations
/******************************************************************************/

/*!
 Specifies the type of input an `MBMLFunction` implementation expects.
*/
typedef NS_ENUM(NSUInteger, MBMLFunctionInputType) {
    /*! The function input type hasn't yet been set. Used as an initial value
        when processing MBML `<Function>` declarations. */
    MBMLFunctionInputUnset = 0,

    /*! The function accepts no input parameters. The implementing method
        should take no parameters. */
    MBMLFunctionInputNone,

    /*! The function accepts a single uninterpreted string as input. The
        string is passed as-is to the implementing method. */
    MBMLFunctionInputRaw,

    /*! The function accepts a Mockingbird string expression as input. The
        expression will be evaluated and the resulting `NSString` will be passed
        to the implementing method. */
    MBMLFunctionInputString,

    /*! The function accepts a Mockingbird object expression as input. The
        expression will be evaluated and the resulting `NSObject` will be passed
        to the implementing method. */
    MBMLFunctionInputObject,

    /*! The function accepts a Mockingbird math expression as input. The
        expression will be evaluated and the resulting `NSNumber` will be
        passed to the implementing method. */
    MBMLFunctionInputMath,

    /*! The function accepts zero or more pipe-separated Mockingbird
        expressions as input. Each individual expression is passed to the
        implementing method as an element in an `NSArray` The function
        implementation is responsible for evaluating the expressions. */
    MBMLFunctionInputPipedExpressions,

    /*! The function accepts zero or more pipe-separated Mockingbird string
        expressions as input. Each individual expression is evaluated and the
        resulting `NSString`s are passed to the implementing method in an
        `NSArray`. */
    MBMLFunctionInputPipedStrings,

    /*! The function accepts zero or more pipe-separated Mockingbird object
        expressions as input. Each individual expression is evaluated and the
        resulting `NSObject`s are passed to the implementing method in an
        `NSArray`. */
    MBMLFunctionInputPipedObjects,

    /*! The function accepts zero or more pipe-separated Mockingbird math
        expressions as input. Each individual expression is evaluated and the
        resulting `NSNumber`s are passed to the implementing method in an
        `NSArray`. */
    MBMLFunctionInputPipedMath,

    /*! The function input type used by default: `MBMLFunctionInputObject`. */
    MBMLFunctionInputDefault = MBMLFunctionInputObject
};

/*!
 Specifies the type of output an `MBMLFunction` implementation returns.
*/
typedef NS_ENUM(NSUInteger, MBMLFunctionOutputType) {
    /*! The function output type hasn't yet been set. Used as an initial value
        when processing MBML `<Function>` declarations. */
    MBMLFunctionOutputUnset = 0,

    /*! The function returns no output. The implementing method should
        return `void`; any return value is ignored. */
    MBMLFunctionOutputNone,

    /*! The function returns an object instance as output. */
    MBMLFunctionOutputObject,

    /*! The function input type used by default: `MBMLFunctionOutputObject`. */
    MBMLFunctionOutputDefault = MBMLFunctionOutputObject
};

/******************************************************************************/
#pragma mark -
#pragma mark MBMLFunction class
/******************************************************************************/

/*!
 Represents an Objective-C method that is exposed to the Mockingbird environment
 as an MBML function.
 
 MBML functions allow native Objective-C code to be called from within
 Mockingbird expressions. When an expression containing a function call is
 evaluated, the implementing method of the function is executed, and the
 value returned by the method (if any) is yielded by the function. Values
 returned by function implementations can then be manipulated further within
 an expression.
 
 Functions can take zero or more input parameters, and they may return an
 object instance as a result.
 
 ### Calling Functions

 Function calls begin with a caret character ('`^`'), followed by the name of
 the function, and end in a list of zero or more pipe-separated parameters 
 surrounded by parentheses.
 
 For example, to call a function that creates an array, you could write:
 
    ^array(pizza|pasta|sushi|lobster)
 
 The function above returns an `NSArray` containing four items: the strings
 "`pizza`", "`pasta`", "`sushi`" and "`lobster`".
 
 Because this particular expression yields an object, we can access values in
 the returned object as if it were a regular Mockingbird object reference. To
 access the fourth element in the (zero-indexed) array, you would write:
 
    ^array(pizza|pasta|sushi|lobster)[3]
 
 This expression yields the value "`lobster`".
 
 ### Implementing Functions

 MBML functions are implemented as Objective-C class methods. MBML functions
 that accept multiple parameters will receive those values in an array. The
 `MBMLFunction` class handles the marshalling of parameters to the function
 implementation. Precisely how parameters are handled depends on the function's
 input type, as discussed below.
 
 The class method that implements an MBML function typically returns an
 `id` type. Functions that fail to execute to completion due to an error
 will signal that error by returning an `MBMLFunctionError` instance. The 
 `MBMLFunction` class inspects the value returned by the function implementation
 to determine whether an error occurred.
 
 When a function returns an `MBMLFunctionError`, it causes the entire expression
 to fail evaluatation, and the error will bubble up to the caller (if the caller
 opted to handle errors directly) or will be logged to the console.
 
 Under normal conditions, the value returned by the function implementation
 becomes the value yielded by the function call within the expression.

 ### Declaring Functions

 A standard set of MBML functions is included in the Mockingbird Data 
 Environment by default, declared in <code>MBDataEnvironmentModule.xml</code>.
 You can inspect this file to see how functions are declared in MBML, and to
 find the implementing class methods for examples of how functions are
 written.

 You can also expose your own function implementations, either through an
 MBML file, or programmatically by creating an `MBMLFunction` instance and
 passing it to `[MBVariableSpace declareFunction:]`.

 In an MBML file, a function declaration looks like:
 
    <Function name="functionName"
              class="ImplementingClass" 
              method="methodName" 
              input="inputType"
              output="outputType"/>

 The `<Function>` tag accepts the following attributes:
 
 * `name` - The name of the function as it will be invoked in an expresion;
 a function with the name "`foo`" taking no parameters is called as "`^foo()`".
 The function's name must be a valid Mockingbird *identifier*.
 
 * `class` - Specifies the name of the Objective-C class that implements the
 function.
 
 * `method` - The implementing method, which must be a class method. This 
 attribute is optional if the name of the method is the same as the function
 name. Unlike with Objective-C selectors, colons are *not* considered part of
 the name and therefore should not be included in the declaration.
 
 * `input` - Specifies the type of input the function expects, as described
 below. The `MBMLFunction` class will marshal input parameters accordingly.
 
 * `output` - Specifies the type of output returned by the function.
 
 #### Function Input Type

 The `input` attribute of the `<Function>` declaration in MBML accepts the
 following values:
 
 * `none` - The function accepts no input parameters. The implementing
 method should take no parameters.
 
 * `raw` - The function accepts a single uninterpreted string as input. The
 implementing method should take an `NSString` parameter.
 
 * `string` - The function accepts as input an expression yielding a string.
 Prior to executing the implementing method, the `MBMLFunction` will evaluate
 the input parameter as a string expression, and will pass the result to the
 implementing method. The implementing method should take an `NSString`
 parameter.
 
 * `object` - The function accepts as input an expression yielding an object.
 Prior to executing the implementing method, the `MBMLFunction` will evaluate
 the input parameter as an object expression, and will pass the result to the
 implementing method. The implementing method should take an `NSObject` or
 `id` parameter.
 
 * `math` - The function accepts as input a math expression yielding a numeric
 value. Prior to executing the implementing method, the `MBMLFunction` will 
 evaluate the input parameter as a numeric expression, and will pass the result
 to the implementing method. The implementing method should take an `NSNumber`
 parameter.

 * `pipedExpressions` - The function accepts zero or more expressions as input.
 Prior to executing the implementing method, the `MBMLFunction` will split
 the input at the pipe character ("`|`") resulting in an `NSArray`, which is
 then passed to the implementing method. Note that it is the responsibility
 of the implementing method to evaluate the passed-in expressions.
 
 * `pipedStrings` - The function accepts zero or more expressions yielding
 strings as input. Prior to executing the implementing method, the
 `MBMLFunction` will split the input at the pipe character ("`|`") and then
 evaluate each resulting expression in the string context. The results are
 placed into an `NSArray` which is then passed to the implementing method.
 
 * `pipedObjects` - The function accepts zero or more expressions yielding
 objects as input. Prior to executing the implementing method, the
 `MBMLFunction` will split the input at the pipe character ("`|`") and then
 evaluate each resulting expression in the object context. The results are
 placed into an `NSArray` which is then passed to the implementing method.
 
 * `pipedMath` - The function accepts zero or more math expressions yielding
 numbers as input. Prior to executing the implementing method, the
 `MBMLFunction` will split the input at the pipe character ("`|`") and then
 evaluate each resulting expression in the numeric context. The results are
 placed into an `NSArray` which is then passed to the implementing method.
 
 #### Function Output Type

 The `output` attribute of the `<Function>` declaration in MBML accepts the
 following values:

 * `object` - The function returns an Objective-C object.
 
 * `none` - The function returns no output. This is only needed for functions
 that produce a side-effect but otherwise do not yield meaningful output.
 
 Typically, a function's implementing method is declared to return the type
 `id` rather than a specific type. This is to allow the method to return an
 `MBMLFunctionError` instance to signal an error.
 
 Even if a function is declared with an output type of `none`, the
 implementing method may return `id` in case it needs to signal an error.

 #### Parameter Validation

 `MBMLFunction` declares a number of parmater validation methods to simplify
 error reporting on behalf of function implementations. When a function
 is passed input it isn't expecting, the validation methods provide a mechanism
 to report descriptive errors in a standardized way, while allowing you to
 minimize boilerplate validation code.
 
 Here's an example of the validation code for a hypothetical function that
 takes 2 or 3 parameters and expects the second parameter to be an expression
 that evaluates to an `NSString` instance:
 
    + (id) hypotheticalFunction:(NSArray*)params
    {
        MBMLFunctionError* err = nil;
        NSUInteger paramCnt = [MBMLFunction validateParameter:params 
                                            countIsAtLeast:2
                                                 andAtMost:3
                                                     error:&err];
        NSString* key = [MBMLFunction validateParameter:params
                                     isStringAtIndex:1
                                               error:&err];
        if (err) return err;

        //    ...function implementation follows...
        // it is safe to use 'paramCnt' and 'key' here
    }

 The parameter validation methods are designed so that you don't need to
 check the value of `err` after each call. You will only need to check 
 `err` before using any of the values returned by the the validation
 methods.
 */
@interface MBMLFunction : MBConditionalDeclaration

/*----------------------------------------------------------------------------*/
#pragma mark Properties
/*!    @name Properties                                                       */
/*----------------------------------------------------------------------------*/

/*!
 Returns the name of the function. A function's name determines how it is
 invoked from within an MBML expression.
 */
@property(nullable, nonatomic, readonly) NSString* name;

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
#pragma mark Creating instances
/*!    @name Creating instances                                               */
/*----------------------------------------------------------------------------*/

/*!
 Initializes a new `MBMLFunction` instance.

 @param     name The name of the function.
 
 @param     inputType The function's input type.
 
 @param     outputType The function's output type.
 
 @param     cls The implementing class of the function.
 
 @param     selector The selector of the implementing method.
 
 @return    `self`
 */
- (nullable instancetype) initWithName:(nonnull NSString*)name
                             inputType:(MBMLFunctionInputType)inputType
                            outputType:(MBMLFunctionOutputType)outputType
                     implementingClass:(nonnull Class)cls
                        methodSelector:(nonnull SEL)selector;

/*----------------------------------------------------------------------------*/
#pragma mark Validating parameter lists
/*!    @name Validating parameter lists                                       */
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
            occurred and `*errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    The number of parameters contained in the array, or `0` if
            parameter validation fails.
 */
+ (NSUInteger) validateParameter:(nonnull NSArray*)params countIs:(NSUInteger)expectedCnt error:(MBMLFunctionErrorPtrPtr)errPtr;

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
            occurred and `*errPtr` already contains an error object, further
            parameter validation will **not** be performed.

 @return    The number of parameters contained in the array, or `0` if
            parameter validation fails.
 */
+ (NSUInteger) validateParameter:(nonnull NSArray*)params countIsAtLeast:(NSUInteger)expectedCnt error:(MBMLFunctionErrorPtrPtr)errPtr;

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
            occurred and `*errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    The number of parameters contained in the array, or `0` if
            parameter validation fails.
 */
+ (NSUInteger) validateParameter:(nonnull NSArray*)params countIsAtMost:(NSUInteger)expectedCnt error:(MBMLFunctionErrorPtrPtr)errPtr;

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
            occurred and `*errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    The number of parameters contained in the array, or `0` if
            parameter validation fails.
 */
+ (NSUInteger) validateParameter:(nonnull NSArray*)params countIsAtLeast:(NSUInteger)minCnt andAtMost:(NSUInteger)maxCnt error:(MBMLFunctionErrorPtrPtr)errPtr;

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
            occurred and `*errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    The number of parameters contained in the array, or `0` if
            parameter validation fails.
 */
+ (NSUInteger) validateParameter:(nonnull NSArray*)params indexIsInRange:(NSUInteger)idx error:(MBMLFunctionErrorPtrPtr)errPtr;

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
            occurred and `*errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the parameter at the given array index is
            returned. If validation fails, `nil` is returned.
 
 @warning   For performance reasons, this method does not attempt to validate
            the provided array index, and an exception will occur if the index
            is out-of-range for the parameter array. Therefore, to avoid 
            problems, you should always validate the parameter count of the
            array prior to calling this method.
 */
+ (nullable id) validateParameter:(nonnull NSArray*)params objectAtIndex:(NSUInteger)idx isKindOfClass:(nonnull Class)cls error:(MBMLFunctionErrorPtrPtr)errPtr;

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
            occurred and `*errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the parameter at the given array index is
            returned. If validation fails, `nil` is returned.
  
 @warning   For performance reasons, this method does not attempt to validate
            the provided array index, and an exception will occur if the index
            is out-of-range for the parameter array. Therefore, to avoid 
            problems, you should always validate the parameter count of the
            array prior to calling this method.
*/
+ (nullable Class) validateParameter:(nonnull NSArray*)params objectAtIndex:(NSUInteger)idx isOneKindOfClass:(nonnull NSArray*)classes error:(MBMLFunctionErrorPtrPtr)errPtr;

/*!
 Validates a function's parameter list array to ensure that an object at a
 given array index is a string. Validation will fail if the parameter at the
 specified index is not an `NSString` instance.
 
 @param     params An array containing the function's input parameters.
 
 @param     idx The array index of the parameter being validated.
  
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `*errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the string at the given array index is
            returned. If validation fails, `nil` is returned.
  
 @warning   For performance reasons, this method does not attempt to validate
            the provided array index, and an exception will occur if the index
            is out-of-range for the parameter array. Therefore, to avoid 
            problems, you should always validate the parameter count of the
            array prior to calling this method.
*/
+ (nullable NSString*) validateParameter:(nonnull NSArray*)params isStringAtIndex:(NSUInteger)idx error:(MBMLFunctionErrorPtrPtr)errPtr;

/*!
 Validates a function's parameter list array to ensure that an object at a
 given array index is a number. Validation will fail if the parameter at the
 specified index is not a numeric value.
 
 @param     params An array containing the function's input parameters.
 
 @param     idx The array index of the parameter being validated.
  
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `*errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the number at the given array index is
            returned. If validation fails, `nil` is returned.
  
 @warning   For performance reasons, this method does not attempt to validate
            the provided array index, and an exception will occur if the index
            is out-of-range for the parameter array. Therefore, to avoid 
            problems, you should always validate the parameter count of the
            array prior to calling this method.
*/
+ (nullable NSDecimalNumber*) validateParameter:(nonnull NSArray*)params containsNumberAtIndex:(NSUInteger)idx error:(MBMLFunctionErrorPtrPtr)errPtr;

/*!
 Validates a function's parameter list array to ensure that an object at a
 given array index is an array. Validation will fail if the parameter at the
 specified index is not an `NSArray` instance.
 
 @param     params An array containing the function's input parameters.
 
 @param     idx The array index of the parameter being validated.
  
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `*errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the array at the given array index is
            returned. If validation fails, `nil` is returned.
  
 @warning   For performance reasons, this method does not attempt to validate
            the provided array index, and an exception will occur if the index
            is out-of-range for the parameter array. Therefore, to avoid 
            problems, you should always validate the parameter count of the
            array prior to calling this method.
*/
+ (nullable NSArray*) validateParameter:(nonnull NSArray*)params isArrayAtIndex:(NSUInteger)idx error:(MBMLFunctionErrorPtrPtr)errPtr;

/*!
 Validates a function's parameter list array to ensure that an object at a
 given array index is a dictionary. Validation will fail if the parameter at the
 specified index is not an `NSDictionary` instance.
 
 @param     params An array containing the function's input parameters.
 
 @param     idx The array index of the parameter being validated.
  
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `*errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the dictionary at the given array index is
            returned. If validation fails, `nil` is returned.
  
 @warning   For performance reasons, this method does not attempt to validate
            the provided array index, and an exception will occur if the index
            is out-of-range for the parameter array. Therefore, to avoid 
            problems, you should always validate the parameter count of the
            array prior to calling this method.
*/
+ (nullable NSDictionary*) validateParameter:(nonnull NSArray*)params isDictionaryAtIndex:(NSUInteger)idx error:(MBMLFunctionErrorPtrPtr)errPtr;

/*----------------------------------------------------------------------------*/
#pragma mark Validating individual parameters
/*!    @name Validating individual parameters                                 */
/*----------------------------------------------------------------------------*/

/*!
 Validates a function's input parameter to ensure that the object is an instance
 of an expected class. Validation will fail if the parameter is not a kind of
 the expected class.
 
 @param     param The function's input parameter.
 
 @param     cls The expected class of the input parameter.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `*errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the parameter object is returned. If 
            validation fails, `nil` is returned.
 */
+ (nullable id) validateParameter:(nonnull id)param isKindOfClass:(nonnull Class)cls error:(MBMLFunctionErrorPtrPtr)errPtr;

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
            occurred and `*errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the parameter object is returned. If 
            validation fails, `nil` is returned.
 */
+ (nullable Class) validateParameter:(nonnull id)param isOneKindOfClass:(nonnull NSArray*)classes error:(MBMLFunctionErrorPtrPtr)errPtr;

/*!
 Validates a function's input parameter to ensure that the object responds
 to the provided selector. Validation will fail if the object does not
 respond to that selector.
 
 @param     param The function's input parameter.
 
 @param     selector The selector to test against the input parameter.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `*errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the parameter object is returned. If 
            validation fails, `nil` is returned.
 */
+ (nullable id<NSObject>) validateParameter:(nonnull id<NSObject>)param respondsToSelector:(nonnull SEL)selector error:(MBMLFunctionErrorPtrPtr)errPtr;

/*!
 Validates a function's input parameter to ensure that it is a string. 
 Validation will fail if the parameter is not an `NSString` instance.
 
 @param     param The function's input parameter.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `*errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the parameter string is returned. If 
            validation fails, `nil` is returned.
 */
+ (nullable NSString*) validateParameterIsString:(nonnull id)param error:(MBMLFunctionErrorPtrPtr)errPtr;

/*!
 Validates a function's input parameter to ensure it contains a numeric value. 
 Validation will fail if the parameter is not a number.
 
 @param     param The function's input parameter.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `*errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the parameter number is returned. If 
            validation fails, `nil` is returned.
 */
+ (nullable NSDecimalNumber*) validateParameterContainsNumber:(nonnull id)param error:(MBMLFunctionErrorPtrPtr)errPtr;

/*!
 Validates a function's input parameter to ensure it is an array. 
 Validation will fail if the parameter is not an `NSArray` instance.
 
 @param     param The function's input parameter.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `*errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the parameter array is returned. If 
            validation fails, `nil` is returned.
 */
+ (nullable NSArray*) validateParameterIsArray:(nonnull id)param error:(MBMLFunctionErrorPtrPtr)errPtr;

/*!
 Validates a function's input parameter to ensure it is a dictionary. 
 Validation will fail if the parameter is not an `NSDictionary` instance.
 
 @param     param The function's input parameter.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `*errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the parameter dictionary is returned. If 
            validation fails, `nil` is returned.
 */
+ (nullable NSDictionary*) validateParameterIsDictionary:(nonnull id)param error:(MBMLFunctionErrorPtrPtr)errPtr;

/*----------------------------------------------------------------------------*/
#pragma mark Validating parameters for functions taking piped expressions
/*!    @name Validating parameters for functions taking piped expressions     */
/*----------------------------------------------------------------------------*/

/*!
 Validates an expression parameter list to ensure that the expression at the
 specified array index yields an `NSString` when evaluated.
 
 This method is intended to be used by functions declared with an `inputType`
 of `MBMLFunctionInputPipedExpressions`.

 @param     params An array containing the function's input parameters.
 
 @param     idx The array index of the parameter being validated.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `*errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the string resulting from evaluating the
            expression at the specified parameter index is returned. If 
            validation fails, `nil` is returned.

 @warning   For performance reasons, this method does not attempt to validate
            the provided array index, and an exception will occur if the index
            is out-of-range for the parameter array. Therefore, to avoid 
            problems, you should always validate the parameter count of the
            array prior to calling this method.
 */
+ (nullable NSString*) validateExpression:(nonnull NSArray*)params isStringAtIndex:(NSUInteger)idx error:(MBMLFunctionErrorPtrPtr)errPtr;

/*!
 Validates an expression parameter list to ensure that the expression at the
 specified array index yields a numeric value when evaluated.
 
 This method is intended to be used by functions declared with an `inputType`
 of `MBMLFunctionInputPipedExpressions`.

 @param     params An array containing the function's input parameters.
 
 @param     idx The array index of the parameter being validated.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `*errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the number resulting from evaluating the
            expression at the specified parameter index is returned. If 
            validation fails, `nil` is returned.

 @warning   For performance reasons, this method does not attempt to validate
            the provided array index, and an exception will occur if the index
            is out-of-range for the parameter array. Therefore, to avoid 
            problems, you should always validate the parameter count of the
            array prior to calling this method.
 */
+ (nullable NSDecimalNumber*) validateExpression:(nonnull NSArray*)params containsNumberAtIndex:(NSUInteger)idx error:(MBMLFunctionErrorPtrPtr)errPtr;

/*!
 Validates an expression parameter list to ensure that the expression at the
 specified array index yields an `NSArray` when evaluated.

 This method is intended to be used by functions declared with an `inputType`
 of `MBMLFunctionInputPipedExpressions`.

 @param     params An array containing the function's input parameters.
 
 @param     idx The array index of the parameter being validated.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `*errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the array resulting from evaluating the
            expression at the specified parameter index is returned. If 
            validation fails, `nil` is returned.

 @warning   For performance reasons, this method does not attempt to validate
            the provided array index, and an exception will occur if the index
            is out-of-range for the parameter array. Therefore, to avoid 
            problems, you should always validate the parameter count of the
            array prior to calling this method.
 */
+ (nullable NSArray*) validateExpression:(nonnull NSArray*)params isArrayAtIndex:(NSUInteger)idx error:(MBMLFunctionErrorPtrPtr)errPtr;

/*!
 Validates an expression parameter list to ensure that the expression at the
 specified array index yields an `NSDictionary` when evaluated.
 
 This method is intended to be used by functions declared with an `inputType`
 of `MBMLFunctionInputPipedExpressions`.
  
 @param     params An array containing the function's input parameters.
 
 @param     idx The array index of the parameter being validated.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if parameter validation fails. Note that
            this must not be a `nil` value. If a previous validation error
            occurred and `*errPtr` already contains an error object, further
            parameter validation will **not** be performed.
 
 @return    If validation succeeds, the dictionary resulting from evaluating 
            the expression at the specified parameter index is returned. If 
            validation fails, `nil` is returned.

 @warning   For performance reasons, this method does not attempt to validate
            the provided array index, and an exception will occur if the index
            is out-of-range for the parameter array. Therefore, to avoid 
            problems, you should always validate the parameter count of the
            array prior to calling this method.
 */
+ (nullable NSDictionary*) validateExpression:(nonnull NSArray*)params isDictionaryAtIndex:(NSUInteger)idx error:(MBMLFunctionErrorPtrPtr)errPtr;

/*----------------------------------------------------------------------------*/
#pragma mark Function execution
/*!    @name Function execution                                               */
/*----------------------------------------------------------------------------*/

/*!
 Called by the expression engine to execute the function.
 
 @param     input The input parameter(s) for the function.
 
 @param     errPtr A memory location where a pointer to an `MBMLFunctionError`
            instance will be placed if function execution fails.
 
 @return    The function's return value. `nil` is returned if an error occurred
            while executing the function.
 */
- (nullable id) executeWithInput:(nullable id)input error:(MBMLFunctionErrorPtrPtr)errPtr;

/*----------------------------------------------------------------------------*/
#pragma mark Debugging output
/*!    @name Debugging output                                                 */
/*----------------------------------------------------------------------------*/

/*!
 Returns a human-readable description of the receiver.
 */
- (nonnull NSString*) functionDescription;

@end
