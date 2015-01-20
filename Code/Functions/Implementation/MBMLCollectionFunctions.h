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
 This class provides a set of MBML functions that perform common
 operations on collections such as `NSArray`, `NSSet` and `NSDictionary`
 objects.

 These functions are exposed to the Mockingbird environment via
 `<Function ... />` declarations in the <code>MBDataEnvironmentModule.xml</code>
 file.

 For more information on MBML functions, see the `MBMLFunction` class.
 */
@interface MBMLCollectionFunctions : NSObject

/*----------------------------------------------------------------------------*/
#pragma mark Testing for collection types
/*!    @name Testing for collection types                                     */
/*----------------------------------------------------------------------------*/

/*!
 Determines whether a given object instance is a collection, that is, of type
 `NSSet`, `NSArray` or `NSDictionary`.
 
 This Mockingbird function accepts a single parameter: an object expression
 yielding the instance to be tested.

 #### Expression usage
 
 Assume the MBML variable `$cities` contains an array value. The expression:
 
    ^isCollection($cities)

 would return the value `@YES`.
 
 @param     param The function's input parameter.
 
 @return    A boolean result, contained in an `NSNumber`.
 */
+ (NSNumber*) isCollection:(id)param;

/*!
 Determines whether a given object is an instance of `NSSet`.
 
 This Mockingbird function accepts a single parameter: an object expression
 yielding the instance to be tested.

 #### Expression usage
 
 Assume the MBML variable `$cities` contains an array value. The expression:
 
    ^isSet($cities)

 would return the value `@YES`.

 @param     param The function's input parameter.
 
 @return    A boolean result, contained in an `NSNumber`.
 */
+ (NSNumber*) isSet:(id)param;

/*!
 Determines whether a given object is an instance of `NSDictionary`.

 This Mockingbird function accepts a single parameter: an object expression
 yielding the instance to be tested.

 #### Expression usage
 
 Assume `$accountIdsToNames` is a dictionary. The expression:
 
    ^isDictionary($accountIdsToNames)

 would return the value `@YES`.

 @param     param The function's input parameter.
 
 @return    A boolean result, contained in an `NSNumber`.
 */
+ (NSNumber*) isDictionary:(id)param;

/*!
 Determines whether a given object is an instance of `NSArray`.

 This Mockingbird function accepts a single parameter: an object expression
 yielding the instance to be tested.

 #### Expression usage
 
 Assume `$cities` is an array. The expression:
 
    ^isArray($cities)

 would return the value `@YES`.

 @param     param The function's input parameter.
 
 @return    A boolean result, contained in an `NSNumber`.
 */
+ (NSNumber*) isArray:(id)param;

/*----------------------------------------------------------------------------*/
#pragma mark Counting the items in a collection
/*!    @name Counting the items in a collection                               */
/*----------------------------------------------------------------------------*/

/*!
 Returns the count of items in a collection object.
 
 This Mockingbird function accepts a single parameter, an object expression
 that's expected to yield an `NSSet`, `NSArray` or `NSDictionary` instance.
 
 #### Expression usage
 
 Assume `$cities` is an array containing the values "`New York`", "`London`",
 and "`Boston`". The expression:
 
    ^count($cities)

 would return the value `3`.
 
 @param     param The function's input parameter.
 
 @return    A number containing the count of items in the input parameter.
 */
+ (id) count:(id)param;

/*----------------------------------------------------------------------------*/
#pragma mark Modifying collections
/*!    @name Modifying collections                                            */
/*----------------------------------------------------------------------------*/

/*!
 Creates and returns a new `NSArray` instance by removing all instances of
 one or more objects from an input array.
 
 This Mockingbird function accepts two or more pipe-separated expressions 
 as parameters:
 
 * The *array* expression, which should evaluate to an `NSArray` instance,
 and
 
 * One or more *object* expressions, which should evaluate to the object(s)
 to be removed from the array.
 
 #### Expression usage
 
 Assume `$babies` is an array containing the values "`Juno`", "`Theo`", 
 "`Cooper`" and "`Shiloh`". The expression:
 
    ^removeObject($babies|Juno|Shiloh)
 
 would return an array containing the values "`Cooper`" and "`Theo`".
 
 @param     params The function's input parameters.
 
 @return    An array containing the items in the input array, with the
            specified items removed.
 */
+ (id) removeObject:(NSArray*)params;

/*!
 Creates and returns a new `NSArray` instance by removing an object at a
 given index from the input array.

 This Mockingbird function accepts two pipe-separated expressions as
 parameters:

 * The *array* expression, which should evaluate to an `NSArray` instance,
 and
 
 * An *index* expression, which should evaluate to a number specifying the
 array index of the object to remove.
 
 #### Expression usage
 
 Assume `$cities` is an array containing the values "`New York`", "`London`",
 and "`Boston`". The expression:
  
    ^removeObjectAtIndex($cities|2)
 
 would return an array containing the values "`New York`" and "`London`".
 
 @param     params The function's input parameters.
 
 @return    An array containing the items in the input array, with the
            specified item removed.
 */
+ (id) removeObjectAtIndex:(NSArray*)params;

/*!
 Creates and returns a new `NSArray` instance by adding one or more items to
 the end of the input array.
 
 This Mockingbird function accepts two or more pipe-separated expressions
 as parameters:

 * The *array* expression, which should evaluate to an `NSArray` instance,
 and
 
 * One or more *object* expressions, which yield the object(s) to append to
 the array.
 
 #### Expression usage
 
 Assume `$cities` is an array containing the values "`New York`", "`London`",
 and "`Boston`". The expression:

    ^appendObject($cities|Chicago|Las Vegas)
 
 would return an array containing the values "`New York`", "`London`", 
 "`Boston`", "`Chicago`" and "`Las Vegas`".
 
 @param     params The function's input parameters.
 
 @return    An array containing the items in the input array, with the
            specified item(s) appended.
 */
+ (id) appendObject:(NSArray*)params;

/*!
 Creates and returns a new `NSArray` instance by inserting an item into the
 input array.
 
 This Mockingbird function accepts three pipe-separated expressions as
 parameters:

 * The *array* expression, which should evaluate to an `NSArray` instance,
 
 * An *object* expression, which yields the object to be inserted into the
 array, and
 
 * The *index* expression, which should evaluate to a numeric value specifying
 the array index into which the object should be inserted.
  
 #### Expression usage
 
 Assume `$cities` is an array containing the values "`New York`", "`London`",
 and "`Boston`". The expression:

    ^insertObject($cities|Chicago|1)
 
 would return an array containing the values "`New York`", "`Chicago`", 
 "`London`", and "`Boston`".
 
 @param     params The function's input parameters.
 
 @return    An array containing the items in the input array, with the
            specified item inserted at the given index.

 @warning   An error will be logged to the console if the index is out-of-range
            for the given array.
 */
+ (id) insertObjectAtIndex:(NSArray*)params;

/*----------------------------------------------------------------------------*/
#pragma mark Creating collections
/*!    @name Creating collections                                             */
/*----------------------------------------------------------------------------*/

/*!
 Returns an `NSArray` containing the result of each input parameter expression.

 This Mockingbird function accepts zero or more pipe-separated expressions as 
 parameters. If zero parameters are provided, an empty array is returned.
 
 #### Expression usage
 
 The expression:

    ^array(One|2|III)
 
 would return an `NSArray` containing the strings "`One`", "`2`", and "`III`".
 
 @param     params The function's input parameters.
 
 @return    An array containing the value of each input parameter expression.
 */
+ (id) array:(NSArray*)params;

/*!
 Returns an `NSSet` containing the result of each input parameter expression.

 This Mockingbird function accepts zero or more pipe-separated expressions as
 parameters. If zero parameters are provided, an empty set is returned.

 #### Expression usage
 
 The expression:
 
    ^set(One|2|III)
 
 would return an `NSSet` containing the strings "`One`", "`2`", and "`III`".

 @param     params The function's input parameters.
 
 @return    A set containing the value of each input parameter expression.
 */
+ (id) set:(NSArray*)params;

/*!
 Creates a new `NSDictionary` instance containing the items provided as 
 keys and values.
 
 This Mockingbird function accepts zero or more pipe-separated expressions as
 parameters:
 
 * If zero parameters are provided, an empty dictionary is returned.
 
 * If more than zero parameters are provided, the function will expect an even
 number of parameters, where the first item in each pair of parameters is an
 expression representing dictionary *key*, followed by an expression 
 representing the corresponding *value* for that key.
 
 #### Expression usage

 The expression:
 
    ^dictionary(firstKey|The first item|secondKey|item 2)
 
 would return an `NSDictionary` containing the key "`firstKey`" having the
 value "`The first item`" and "`secondKey`" having the value "`item 2`".
 
 @param     params The function's input parameters.
 
 @return    A dictionary containing the specified key/value pairs.
 */
+ (id) dictionary:(NSArray*)params;

/*!
 Returns an array containing the keys of an `NSDictionary`.

 This Mockingbird function accepts a single parameter: an object expression
 yielding an `NSDictinary` instance.
 
 #### Expression usage
 
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
 Returns an array containing the values of an `NSDictionary`.
 
 This Mockingbird function accepts a single parameter: an object expression
 yielding an `NSDictinary` instance.

 #### Expression usage

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
 Removes the last object in an array and returns the resulting array.
 
 This Mockingbird function accepts a single parameter: an object expression
 yielding an `NSArray` instance.

 #### Expression usage
 
 Assume that the object expression `$colors` yields an array containing the
 values "`red`", "`yellow`", "`green`", and "`blue`" in that order.
 
 The expression:
 
    ^removeLastObject($colors)
 
 would return an array containing the values "`red`", "`yellow`" and "`green`".
 
 @param     array The function's input parameter, which is expected to
            be an array.
 
 @return    A copy of the input array, with the last item removed.
 */
+ (id) removeLastObject:(id)array;

/*!
 Returns the last object in an array.
 
 This Mockingbird function accepts a single parameter: an object expression
 yielding an `NSArray` instance.

 #### Expression usage

 Assume that the object expression `$colors` yields an array containing the
 values "`red`", "`yellow`", "`green`", and "`blue`" in that order.
 
 The expression:

    ^lastObject($colors)
 
 would return the string "`blue`".
 
 @param     array The function's input parameter, which is expected to
            be an array.

 @return    The last item in the input array.
 */
+ (id) lastObject:(id)array;

/*!
 Returns the index of a specified value within an array, or `-1` if the
 value is not found.
 
 This Mockingbird function accepts two pipe-separated expressions as parameters:
 
 * An *array* expression, which should evaluate to an `NSArray` instance
 
 * The *value*, an expression yielding a value that will be searched for in the
 array
 
 #### Expression usage

 Assume that the object expression `$colors` yields an array containing the
 values "`red`", "`yellow`", "`green`", and "`blue`" in that order.

 The expression:

    ^indexOf($colors|yellow)
 
 would return the number `1` indicating that the value "`yellow`" exists
 in `$colors` at array index `1`.
 
 @param     params an array containing the input parameters for the function
 
 @return    A number indicating the zero-based index of the value in the array.
            If the value does not exist in the array, `-1` is returned.
 */
+ (id) indexOf:(NSArray*)params;

/*!
 Returns an immutable copy of an object adopting the `NSCopying` protocol.
 
 This Mockingbird function accepts a single object expression parameter
 yielding the object instance to be copied.
 
 #### Expression usage
 
 **Note:** This function is exposed to the Mockingbird environment with a
 name that differs from that of its implementing method:

    ^copy($array)

 Assuming the object expression `$array` yields an `NSArray`, the expression
 above would return an `NSArray` containing the same contents as the original
 array. If the original array is subsequently modified, the copy would be
 unaffected.
 
 @param     param The function's input parameters.
 
 @return    A copy of the object yielded by the input parameter expression.
 */
+ (id) copyOf:(id)param;

/*!
 Returns a mutable copy of an object adopting the `NSMutableCopying` protocol.

 This Mockingbird function accepts a single object expression parameter
 yielding the object instance to be copied.

 #### Expression usage

 **Note:** This function is exposed to the Mockingbird environment with a
 name that differs from that of its implementing method:

    ^mutableCopy($array)

 Assuming that the object expression `$array` yields an `NSArray`, the
 expression above would return an `NSMutableArray` containing the same contents
 as the original array. If the original array is subsequently modified, the
 copy would be unaffected. Similarly, if the copy is modified, the original
 array would be unaffected.
 
 @param     param The function's input parameters.
 
 @return    A mutable copy of the object yielded by the input parameter
            expression.
 */
+ (id) mutableCopyOf:(id)param;

/*!
 Retrieves a value from an object using key-value coding (KVC).
 
 This Mockingbird function accepts two or three pipe-separated expressions as
 parameters:
 
 * An *object* expression, which yields the object whose key will be queried,
 
 * A *key* expression, which should evaluate to a string representing a key, and
 
 * An optional *default value* expression, which will be returned if the
 object does not possess a value for the specified key.
 
 #### Expression usage

 **Note:** This function is exposed to the Mockingbird environment with a
 name that differs from that of its implementing method:

    ^valueForKey($dictionaryOfImages|$myImageKey|default.png)

 Assuming that the expression `$dictionaryOfImages` yields a dictionary, the
 expression above would return the value for the key identified by the string
 expression `$myImageKey` in the dictionary `$dictionaryOfImages`.
 
 If `$dictionaryOfImages` contains no value for the key identified by 
 `$myImageKey`, the value of "`default.png`" will be returned.

 @param     params The function's input parameters.

 @return    The value for the given key. If the key does not have an associated
            value, the default value (if it was provided) or `nil` (if no
            default was provided) is returned.
*/
+ (id) getValueForKey:(NSArray*)params;

@end
