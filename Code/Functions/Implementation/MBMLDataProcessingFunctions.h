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
 
 **Container objects:** Where parameters are referred to as *container
 objects*, the function will accept `NSDictionary`, `NSArray` or `NSSet`
 instances.

 ### About function declarations

 These functions are exposed to the Mockingbird environment via
 `<Function ... />` declarations in the <code>MBDataEnvironmentModule.xml</code>
 file.

 For more information on MBML functions, see the `MBMLFunction` class.
 */
@interface MBMLDataProcessingFunctions : NSObject

/*----------------------------------------------------------------------------*/
#pragma mark Testing containers
/*!    @name Testing containers                                               */
/*----------------------------------------------------------------------------*/

/*!
 Determines whether any of the values contained within one or more container
 objects equals a specified value.
 
 **Note:** This method tests equality through the MBExpression class, not the
 `isEqual:` method. As a result, implicit type conversions occur, allowing
 an `NSNumber` instance containing the integer `5` to equal an `NSString`
 containing the text "`5`". Be forewarned, however: Do not expect normal
 `NSObject` equality test behavior!
 
 This Mockingbird function accepts two or more pipe-separated expressions as 
 parameters:
 
 * One or more *container objects*, expressions that evaluate to array
 or dictionary values
 
 * The *test value*, an expression whose value will be used to test
 equality with the values in the passed-in container(s)
 
 #### Expression usage
 
    ^containsValue($colorsOne|$colorsTwo|yellow)
 
 The expression above would return a boolean true value if either `$colorsOne`
 or `$colorsTwo` contained an item whose value is the string "`yellow`".
 
 @param     params The function's input parameters.

 @return    An `NSNumber` instance containing either the boolean
            value `YES` if any of the input parameters contains the specified
            element, or `NO` otherwise.
 */
+ (id) containsValue:(NSArray*)params;

/*!
 Determines whether a set contains a given object.
 
 Because this function is optimized to work with `NSSet` instances, it is
 more efficient than using `^containsValue()` for the same purpose.

 This function accepts two pipe-separated expressions as parameters:
 
 * A *set* expression, which should yield an `NSSet` instance, and
 
 * An *object* expression, which yields the object whose presence in the
 set is to be tested.
 
 #### Expression usage
 
 Assume that the MBML variable `$colors` is a set containing the values "`red`",
 "`yellow`", "`green`", and "`blue`":
 
    ^setContains($colors|orange)
 
 The expression above would return a boolean `NO`, because `$colors` does
 not contain the value "`orange`".
 
 @param     params The function's input parameters.
 
 @return    An `NSNumber` containing a boolean value indicating the result
            of the function.
 */
+ (id) setContains:(NSArray*)params;

/*!
 Applies a boolean expression test to each member of the passed collection
 and returns whether or not all members passed the test.
 
 **Note:** This method tests equality through the MBExpression class, not the
 `isEqual:` method. As a result, implicit type conversions occur, allowing
 an `NSNumber` instance containing the integer `5` to equal an `NSString`
 containing the text "`5`". Be forewarned, however: Do not expect normal
 `NSObject` equality test behavior!

 This Mockingbird function accepts two pipe-separated expressions as parameters:
 
 * One *container object*
 
 * The *test value*, an expression whose value will be used to test
 against the values in the passed-in container(s)
 
 #### Expression usage
 
    ^collectionPassesTest($collection|$item.length -GT 0)
 
 The expression above would return a boolean true value if all 
 the members of `$collection` pass the Mockingbird expression 
 `$item.length -GT 0`
 
 @param     params The function's input parameters.

 @return    An `NSNumber` instance containing either the boolean
            value `YES` if all of the input collections pass the 
            specified Mockingbird expression, or `NO` otherwise.
 */
+ (id) collectionPassesTest:(NSArray*)params;

/*!
 Tests a boolean expression against the values in one or more container objects,
 and returns an array of values for which the test expression is true.
 
 This Mockingbird function accepts two or more pipe-separated expressions
 yielding:

 * One or more *container objects*

 * The *test expression*, an expression that will be evaluated for each
 value in each container object in the input parameters

 The test expression can refer to the following pre-defined variables:
 
 * `$item` refers to the value in a container object that's 
 currently being tested
 
 * When the container object being tested is a dictionary, `$key` 
 can be used to access the key associated with the current `$item`
 
 * `$root` contains the value of the current item being iterated
 at the top level of the data model

 #### Expression usage

 Assume that `$articles` and `$videos`
 are containers whose values each have a `displayOrder` attribute:
 
    ^valuesPassingTest($articles|$videos|$item.displayOrder -EQ 1)
 
 The expression above would iterate over all the values in the
 `$articles` and then the `$videos` container objects, and 
 for each value, it would perform a `$item.displayOrder -EQ 1` boolean
 test. Each value in `$articles` and `$videos` for which
 the expression `$item.displayOrder -EQ 1` evaluates to true will be
 placed into the array returned by the function.
 
 @param     params The function's input parameters.
 
 @return    An array containing the values in the container objects
            for which the test expression evaluates to true
 */
+ (id) valuesPassingTest:(NSArray*)params;

/*!
 Tests whether two container objects share at least one value in common.
 
 This Mockingbird function accepts two pipe-separated object expressions
 yielding the container objects to test.
 
 The function returns `@YES` if the two container objects share at least
 one common value, `@NO` if they do not.

 #### Expression usage

 Assume that `$boys` is an `NSSet` containing the strings "`Bob`", "`Joe`" and
 "`Pat`", and that `$girls` is an `NSSet` containing the strings "`Alice`", 
 "`Pat`" and "`Sally`".

    ^valuesIntersect($boys|$girls)

 The expression above would return `@YES` because both `$boys` and `$girls`
 share a common value: the string "`Pat`".
 
 @param     params The function's input parameters.
 
 @return    `@YES` if the two container objects share at least one common value,
            `@NO` if they do not.
 */
+ (id) valuesIntersect:(NSArray*)params;

/*----------------------------------------------------------------------------*/
#pragma mark Joining & splitting strings
/*!    @name Joining & splitting strings                                      */
/*----------------------------------------------------------------------------*/

/*!
 Creates a string by concatenating the string values of the elements
 in one or more container objects, using the specified separator
 string between each value in the returned string. 
 
 This Mockingbird function accepts two or more pipe-separated expressions as 
 parameters:
 
 * One or more *container objects*, expressions that evaluate to arrays
 or dictionaries
 
 * The *separator string*, which is placed between each value in the
 returned string
 
 #### Expression usage

 Assume that `$values` is an array containing the strings "`string1`", 
 "`anotherString`", and "`lastly`":

    ^join($values|, )

 The expression above would yield the string "`string1, anotherString, lastly`".
 
 @param     params The function's input parameters.
 
 @return    A string containing the string values of the items in the
            *container objects*, separated by the string specified
            as the *separator string*
 */
+ (id) join:(NSArray*)params;

/*!
 Creates an array by splitting a string on a given delimeter.
 
 This Mockingbird function accepts two pipe-separated expressions as parameters:
 
 * An expression specifying the *delimiter*, which specifies where
 the *input string* will be split

 * An expression specifying the *input string*, which is the
 string to be split 
 
 #### Expression usage:
 
    ^split(, |Evan, Jesse, Yon)
 
 The expression above would return an array containing three elements:
 "`Evan`", "`Jesse`", and "`Yon`".
 
 @param     params The function's input parameters.
 
 @return    An array containing the components of the split string.
 */
+ (id) split:(NSArray*)params;

/*!
 Creates an array by splitting a string at newlines.
 
 This function accepts a single Mockingbird expression, the *input string*
 that will be split on newlines.
 
 #### Expression usage

 Assume that `$lines` is a string containing newlines:
 
    ^splitLines($lines)
 
 The expression above would return an array containing one element for each
 line in `$lines`, where each element contains a single line of text (with
 newlines stripped off).
 
 @param     stringToSplit The string being split.
 
 @return    An `NSArray` containing the individual lines of `stringToSplit`.
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
 Returns a single array containing all the elements of the array(s) specified
 in the parameters, wherein any element that is an array will be flattened
 such that the returned array contains no nested arrays. This does a 
 depth-first traversal of the input parameters.
 
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
 Merges a set of dictionaries into a single dictionary.

 This Mockingbird function accepts at least two pipe-separated object 
 expressions as input parameters:
 
 * The *first input dictionary*, an `NSDictionary` instance

 * The *second input dictionary*, an `NSDictionary` instance

 * Zero or more *additional input dictionaries*, each an `NSDictionary` instance
 
 The return value will be the result of overlaying the values of each input
 dictionary parameter with the dictionary parameter that preceded it. The
 resulting dictionary will contain keys from all input dictionaries, and if
 there are any duplicate keys, the value from the right-most parameter
 will be selected.
 
 For example, if *second input dictionary* contains a value for a key that's
 also present in *first input dictionary*, the key/value pair from *second input
 dictionary* will overwrite the first.
 
 #### Expression usage

    ^mergeDictionaries($localUsers|$remoteUsers|$automatedUsers)
 
 The dictionaries yielded by the expressions `$localUsers`, `$remoteUsers` and 
 `$automatedUsers` are merged such that:
 
 * Each key/value pair in `$automatedUsers` will be present in the returned
   dictionary
 
 * For each key in `$remoteUsers` not present in `$automatedUsers`, the 
   key/value in `$remoteUsers` will be present in the returned dictionary
 

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
 Traverses an array-based tree structure, removing any leaves whose values
 match a given test expression. The resulting pruned tree is then returned.
 
 This Mockingbird function accepts two pipe-separated expressions as parameters:
 
 * The *input array* representing the root of the tree; this expression
 must evaluate to an `NSArray` instance
 
 * The *test expression*, which will be evaluated once for each 
 non-array element found while traversing the tree
 
 The function will return an tree structure similar to the input
 structure, but containing only those non-array elements for which the
 *test expression* evaluates to `NO`.

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
 */
+ (id) pruneMatchingLeaves:(NSArray*)params;

/*!
 Traverses an array-based tree structure, removing any leaves whose values
 do not match a given test expression. The resulting pruned tree is then 
 returned.
 
 This Mockingbird function accepts two pipe-separated expressions as parameters:
 
 * The *input array* representing the root of the tree; this expression
 must evaluate to an `NSArray` instance
 
 * The *test expression*, which will be evaluated once for each 
 non-array element found while traversing the tree
 
 The function will return an tree structure similar to the input
 structure, but containing only those non-array elements for which the
 *test expression* evaluates to `YES`.
 
 #### Expression usage

 Assume that `$input` is an array containing two inner arrays. The first inner
 array contains the strings: "`Bob`", "`Joe`" and "`Pat`"; the second inner
 array contains: "`Alice`", "`Pat`" and "`Sally`".

    ^pruneNonmatchingLeaves($input|$item -EQ Pat)
 
 The expression above would return an array containing two inner arrays,
 each with a single element: "`Pat`".
 
 @param     params The function's input parameters.
 
 @return    The function result.
 */
+ (id) pruneNonmatchingLeaves:(NSArray*)params;

/*----------------------------------------------------------------------------*/
#pragma mark Extracting data
/*!    @name Extracting data                                                  */
/*----------------------------------------------------------------------------*/

/*!
 Filters a collection object by applying a test expression to the contents
 of each object in the collection. Each top-level object in the collection
 where the test expression evaluates to true according to the rules of
 the filter behavior is returned.

 Because you can recurse into portions of the data model where more than
 one element may exist, the filter may iterate over multiple items for each
 top-level object, and the test expression will get applied multiple times.
 You can specify whether the filter will return items that match at least
 once, or whether all of the existing items must match.
 
 This Mockingbird function accepts two or more pipe-separated expressions as 
 parameters:
 
 * The *data model*, an expression whose value is a container object
 (either an array or dictionary) that will be used as the source for the
 filtering
 
 * Zero or more *intermediate expressions*, which are used to recurse
 into portions of the data model
 
 * A *test expression*, which will be used for the basis of the 
 filtering.
 
 * Finally, an optional *filter behavior*, which can be either 
 `matchAtLeastOnce` or `matchAll` (note that these string
 literals must be used; this parameter is not evaluated). If the parameter is 
 omitted `matchAtLeastOnce` behavior will be used.

 #### Expression usage

 Assume that `$people` is an array of data objects representing people:
 
    ^filter($people|$item.children|$item.aunt|$item.firstName -EQ Jill|matchAll)
 
 The expression above would return all the objects contained in 
 `$people` where every aunt of every child of the person has
 the first name Jill. The `matchAll` parameter can be omitted
 to return every person with at least one child who has at least one aunt
 with the first name Jill.
 
 @param     params The function's input parameters.
 
 @return    An array or dictionary containing the filtered items. The type of
            the object returned will match the *data model* input
            parameter.
 */
+ (id) filter:(NSArray*)params;

/*!
 Iterates over (and potentially recurses into) the items in a container object,
 and returns a list of values. The values in the returned list will reflect the
 ordering of any arrays iterated, however iterating dictionaries will result in 
 non-deterministic ordering.
 
 This Mockingbird function accepts two or more pipe-separated expressions as 
 parameters:
 
 * The *data model*, an expression whose value is a container object
 (either an array or dictionary) that will be iterated
 
 * Zero or more *intermediate expressions*, which are used to recurse
 into portions of the data model
 
 * A *value expression*, which will be evaluated once for each item 
 encountered while iterating the data model and recursing into any
 intermediate expressions.
 
 The function will return an array containing the result of evaluating the
 *value expression* once for each item encountered in the data
 model.

 #### Expression usage

 Assume that `$states` is a map where each item in the map represents a state.
 The key for each item is the two-letter postal code for the state, and the
 value associated with each key is another dictionary containing additional 
 information about the state.
 
    ^list($states|$item.citiesBySize|$item.name, <span>$</span>root:key - $item.population residents)
 
 The expression above would iterate over all the elements in the
 `$states` dictionary, and for each state, it would then iterate over
 the elements contained in the states's `cityBySize` property, which
 in this case is an ordered array of cities in the state sorted by population.
 For each city in each state's `cityBySize`, the returned array would
 contain a string with values such as:
 
    New York, NY - 8,391,881 residents
  
 @param     params The function's input parameters.
 
 @return    The function result.
 */
+ (id) list:(NSArray*)params;

/*!
 Associates a set of keys with values by iterating over (and potentially
 recursing into) a container object holding an arbitrary data model.
 The keys and values of the returned dictionary are constructed based
 on expressions passed to the function.
 
 **Note:** If the association would result in more than one value for a given
 key, the multiple values will be placed into an array, and that array will be
 the value of the key.

 This Mockingbird function accepts three or more pipe-separated expressions as
 parameters:
 
 * The *data model*, an expression whose value is a container object
 (either an array or dictionary) that will be used as the source for the
 returned dictionary
 
 * Zero or more *intermediate expressions*, which are used to recurse
 into portions of the data model
 
 * The second-to-last expression in the input parameters is the *key
 expression*, which is used to construct the keys in the map
 
 * The last expression is the *value expression*, which is used to
 construct the values contained in the map
 
 The intermediate, key and value expressions can refer to portions of the
 data model using several pre-defined variables:
 
 * `$item` refers to the value of the current item in the innermost
 scope being iterated/recursed
 
 * When iterating the values of a dictionary, the `$key` variable
 can be used to access the key associated with the current `$item`
 
 * `$root` contains the value of the current item being iterated
 at the top level of the data model
 
 * When the data model expression refers to a dictionary, `$rootKey`
 will contain the key associated with the current `$root` value.
 
 * In addition, when intermediate expressions are used to recurse into the
 data model, you can refer to items and keys contained in the outer scopes
 using the prefix `outer:` in the variable name, such as
 `$``outer:key` or `$outer:item`. This prefix 
 can also be compounded (eg.: `$outer:outer:key`) to reach different
 levels of scope.
 
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
 recursing into) a container object holding an arbitrary data model.

 The keys and values of the returned dictionary are constructed based
 on expressions passed to the function.
 
 **Note:** If the association would result in more than one value for a given
 key, additional values are ignored and only one value will be returned. Assume
 non-deterministic behavior for multiple values.
 
 This Mockingbird function accepts three or more pipe-separated expressions as parameters:
 
 * The *data model*, an expression whose value is a container object
 (either an array or dictionary) that will be used as the source for the
 returned dictionary
 
 * Zero or more *intermediate expressions*, which are used to recurse
 into portions of the data model
 
 * The second-to-last expression in the input parameters is the *key
 expression*, which is used to construct the keys in the map
 
 * The last expression is the *value expression*, which is used to
 construct the values contained in the map
 
 The intermediate, key and value expressions can refer to portions of the
 data model using several pre-defined variables:
 
 * `$item` refers to the value of the current item in the innermost
 scope being iterated/recursed
 
 * When iterating the values of a dictionary, the `$key` variable
 can be used to access the key associated with the current `$item`
 
 * `$root` contains the value of the current item being iterated
 at the top level of the data model
 
 * When the data model expression refers to a dictionary, `$rootKey`
 will contain the key associated with the current `$root` value.
 
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
 recursing into) a container object holding an arbitrary data model.

 The keys and values of the returned dictionary are constructed based
 on expressions passed to the function.
 
 **Note:** The value of each key will always be an array, even if the key
 only maps to a single value.
 
 This Mockingbird function accepts three or more pipe-separated expressions as 
 parameters:
 
 * The *data model*, an expression whose value is a container object
 (either an array or dictionary) that will be used as the source for the
 returned dictionary
 
 * Zero or more *intermediate expressions*, which are used to recurse
 into portions of the data model
 
 * The second-to-last expression in the input parameters is the *key
 expression*, which is used to construct the keys in the map
 
 * The last expression is the *value expression*, which is used to
 construct the values contained in the map
 
 The intermediate, key and value expressions can refer to portions of the
 data model using several pre-defined variables:
 
 * `$item` refers to the value of the current item in the innermost
 scope being iterated/recursed
 
 * When iterating the values of a dictionary, the `$key` variable
 can be used to access the key associated with the current `$item`
 
 * `$root` contains the value of the current item being iterated
 at the top level of the data model
 
 * When the data model expression refers to a dictionary, `$rootKey`
 will contain the key associated with the current `$root` value.
 
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
 Returns an array containing the sorted values of a container object.
 
 This Mockingbird function accepts between one and three expressions as
 input parameters:
 
 * The *data model*, the container object whose sorted values are to be 
   returned

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
 
 This function accepts a single Mockingbird expression, which it expects to
 evaluate to an object that implements the `NSFastEnumeration`
 protocol (such as an `NSArray` or `NSSet`). The values
 in the returned array will be in the same order that they were supplied by 
 the enumerator.
 
 #### Expression usage

 Assume that `$animals` is an array with three elements: the strings "`Duck`",
 "`Duck`" and "`Goose`".
 
    ^unique($animals)
 
 The expression above would return an array containing two strings: "`Duck`"
 and "`Goose`", in that order.
 
 @param     enumerator The function's input parameter.
 
 @return    a set containing the unique values in the input parameter.
 */
+ (id) unique:(NSObject<NSFastEnumeration>*)enumerator;

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
 Distributes the elements in a single array across multiple arrays.
 
 This Mockingbird function accepts two pipe-separated expressions as parameters:

 * The *source array*, an expression that is expected to evaluate
 as an array value.

 * The *returned array count*, which specifies the number of arrays
 across which to distribute the source array's elements. This expression
 will be interpreted as integer value, and must be `1` or 
 greater.
 
 The source array is iterated, and each item in it is distributed across
 *returned array count* arrays in sequence.
 
 The function will always return the number of arrays specified by
 *returned array count*. If the source array contains fewer elements
 than *returned array count*, one or more of the returned arrays
 will be empty.
 
 #### Expression usage

 Assume that `$newYorkTeams` is an array with five elements: the strings 
 "`Yankees`", "`Mets`", "`Knicks`", `Rangers` and "`Nets`" in that
 order.
 
    ^distributeArrayElements($newYorkTeams|2)

 The expression above would return an array containing two arrays, where the
 first array contains three items ("`Yankees`", "`Knicks`" and "`Nets`") and
 the second array contains two ("`Mets`" and "`Rangers`").
 
 @param     params The function's input parameters.
 
 @return    An array containing *returned array count* arrays, each
            containing the distributed elements from *source array*.
 */
+ (id) distributeArrayElements:(NSArray*)params;

/*!
 Groups the elements in a single array into multiple arrays.
 
 This Mockingbird function accepts two pipe-separated expressions as parameters:
 
 * The *source array*, an expression that is expected to evaluate
 as an array value.
 
 * A *group size*, which specifies the maximum number of items to allow
 in a single group. This expression will be interpreted as integer value, and
 must be `1` or greater.
 
 The source array is iterated, and for each *group size* number of
 items encountered, a new *group array* is created containing just those
 items. The return value is an array containing one or more group arrays
 created while iterating the source array.
 
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
 
 @return    an array containing one or more *group arrays*.
 */
+ (id) groupArrayElements:(NSArray*)params;

@end


