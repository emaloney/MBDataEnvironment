//
//  MBMLDataProcessingFunctions.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 8/8/11.
//  Copyright (c) 2011 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************************************/
#pragma mark -
#pragma mark MBMLDataProcessingFunctions class
/******************************************************************************/

/*!
 This class provides a set of MBML functions for manipulating data structures.

 ### Terminology
 
 **Collection objects:** Where objects are referred to as *collections*, any
 object implementing `NSFastEnumeration` may be used. Typically, collections
 are `NSDictionary`, `NSArray` or `NSSet` instances.

 ### About function declarations

 These functions are exposed to the Mockingbird environment via
 `<Function ... />` declarations in the <code>MBDataEnvironmentModule.xml</code>
 file.

 For more information on MBML functions, see the `MBMLFunction` class.
 */
@interface MBMLDataProcessingFunctions : NSObject

/*----------------------------------------------------------------------------*/
#pragma mark Testing collections
/*!    @name Testing collections                                              */
/*----------------------------------------------------------------------------*/

/*!
 Determines whether one or more *collections* contains a specified *value*.

 This Mockingbird function accepts two or more pipe-separated expressions as 
 parameters:
 
 * One or more *collections*, object expressions yielding collection instances.
 
 * The *test value*, an object expression yielding the value be used to test
 equality with the values in the passed-in *collections*.
 
 **Note:** This method tests equality using `[MBExpression value:isEqualTo:]`,
 not the standard `isEqual:` method. This allows implicit type conversions to
 occur, so that an `NSNumber` containing the integer `5` is considered equal
 to an `NSString` containing the text "`5`".

 #### Expression usage
 
    ^containsValue($colorsOne|$colorsTwo|yellow)
 
 The expression above will evaluate to `true` if either `$colorsOne` or
 `$colorsTwo` contains an item whose value is the string "`yellow`".
 
 @param     params The function's input parameters.

 @return    `@YES` if any of the input *collections* contains the *test value*;
            `@NO` otherwise.
 
 @see       setContains:, collectionPassesTest:, valuesPassingTest:,
            valuesIntersect:
 */
+ (id) containsValue:(NSArray*)params;

/*!
 Determines whether an `NSSet` contains a given object.
 
 Because this function is optimized to work with `NSSet` instances, it is
 more efficient than using `^containsValue()` for the same purpose.

 This function accepts two pipe-separated expressions as parameters:
 
 * The *set*, an object expression yielding an `NSSet` instance.
 
 * The *test value*, an object expression yielding the value whose presence
 within *set* is to be detected.

 #### Expression usage
 
 Assume that the MBML variable `$colors` is a set containing the values "`red`",
 "`yellow`", "`green`", and "`blue`":
 
    ^setContains($colors|orange)
 
 The expression above would evaluate to `false` because `$colors` does not 
 contain the value "`orange`".
 
 @param     params The function's input parameters.
 
 @return    `@YES` if the input *set* contains the *test value*; `@NO`
            otherwise.
 
 @see       containsValue:, collectionPassesTest:, valuesPassingTest:,
            valuesIntersect:
 */
+ (id) setContains:(NSArray*)params;

/*!
 Applies a boolean expression *test* to each member of a *collection* and
 returns `@YES` if and only if the expression *test* evaluates to `true`
 for every item in the collection.

 This Mockingbird function accepts two pipe-separated expressions as parameters:
 
 * The *collection*, an object expression yielding a collection instance.
 
 * The *test*, a boolean expression that will be used to test each value in the
 passed-in collection.

 **Note:** This method tests equality using `[MBExpression value:isEqualTo:]`,
 not the standard `isEqual:` method. This allows implicit type conversions to
 occur, so that an `NSNumber` containing the integer `5` is considered equal
 to an `NSString` containing the text "`5`".

 #### Expression usage
 
    ^collectionPassesTest($collection|$item.length -GT 0)
 
 The expression above would evaluate to `true` if all the members of
 `$collection` have a length greater than `0`.
 
 @param     params The function's input parameters.

 @return    `@YES` if every item in the collection passes the *test*; `NO`
            otherwise.
 
 @see       valuesPassingTest:, containsValue:, setContains:,   
            valuesIntersect:
 */
+ (id) collectionPassesTest:(NSArray*)params;

/*!
 Evaluates a boolean *test* expression against each value in one or more
 *collections*, and returns an array containing the collection values
 for which *test* evaluates to `true`.
 
 This Mockingbird function accepts two or more pipe-separated expressions
 yielding:

 * One or more *data models*, object expressions yielding collection instances.

 * The *test expression*, an expression that will be evaluated for each
 value in each passed-in data model.

 The test expression can refer to the following pre-defined variables:
 
 * `$item` refers to the value in a collection object that's currently being
 tested.
 
 * When the collection being tested is a dictionary, `$key` can be used to
 access the key associated with the current `$item`.

 #### Expression usage

 Assume that `$articles` and `$videos` are collections whose values each have
 a `displayOrder` attribute:
 
    ^valuesPassingTest($articles|$videos|$item.displayOrder -EQ 1)
 
 The expression above would iterate over all the values in the
 `$articles` and then the `$videos` collection objects, and
 for each value, it would perform a `$item.displayOrder -EQ 1` boolean
 test. Each value in `$articles` and `$videos` for which
 the expression `$item.displayOrder -EQ 1` evaluates to `true` will be
 placed into the array returned by the function.
 
 @param     params The function's input parameters.
 
 @return    An array containing the values in the collections for which the
            test expression evaluates to `true`.
 
 @see       collectionPassesTest:, containsValue:, setContains:, 
            valuesIntersect:
 */
+ (id) valuesPassingTest:(NSArray*)params;

/*!
 Tests whether two collections share at least one value in common.
 
 This Mockingbird function accepts two pipe-separated object expressions
 yielding the collection objects to test.

 #### Expression usage

 Assume that `$boys` is an `NSSet` containing the strings "`Bob`", "`Joe`" and
 "`Pat`", and that `$girls` is an `NSSet` containing the strings "`Alice`", 
 "`Pat`" and "`Sally`".

    ^valuesIntersect($boys|$girls)

 The expression above would evaluate to `true` because both `$boys` and `$girls`
 share a common value: the string "`Pat`".
 
 @param     params The function's input parameters.
 
 @return    `@YES` if the two collection objects share at least one common 
            value, `@NO` if they do not.
 
 @see       collectionPassesTest:, containsValue:, setContains:,
            valuesPassingTest:
 */
+ (id) valuesIntersect:(NSArray*)params;

/*----------------------------------------------------------------------------*/
#pragma mark Joining & splitting strings
/*!    @name Joining & splitting strings                                      */
/*----------------------------------------------------------------------------*/

/*!
 Creates a string by concatenating the string values of the elements in one or
 more collections, using the specified separator string between each value in
 the returned string.
 
 This Mockingbird function accepts two or more pipe-separated expressions as 
 parameters:
 
 * One or more *collections*, object expressions that evaluate to collection
 instances.
 
 * The *separator*, a string expression yielding the separator to be used
 between each value in the returned string.
 
 #### Expression usage

 Assume that `$values` is an array containing the strings "`string1`", 
 "`anotherString`", and "`lastly`":

    ^join($values|, )

 The expression above would yield the string "`string1, anotherString, lastly`".
 
 @param     params The function's input parameters.
 
 @return    A string containing the string values of the items in the
            *collections*, separated by the string specified as the *separator*.
 
 @see       split:, splitLines:
 */
+ (id) join:(NSArray*)params;

/*!
 Creates an array by splitting a string on a given delimeter.
 
 This Mockingbird function accepts two pipe-separated string expressions as
 parameters:
 
 * The *delimiter*, which specifies where the *input string* will be split.

 * The *input string*, which is the string to be split.
 
 #### Expression usage:
 
    ^split(, |Evan, Jesse, Yon)
 
 The expression above would return an array containing three elements:
 "`Evan`", "`Jesse`", and "`Yon`".
 
 @param     params The function's input parameters.
 
 @return    An array containing the components of the split string.
 
 @see       join:, splitLines:
 */
+ (id) split:(NSArray*)params;

/*!
 Creates an array by splitting a string at newlines.
 
 This function accepts a single Mockingbird expression, an expression yielding
 the string to be split.

 #### Expression usage

 Assume that `$lines` is a string containing newlines:
 
    ^splitLines($lines)
 
 The expression above would return an array containing one element for each
 line in `$lines`, where each element contains a single line of text (with
 newlines stripped off).
 
 @param     stringToSplit The string being split.
 
 @return    An `NSArray` containing the individual lines of `stringToSplit`.
 
 @see       split:, join:
 */
+ (id) splitLines:(NSString*)stringToSplit;

/*----------------------------------------------------------------------------*/
#pragma mark Manipulating arrays
/*!    @name Manipulating arrays                                              */
/*----------------------------------------------------------------------------*/

/*!
 Returns a single array containing all the elements in the arrays specified
 in the input parameters.
 
 This Mockingbird function accepts two or more pipe-separated object expressions
 as parameters, where each expression yields an `NSArray` instance.

 #### Expression usage

 Assume that `$array1`, `$array2` and `$array3` resolve to array values:

    ^appendArrays($array1|$array2|$array3)

 The expression above will evaluate to a single array, wherein the returned
 array will contain all the elements of `$array1`, in the same order they 
 appear in the array, followed by the elements of `$array2`, and then those
 of `$array3`.
 
 @param     params The function's input parameters.
 
 @return    An array containing all of the elements in the arrays referenced
            by the passed-in expression parameters.
 */
+ (id) appendArrays:(NSArray*)params;

/*!
 Accepts one or more input arrays and returns a single array containing a
 flattened version of the contents of the input arrays.
 
 Flattening involves removing nested arrays such that all non-arrays contained
 at any level of nesting in the input arrays will become elements in the
 returned array. The returned array will contain no elements that are themselves
 `NSArray` instances.
 
 Flattening is performed with a depth-first traversal of the input arrays.
 
 This Mockingbird function accepts one or more pipe-separated object expressions
 as parameters, where each expression yields an `NSArray` instance.

 #### Expression usage

 Assume that `$nestedArrays` refers to an array wherein each element is 
 another array:

    ^flattenArrays($nestedArrays)
 
 The example above would return an array containing the elements of each array
 contained in `$nestedArrays`.
 
 @param     params The function's input parameters.

 @return    The flattened array.
 */
+ (id) flattenArrays:(NSArray*)params;

/*----------------------------------------------------------------------------*/
#pragma mark Manipulating dictionaries
/*!    @name Manipulating dictionaries                                        */
/*----------------------------------------------------------------------------*/

/*!
 Merges the keys and values contained in multiple dictionaries into a single
 dictionary.

 This Mockingbird function accepts at least two pipe-separated object 
 expressions yielding `NSDictionary` instances as input parameters:
 
 * The *first input dictionary*

 * The *second input dictionary*

 * Zero or more *additional input dictionaries*
 
 The return value will be the result of overlaying the values of each input
 dictionary parameter with the dictionary parameter that preceded it. The
 resulting dictionary will contain keys from all input dictionaries, and if
 there are any duplicate keys, the value from the right-most parameter
 will be selected.
 
 For example, if *second input dictionary* contains a value for a key that's
 also present in *first input dictionary*, the key/value pair from *second input
 dictionary* will overwrite the first.
 
 #### Expression usage

 For example, in the expression:

    ^mergeDictionaries($localUsers|$remoteUsers|$automatedUsers)
 
 The dictionaries yielded by the expressions `$localUsers`, `$remoteUsers` and 
 `$automatedUsers` are merged such that:
 
 * Each key/value pair in `$automatedUsers` will be present in the returned
   dictionary
 
 * For each key in `$remoteUsers` not present in `$automatedUsers`, the 
   key/value in `$remoteUsers` will be present in the returned dictionary
 
 * For each key in `$localUsers` not present in `$remoteUsers` or
   `$automatedUsers`, the key/value in `$localUsers` will be present in the
   returned dictionary

 @param     params The function's input parameters.

 @return    The function result.
 */
+ (id) mergeDictionaries:(NSArray*)params;

/*----------------------------------------------------------------------------*/
#pragma mark Pruning trees
/*!    @name Pruning trees                                                    */
/*----------------------------------------------------------------------------*/

/*!
 Traverses an array-based tree structure, removing any leaves (non-arrays) 
 whose values match a given test expression. The resulting pruned tree is then
 returned in an array.
 
 This Mockingbird function accepts two pipe-separated expressions as parameters:
 
 * The *input array*, an object expression yielding an `NSArray` representing 
 the root of the tree.
 
 * The *test*, a boolean expression that will be evaluated once for each 
 non-array element found while traversing the tree.

 The function will return a tree structure similar to the input structure, but
 where all leaf elements for which *test* evaluates to `true` have been removed.

 #### Expression usage

 Assume that `$input` is an array containing two inner arrays. The first inner
 array contains the strings: "`Bob`", "`Joe`" and "`Pat`"; the second inner
 array contains: "`Alice`", "`Pat`" and "`Sally`".
 
    ^pruneMatchingLeaves($input|$item -EQ Pat)

 The expression above would return an array containing two inner arrays,
 the first having the elements "`Bob`" and "`Joe`", and the second having
 the elements "`Alice`" and "`Sally`".
 
 @param     params The function's input parameters.
 
 @return    The function result.

 @see       pruneNonmatchingLeaves:
*/
+ (id) pruneMatchingLeaves:(NSArray*)params;

/*!
 Traverses an array-based tree structure, removing any leaves (non-arrays) 
 whose values do not match a given test expression. The resulting pruned tree 
 is then returned in an array.
 
 This Mockingbird function accepts two pipe-separated expressions as parameters:
 
 * The *input array*, an object expression yielding an `NSArray` representing 
 the root of the tree.

 * The *test*, a boolean expression that will be evaluated once for each 
 non-array element found while traversing the tree.

 The function will return a tree structure similar to the input structure, but
 where all leaf elements for which *test* evaluates to `false` have been
 removed.

 #### Expression usage

 Assume that `$input` is an array containing two inner arrays. The first inner
 array contains the strings: "`Bob`", "`Joe`" and "`Pat`"; the second inner
 array contains: "`Alice`", "`Pat`" and "`Sally`".

    ^pruneNonmatchingLeaves($input|$item -EQ Pat)
 
 The expression above would return an array containing two inner arrays,
 each with a single element: "`Pat`".
 
 @param     params The function's input parameters.
 
 @return    The function result.

 @see       pruneMatchingLeaves:
 */
+ (id) pruneNonmatchingLeaves:(NSArray*)params;

/*----------------------------------------------------------------------------*/
#pragma mark Extracting data
/*!    @name Extracting data                                                  */
/*----------------------------------------------------------------------------*/

/*!
 Filters a data model by applying a test expression against each item in the
 collection.

 This Mockingbird function accepts two or more pipe-separated expressions as 
 parameters:
 
 * The *data model*, an object expression yielding the collection instance to
 be filtered.

 * Zero or more *intermediate expressions*, which are used to recurse into
 portions of the data model.
 
 * The *test*, a boolean expression used to determine which values pass through
 the filter.
 
 * Finally, an optional *filter behavior*, which can be either
 `matchAtLeastOnce` or `matchAll`. Note that **only** these text literals are
 acceptable values if this parameter is provided; this parameter is not
 evaluated as an expression. If this parameter is omitted, `matchAtLeastOnce` 
 filtering behavior will be used.

 #### Filter behaviors

 Intermediate expressions make it possible to recurse into the data model
 to apply the test expression to values below the top level of the data model.
 
 As a result, when intermediate expressions are used, for any given top-level
 object, the test expression may be applied multiple times.
 
 The filter behavior determines when the top-level object will pass through
 the filter:
 
 * `matchAtLeastOnce`: If *test* is evaluated multiple times for a given
 top-level object, that object will pass through the filter if *test* evaluates 
 to `true` at least once.
 
 * `matchAll`:  If *test* is evaluated multiple times for a given
 top-level object, that object will pass through the filter **only** if *test*
 evaluates to `true` every time.

 If no intermediate expressions are used, *test* will only be evaluated once for
 a given top-level object, so there is no effective difference between the
 behavior of these two options.

 #### Expression usage

 Assume that `$people` is an array of data objects representing people:
 
    ^filter($people|$item.children|$item.aunt|$item.firstName -EQ Jill|matchAll)
 
 The expression above would return all *persons* contained in `$people` where
 every aunt of every child of the *person* has the first name "`Jill`".
 
 The `matchAll` parameter can be omitted to return every *person* with at least
 one child who has at least one aunt with the first name "`Jill`".
 
 @param     params The function's input parameters.
 
 @return    An array or dictionary containing the filtered items. If the *data
            model* collection is a dictionary, the returned value will be a
            dictionary. Otherwise, an array will be returned.
 */
+ (id) filter:(NSArray*)params;

/*!
 Iterates over (and potentially recurses into) the items in a collection object 
 holding an arbitrary data model, and returns an `NSArray` containing a list of
 values. The values in the returned array will reflect the ordering of any
 arrays iterated; however, iterating dictionaries or sets will result in 
 non-deterministic ordering.
 
 This Mockingbird function accepts two or more pipe-separated expressions as 
 parameters:
 
 * The *data model*, an object expression yielding the collection object to be
 iterated.

 * Zero or more *intermediate expressions*, which are used to recurse
 into portions of the data model.
 
 * A *value expression*, which will be evaluated once for each item encountered
 while iterating the data model and recursing into any intermediate expressions.
 
 The function will return an array containing the result of evaluating the
 *value expression* once for each item encountered while traversing the data
 model.

 #### Expression usage

 Assume that `$states` is a dictionary where each item in the dictionary 
 represents a state. The key for each item is the two-letter postal code for the
 state, and the value associated with each key is another dictionary containing 
 additional information about the state.
 
    ^list($states
         |$item.citiesBySize
         |$item.name, $root:key - $item.population residents)
 
 The expression above would iterate over all the elements in the `$states`
 dictionary, and for each state, it would then iterate over the elements 
 contained in the states's `cityBySize` property, which in this case is an
 ordered array of cities in the state sorted by population.

 For each city in each state's `cityBySize`, the returned array would
 contain a string with values such as:
 
    New York, NY - 8,391,881 residents
  
 @param     params The function's input parameters.
 
 @return    The function result.
 */
+ (id) list:(NSArray*)params;

/*!
 Associates a set of keys with values by iterating over (and potentially
 recursing into) a collection object holding an arbitrary data model. If the
 association would result in more than one value for a given key, the multiple 
 values will be placed into an array.

 This Mockingbird function accepts three or more pipe-separated expressions as
 parameters:
 
 * The *data model*, an object expression yielding a *collection* to be
 used as the source for the keys and values in the returned dictionary.

 * Zero or more *intermediate expressions*, which are used to recurse
 into portions of the data model.
 
 * The second-to-last expression in the input parameters is the *key
 expression*, which yields the keys contained in the returned dictionary.
 
 * The last expression is the *value expression*, which yields the values
 contained in the returned dictionary.

 The intermediate, key and value expressions can refer to portions of the
 data model using several pre-defined variables:
 
 * `$item` refers to the value of the current item in the innermost
 scope being iterated/recursed.
 
 * When iterating the values of a dictionary, the `$key` variable
 can be used to access the key associated with the current `$item`.
 
 * `$root` contains the value of the current item being iterated
 at the top level of the data model.
 
 * When the data model collection is a dictionary, `$rootKey` will contain the
 key associated with the current `$root` value.
 
 * In addition, when intermediate expressions are used to recurse into the
 data model, you can refer to items and keys contained in the outer scopes
 using the prefix `outer:` in the variable name, such as `$outer:key` or
 `$outer:item`. This prefix can also be compounded (eg.: `$outer:outer:key`)
 to reach different levels of scope.

 #### Expression usage

 Assume that `$people` is an array of data objects representing people:
 
    ^associate($people|$item.children|$item.fullName|$root)
 
 The expression above would iterate over all the values in `$people`, and for
 each person, it would then iterate over the elements contained in the person's
 `children` array. For each of those children, it would create an association
 between the *key*—the value of that child's `fullName` attribute—and the
 *value*—the `$root` item (the current person in the iteration from `$people`).

 In other words, the expression above would create a dictionary where the keys 
 are the full names of children, and the value of each key is the item in
 `$people` representing that child's parent.

 In the event that more than one child has a given full name, the corresponding
 value in the dictionary will be an array.

 @param     params The function's input parameters.
 
 @return    The function result.

 @see       associateWithArray:, associateWithSingleValue:
 */
+ (id) associate:(NSArray*)params;

/*!
 Associates a set of keys with values by iterating over (and potentially
 recursing into) a collection object holding an arbitrary data model. If the
 association would result in more than one value for a given key, additional 
 values are ignored and only one value will be returned. Assume 
 non-deterministic behavior for multiple values.

 This Mockingbird function accepts three or more pipe-separated expressions as
 parameters:
 
 * The *data model*, an object expression yielding a *collection* to be
 used as the source for the keys and values in the returned dictionary.

 * Zero or more *intermediate expressions*, which are used to recurse
 into portions of the data model.
 
 * The second-to-last expression in the input parameters is the *key
 expression*, which yields the keys contained in the returned dictionary.
 
 * The last expression is the *value expression*, which yields the values
 contained in the returned dictionary.

 The intermediate, key and value expressions can refer to portions of the
 data model using several pre-defined variables:
 
 * `$item` refers to the value of the current item in the innermost
 scope being iterated/recursed.
 
 * When iterating the values of a dictionary, the `$key` variable
 can be used to access the key associated with the current `$item`.
 
 * `$root` contains the value of the current item being iterated
 at the top level of the data model.
 
 * When the data model collection is a dictionary, `$rootKey` will contain the
 key associated with the current `$root` value.
 
 * In addition, when intermediate expressions are used to recurse into the
 data model, you can refer to items and keys contained in the outer scopes
 using the prefix `outer:` in the variable name, such as `$outer:key` or
 `$outer:item`. This prefix can also be compounded (eg.: `$outer:outer:key`)
 to reach different levels of scope.

 #### Expression usage

 Assume that `$people` is an array of data objects representing people:
 
    ^associateWithSingleValue($people|$item.children|$item.fullName|$root)
 
 The expression above would iterate over all the values in `$people`, and for
 each person, it would then iterate over the elements contained in the person's 
 `children` array. For each of those children, it would create an association
 between the *key*—the value of that child's `fullName` attribute—and the
 *value*—the `$root` item (the current person in the iteration from `$people`).
 
 In other words, the expression above would create a dictionary where the keys 
 are the full names of children, and the value of each key is the item in
 `$people` representing that child's parent.
 
 Because this function associates a given key with at most one value, in the 
 event that more than one child has a given full name, some values will be 
 ignored.

 @param     params The function's input parameters.

 @return    The function result.

 @see       associateWithArray:, associate:
 */
+ (id) associateWithSingleValue:(NSArray*)params;

/*!
 Associates a set of keys with values by iterating over (and potentially
 recursing into) a collection object holding an arbitrary data model. The
 value of each key will always be an array, even if the key only maps to a
 single value.

 This Mockingbird function accepts three or more pipe-separated expressions as
 parameters:
 
 * The *data model*, an object expression yielding a *collection* to be
 used as the source for the keys and values in the returned dictionary.

 * Zero or more *intermediate expressions*, which are used to recurse
 into portions of the data model.
 
 * The second-to-last expression in the input parameters is the *key
 expression*, which yields the keys contained in the returned dictionary.
 
 * The last expression is the *value expression*, which yields the values
 contained in the returned dictionary.

 The intermediate, key and value expressions can refer to portions of the
 data model using several pre-defined variables:
 
 * `$item` refers to the value of the current item in the innermost
 scope being iterated/recursed.
 
 * When iterating the values of a dictionary, the `$key` variable
 can be used to access the key associated with the current `$item`.
 
 * `$root` contains the value of the current item being iterated
 at the top level of the data model.
 
 * When the data model collection is a dictionary, `$rootKey` will contain the
 key associated with the current `$root` value.
 
 * In addition, when intermediate expressions are used to recurse into the
 data model, you can refer to items and keys contained in the outer scopes
 using the prefix `outer:` in the variable name, such as `$outer:key` or
 `$outer:item`. This prefix can also be compounded (eg.: `$outer:outer:key`)
 to reach different levels of scope.

 #### Expression usage

 Assume that `$people` is an array of data objects representing people:
 
    ^associateWithArray($people|$item.children|$item.fullName|$root)
 
 The expression above would iterate over all the values in `$people`, and for
 each person, it would then iterate over the elements contained in the person's 
 `children` array. For each of those children, it would create an association
 between the *key*—the value of that child's `fullName` attribute—and the
 *value*—the `$root` item (the current person in the iteration from `$people`).

 In other words, the expression above would create a dictionary where the keys 
 are the full names of children, and the value of each key is the item in
 `$people` representing that child's parent.
 
 Regardless of whether or not a given key has multiple values, each key
 in the returned dictionary will have an array value.

 @param     params The function's input parameters.

 @return    The function result.

 @see       associate:, associateWithSingleValue:
 */
+ (id) associateWithArray:(NSArray*)params;

/*----------------------------------------------------------------------------*/
#pragma mark Sorting
/*!    @name Sorting                                                          */
/*----------------------------------------------------------------------------*/

/*!
 Returns an array containing the sorted values of a collection object.
 
 This Mockingbird function accepts between one and three expressions as
 input parameters:
 
 * The *data model*, an object expression yielding the collection object whose
   sorted values are to be returned.

 * An optional *sort key*, an expression indicating the value within *data
   model* that should be used for the basis of sorting. If omitted, the
   default value is `$item`, meaning that the value itself should be
   used for sorting. Subvalues of `$item` may also be specified. This
   parameter must be provided when the *descending order specifier* 
   parameter is used.
 
 * An optional *descending order specifier*. If this string expression yields
   the value "`desc`", sorting will occur in descending order. If this 
   parameter is omitted or if the value is anything else, sorting will occur
   in the default ascending order.

 Note that this method sorts using MBML logical comparators, the behavior
 of which differs from that of the `compare:` method due to Mockingbird's
 use of implicit type conversions. The comparison mechanism used is exposed
 via the `[MBExpression compareLeftValue:againstRightValue:]` method.

 #### Expression usage

 Assume `$buildings` represents a collection object whose members have a
 `height` property indicating the corresponding building's height in feet:

    ^sort($buildings|$item.height|desc)
 
 The expression above would return an array containing each item in `$building`
 sorted from tallest to shortest.

    ^sort(^array(z|x|a|c|y|b))

 The expression above yields the array: ["`a`", "`b`", "`c`", "`x`", "`y`", 
 "`z`"].

 @param     params The function's input parameters.

 @return    The function result.
 */
+ (id) sort:(NSArray*)params;

/*----------------------------------------------------------------------------*/
#pragma mark Removing duplicate values
/*!    @name Removing duplicate values                                        */
/*----------------------------------------------------------------------------*/

/*!
 Iterates over the values supplied by the passed-in enumerator, and returns an
 array containing the unique values encountered.
 
 This function accepts a single Mockingbird expression, an *input collection*
 that is expected to yield an object conforming to the `NSFastEnumeration` 
 protocol.

 The values in the returned array will be in the same order that they were
 supplied by the enumeration.
 
 #### Expression usage

 Assume that `$animals` is an array with three elements: the strings "`Duck`",
 "`Duck`" and "`Goose`".
 
    ^unique($animals)
 
 The expression above would return an array containing two strings: "`Duck`"
 and "`Goose`", in that order.
 
 @param     param The function's input parameter.
 
 @return    An array containing the unique values in the input collection.
 */
+ (id) unique:(id)param;

/*----------------------------------------------------------------------------*/
#pragma mark Reversing the contents of an array
/*!    @name Reversing the contents of an array                               */
/*----------------------------------------------------------------------------*/

/*!
 Returns a new `NSArray` by reversing the order of the items in the passed-in
 array.

 This function accepts as a parameter a single Mockingbird object expression,
 the *input array*, which is expected to yield an `NSArray` instance.

 #### Expression usage

 Assume that `$animals` is an array with three elements: the strings "`Duck`",
 "`Duck`" and "`Goose`".

    ^reverse($animals)

 The expression above would return an array containing the strings "`Goose`", 
 "`Duck`" and "`Duck`" in that order.

 @param     param The function's input parameter.

 @return    An array containing the reversed values of the input array.
 */
+ (id) reverse:(id)param;

/*----------------------------------------------------------------------------*/
#pragma mark Reducing an array of items
/*!    @name Reducing an array of items                                       */
/*----------------------------------------------------------------------------*/

/*!
 Reduce an array of items into a single item.
 
 This Mockingbird function accepts 3 pipe-separated expressions as parameters:
 
 * The *source array*, an object expression expected to yield an `NSArray`
   instance

 * The *initial value*, an object expression yielding the initial value for
   the reduce operation

 * The *combining expression*, an object expression yielding the result of
   combining the *current value* with the current item in the array.

 The return value is an array whose items are constructed by iterating over the
 source array and for each item in the array, evaluating the combining 
 expression.
 
 The combining expression may refer to the *current reduced value* using 
 `$currentValue`. The current reduced value is the result of the previous
 evaluation of the combining expression. For the first item in the source
 array, the combining expression has not yet been evaluated, so the
 initial value is used as `$currentValue`.

 #### Expression usage

    ^reduce(^arrayFilledWithIntegers(1|10)|0|#($currentValue + $item))
 
 The expression above would return the result `55`.

 @param     params The function's input parameters.
 
 @return    The result of the reduction.
 */
+ (id) reduce:(NSArray*)params;

/*----------------------------------------------------------------------------*/
#pragma mark Distributing values
/*!    @name Distributing values                                              */
/*----------------------------------------------------------------------------*/

/*!
 Distributes the elements contained in a single input array across multiple
 arrays.
 
 This Mockingbird function accepts two pipe-separated expressions as parameters:

 * The *source array*, an object expression yielding an array.

 * The *returned array count*, a numeric expression specifying the number of
 arrays across which to distribute the elements in *source array*. This 
 expression will be interpreted as integer, and must be `1` or greater.
 
 The *source array* is iterated, and each item it contains is distributed across
 *returned array count* arrays in sequence.
 
 The function will always return the number of arrays specified by *returned 
 array count*. If *source array* contains fewer elements than *returned array
 count*, one or more of the returned arrays will be empty.
 
 #### Expression usage

 Assume that `$newYorkTeams` is an array with five elements: the strings 
 "`Yankees`", "`Mets`", "`Knicks`", `Rangers` and "`Nets`" in that
 order.
 
    ^distributeArrayElements($newYorkTeams|2)

 The expression above would return an array containing two arrays, where the
 first array contains three items ("`Yankees`", "`Knicks`" and "`Nets`") and
 the second array contains two ("`Mets`" and "`Rangers`").
 
 @param     params The function's input parameters.
 
 @return    An array containing *returned array count* arrays containing the
            elements distributed from *source array*.
 
 @see       groupArrayElements:
 */
+ (id) distributeArrayElements:(NSArray*)params;

/*!
 Groups the elements in a single array into multiple arrays.
 
 This Mockingbird function accepts two pipe-separated expressions as parameters:
 
 * The *source array*, an object expression yielding an `NSArray`.

 * The *group size*, a numeric expression specifying the maximum number of items
 to allow in a single group. This expression will be interpreted as integer 
 value, and must be `1` or greater.
 
 The source array is iterated, and for each *group size* number of items
 encountered, a new *group array* is created containing just those items. 

 The return value is an array containing one or more group arrays created while 
 iterating the source array.
 
 Unless *source array* contains an exact multiple of *group size* number of
 items, the last group array will contain fewer than *group size* number of
 items.
 
 #### Expression usage

 Assume that `$newYorkTeams` is an array with five elements: the strings
 "`Yankees`", "`Mets`", "`Knicks`", `Rangers` and "`Nets`" in that
 order.

    ^groupArrayElements($newYorkTeams|2)
 
 The expression above would return an array containing three arrays, where the
 first array contains two items ("`Yankees`" and "`Mets`"), the second array 
 contains two items ("`Knicks`" and "`Rangers`"), and the third array contains 
 one item ("`Nets`").
 
 @param     params The function's input parameters.
 
 @return    An array containing one or more *group arrays*.
 
 @see       distributeArrayElements:
 */
+ (id) groupArrayElements:(NSArray*)params;

@end


