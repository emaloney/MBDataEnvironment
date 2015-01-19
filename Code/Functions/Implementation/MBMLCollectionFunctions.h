//
//  MBMLCollectionFunctions.h
//  Mockingbird Data Environment
//
//  Created by Alberto Tafoya on 8/23/11.
//  Copyright (c) 2011 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************************************/
#pragma mark -
#pragma mark MBMLCollectionFunctions class
/******************************************************************************/

/*!
 A class containing implementations for MBML functions that perform common
 operations on collections such as `NSArray`, `NSSet` and `NSDictionary`
 objects.
 
 See `MBMLFunction` for more information on MBML functions and how they're used.
 */
@interface MBMLCollectionFunctions : NSObject

/*!
 An MBML function implementation that determines whether a given value is
 a collection. A collection is an object that's an instance of `NSSet`, 
 `NSArray` or `NSDictionary`.
 
 **MBML Example**
 
 Assume the MBML variable `$cities` contains an array value. The expression:
 
    ^isCollection($cities)

 would return the boolean value `YES`.
 
 @param     param The function's input parameter.
 
 @return    A boolean result, contained in an `NSNumber`.
 */
+ (NSNumber*) isCollection:(id)param;

/*!
 An MBML function implementation that determines whether a given value is
 an instance of `NSSet`.
 
 **MBML Example**
 
 Assume the MBML variable `$cities` contains an array value. The expression:
 
    ^isSet($cities)

 would return the boolean value `YES`.
 
 @param     param The function's input parameter.
 
 @return    A boolean result, contained in an `NSNumber`.
 */
+ (NSNumber*) isSet:(id)param;

/*!
 An MBML function implementation that determines whether a given value is
 an instance of `NSSet`.
 
 **MBML Example**
 
 Assume `$accountIdsToNames` is a dictionary. The expression:
 
    ^isDictionary($accountIdsToNames)

 would return the boolean value `YES`.
 
 @param     param The function's input parameter.
 
 @return    A boolean result, contained in an `NSNumber`.
 */
+ (NSNumber*) isDictionary:(id)param;

/*!
 An MBML function implementation that determines whether a given value is
 an instance of `NSSet`.
 
 **MBML Example**
 
 Assume `$cities` is an array. The expression:
 
    ^isArray($cities)

 would return the boolean value `YES`.
 
 @param     param The function's input parameter.
 
 @return    A boolean result, contained in an `NSNumber`.
 */
+ (NSNumber*) isArray:(id)param;

/*!
 An MBML function implementation that returns the count of items in a
 collection object.
 
 This function accepts a single parameter, the collection expression, which
 is expected to yield an `NSSet`, `NSArray` or `NSDictionary` instance.
 
 **MBML Example**
 
 Assume `$cities` is an array containing the values "New York", "London", and
 "Boston". The expression:
 
    ^count($cities)

 would return the value `3`.
 
 @param     param The function's input parameter.
 
 @return    A number containing the count of items in the input parameter.
 */
+ (id) count:(id)param;

/*!
 An MBML function implementation that removes all instances of one or more
 objects from an array and returns the resulting array.
 
 This function accepts two or more pipe-separated expressions as parameters:
 
 * The *array* expression, which should evaluate to an `NSArray` instance,
 and
 
 * One or more *object* expressions, which should evaluate to the object(s)
 to be removed from the array.
 
 **MBML Example**
 
 Assume `$babies` is an array containing the values "Juno", "Theo", "Cooper" 
 and "Shiloh". The expression:
 
    ^removeObject($babies|Theo|Cooper)
 
 would return an array containing the values "Juno" and "Shiloh".
 
 @param     params The function's input parameters.
 
 @return    An array containing the items in the input array, with the
            specified items removed.
 */
+ (id) removeObject:(NSArray*)params;

/*!
 An MBML function implementation that removes an object at a given index from
 an array and returns the resulting array.
 
 This function accepts two pipe-separated expressions as parameters:
 
 * The *array* expression, which should evaluate to an `NSArray` instance,
 and
 
 * An *index* expression, which should evaluate to a number specifying the
 array index of the object to remove.
 
 **MBML Example**
 
 Assume `$cities` is an array containing the values "New York", "London", and
 "Boston". The expression:
  
    ^removeObjectAtIndex($cities|2)
 
 would return an array containing the values "New York" and "London".
 
 @param     params The function's input parameters.
 
 @return    An array containing the items in the input array, with the
            specified item removed.
 */
+ (id) removeObjectAtIndex:(NSArray*)params;

/*!
 An MBML function implementation that adds one or more items to the end of
 an existing array and returns the resulting array.
 
 This function accepts two or more pipe-separated expressions as parameters:
 
 * The *array* expression, which should evaluate to an `NSArray` instance,
 and
 
 * One or more *object* expressions, which yield the object(s) to append to
 the array.
 
 **MBML Example**
 
 Assume `$cities` is an array containing the values "New York", "London", and
 "Boston". The expression:
 
    ^appendObject($cities|Chicago|Las Vegas)
 
 would return an array containing the values "New York", "London", "Boston",
 "Chicago" and "Las Vegas".
 
 @param     params The function's input parameters.
 
 @return    An array containing the items in the input array, with the
            specified item(s) appended.
 */
+ (id) appendObject:(NSArray*)params;

/*!
 An MBML function implementation that inserts an item into an array and returns
 the resulting array.
 
 This function accepts three pipe-separated expressions as parameters:

 * The *array* expression, which should evaluate to an `NSArray` instance,
 
 * An *object* expression, which yields the object to be inserted into the
 array, and
 
 * The *index* expression, which should evaluate to a numeric value specifying
 the array index into which the object should be inserted.
  
 **MBML Example**
 
 Assume `$cities` is an array containing the values "New York", "London", and
 "Boston". The expression:
 
    ^insertObject($cities|Chicago|1)
 
 would return an array containing the values "New York", "Chicago", "London",
 and "Boston".
 
 @param     params The function's input parameters.
 
 @return    An array containing the items in the input array, with the
            specified item inserted at the given index.

 @warning   An error will be logged to the console if the index is out-of-range
            for the given array.
 */
+ (id) insertObjectAtIndex:(NSArray*)params;

/*!
 An MBML function implementation that returns an `NSArray` containing the
 value of each input parameter expression as an array element.
 
 This function accepts zero or more pipe-separated expressions as parameters.
 If zero parameters are provided, an empty array is returned.
 
 **MBML Example**
 
 The expression:

    ^array(One|2|III)
 
 would return an `NSArray` containing the strings "One", "2", and "III".
 
 @param     params The function's input parameters.
 
 @return    An array containing the value of each input parameter expression.
 */
+ (id) array:(NSArray*)params;

/*!
 An MBML function implementation that returns an `NSSet` containing the
 value of each input parameter expression as set elements.

 This function accepts zero or more pipe-separated expressions as parameters.
 If zero parameters are provided, an empty set is returned.
 
 **MBML Example**
 
 The expression:
 
    ^set(One|2|III)
 
 would return an `NSSet` containing the strings "One", "2", and "III".
 
 @param     params The function's input parameters.
 
 @return    A set containing the value of each input parameter expression.
 */
+ (id) set:(NSArray*)params;

/*!
 An MBML function implementation that determines whether a set contains a
 given object.
 
 This function accepts two pipe-separated expressions as parameters:
 
 * A *set* expression, which should yield an `NSSet` instance, and
 
 * An *object* expression, which yields the object whose presence in the
 set is to be tested.
 
 **MBML Example**
 
 Assume that the MBML variable `$colors` is a set containing the values "red",
 "yellow", "green", and "blue":
 
    ^setContains($colors|orange)
 
 The expression above would return a boolean `NO`, because `$colors` does
 not contain the value "orange".
 
 @param     params The function's input parameters.
 
 @return    An `NSNumber` containing a boolean value indicating the result
            of the function.
 */
+ (id) setContains:(NSArray*)params;

/*!
 An MBML function implementation that returns an `NSDictionary` containing the
 items provided as keys and values.
 
 This function accepts a pipe-separated list of zero or more expression 
 parameters:
 
 * If zero parameters are provided, an empty dictionary is returned.
 
 * If more than zero parameters are provided, the function will expect an even
 number of parameters, where the first item in each pair of parameters is an
 expression representing dictionary *key*, followed by an expression 
 representing the corresponding *value* for that key.
 
 **MBML Example**

 The expression:
 
    ^dictionary(firstKey|The first item|secondKey|item 2)
 
 would return an `NSDictionary` containing the key "firstKey" having the
 value "The first item" and "secondKey" having the value "item 2".
 
 @param     params The function's input parameters.
 
 @return    A dictionary containing the specified key/value pairs.
 */
+ (id) dictionary:(NSArray*)params;

/*!
 An MBML function implementation that returns an array containing the keys of
 an `NSDictionary`.

 This function accepts a single parameter: an expression that evaluates to
 a dictionary instance.
 
 **MBML Example**
 
 Assume that the expression `$namesToAges` yields a dictionary containing a
 mapping of people's names (keys) to their ages (values). The expression:
 
    ^keys($namesToAges)
 
 would return an array containing the names of each person in `$namesToAges`.
 
 @param     dict The function's input parameter, which is expected to
            be a dictionary.
 
 @return    An array containing the passed-in dictionary's keys.
 
 @see       values:
 */
+ (id) keys:(NSDictionary*)dict;

/*!
 An MBML function implementation that returns an array containing the values of
 an `NSDictionary`.
 
 This function accepts a single parameter: an expression that evaluates to
 a dictionary instance.

 **MBML Example**

 Assume that the expression `$namesToAges` yields a dictionary containing a
 mapping of people's names (keys) to their ages (values). The expression:
 
    ^values($namesToAges)
 
 would return an array containing the age of each person in `$namesToAges`.
 
 @param     dict The function's input parameter, which is expected to
            be a dictionary.
 
 @return    An array containing the passed-in dictionary's values.
 
 @see       keys:
 */
+ (id) values:(NSDictionary*)dict;

/*!
 An MBML function implementation that removes the last object in an array
 and returns the resulting array.
 
 This function accepts a single parameter: an expression that evaluates to
 an array instance.
 
 **MBML Example**
 
 Assume that the MBML expression `$colors` yields an array containing the 
 values "red", "yellow", "green", and "blue" in that order. The expression:
 
    ^removeLastObject($colors)
 
 would return an array containing the values "red", "yellow" and "green".
 
 @param     array The function's input parameter, which is expected to
            be an array.
 
 @return    A copy of the input array, with the last item removed.
 */
+ (id) removeLastObject:(id)array;

/*!
 An MBML function implementation that returns the last object in an array.
 
 This function accepts a single parameter: an expression that evaluates to
 an array instance.
 
 **MBML Example**

 Assume that the MBML expression `$colors` yields an array containing the 
 values "red", "yellow", "green", and "blue" in that order. The expression:

    ^lastObject($colors)
 
 would return the string "blue".
 
 @param     array The function's input parameter, which is expected to
            be an array.

 @return    The last item in the input array.
 */
+ (id) lastObject:(id)array;

/*!
 An MBML function implementation that determines the index of a specified value
 within an array, or `-1` if the value is not found.
 
 This function accepts two MBML expressions as parameters:
 
 * An *array* expression, which should evaluate to an `NSArray` instance
 
 * The *value*, an expression yielding a value that will be searched for in the
 array
 
 **MBML Example**

 Assume that the MBML expression `$colors` yields an array containing the 
 values "red", "yellow", "green", and "blue" in that order. The expression:
 
    ^indexOf($colors|yellow)
 
 would return the number `1` indicating that the value "yellow" exists
 in `$colors` at array index `1`.
 
 @param     params an array containing the input parameters for the function
 
 @return    A number indicating the zero-based index of the value in the array.
            If the value does not exist in the array, `-1` is returned.
 */
+ (id) indexOf:(NSArray*)params;

/*!
 An MBML function implementation that returns a copy of an object adopting
 the `NSCopying` protocol.
 
 This function accepts a single MBML expression parameter which yields the
 object to be copied.
 
 **MBML Example**
 
 Assume that the MBML expression `$array` yields an `NSArray`. The expression:
 
    ^copy($array)
 
 would return an `NSArray` containing the same contents as the original
 array. If the original array is modified, the copy would be unaffected.
 
 @param     param The function's input parameters.
 
 @return    A copy of the object yielded by the input parameter expression.
 
 @note      This function is exposed to the MBML environment as
            `^copy()`.
 */
+ (id) copyOf:(id)param;

/*!
 An MBML function implementation that returns a mutable copy of an object
 adopting the `NSMutableCopying` protocol.
 
 This function accepts a single MBML expression parameter which yields the
 object to be copied.
 
 **MBML Example**
 
 Assume that the MBML expression `$array` yields an `NSArray`. The expression:
 
    ^mutableCopy($array)
 
 would return an `NSMutableArray` containing the same contents as the original
 array. If the original array is modified, the copy would be unaffected. 
 Similarly, if the copy is modified, the original array would be unaffected.
 
 @param     param The function's input parameters.
 
 @return    A mutable copy of the object yielded by the input parameter
            expression.
 
 @note      This function is exposed to the MBML environment as
            `^mutableCopy()`.
 */
+ (id) mutableCopyOf:(id)param;

/*!
 An MBML function implementation that uses key-value coding to retrieve a
 value from an object.
 
 This function accepts two or three MBML expressions as parameters:
 
 * An *object* expression, which yields the object whose key will be queried,
 
 * A *key* expression, which should evaluate to a string representing a key, and
 
 * An optional *default value* expression, which will be returned if the
 object does not possess a value for the specified key.
 
 **MBML Example**

 Assume that the MBML expression `$dictionaryOfImages` yields a dictionary.
 The expression:
 
    ^valueForKey($dictionaryOfImages|$myImageKey|default.png)
 
 would return the value for the key identified by the MBML expression
 `$myImageKey` in `$dictionaryOfImages`. If `$dictionaryOfImages` contains no
 value for the key identified by `$myImageKey`, the value of "default.png" will
 be returned.

 @param     params The function's input parameters.

 @return    The value for the given key. If the key does not have an associated
            value, the default value (if it was provided) or `nil` (if no
            default was provided) is returned.

 @note      This function is exposed to the MBML environment as
            `^valueForKey()`.
*/
+ (id) getValueForKey:(NSArray*)params;

@end
