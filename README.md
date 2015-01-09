MBDataEnvironment
=================

This repository hosts the Mockingbird Data Environment, an open-source project from Gilt Groupe that builds upon [the Mockingbird Toolbox](https://github.com/emaloney/MBToolbox) project to provide a dynamic data processing engine for iOS applications.

# Mockingbird Data Environment

The Mockingbird Data Environment provides a *variable space* through which named variables can be accessed using *expressions*.

Mockingbird expressions are useful for extracting data from object graphs, particularly those sent by a server.

The Mockingbird Data Environment is specifically designed to allow moving the knowledge of how to access server-side data out of native code.

### The Problem

With iOS applications, the server typically defines its own data model and native client code implements the logic required to extract meaningful information from that data.

The problem with this architecture is that *both* the client *and* the server require knowledge of a service's data structure.

By definition, the server *must* maintain knowledge of the data structure—after all, the server is responsible for creating that data structure in the first place.

But if you think about what a client application really cares about, it's not the details of a data structure, it's specific bits of information embedded in that data structure.

An app might be interested in a *product list*, for example, but the fact that the product list can be assembled from information three levels deep into a JSON structure is merely incidental.

### The Solution

The Mockingbird Data Environment allows you to build apps where the server can host the logic required to navigate the data structures it returns. Services can return a data model and also a set of expressions needed to extract meaningful information from that data model.

Because everything is hosted on the server—both the data model and the knowledge of that data model—every installed copy of your app can automatically adapt to new data models whenever you choose to deploy them.

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
                                              @"Duncan":  @"male",
                                              @"Gabby":   @"female"}];
```

In the code above, we've created a dictionary containing a mapping of cat names to genders, and we've associated it with the Mockingbird variable name "`catGenders`".

To access the gender of any specific cat, we could use the bracket notation to yield the value associated with the given dictionary key:

```
	$catGenders[Barrett]
```

This expression yields the string "`female`".

### Evaluating Expressions

So, you've got a variable space populated with some values, and a set of expressions you'd like to use to extract data from the values in the variable space. Where do you go from here?

The `MBExpression` class provides an interface for evaluating expressions.

Depending on the data you have and how you want to use it, you would evaluate a given expression according to one of the following *expression types*:

#### String Expressions

If you're evaluating an expression that you expect to yield a string, you should use one of the `asString:` class methods provided by `MBExpression`:

```objc
    NSString* gender = [MBExpression asString:@"$catGenders[Barrett]"];
```

This evaluates the expression `$catGenders[Barrett]` as a string, meaning that the return value will either be `nil` or an `NSString` instance.

In this particular case, the `gender` variable would contain the string value "`female`".

> **Note:** If the underlying object isn't an `NSString` instance, it will be coerced into a string using the object's `description` method, which returns a string representation of the object.

##### String Interpolation

When evaluating string expressions, you can include *text literals* within your expression. You can think of a text literal as an expression whose result is the same as its original form.

When a string expression is evaluated, any text literals contained within the expression are returned as-is, while any variable references will be evaluated and replaced with their actual values. This is called *string interpolation*.

For example, consider the expression:

```objc
	NSString* barrett = [MBExpression asString:@"Barrett is a $catGenders[Barrett] cat."];
```

Here, the string "`Barrett is a `" and "` cat.`" are text literals, while "`$catGenders[Barrett]`" is a variable reference.

Because the string "`$catGenders[Barrett]`" represents a variable reference, it gets replaced with its underlying value; in this case, that's the string "`female`". Everything else in the expression is a text literal, so it is returned as-is.

The value of the `barrett` variable is the string "`Barrett is a female cat.`"

#### Object Expressions

If, say, you have an `NSArray` or an `NSDictionary` in the variable space (as is the case with the "`catGenders`" variable), you can retrieve the underlying object by evaluating an expression referencing it *as an object expression*:

```objc
    NSDictionary* genders = [MBExpression asObject:@"$catGenders"];
```

The `genders` variable now contains the `NSDictionary` instance that was previously bound to the Mockingbird variable name "`catGenders`" via the `setVariable:value:` method of `MBVariableSpace`.

> **Note:** Because the `asObject:` method returns the generic object type `id`, it is the responsibility of the caller to know the type of object returned, or to do proper type checking before use.

#### Numeric Expressions

To retrieve the value of a numeric variable, or to perform a simple mathematical calculation, you can evaluate an expression *as a number*:

```objc
    NSNumber* five = [MBExpression asNumber:@"5"];
    five = [MBExpression asNumber:@"2 + 3"];
    five = [MBExpression asNumber:@"8 - 3"];
    five = [MBExpression asNumber:@"10 / 2"];
    five = [MBExpression asNumber:@"2.5 * 2"];
    five = [MBExpression asNumber:@"((5 * 2) - 5)"];
```

All of the expressions above yield an `NSNumber` containing the value `5`.

As you can see, numeric expressions can contain simple math expressions. The `+`, `-`, `*` and `/` operators are supported. (Operators must be separated from surrounding tokens with a space.)

> By default, C language order is used when evaluating math operators. Parenthetical groupings can be used to ensure specific evaluation order.

Evaluating an expression as a number also handles converting Mockingbird variable values to numbers:

```objc
    [[MBVariableSpace instance] setVariable:@"five" value:@(5)];
    NSNumber* val = [MBExpression asNumber:@"$five"];
```

The variable `val` will contain the integer value `5`.

In the code above, the `@(5)` notation in the `setVariable:value:` method call ensures that the Mockingbird variable is set to an `NSNumber` instance. However, the object instance that underlies a Mockingbird variable doesn't need to be an `NSNumber` in order for an expression to be evaluated numerically.

In the code below, we're setting the Mockingbird variable named "`five`" to an `NSString` containing the text "`5`":

```objc
    [[MBVariableSpace instance] setVariable:@"five" value:@"5"];
    NSNumber* val = [MBExpression asNumber:@"$five"];
```

Because the Mockingbird expression engine will attempt to convert the value of a non-`NSNumber` into an `NSNumber`, `val` contains the integer value `5`.

For `NSString`s, the conversion is straightforward; the string is parsed as a numeric value. For non-`NSString` instances, the `description` method is called to convert the object into a string, and then that string is parsed as a number.

#### Boolean Expressions

When an expression is evaluated in a boolean context, the Mockingbird expression engine recognizes an additional set of operators and comparators to make boolean logic possible:

Boolean operator|Purpose
----------------|-------
*lVal* `-AND` *rVal* **or** *lVal* `&&` *rVal* | The **logical and** operator; evaluates *lVal* as a boolean expression and, if it is `true`, evaluates *rVal* as a boolean expression. The operator evaluates to `true` if and only if both *lVal* and *rVal* are `true`.
*lVal* `-OR` *rVal* **or** *lVal* `||` *rVal* | The **logical or** operator; evaluates *lVal* and *rVal* as boolean expressions. The operator evaluates to `true` if either *lVal* or *rVal* are `true`.
`!`*rVal* | The **logical not** operator; evaluates *rVal* as a boolean expression and negates that value. The operator evaluates to `true` when *rVal* evaluates to `false` and vise-versa.

Boolean operators can be combined into compound forms:

```objc
	MBVariableSpace* vars = [MBVariableSpace instance];
	vars[@"catName"] = @"Barrett";
	BOOL isFemale = [MBExpression asBoolean:@"$catName -AND $catGenders[$catName] -AND $catGenders[$catName] == female"];
```

In this example, `isFemale` would be `YES`.

> **Note:** Parenthetical grouping can also be used within boolean expressions to ensure specific evaluation logic.

In addition to the expected boolean operators, a number of boolean comparators are supported as well.

Comparators rely on the standard `isEqual:` and `compare:` methods for their work, but not exclusively. In some cases, type coercion may occur (for example, when comparing an `NSString` to an `NSNumber`).

Boolean comparator|Purpose
----------------|-------
*lVal* `-EQ` *rVal* **or** *lVal* `==` *rVal* | The **equal to** comparator. The operator evaluates to `true` when *lVal* and *rVal* are considered equivalent.
*lVal* `-NE` *rVal* **or** *lVal* `!=` *rVal* | The **not equal to** comparator. The operator evaluates to `true` when *lVal* and *rVal* are not considered equivalent.
*lVal* `-LT` *rVal* **or** *lVal* `<` *rVal* | The **less than** comparator. Evaluates to `true` when *lVal* is considered less than *rVal*.
*lVal* `-LTE` *rVal* **or** *lVal* `<=` *rVal* **or** *lVal* `=<` *rVal* | The **less than or equal to** comparator. Evaluates to `true` when *lVal* is considered less than or equal to *rVal*.
*lVal* `-GT` *rVal* **or** *lVal* `>` *rVal* | The **greater than** comparator. Evaluates to `true` when *lVal* is considered greater than *rVal*.
*lVal* `-GTE` *rVal* **or** *lVal* `>=` *rVal* **or** *lVal* `=>` *rVal* | The **greater than or equal to** comparator. Evaluates to `true` when *lVal* is considered greater than or equal to *rVal*.

For example:

```objc
	BOOL hasThreeCats = [MBExpression asBoolean:@"$cats.count == 3"];
	BOOL hasAnyCats = [MBExpression asBoolean:@"$cats.count -GTE 1"];
	BOOL theCatLady = [MBExpression asBoolean:@"!($cats.count -LT 7)"];
```

Here, `hasThreeCats` would be `YES`, `hasAnyCats` would also be `YES`, and `theCatLady` would be `NO`.

Finally, two boolean literals can be used in a boolean expression context:

Boolean literal|Purpose
---------------|-------
`T` | A boolean `true` (or `YES`)
`F` | A boolean `false` (or `NO`)

These values work as you might expect:

```objc
	BOOL tValue = [MBExpression asBoolean:@"T"];
	BOOL fValue = [MBExpression asBoolean:@"F"];
```

The variable `tValue` will be `YES`, and `fValue` will be `NO`.

This allows you to store a boolean value in a string, and have it evaluate as the intended boolean value:

```objc
    [[MBVariableSpace instance] setVariable:@"featureFlag"
                                      value:@"T"];

	// somewhere later on...

	if ([MBExpression asBoolean:@"$featureFlag"]) {
		// do something awesome with our great new feature
	}
```
