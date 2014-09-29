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
 Provides a mechanism for manipulating data structures from within the template
 language.
 
 <b>Container objects:</b> Where parameters are referred to as <i>container
 objects</i>, the function will accept <code>NSDictionary</code> and
 <code>NSArray</code> instances.
 */
@interface MBMLDataProcessingFunctions : NSObject

/*!
 Determines whether any of the values contained within one or more container
 objects equals a specified value.
 
 <b>Note:</b> This method tests equality through the MBExpression, not
 through the <code>isEqual:</code> method. As a result, implicit type conversions
 occur, allowing an <code>NSNumber</code> instance containing the integer 
 <code>5</code> to equal an <code>NSString</code> containing the text 
 &quot;<code>5</code>&quot;. Be forewarned, however: Do not expect normal 
 <code>NSObject</code> equality test behavior!
 
 This function accepts two or more template expressions as parameters:
 
 <ul>
 <li>One or more <i>container objects</i>, expressions that evaluate to array
 or dictionary values
 
 <li>The <i>test value</i>, an expression whose value will be used to test
 equality with the values in the passed-in container(s)
 </ul>
 
 <b>Template example:</b>
 
 <pre>^containsValue($colorsOne|$colorsTwo|yellow)</pre>
 
 The expression above would return a boolean true value if either 
 <code>$colorsOne</code> or <code>$colorsTwo</code> contained an item
 whose value is the string <code>yellow</code>.
 
 @param     params an array containing the input parameters for the function
 
 @return    An <code>NSNumber</code> instance containing either the boolean
            value <code>YES</code> if any of the input parameters contains the specified
            element, or <code>NO</code> otherwise.
 */
+ (id) containsValue:(NSArray*)params;

/*!
 Applies a template expression accross each member of the passed collection and returns 
 whether or not all members passed the test (particularly useful for form validation).
 
 <b>Note:</b> This method tests equality through the MBExpression, not
 through the <code>isEqual:</code> method. As a result, implicit type conversions
 occur, allowing an <code>NSNumber</code> instance containing the integer 
 <code>5</code> to equal an <code>NSString</code> containing the text 
 &quot;<code>5</code>&quot;. Be forewarned, however: Do not expect normal 
 <code>NSObject</code> equality test behavior!
 
 This function accepts two template expressions as parameters:
 
 <ul>
 <li>One <i>container object</i>, which is expected to evaluate to array
 or dictionary
 
 <li>The <i>test value</i>, an expression whose value will be used to test
 against the values in the passed-in container(s)
 </ul>
 
 <b>Template example:</b>
 
 <pre>^collectionPassesTest($collection|$item.length -GT 0)</pre>
 
 The expression above would return a boolean true value if all 
 the members of <code>$collection</code> pass the template expression 
 <code>$item.length -GT 0</code>
 
 @param     params an array or dictionary containing the input parameters for the function
 
 @return    An <code>NSNumber</code> instance containing either the boolean
            value <code>YES</code> if all of the input collections pass the 
            specified template expression, or <code>NO</code> otherwise.
 */
+ (id) collectionPassesTest:(NSArray*)params;

/*!
 Tests a boolean expression against the values in one or more container objects,
 and returns an array of values for which the test expression is true.
 
 This function accepts an array of template expressions, and expects
 two or more objects in the array:

 <ul>
 <li>One or more <i>container objects</i>, expressions that evaluate to arrays
 or dictionaries

 <li>The <i>test expression</i>, an expression that will be evaluated for each
 value in each container object in the input parameters
 </ul>

 The test expression can refer to the following pre-defined variables:
 
 <ul>
 <li><code>$item</code> refers to the value in a container object that's 
 currently being tested
 
 <li>When the container object being tested is a dictionary, <code>$key</code> 
 can be used to access the key associated with the current <code>$item</code>
 
 <li><code>$root</code> contains the value of the current item being iterated
 at the top level of the data model
 </ul>

 <b>Template example:</b> Assume that <code>$articles</code> and <code>$videos</code>
 are containers whose values each have a <code>displayOrder</code> attribute:
 
 <pre>^valuesPassingTest($articles|$videos|$item.displayOrder -EQ 1)</pre>
 
 The template expression above would iterate over all the values in the
 <code>$articles</code> and then the <code>$videos</code> container objects, and 
 for each value, it would perform a <code>$item.displayOrder -EQ 1</code> boolean
 test. Each value in <code>$articles</code> and <code>$videos</code> for which
 the expression <code>$item.displayOrder -EQ 1</code> evaluates to true will be
 placed into the array returned by the function.
 
 @param     params an array containing the input parameters for the 
            function.
 
 @return    An array containing the values in the container objects
            for which the test expression evaluates to true
 */
+ (id) valuesPassingTest:(NSArray*)params;



// returns YES if the containers contain at least one value in common
+ (id) valuesIntersect:(NSArray*)params;




/*!
 Creates a string by concatenating the string values of the elements
 in one or more container objects, using the specified separator
 string between each value in the returned string. 
 
 This function accepts two or more template expressions as parameters:
 
 <ul>
 <li>One or more <i>container objects</i>, expressions that evaluate to arrays
 or dictionaries
 
 <li>The <i>separator string</i>, which is placed between each value in the
 returned string
 </ul>
 
 <b>Template example:</b> Assume that <code>$values</code> is an array
 containing the strings "string1", "anotherString", and "lastly":

 <pre>^join($values|, )</pre>

 The expression above would return the string "string1, anotherString, lastly".
 
 @param     params an array containing the input parameters for the 
            function.
 
 @return    a string containing the string values of the items in the
            <i>container objects</i>, separated by the string specified
            as the <i>separator string</i>
 */
+ (id) join:(NSArray*)params;

/*!
 Creates an array by splitting a string on a given delimeter.
 
 This function accepts two template expressions as parameters:
 
 <ul>
 <li>An expression specifying the <i>delimiter</i>, which specifies where
 the <i>input string</i> will be split

 <li>An expression specifying the <i>input string</i>, which is the
 string to be split 
 </ul>
 
 <b>Template example:</b>:
 
 <pre>^split(, |Evan, Jesse, Yon)</pre>
 
 The expression above would return an array containing three elements:
 "<code>Evan</code>", "<code>Jesse</code>", and "<code>Yon</code>".
 
 @param     params an array containing the input parameters for the 
            function.
 
 @return    an array containing the components of the split string
 */
+ (id) split:(NSArray*)params;

/*!
 Creates an array by splitting a string on newline characters (as determined
 by the <code>+[NSCharacterSet newlineCharacterSet]</code> method).
 
 This function accepts a single template expression, the <i>input string</i>
 that will be split on newlines.
 
 <b>Template example:</b> Assume that <code>$lines</code> is a string 
 containing newlines:
 
 <pre>^splitLines($lines)</pre>
 
 The expression above would return an array containing one element for each
 line in <code>$lines</code>, where each element contains a single line of
 text (with the newlines stripped off).
 
 @param     params an array containing the input parameters for the 
 function.
 
 @return    an array containing the components of the split string
 */
+ (id) splitLines:(NSString*)stringToSplit;

/*!
 Returns a single array containing all the elements in the arrays specified
 in the input parameters.
 
 This function accepts two or more template expressions as parameters,
 where each expression evaluates as an array value.

 <b>Template example:</b> Assume that <code>$array1</code>, <code>$array2</code>
 and <code>$array3</code> resolve to array values:

 <pre>^appendArrays($array1|$array2|$array3)</pre>

 The expression above will evaluate to a single array, wherein the returned
 array will contain all the elements of <code>$array1</code>, in the same
 order they appear in the array, followed by the elements of <code>$array2</code>,
 and then those of <code>$array3</code>.
 
 @param     params an array containing the input parameters for the 
            function.
 
 @return    an array containing all of the elements in the arrays referenced
            by the passed-in expression parameters.
 */
+ (id) appendArrays:(NSArray*)params;

/*!
 Returns a single array containing all the elements of the array(s) specified
 in the parameters, wherein any element that is an array will be flattened
 such that the returned array contains no nested arrays. This does a 
 depth-first traversal of the input parameters.
 
 This function accepts one or more template expressions as parameters,
 where each expression evaluates as an array value.
 
 <b>Template example:</b> Assume that <code>$nestedArrays</code> refers to
 an array wherein each element is another array:

 <pre>^flattenArrays($nestedArrays)</pre>
 
 The example above would return an array containing the elements of each array
 contained in <code>$nestedArrays</code>.
 
 @param     params an array containing the input parameters for the 
            function.

 @return    the flattened array.
 */
+ (id) flattenArrays:(NSArray*)params;

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
 
 This function accepts two or more template expressions as parameters:
 
 <ul>
 <li>The <i>data model</i>, an expression whose value is a container object
 (either an array or dictionary) that will be used as the source for the
 filtering
 
 <li>Zero or more <i>intermediate expressions</i>, which are used to recurse
 into portions of the data model
 
 <li>A <i>test expression</i>, which will be used for the basis of the 
 filtering.
 
 <li>Finally, an optional <i>filter behavior</i>, which can be either 
 <code>matchAtLeastOnce</code> or <code>matchAll</code> (note that these string
 literals must be used; this parameter is not evaluated). If the parameter is 
 omitted <code>matchAtLeastOnce</code> behavior will be used.
 </ul>

 <b>Template example:</b> Assume that <code>$people</code> is an array of data
 objects representing people:
 
 <pre>^filter($people|$item.children|$item.aunt|$item.firstName -EQ Jill|matchAll)</pre>
 
 The template expression above would return all the objects contained in 
 <code>$people</code> where every aunt of every child of the person has
 the first name Jill. The <code>matchAll</code> parameter can be omitted
 to return every person with at least one child who has at least one aunt
 with the first name Jill.
 
 @param     params an array containing the function's input parameters.
 
 @return    an array or dictionary containing the filtered items. The type of 
            the object returned will match the <i>data model</i> input
            parameter.
 */
+ (id) filter:(NSArray*)params;

/*!
 Traverses an array-based tree structure, removing any leaves whose values
 match a given test expression. The resulting pruned tree is then returned.
 
 This function accepts two template expressions as parameters:
 
 <ul>
 <li>The <i>input array</i> representing the root of the tree; this expression
 must evaluate to an <code>NSArray</code> instance
 
 <li>The <i>test expression</i>, which will be evaluated once for each 
 non-array element found while traversing the tree
 </ul>
 
 The function will return an tree structure similar to the input
 structure, but containing only those non-array elements for which the
 <i>test expression</i> evaluates to <code>NO</code>.

 <b>Template example:</b> Assume that <code>$input</code> is an array 
 containing two inner arrays. The first inner array contains the strings:
 "<code>Bob</code>", "<code>Joe</code>" and "<code>Pat</code>"; the second
 inner array contains: "<code>Alice</code>", "<code>Pat</code>" and 
 "<code>Sally</code>".
 
 <pre>^pruneMatchingLeaves($input|$item -EQ Pat)</pre>

 The expression above would return an array containing two inner arrays,
 the first having the elements "<code>Bob</code>" and "<code>Joe</code>",
 and the second having the elements "<code>Alice</code>" and 
 "<code>Sally</code>".
 
 @param     params an array containing the function's input parameters.
 
 @return    an array containing the result of the operation.
 */
+ (id) pruneMatchingLeaves:(NSArray*)params;

/*!
 Traverses an array-based tree structure, removing any leaves whose values
 do not match a given test expression. The resulting pruned tree is then 
 returned.
 
 This function accepts two template expressions as parameters:
 
 <ul>
 <li>The <i>input array</i> representing the root of the tree; this expression
 must evaluate to an <code>NSArray</code> instance
 
 <li>The <i>test expression</i>, which will be evaluated once for each 
 non-array element found while traversing the tree
 </ul>
 
 The function will return an tree structure similar to the input
 structure, but containing only those non-array elements for which the
 <i>test expression</i> evaluates to <code>YES</code>.
 
 <b>Template example:</b> Assume that <code>$input</code> is an array 
 containing two inner arrays. The first inner array contains the strings:
 "<code>Bob</code>", "<code>Joe</code>" and "<code>Pat</code>"; the second
 inner array contains: "<code>Alice</code>", "<code>Pat</code>" and 
 "<code>Sally</code>".
 
 <pre>^pruneNonmatchingLeaves($input|$item -EQ Pat)</pre>
 
 The expression above would return an array containing two inner arrays,
 each with a single element: "<code>Pat</code>".
 
 @param     params an array containing the function's input parameters.
 
 @return    an array containing the result of the operation.
 */
+ (id) pruneNonmatchingLeaves:(NSArray*)params;

/*!
 Iterates over (and potentially recurses into) the items in a container object,
 and returns a list of values. The values in the returned list will reflect the
 ordering of any arrays iterated, however iterating dictionaries will result in 
 non-deterministic ordering.
 
 This function accepts two or more template expressions as parameters:
 
 <ul>
 <li>The <i>data model</i>, an expression whose value is a container object
 (either an array or dictionary) that will be iterated
 
 <li>Zero or more <i>intermediate expressions</i>, which are used to recurse
 into portions of the data model
 
 <li>A <i>value expression</i>, which will be evaluated once for each item 
 encountered while iterating the data model and recursing into any
 intermediate expressions.
 </ul>
 
 The function will return an array containing the result of evaluating the
 <i>value expression</i> once for each item encountered in the data
 model.

 <b>Template example:</b> Assume that <code>$states</code> is a map where
 each item in the map represents a state. The key for each item is the
 two-letter postal code for the state, and the value associated with
 each key is another dictionary containing additional information about the
 state.
 
 <pre>^list($states|$item.citiesBySize|$item.name, <span>$</span>root:key - $item.population residents)</pre>
 
 The template expression above would iterate over all the elements in the
 <code>$states</code> dictionary, and for each state, it would then iterate over
 the elements contained in the states's <code>cityBySize</code> property, which
 in this case is an ordered array of cities in the state sorted by population.
 For each city in each state's <code>cityBySize</code>, the returned array would
 contain a string with values such as:
 
 <pre>New York, NY - 8,391,881 residents</pre>
  
 @param     params an array containing the function's input parameters.
 
 @return    an array containing the listed items.
 */
+ (id) list:(NSArray*)params;

/*!
 Creates a mapping of keys to values by iterating over (and potentially
 recursing into) a container object holding an arbitrary data model.
 The keys and values of the returned dictionary are constructed based
 on expressions passed to the function.
 
 <b>Note:</b> If the mapping operation would result in more than one value
 being mapped to a given key, the multiple values will be placed into an
 array, and that array will be the value of the key.

 This function accepts three or more template expressions as parameters:
 
 <ul>
 <li>The <i>data model</i>, an expression whose value is a container object
 (either an array or dictionary) that will be used as the source for the
 returned mapping
 
 <li>Zero or more <i>intermediate expressions</i>, which are used to recurse
 into portions of the data model
 
 <li>The second-to-last expression in the input parameters is the <i>key
 expression</i>, which is used to construct the keys in the map
 
 <li>The last expression is the <i>value expression</i>, which is used to
 construct the values contained in the map
 </ul>
 
 The intermediate, key and value expressions can refer to portions of the
 data model using several pre-defined variables:
 
 <ul>
 <li><code>$item</code> refers to the value of the current item in the innermost
 scope being iterated/recursed
 
 <li>When iterating the values of a dictionary, the <code>$key</code> variable
 can be used to access the key associated with the current <code>$item</code>
 
 <li><code>$root</code> contains the value of the current item being iterated
 at the top level of the data model
 
 <li>When the data model expression refers to a dictionary, <code>$rootKey</code>
 will contain the key associated with the current <code>$root</code> value.
 
 <li>In addition, when intermediate expressions are used to recurse into the
 data model, you can refer to items and keys contained in the outer scopes
 using the prefix <code>outer:</code> in the variable name, such as
 <code>$</code><code>outer:key</code> or <code>$outer:item</code>. This prefix 
 can also be compounded (eg.: <code>$outer:outer:key</code>) to reach different
 levels of scope.
 </ul>
 
 <b>Template example:</b> Assume that <code>$people</code> is an array of data
 objects representing people:
 
 <pre>^map($people|$item.children|$item.fullName|$root)</pre>
 
 The template expression above would iterate over all the values in
 <code>$people</code>, and for each person, it would then iterate over
 the elements contained in the person's <code>children</code> array. For
 each of those children, it would create a mapping from the value of that
 child's <code>fullName</code> attribute to the <code>$root</code> item,
 or the person from <code>$people</code> that's currently being iterated. In 
 other words, the expression above would create a dictionary where the keys are 
 the full names of children, and the value of each key is the item in 
 <code>$people</code> representing that child's parent.

 @param     params an array containing the function's input parameters.
 
 @return    a dictionary containing the mapped items.
  
 @see       mapToArray:, mapToSingleValue:
 */
+ (id) map:(NSArray*)params;

/*!
 Creates a mapping of keys to values by iterating over (and potentially
 recursing into) a container object holding an arbitrary data model.
 The keys and values of the returned dictionary are constructed based
 on expressions passed to the function.
 
 <b>Note:</b> If the mapping operation would result in more than one value
 being mapped to a given key, additional values are ignored and only one
 value will be returned. Assume non-deterministic behavior for multiple
 values.
 
 This function accepts three or more template expressions as parameters:
 
 <ul>
 <li>The <i>data model</i>, an expression whose value is a container object
 (either an array or dictionary) that will be used as the source for the
 returned mapping
 
 <li>Zero or more <i>intermediate expressions</i>, which are used to recurse
 into portions of the data model
 
 <li>The second-to-last expression in the input parameters is the <i>key
 expression</i>, which is used to construct the keys in the map
 
 <li>The last expression is the <i>value expression</i>, which is used to
 construct the values contained in the map
 </ul>
 
 The intermediate, key and value expressions can refer to portions of the
 data model using several pre-defined variables:
 
 <ul>
 <li><code>$item</code> refers to the value of the current item in the innermost
 scope being iterated/recursed
 
 <li>When iterating the values of a dictionary, the <code>$key</code> variable
 can be used to access the key associated with the current <code>$item</code>
 
 <li><code>$root</code> contains the value of the current item being iterated
 at the top level of the data model
 
 <li>When the data model expression refers to a dictionary, <code>$rootKey</code>
 will contain the key associated with the current <code>$root</code> value.
 
 <li>In addition, when intermediate expressions are used to recurse into the
 data model, you can refer to items and keys contained in the outer scopes
 using the prefix <code>outer:</code> in the variable name, such as
 <code>$</code><code>outer:key</code> or <code>$outer:item</code>. This prefix 
 can also be compounded (eg.: <code>$outer:outer:key</code>) to reach different
 levels of scope.
 </ul>
 
 <b>Template example:</b> Assume that <code>$people</code> is an array of data
 objects representing people:
 
 <pre>^mapToSingleValue($people|$item.children|$item.fullName|$root)</pre>
 
 The template expression above would iterate over all the values in
 <code>$people</code>, and for each person, it would then iterate over
 the elements contained in the person's <code>children</code> array. For
 each of those children, it would create a mapping from the value of that
 child's <code>fullName</code> attribute to the <code>$root</code> item,
 or the person from <code>$people</code> that's currently being iterated. In 
 other words, the expression above would create a dictionary where the keys are 
 the full names of children, and the value of each key is the item in 
 <code>$people</code> representing that child's parent.
 
 @param     params an array containing the function's input parameters.
 
 @return    a dictionary containing the mapped items.
 
 @see       mapToArray:, mapToSingleValue:
 */
+ (id) mapToSingleValue:(NSArray*)params;

/*!
 Creates a mapping of keys to values by iterating over (and potentially
 recursing into) a container object holding an arbitrary data model.
 The keys and values of the returned dictionary are constructed based
 on expressions passed to the function.
 
 <b>Note:</b> The value of each key will always be an array, even if the key
 only maps to a single value.
 
 This function accepts three or more template expressions as parameters:
 
 <ul>
 <li>The <i>data model</i>, an expression whose value is a container object
 (either an array or dictionary) that will be used as the source for the
 returned mapping
 
 <li>Zero or more <i>intermediate expressions</i>, which are used to recurse
 into portions of the data model
 
 <li>The second-to-last expression in the input parameters is the <i>key
 expression</i>, which is used to construct the keys in the map
 
 <li>The last expression is the <i>value expression</i>, which is used to
 construct the values contained in the map
 </ul>
 
 The intermediate, key and value expressions can refer to portions of the
 data model using several pre-defined variables:
 
 <ul>
 <li><code>$item</code> refers to the value of the current item in the innermost
 scope being iterated/recursed
 
 <li>When iterating the values of a dictionary, the <code>$key</code> variable
 can be used to access the key associated with the current <code>$item</code>
 
 <li><code>$root</code> contains the value of the current item being iterated
 at the top level of the data model
 
 <li>When the data model expression refers to a dictionary, <code>$rootKey</code>
 will contain the key associated with the current <code>$root</code> value.
 
 <li>In addition, when intermediate expressions are used to recurse into the
 data model, you can refer to items and keys contained in the outer scopes
 using the prefix <code>outer:</code> in the variable name, such as
 <code>$</code><code>outer:key</code> or <code>$outer:item</code>. This prefix 
 can also be compounded (eg.: <code>$outer:outer:key</code>) to reach different
 levels of scope.
 </ul>
 
 <b>Template example:</b> Assume that <code>$people</code> is an array of data
 objects representing people:
 
 <pre>^mapToArray($people|$item.children|$item.fullName|$root)</pre>
 
 The template expression above would iterate over all the values in
 <code>$people</code>, and for each person, it would then iterate over
 the elements contained in the person's <code>children</code> array. For
 each of those children, it would create a mapping from the value of that
 child's <code>fullName</code> attribute to the <code>$root</code> item,
 or the person from <code>$people</code> that's currently being iterated. In 
 other words, the expression above would create a dictionary where the keys are 
 the full names of children, and the value of each key is the item in 
 <code>$people</code> representing that child's parent.
 
 @param     params an array containing the function's input parameters.
 
 @return    a dictionary containing the mapped items.
 
 @see       mapToArray:, mapToSingleValue:
 */
+ (id) mapToArray:(NSArray*)params;

/*!
 Sorts a data structure based on the value of an expression. 
 
 */
+ (id) sort:(NSArray*)params;

/*!
 Merges a set of dictionaries into a single dictionary. 
 
 */
+ (id) merge:(NSArray*)params;

/*!
 Iterates over the values supplied by the passed-in enumerator, and returns an
 array containing the unique values encountered.
 
 This function accepts a single template expression, which it expects to
 evaluate to an object that implements the <code>NSFastEnumeration</code>
 protocol (such as an <code>NSArray</code> or <code>NSSet</code>). The values
 in the returned array will be in the same order that they were supplied by 
 the enumerator.
 
 <b>Template example:</b> Assume that <code>$animals</code> is an array with
 three elements: the strings <code>Duck</code>, <code>Duck</code> and
 <code>Goose</code>.
 
 <pre>^unique($animals)</pre>
 
 The template expression above would return an array containing two
 strings: <code>Duck</code> and <code>Goose</code>, in that order.
 
 @param     enumerator the function's input parameter.
 
 @return    a set containing the unique values in the input parameter.
 */
+ (id) unique:(NSObject<NSFastEnumeration>*)enumerator;

/*!
 Distributes the elements in a single array across multiple arrays.
 
 This function accepts two template expressions as parameters:

 <ul>
 <li>The <i>source array</i>, an expression that is expected to evaluate
 as an array value.

 <li>The <i>returned array count</i>, which specifies the number of arrays
 across which to distribute the source array's elements. This expression
 will be interpreted as integer value, and must be <code>1</code> or 
 greater.
 </ul>
 
 The source array is iterated, and each item in it is distributed across
 <i>returned array count</i> arrays in sequence.
 
 The function will always return the number of arrays specified by
 <i>returned array count</i>. If the source array contains fewer elements
 than <i>returned array count</i>, one or more of the returned arrays
 will be empty.
 
 <b>Template example:</b> Assume that <code>$newYorkTeams</code> is an
 array with five elements: the strings <code>Yankees</code>, <code>Mets</code>,
 <code>Knicks</code>, <code>Rangers</code> and <code>Islanders</code> in that
 order.
 
 <pre>^distributeArrayElements($newYorkTeams|2)</pre>
 
 The template expression above would return an array containing two
 arrays, where the first array contains three items (<code>Yankees</code>,
 <code>Knicks</code> and <code>Islanders</code>) and the second array
 contains two (<code>Mets</code> and <code>Rangers</code>).
 
 @param     params the function's input parameters.
 
 @return    an array containing <i>returned array count</i> arrays, each 
            containing the distributed elements from <i>source array</i>.
 */
+ (id) distributeArrayElements:(NSArray*)params;

/*!
 Groups the elements in a single array into multiple arrays.
 
 This function accepts two template expressions as parameters:
 
 <ul>
 <li>The <i>source array</i>, an expression that is expected to evaluate
 as an array value.
 
 <li>A <i>group size</i>, which specifies the maximum number of items to allow
 in a single group. This expression will be interpreted as integer value, and
 must be <code>1</code> or greater.
 </ul>
 
 The source array is iterated, and for each <i>group size</i> number of
 items encountered, a new <i>group array</i> is created containing just those
 items. The return value is an array containing one or more group arrays
 created while iterating the source array.
 
 Unless <i>source array</i> contains an exact multiple of <i>group 
 size</i> number of items, the last group array will contain fewer than 
 <i>group size</i> number of items.
 
 <b>Template example:</b> Assume that <code>$newYorkTeams</code> is an
 array with five elements: the strings <code>Yankees</code>, <code>Mets</code>,
 <code>Knicks</code>, <code>Rangers</code> and <code>Islanders</code> in that 
 order.
 
 <pre>^groupArrayElements($newYorkTeams|2)</pre>
 
 The template expression above would return an array containing three
 arrays, where the first array contains two items (<code>Yankees</code> and
 <code>Mets</code>), the second array contains two items (<code>Knicks</code> 
 and <code>Rangers</code>), and the third array contains one item 
 (<code>Islanders</code>).
 
 @param     params the function's input parameters.
 
 @return    an array containing one or more <i>group arrays</i>.
 */
+ (id) groupArrayElements:(NSArray*)params;

/*!
 Reduce an array of items into a single item.
 
 This function accepts 3 template expressions as parameters:
 
 <ul>
 <li>The source array, an expression that is expected to evaluate
 to an array.
 
 <li>A template expression that returns an initial value
 
 <li>A template expression that returns a single value
 </ul>
 
 The source is iterated and the expression is evaluated with respect to each $item.
 
 <b>Template example:</b> Assume that <code>$numbers</code> is an
 array with the numbers 1 through 5
 
 <pre>^reduce($numbers|0|#($currentValue + $item))</pre>
 
 The template expression above would return the value 15

 @param     params the function's input parameters.
 
 @return    a single value.
 */
+ (id) reduce:(NSArray*)params;

@end


