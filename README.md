MBDataEnvironment
=================

**Note:** This open-source project is a pre-release version that is not yet fully documented.

More complete documentation will be available in the 1.0.0 release.

# Mockingbird Data Environment

The Mockingbird Data Environment provides a *variable space* through which named variables can be accessed using *expressions*.

Mockingbird expressions are useful for extracting data from object graphs, particularly those sent by a server.

The Mockingbird Data Environment is specifically designed to allow moving the knowledge of how to access server-side data out of native code.

With iOS applications, the server typically defines its own data model and native client code implements the logic required to extract meaningful information from that data.

The problem with this architecture is that *both* the client *and* the server require knowledge of a service's data structure.

By definition, the server *must* maintain knowledge of the data structure—after all, the server is responsible for creating that data structure in the first place.

But if you think about what a client application really cares about, it's not the details of a data structure, it's specific bits of information embedded in that data structure.

An app might be interested in a *product list*, for example, but the fact that the product list can be assembled from information three levels deep into a JSON structure is merely incidental.

The Mockingbird Data Environment allows you to build apps where the server can host the logic required to navigate the data structures it returns. Services can return a data model and also a set of expressions needed to extract meaningful information from that data model.

Because everything is hosted on the server—both the data model and the knowledge of that data model—every installed copy of your app can automatically adapt to new data models.

You can change the way your services return data any time you want. You won't need to resubmit your app for review, and you don't need to run multiple versions of your backend for legacy versions of your app.

Just use the Mockingbird Data Environment to decouple your native code from your server data.

> This technique was discussed in more detail at the [iOSoho Developer's Symposium](http://www.meetup.com/iOSoho/events/181963632/) meetup on August 11th, 2014. ([Slides available at the Gilt Tech blog](http://tech.gilt.com/post/94663143169/handling-changes-to-your-server-side-data-model).)

## A Brief Introduction to Mockingbird Expressions

Any native runtime object instance can be stored in the Mockingbird variable space. When an object is stored in the variable space, it is associated with a *variable name* and is then considered a *variable value*.

Variable values can be exposed to the variable space through several means, including through Objective-C code:

```objc
    [[MBVariableSpace instance] setVariable:@"cats"
                                      value:@[@"Barrett", @"Duncan", @"Gabby"]];
```

The code above associates the variable name "`cats`" with an `NSArray` instance containing three items (the strings "`Barrett`", "`Duncan`" and "`Gabby`").

This array can be accessed through the Mockingbird expression:

```
    $cats
```

This shows the most basic expression form: a simple *variable reference*, where the variable name is prefixed with a dollar sign.

When an object is made available through the variable space, not only does the object instance itself become available through an expression, so do its properties, KVC values, and—if it's an array or dictionary—its contents.

You can access these sub-values through *variable subreferences*, which can take one of two forms: dot accessors and bracket accessors.

You can use the *dot accessor* to access the value of an object property or KVC value. For example, to determine the number of objects in the `$cats` array, you would use the expression:

```
    $cats.count
```

When that expression is evaluated, the Mockingbird expression engine accesses the `count` property of the `NSArray` instance associated with the variable named "`cats`", and returns that value.

In this example, the value of the expression `$cats.count` would be an `NSNumber` instance containing the integer value `3`.

> **Note:** The Mockingbird expression engine doesn't handle *primitives* (non-objects) directly. As a result, primitive types are wrapped in their equivalent Cocoa class. `NSUInteger` and `BOOL`, for example, are wrapped in `NSNumber` instances.

> That's why even though the `NSArray` class's `count` property is declared to return an `NSUInteger`, when a Mockingbird expression is evaluated referencing that property, the value yielded is contained in an `NSNumber`.

To access items within an array, you use the *bracket accessor*:

```
    $cats[1]
```

The expression above would yield the object at index `1` of the `NSArray` associated with the variable named "`cats`". Because array indexes are zero-based, this is actually the second item in the array: the string "`Duncan`".

Subreferences in Mockingbird expressions can also be chained together:

```
    $cats[1].length
```

This expression yields the value of the `length` property of the object at index `1` of the `NSArray` associated with the variable named "`cats`".

In this example, the value yielded would be the number `6`, which is the length of the string "`Duncan`".

> Expression subreferences can be chained to an arbitrary depth, allowing you to extract values from arbitrarily complex object graphs.

Values contained in dictionaries can also be retrieved using the bracket accessor notation.

Let's assume a new Mockingbird variable:

```objc
    [[MBVariableSpace instance] setVariable:@"catGenders"
                                      value:@{@"Barrett": @"female",
                                              @"Duncan": @"male",
                                              @"Gabby": @"female"}];
```

In the code above, we've created a dictionary containing a mapping of cat names to genders, and we've associated it with the Mockingbird variable name "`catGenders`".

To access the gender of any specific cat, we could use the bracket notation to yield the value associated with the given dictionary key:

```
	$catGenders[Barrett]
```

This expression yields the string "`female`".

