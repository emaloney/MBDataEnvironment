![HBC Digital logo](https://raw.githubusercontent.com/gilt/Cleanroom/master/Assets/hbc-digital-logo.png)     
![Gilt Tech logo](https://raw.githubusercontent.com/gilt/Cleanroom/master/Assets/gilt-tech-logo.png)

# MBDataEnvironment

The Mockingbird Data Environment builds upon [the Mockingbird Toolbox](https://github.com/emaloney/MBToolbox) to provide a dynamic data processing engine for iOS, macOS, tvOS and watchOS applications.

The Mockingbird Data Environment allows arbitrary data models and object graphs to be assigned *names* and stored in a *variable space* from which values can be extracted using *expressions*.

The Mockingbird Data Environment is particularly suited for building applications that can adapt to changes in server-side data models.

MBDataEnvironment is part of the Mockingbird Library from [Gilt Tech](http://tech.gilt.com).


### Xcode compatibility

This is the `master` branch. It **requires Xcode 8.3** to compile.


#### Current status

Branch|Build status
--------|------------------------
[`master`](https://github.com/emaloney/MBDataEnvironment)|[![Build status: master branch](https://travis-ci.org/emaloney/MBDataEnvironment.svg?branch=master)](https://travis-ci.org/emaloney/MBDataEnvironment)


### Why Mockingbird Data Environment?

It is a common scenario for app publishers to have a population of users running old versions. Sometimes, users are stuck on old versions because the latest requires an operating system newer than their hardware will support. Such users won't be running your latest app until they buy a new machine, if they ever do.

For some types of apps, this isn't a big problem. But for apps that must communicate with network-based services, having a wide variety of old versions out in the wild makes it difficult to evolve and maintain your services.

Eventually, you will be faced with accepting one of these tradeoffs:

* Do you drop support for old versions, knowing that there's a risk of severing valuable relationships with some of your users?

* Do you take on the expense and difficulty of maintaining and operating a growing number of legacy backend services over time?

* Or do you resign yourself to never evolving your backend systems—or doing it much more slowly than you'd like?

The purpose of the Mockingbird Data Environment is to free you from having to make these compromises.

#### The Root of the Problem

The way applications are typically architected, the client application and the server must both agree in advance on the data schema that will be used to communicate. On the client side, native code is written that implements the logic of extracting meaningful information from the data sent by the server.

The problem with this architecture is that *both* the client *and* the server require intimate knowledge of the data schema.

Some have attempted to address this with solutions that automatically generate client code from data schemas. While this is undoubtedly convenient and time-saving, the original problem remains: the knowledge of the data format must be *compiled in* to the client application and therefore can't be changed once the app has been released. You're still going to end up with some users running very old app versions that will want to communicate with your services.

Ideally, there would be only *one* place where knowledge of a data model would need to live. The long tail of legacy applications gives us a compelling reason to avoid having that knowledge hard-coded into the client, so we should look to a server-driven solution.

If you think about what a client application really needs to know, it's not the details of the data structure sent by the server, it's specific bits of information embedded within that data structure. The data structure is merely a byproduct of the application's need to communicate with the server.

An app might be interested in a product list, for example, but the fact that the product list is assembled from data three levels down in a particular JSON structure is incidental.

#### The Solution

The Mockingbird Data Environment allows you to build apps where the server can host the logic required to navigate the data structures it returns. Services can return a data model and also a set of *expressions* used to extract meaningful information from that data model.

Essentially, the server's response tells the client application two things: "*Here's a data structure containing the information you need, and here's how you pick out the parts that are relevant to you.*"

Because everything is hosted on the server—both the data model and the knowledge of how to interpret that data model—every installed copy of your app can automatically adapt to new data models whenever you choose to deploy them.

You won't need to resubmit your app for review every time you change how your services communicate, and you won't need to run multiple versions of your backend to support legacy versions of your app.

Let the Mockingbird Data Environment decouple your native code from the details of your server-side data, and you can evolve your services on your own schedule while long-forgotten versions of your app will just keep on working.

> This technique was discussed in more detail at the [iOSoho Developer's Symposium](http://www.meetup.com/iOSoho/events/181963632/) meetup on August 11th, 2014. ([Slides available at the Gilt Tech blog](http://tech.gilt.com/post/94663143169/handling-changes-to-your-server-side-data-model).)

## Contents

1. [Initializing the Mockingbird Data Environment](#initializing-the-mockingbird-data-environment)
2. [An Introduction to Mockingbird Expressions](#an-introduction-to-mockingbird-expressions)
  1. [Evaluating Expressions](#evaluating-expressions)
    1. [String Expressions](#string-expressions)
    2. [Object Expressions](#object-expressions)
    3. [Numeric Expressions](#numeric-expressions)
    4. [Boolean Expressions](#boolean-expressions)
    5. [Expression Contexts](#expression-contexts)
      1. [Forcing a Numeric Context](#forcing-a-numeric-context)
      2. [Forcing a Boolean Context](#forcing-a-boolean-context)
      3. [Quoting](#quoting)
      4. [Escape Sequences](#escape-sequences)
    6. [Additional Variable Reference Notations](#additional-variable-reference-notations)
      1. [Curly-Brace Notation](#curly-brace-notation)
      2. [Bracket Notation](#bracket-notation)
      3. [Parentheses Notation](#parentheses-notation)
    7. [Variable Notation Summary](#variable-notation-summary)
  2. [MBML Functions](#mbml-functions)
  3. [Debugging Expressions](#debugging-expressions)
    1. [MBML Functions for Debugging](#mbml-functions-for-debugging)
    2. [Evaluating Expressions in the Xcode Debugger](#evaluating-expressions-in-the-xcode-debugger)
3. [An Introduction to MBML Files](#an-introduction-to-mbml-files)
  1. [The Manifest File](#the-manifest-file)
  2. [The Structure of an MBML File](#the-structure-of-an-mbml-file)
  3. [Types of MBML declarations](#types-of-mbml-declarations)
    1. [Includes](#includes)
    2. [Variables](#variables)
      1. [Concrete Variables](#concrete-variables)
      2. [Singleton Variables](#singleton-variables)
      3. [Dynamic Variables](#dynamic-variables)
    3. [Functions](#functions)
4. [Further Reading](#further-reading)
5. [Additional Resources](#additional-resources)

## Initializing the Mockingbird Data Environment
	


### License

MBDataEnvironment is distributed under [the MIT license](https://github.com/emaloney/MBDataEnvironment/blob/master/LICENSE).

MBDataEnvironment is provided for your use—free-of-charge—on an as-is basis. We make no guarantees, promises or apologies. *Caveat developer.*


### Adding MBDataEnvironment to your project

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

The simplest way to integrate MBDataEnvironment is with the [Carthage](https://github.com/Carthage/Carthage) dependency manager.

First, add this line to your [`Cartfile`](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile):

```
github "emaloney/MBDataEnvironment" ~> 3.0.0
```

Then, use the `carthage` command to [update your dependencies](https://github.com/Carthage/Carthage#upgrading-frameworks).

Finally, you’ll need to [integrate MBDataEnvironment into your project](https://github.com/emaloney/MBDataEnvironment/blob/master/INTEGRATION.md) in order to use [the API](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/API/index.html) it provides.

Once successfully integrated, just add the following `import` statement to any Objective-C file where you want to use MBDataEnvironment:

```objc
@import MBDataEnvironment;
```

See [the Integration document](https://github.com/emaloney/MBDataEnvironment/blob/master/INTEGRATION.md) for additional details on integrating MBDataEnvironment into your project.


## MBDataEnvironment Reference

Before making use of the Mockingbird Data Environment, your application first loads an `MBEnvironment` instance.

The easiest way to do this is to load the *default environment*:

```objc
[MBEnvironment loadDefaultEnvironment];
```

The default environment contains everything you need to get started using the Mockingbird Data Environment.

You can also provide your own *manifest file* that contains additional declarations allowing you to customize the initial state of the environment when it is loaded. 

The manifest is an XML file (typically named `manifest.xml`) that contains MBML markup for customizing and configuring the Mockingbird environment.

> MBML is an XML document format whose name stands for **M**ocking**b**ird **M**arkup **L**anguage. The format is described in **[An Introduction to MBML Files](#an-introduction-to-mbml-files)** below.

If your application provides a `manifest.xml` file in its resources, instead of calling `loadDefaultEnvironment`, you could load the environment using:

```objc
[MBEnvironment loadFromManifest];
```

Once an environment is loaded, you can start populating the *variable space* with data and use *expressions* to interact with that data.

## An Introduction to Mockingbird Expressions

Mockingbird expressions are strings containing zero or more *literals* or *expression tokens*.

Depending on the context, Mockingbird expressions can contain:
 
 - text literals
 - numeric literals
 - references to variables of any Objective-C type
 - basic math expressions
 - boolean logic expressions
 - function calls

The process of resolving an expression to yield the specific value(s) it references is called _evaluation_. During evaluation, literals are passed through untouched, but any expression tokens encountered are replaced with the values they represent at evaluation time.

The primary API for evaluating expressions is through several [`MBExpression` class methods](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBExpression.html):

Expressions yielding|are evaluating using
--------------------|--------------------
`NSString`|`asString:`
`NSNumber`|`asNumber:`
`BOOL`|`asBoolean:`
`id` or `NSObject`|`asObject:`

One possible use of a Mockingbird expression is to perform string replacement when populating user interface views, such as `UILabel`s:
 
```objc
	UILabel* greeting = // created elsewhere
	greeting.text = [MBExpression asString:@"Hello, $userName!"];
```

In the code above, the `text` property of the `greeting` label will be set to the result of evaluating the *string expression* `Hello, $userName!`.

This particular expression consists of three parts: a text literal ("`Hello, `") followed by a reference to the Mockingbird variable `userName`, followed by another text literal ("`!`").

When the expression is evaluated, the "`$userName`" portion of the expression is replaced by the value of the `userName` variable in the active *variable space*.

If the value of `userName` is "`Cooper`", then the label would display the text "`Hello, Cooper!`".

> In this documentation, the notation `$variableName` can be read as either "the variable named *variableName* in the active variable space," or "a reference to the value of the variable named *variableName* in the active variable space," depending on the context.

#### The Variable Space

The *variable space* is where Mockingbird variable values are stored.

Any native runtime object instance can be stored in the Mockingbird variable space. When an object is stored in the variable space, it is associated with a *variable name* and is considered a *variable value*.

In Objective-C, variable values can be exposed to the variable space using the keyed subscripting notation:

```objc
[MBVariableSpace instance][@"cats"] = @[@"Barrett", @"Duncan", @"Gabby"];
```

The code above associates `$cats` with an `NSArray` containing three items (the strings "`Barrett`", "`Duncan`" and "`Gabby`").

You can also use an MBML manifest file to pre-populate the variable space when the environment is loaded. Using a manifest file allows you to avoid needing to programmatically populate the variable space with common values every time your application is launched.

To ensure that the Mockingbird environment always has the same values for `$cats`, you could add this *variable declaration* in the manifest:

```xml
<Var name="cats" type="list" mutable="F">
    <Var literal="Barrett"/>
    <Var literal="Duncan"/>
    <Var literal="Gabby"/>
</Var>
```

> The `mutable="F"` attribute ensures that `$cats` can't be overwritten by another value during runtime. It does not guarantee the immutability of the underlying object instance, however.

See **[The Manifest File](#the-manifest-file)** below for more information on manifest files.

#### Variable References

The most basic non-literal expression form is a *simple variable reference*, where the variable name is prefixed with a dollar sign:

```
$cats
```

When an object is made available through the variable space, not only does the object instance itself become accessible using an expression, so do its properties, any values addressable using key-value coding (KVC), and—if the object in question is an array or dictionary—its contents.

You can access these sub-values through *variable subreferences*, which can take one of two forms: dot accessors and bracket accessors.

##### Dot Accessors

You can use the *dot accessor* to access the value of an object property or KVC value. For example, to determine the number of objects in the `$cats` array, you would use the expression:

```
$cats.count
```

When that expression is evaluated, the Mockingbird expression engine accesses the `count` property of the underlying `NSArray` value of `$cats`, and returns that value. In this example, the value of `$cats.count` would be an `NSNumber` containing the integer value `3`.

> The Mockingbird expression engine doesn't handle *primitives* (non-objects) directly. As a result, primitive types are wrapped in their equivalent Cocoa class. `NSUInteger` and `BOOL`, for example, are wrapped in `NSNumber` instances.

##### Bracket Accessors

To access items contained in an array or dictionary, you use the *bracket accessor*:

```
$cats[1]
```

The expression above would yield the object at index `1` of the `$cats` array. Because array indexes are zero-based, this is actually the second item in the array: the string "`Duncan`".

> An expression referencing an out-of-bounds array index will yield the value `nil`.

Subreferences can also be chained together:

```
$cats[1].length
```

This expression yields the value of the `length` property of the object at index `1` of the `$cats` array.

In this example, the value yielded would be the number `6`, which is the length of the string "`Duncan`".

The bracket accessor works similarly for dictionaries. For example:

```objc
[MBVariableSpace instance][@"catGenders"] = @{@"Barrett": @"female",
                                              @"Duncan":  @"male",
                                              @"Gabby":   @"female"}];
```

In the code above, we've created a dictionary containing a mapping of cat names to genders, and we've associated it with the variable `$catGenders`.

To access the gender of any specific cat, we could use the bracket notation to yield the value associated with the given dictionary key:

```
$catGenders[Barrett]
```

This expression yields the string "`female`".

### Evaluating Expressions

Depending on the data you have in the variable space and how you need to use it, the `MBExpression` class provides several methods to evaluate expressions according to one of the following *expression types*:

#### String Expressions

If you're evaluating an expression that you expect to yield a string, you should use one of the `asString:` class methods provided by `MBExpression`:

```objc
NSString* gender = [MBExpression asString:@"$catGenders[Barrett]"];
```

This evaluates the expression `$catGenders[Barrett]` as a string, ensuring that the return value will either be an `NSString` or `nil`.

In this particular case, the `NSString` variable `gender` would contain the value "`female`".

> If the underlying object isn't an `NSString` instance, a reasonable attempt will be made to coerce the value into a string.

##### String Interpolation

When writing string expressions, you can include *text literals* within your expression. You can think of a text literal as an expression whose result is the same as its original form.

When a string expression is evaluated, any text literals contained within the expression are returned as-is, while any variable references will be evaluated and replaced with their resulting values. This is called *string interpolation*.

For example, consider the expression:

```objc
NSString* barrett = [MBExpression asString:@"Barrett is a $catGenders[Barrett] cat."];
```

Here, the strings "`Barrett is a `" and "` cat.`" are text literals, while "`$catGenders[Barrett]`" is a variable reference.

Because the string "`$catGenders[Barrett]`" represents a variable reference, it gets replaced with its underlying value; in this case, the string "`female`".

The resulting value of the `NSString` variable `barrett` is "`Barrett is a female cat.`"

#### Object Expressions

If you have, say, an `NSArray` or an `NSDictionary` in the variable space (as is the case with `$catGenders`), you can retrieve the underlying object value using an *object expression*:

```objc
NSDictionary* genders = [MBExpression asObject:@"$catGenders"];
```

The `NSDictionary` variable `genders` now references the same value as `$catGenders`.

> Because the `asObject:` method returns the generic object type `id`, it is the responsibility of the caller to know the type of object returned, or to do proper type checking before use.

#### Numeric Expressions

To retrieve the value of a numeric variable, or to perform a mathematical calculation, you can evaluate an expression *as a number*:

```objc
NSNumber* five = [MBExpression asNumber:@"5"];
five = [MBExpression asNumber:@"2 + 3"];
five = [MBExpression asNumber:@"8 - 3"];
five = [MBExpression asNumber:@"10 / 2"];
five = [MBExpression asNumber:@"2.5 * 2"];
five = [MBExpression asNumber:@"((5 * 2) - 5)"];
```

All of the expressions above yield an `NSNumber` containing the value `5`.

As you can see, numeric expressions can contain basic math expressions. The `+`, `-`, `*`, `/` and `%` (modulo) operators are supported. Operators must be separated from surrounding tokens with at least one space character.

> By default, C language order is used when evaluating math operators. Parenthetical groupings can be used to ensure specific evaluation order.

Evaluating an expression as a number also handles converting Mockingbird variable values to numbers. Here, the `NSNumber` variable `val` will contain the integer value `5`:

```objc
[MBVariableSpace instance][@"five"] = @(5);
NSNumber* val = [MBExpression asNumber:@"$five"];
```

In the code above, the `@(5)` notation ensures that the Mockingbird variable is set to an `NSNumber` instance. However, the object instance that underlies a Mockingbird variable doesn't need to be an `NSNumber` in order for an expression to be evaluated numerically.

In the code below, we're setting the Mockingbird variable named `five` to an `NSString` containing the text "`5`":

```objc
[MBVariableSpace instance][@"five"] = @"5";
NSNumber* val = [MBExpression asNumber:@"$five"];
```

Because the Mockingbird expression engine will attempt to convert the value of a non-`NSNumber` into an `NSNumber`, `val` will contain the integer value `5`.

#### Boolean Expressions

When an expression is evaluated in a *boolean context*, the Mockingbird expression engine recognizes an additional set of operators and comparators to make boolean logic possible:

Boolean operator|Purpose
----------------|-------
*lVal* `-AND` *rVal* **or** *lVal* `&&` *rVal* | The **logical and** operator; evaluates *lVal* as a boolean expression and, if it is `true`, evaluates *rVal* as a boolean expression. The operator evaluates to `true` if and only if both *lVal* and *rVal* are `true`.
*lVal* `-OR` *rVal* **or** *lVal* `||` *rVal* | The **logical or** operator; evaluates *lVal* and *rVal* as boolean expressions. The operator evaluates to `true` if either *lVal* or *rVal* are `true`.
`!`*rVal* | The **logical not** operator; evaluates *rVal* as a boolean expression and negates that value. The operator evaluates to `true` when *rVal* evaluates to `false` and vice-versa.

Boolean operators can be combined into compound forms:

```objc
MBVariableSpace* vars = [MBVariableSpace instance];
vars[@"catName"] = @"Barrett";
BOOL isFemale = [MBExpression asBoolean:@"$catName -AND $catGenders[$catName] -AND $catGenders[$catName] == female"];
```

In this example, the `BOOL` variable `isFemale` would hold the value `YES`.

> Parenthetical grouping can also be used within boolean expressions to ensure specific evaluation order.

In addition to the expected boolean operators, a number of boolean comparators are supported as well.

Comparators rely on the standard `isEqual:` and `compare:` methods for their work, but not exclusively. In some cases, type coercion may occur (for example, when comparing an `NSString` to an `NSNumber`).

Boolean comparator|Purpose
----------------|-------
*lVal* `-EQ` *rVal* **or** *lVal* `==` *rVal* | The **equal to** comparator. The operator evaluates to `true` when *lVal* and *rVal* are considered equivalent.
*lVal* `-NE` *rVal* **or** *lVal* `!=` *rVal* | The **not equal to** comparator. The operator evaluates to `true` when *lVal* and *rVal* are not considered equivalent.
*lVal* `-LT` *rVal* **or** *lVal* `<` *rVal* | The **less than** comparator. Evaluates to `true` when *lVal* is considered less than *rVal*.
*lVal* `-LTE` *rVal* **or** *lVal* `<=` *rVal* **or** *lVal* `=<` *rVal* | The **less than or equal to** comparator. Evaluates to `true` when *lVal* is considered less than or equal to *rVal*.
*lVal* `-GT` *rVal* **or** *lVal* `>` *rVal* | The **greater than** comparator. Evaluates to `true` when *lVal* is considered greater than *rVal*.
*lVal* `-GTE` *rVal* **or** *lVal* `>=` *rVal* **or** *lVal* `=>` *rVal* | The **greater than or equal to** comparator. Evaluates to `true` when *lVal* is considered greater than or equal to *rVal*.

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
[MBVariableSpace instance][@"featureFlag"] = @"T";

// somewhere later on...

if ([MBExpression asBoolean:@"$featureFlag"]) {
	// do something awesome with our great new feature
}
```

#### Expression Contexts

The four expression types—*string*, *object*, *numeric* and *boolean*—all handle their input and output differently. Therefore, an expression evaluated in a *string context* may yield a different result from the same expression evaluated in a *boolean context*. Likewise, an expression that's valid in a *numeric context* might not be valid in any other context.

For example, tokens like `-EQ`, `-LTE`, `-GT`, etc. are only valid in a boolean expression context. When encountered outside of a boolean context, the expression engine will treat those values as text literals. 

> If you've got an expression that's not behaving as you expect, double-check that the expression context is what you assume it is. See [**Debugging Expressions**](#debugging-expressions) below for additional tips on diagnosing problematic expressions.

Sometimes, you might want to mix contexts. For example, you might want to display a string in a `UILabel` that includes a mathematical calculation. Or you might want to display a message that contains some conditional text within it.

##### Forcing a Numeric Context

You can embed a numeric expression within any other expression context using the notation: **`#(`** *numeric expression* **`)`**.

For example:

```objc
[MBExpression asString:@"There are #(10 - 3) days in the week."];
```

This expression consists of three components: the text literal "`There are `", then the numeric expression `#(10 - 3)`, followed by another text literal: "` days in the week.`".

As usual, the text literals are returned as-is, but the numeric expression is evaluated as such, resulting in the value `7`. So, the expression above would return the string `"There are 7 days in the week."`

##### Forcing a Boolean Context

You can evaluate a boolean expression within a non-boolean context using the notation: **`^if(`** *boolean expression* **`|`** *true result* [ **`|`** *false result* ] **`)`**. 

When this notation is encountered, *boolean expression* is evaluated in the boolean context, and based on the result, either *true result* or *false result* is returned.

```objc
[MBExpression asString:@"You ^if($user.isAdmin|have|do not have) admin privileges"];
```

The value yielded by the expression above depends on the *boolean context value* of `$user.isAdmin`. If it evaluates to `true`, the return value will be "`You have admin privileges`"; otherwise, it will be "`You do not have admin privileges`".

Because either *true result* or *false result* can be empty strings, the expression above could be rewritten slightly more succinctly while achieving the same result:

```objc
[MBExpression asString:@"You ^if($user.isAdmin||do not )have admin privileges"];
```

Which is also the logical equivalent of:

```objc
[MBExpression asString:@"You ^if(!$user.isAdmin|do not |)have admin privileges"];
```

Because the entire *false result* clause is optional, the expression above can be shortened by one more character by removing the last pipe:

```objc
[MBExpression asString:@"You ^if(!$user.isAdmin|do not )have admin privileges"];
```

> When string interpolation is being used, a `nil` value within an expression is treated as an empty string.

##### Quoting

In some cases, an expression may contain characters that you don't want to be recognized as part of an expression. 

For example, consider this string expression:

```
It will cost $total for your $quantity tickets to the Ke$ha concert
```

The `$` character signals the beginning of a variable reference, so while `$total` and `$quantity` are correctly recognized as variables, the text "`$ha`" in the name "`Ke$ha`" will be incorrectly interpreted as a variable reference.

Assuming there is no value for `$ha`, the expression will yield a string that ends in "`Ke concert`" instead of the intended "`Ke$ha concert`".

To avoid this problem, you can use *quoting* to ensure that portions of your expression are not evaluated.

To quote a range of text within an expression, use the notation **`^q(`** *text to quote* **`)`**. The text that appears within the parentheses is treated as a text literal and returned as-is when the expression containing the quote is evaluated.

Here's how quoting can be used to fix the expression above:
```
It will cost $total for your $quantity tickets to the ^q(Ke$ha) concert
```

When this expression is evaluated, the string returned will correctly contain the text "`Ke$ha`" instead of just "`Ke`".

##### Escape Sequences

A technique similar to quoting is to use *escape sequences* to represent a character that can't be represented by itself.

For example, the string "`$$`" is an escape sequence representing the dollar-sign character `$`. Just as quoting was used to ensure that "`Ke$ha`" was handled correctly, this escape sequence could also be used:

```
It will cost $total for your $quantity tickets to the Ke$$ha concert
```

The following escape sequences are supported:

Escape sequence|represents
---------------|----------
`$$`|`$`
`##`|`#`
`^^`|`^`
`\n`|newline character
`\t`|tab character

#### Additional Variable Reference Notations

So far, we've seen one form of variable reference, the *simple variable reference*. This notation can be used only when the variable name is considered an *identifier*. Identifiers are names that are constructed as follows:

- The first character can be an uppercase (`A-Z`) or lowercase (`a-z`) alphabet character or an underscore (`_`).

- Subsequent characters can be uppercase (`A-Z`) or lowercase (`a-z`) alphabet characters, numeric (`0-9`) digits, underscores (`_`), hyphens (`-`), or colons (`:`).

In some cases, the simple notation can't be used to reference a given variable because the name of the variable is not a valid identifier.

In other cases, you may want to ensure that the parser recognizes a boundary between a variable name and a literal or another expression.

Additional variable reference notations are provided for these situations.

##### Curly-Brace Notation

The curly-brace variable reference notation can be used to prevent the expression engine from interpreting characters following a variable reference as being part of the reference itself. The notation is used by surrounding the variable name with curly braces.

The curly-brace notation is similar to the simple notation in that it only accepts variable names that are also valid identifiers. The expressions `$userName` and `${userName}` both refer to the same variable, but they cause the expression evaluator to treat the characters following the variable reference differently.

Let's say you have a variable `$lastName` that contains a person's surname, and you want to construct a message such as "How are the Butterfields doing?" that refers to the surname in the plural form.

You couldn't use the unquoted notation (eg., "`How are the $lastNames doing?`") because the `s` that follows `$lastName` would be interpreted as part of the variable name. Instead of referencing the variable `$lastName` followed by the character literal `s`, the expression actually references an entirely different variable: `$lastNames`.

The curly-brace notation allows you to separate the variable reference from any surrounding text that should be considered a literal. Using this notation, the expression can be written as:

```
How are the ${lastName}s doing?
```

This expression will be interpreted as the text literal "`How are the `" followed by the value of `$lastName`, followed by another text literal, "`s doing?`".

##### Bracket Notation

The bracket variable reference notation can be used to access Mockingbird variables whose names aren't valid identifiers.

For example, the space character and the dollar sign (`$`) are not valid identifier characters. Normally, when a space is encountered while interpreting a variable name, the expression engine assumes that the space signals the end of the variable name. When a dollar sign is encountered within an expression, the expression engine assumes it signals the beginning of a new variable reference.

Because Mockingbird variable names don't *have* to be identifiers, the bracket notation exists to allow access to variables whose names aren't identifiers.

Let's say your application connects to a backend system that introduces a Mockingbird variable named `total $`. You could reference the value of this variable with the expression:

```
$[total $]
```

Using the bracket notation allows subreferences after the closing bracket. Assuming the variable `total $` is a string, the following expression would yield the length of that string:

```
$[total $].length
```

##### Parentheses Notation

As with the bracket notation, the parentheses variable reference notation can be used to access Mockingbird variables whose names aren't valid identifiers. And like the curly-brace notation, the parentheses notation prevents the expression engine from misconstruing adjacent characters as being part of the variable reference.

To see the difference, consider these two expressions:

```
$[total $].length
$(total $).length
```

The top expression uses the bracket notation, which allows subreferences after the closing bracket. The bottom expression uses the parentheses notation, which does not allow subreferences.

Because subreferences are not allowed by the parentheses notation, any text that appears after the closing parenthesis will be considered the start of a new statement. In this case, because "`.length`" is not a valid expression of any kind, it is interpreted as a text literal.

So while `$[total $].length` will yield the value of the `length` property of `total $`, `$(total $).length` will yield the value of  `total $` followed by the text literal "`.length`".

#### Variable Notation Summary

Notation|Variable Name|Example|Example With Subreference|Follow-on Subreferences|
--------|---------------|-------|-----------------|-----------------------|
simple|must be an identifier|`$variableName`|`$string.length`|allowed|
curly-brace|must be an identifier|`${variableName}`|`${string.length}`|not recognized|
bracket|can contain any character except `[` or `]`|`$[variable name]`|`$[a string].length`|allowed|
parentheses|can contain any character except `(` or `)`|`$(variable name)`|not possible|not recognized|

#### MBML Functions

MBML functions allow native Objective-C code to be called from within Mockingbird expressions. Functions can take zero or more input parameters, and they may return an object instance as a result.

When an expression containing a function call is evaluated, the method that implements the function is executed, and the value returned by that method (if any) is yielded by the function. Values returned by function implementations can then be manipulated further within an expression.

Function calls begin with a caret character (`^`), followed by the name of the function, and end in a list of zero or more pipe-separated parameters surrounded by parentheses.

For example, to call a function that creates an array, you could write:

```
^array(pizza|pasta|sushi|lobster)
```

If this notation looks familiar, it's because you've already encountered two functions—`^if()` and `^q()`—in the documentation above.

In this example, the `^array()` function returns an `NSArray` containing four items: the strings "`pizza`", "`pasta`", "`sushi`" and "`lobster`".

Subreferences can be used with the return value of functions in the same way that they can with variable references:

```
^array(pizza|pasta|sushi|lobster)[3]
```

This expression yields the value "`lobster`".

The Mockingbird Data Environment ships with nearly 200 functions built in, and more can be added through `MBModule`s or by implementing them yourself.

The list of included functions can be seen in [the `MBDataEnvironmentModule.xml` file](https://rawgit.com/emaloney/MBDataEnvironment/blob/master/Resources/MBDataEnvironmentModule.xml); they are declared using the `<Function>` tag.

The functions themselves are documented within their implementing classes:

- [`MBMLCollectionFunctions`](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBMLCollectionFunctions.html)
- [`MBMLDataProcessingFunctions`](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBMLDataProcessingFunctions.html)
- [`MBMLDateFunctions`](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBMLDateFunctions.html)
- [`MBMLDebugFunctions`](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBMLDebugFunctions.html)
- [`MBMLEncodingFunctions`](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBMLEncodingFunctions.html)
- [`MBMLEnvironmentFunctions`](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBMLEnvironmentFunctions.html)
- [`MBMLFileFunctions`](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBMLFileFunctions.html)
- [`MBMLFontFunctions`](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBMLFontFunctions.html)
- [`MBMLGeometryFunctions`](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBMLGeometryFunctions.html)
- [`MBMLLogicFunctions`](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBMLLogicFunctions.html)
- [`MBMLMathFunctions`](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBMLMathFunctions.html)
- [`MBMLRegexFunctions`](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBMLRegexFunctions.html)
- [`MBMLResourceFunctions`](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBMLResourceFunctions.html)
- [`MBMLRuntimeFunctions`](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBMLRuntimeFunctions.html)
- [`MBMLStringFunctions`](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBMLStringFunctions.html)

To learn how MBML functions are implemented, see [the `MBMLFunction` class documentation](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBMLFunction.html)

### Debugging Expressions

When faced with an expression that isn't behaving as you expect, first check your application's console log. When unhandled expression errors occur, information will be written to the console describing the problem.

If that doesn't help, you may need to delve further. The Mockingbird Data Environment comes with several tools to help you debug.

#### MBML Functions for Debugging

The [`MBMLDebugFunctions`](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBMLDebugFunctions.html) class provides MBML functions useful for debugging expressions.

Some of these are *pass-through* functions that allow you to wrap an expression (or a portion thereof) in a function call that writes debugging information to the console, but does not otherwise interfere with the expression in which its used. These types of functions can be inserted at variable reference or subreference boundaries in an expression without affecting the expression's result.

Consider the expression:

```
$dictionary[$key].propertyValue.anotherValue[$arrayIndex]
```

If this expression were not returning the expected result, there are a number of possible reasons why. Perhaps `$dictionary`, `$key` or `$index` has an unexpected value. Or maybe the `.propertyValue` or `.anotherValue` subreferences are returning `nil`.

##### ^log(...)

To inspect the innards of an expression, you could wrap some or all of it in one or more calls to `^log()`.

The `^log()` function accepts an object expression as a parameter. When invoked, the function logs debugging information to the console, showing the input expression and the value it yields when evaluated. The function then returns that value.

Here, four portions of the expression above are wrapped in calls to `^log()`:

```
^log(^log($dictionary)[^log($key)]).propertyValue.anotherValue[^log($arrayIndex)]
```

When this expression is evaluated, each call to `^log()` will result in debugging information being written to the console:

* First, `^log($dictionary)` will print the value of `$dictionary`.

* If `$dictionary` is non-`nil`, `^log($key)` will then print debugging information for `$key`.

* Next, `^log(^log($dictionary)[^log($key)])` will print information for  `$dictionary[$key]` to the console (because the contained `^log()` calls are pass-throughs, they can be ignored).

* Finally, if no intermediate values in the expression are `nil`, `^log($arrayIndex)` will print the value of `$arrayIndex`.

##### ^test(...)

The `^test()` function is similar to `^log()` except that it accepts a boolean expression and returns the result of evaluating that expression in the boolean context.

This function is ideal for testing portions of boolean expressions. It can be used as follows:

```
^test($Network.isWifiConnected) -AND ^test($Device.isRetina)
```

When the expression above is evaluated, debugging information for the boolean expression `$Network.isWifiConnected` will be logged to the console. If `$Network.isWifiConnected` evaluates to `true`, debugging information for `$Device.isRetina` will also be logged.

> Because the boolean `-AND` operator is short-circuiting, the right operand is only evaluated if the left operand evaluates to `true`.

##### ^debugBreak(...)

When `MBDataEnvironment` is compiled as part of a `DEBUG` build, the `^debugBreak()` function is available.

When evaluating an expression containing a call to `^debugBreak()`, if the code is running within Xcode, a debug breakpoint will be triggered, landing you at the debugger's command prompt. From there, you can [evaluate expressions by typing commands in the debugger](#evaluating-expressions-in-the-xcode-debugger).

The `^debugBreak()` function takes an input message that is logged to the console before breaking into the debugger.

> **Important:** If `^debugBreak()` is called in a `DEBUG` build when the application is *not* running in the Xcode debugger, the application will crash.

##### ^tokenize(...)

The `^tokenize()` function tokenizes the input expression in the object context and prints the resulting tokens to the console.

Tokenization shows you how your expressions are being interpreted by Mockingbird.

For example:

```
^tokenize(This $aint.no ^party())
```

The expression above would result in console output similar to:

```
--> Tokens for object expression "This $aint.no ^party()":
<MBMLLiteralToken@0x7f8ac03aaea0: "This " {0, 5}>
<MBMLVariableReferenceToken@0x7f8abce042a0: "$aint" {5, 5}> containing 1 token:
    0: <MBMLObjectSubreferenceToken@0x7f8ac0670a00: ".no" {10, 3}>
<MBMLLiteralToken@0x7f8ac036f4a0: " " {13, 1}>
<MBMLFunctionCallToken@0x7f8ac0645bb0: "^party()" {14, 8}>
```

As with `^log()` and `^test()`, this function can be used to wrap some or all of a larger expression.

##### ^tokenizeBoolean(...)

The `^tokenizeBoolean()` function is similar to `^tokenize()` but it accepts a boolean expression as an input parameter.

```
^tokenizeBoolean(This != ^party())
```

The expression above would result in console output similar to:

```
--> Tokens for boolean expression "This != ^party()":
<MBMLInequalityTestToken@0x7fa93fb5fbe0: "!=" {5, 2}> containing 2 tokens:
    0: <MBMLLiteralToken@0x7fa93fb45970: "This" {0, 4}>
    1: <MBMLFunctionCallToken@0x7fa93fb4af80: "^party()" {8, 8}>
```

##### ^tokenizeMath(...)

The `^tokenizeMath()` function tokenizes math expressions but otherwise works like `^tokenize()` and `^tokenizeBoolean()`:

```
^tokenizeMath(($user.firstName.length + $user.lastName.length) + 1)
```

The expression above would result in console output similar to:

```
--> Tokens for math expression "($user.firstName.length + $user.lastName.length) + 1":
<MBMLAdditionOperatorToken@0x7fa940048b70: "+" {49, 1}> containing 2 tokens:
    0: <MBMLMathGroupingToken@0x7fa9400a87d0: "($user.firstName.length + $user.lastName.length)" {0, 48}> containing 1 token:
        0: <MBMLAdditionOperatorToken@0x7fa93ae86fd0: "+" {23, 1}> containing 2 tokens:
            0: <MBMLVariableReferenceToken@0x7fa93faf9400: "$user" {0, 5}> containing 2 tokens:
                0: <MBMLObjectSubreferenceToken@0x7fa940049ac0: ".firstName" {5, 10}>
                1: <MBMLObjectSubreferenceToken@0x7fa93fae4340: ".length" {15, 7}>
            1: <MBMLVariableReferenceToken@0x7fa93aeb8f70: "$user" {25, 5}> containing 2 tokens:
                0: <MBMLObjectSubreferenceToken@0x7fa93aea8d90: ".lastName" {30, 9}>
                1: <MBMLObjectSubreferenceToken@0x7fa93fa52f60: ".length" {39, 7}>
    1: <MBMLNumericLiteralToken@0x7fa94007d100: "1" {51, 1}>
```

#### Evaluating Expressions in the Xcode Debugger

The ability to interactively evaluate expressions from within the debugger can be added to Xcode using the `.lldbinit` file provided as part of the Mockingbird Data Environment.

LLDB is the debugger used by Xcode, and it can be extended by adding commands to an `.lldbinit` file in your home directory.

To be able to evaluate expressions in the debugger, copy [the `.lldbinit` file](https://rawgit.com/emaloney/MBDataEnvironment/blob/master/.lldbinit) that comes with this project into your home directory. (Or, if you already have an `.lldbinit` file, you can add the entries from our `.lldbinit` file to yours.)

Then, restart your application's debugging session, and any time you're at the `(lldb)` prompt in Xcode, you can use the following commands to evaluate expressions:

Command|Name|Purpose|Example
-------|----|-------|-------
`pe`|**p**rint **e**xpression|evaluates an object expression and prints the result|`pe $user`
`pec`|**p**rint **e**xpression **c**lass|evaluates an object expression and prints the resulting class|`pec $user.guid`
`pse`|**p**rint **s**tring **e**xpression|evaluates a string expression and prints the result|`pse Hello, $user.lastName!`
`pbe`|**p**rint **b**oolean **e**xpression|evaluates a boolean expression and prints the result|`pbe $user.isLoggedIn`
`pne`|**p**rint **n**umeric **e**xpression|evaluates a numeric or math expression and prints the result|`pne (50 % 3)`

## An Introduction to MBML Files

The state of the `MBEnvironment` can be modified through the use of MBML files.

MBML is an XML-based document format that provides a mechanism for declaring new variable values, functions, and other state. If there are certain variables or functions that you always want present in the environment, you can declare them in MBML.

### The Manifest File

If you include a `manifest.xml` file in your application's main resource bundle, you can use it to configure the initial state of the environment. You would simply load the environment using the method:

```objc
[MBEnvironment loadFromManifest];
```

Additional `loadFromManifest...` method variants exist to allow you to store your manifest file elsewhere or name it something other than `manifest.xml`.

### The Structure of an MBML File

The outermost XML tag in an MBML document is the `<MBML>` tag. Contained within this tag are *declarations* of various types. The structure of the document is:

```xml
<MBML modules="...">

	<!-- declarations -->

</MBML>
```

The `modules` attribute is optional. If present, the attribute's value may be a comma-separated list of classes conforming to [the `MBModule` protocol](https://rawgit.com/emaloney/MBToolbox/master/Documentation/html/Protocols/MBModule.html). Modules provide additional functionality to the Mockingbird Data Environment and are loaded loaded along with the environment.

Modules can hook into the MBML parsing process, allowing new tags to be introduced to the language. For example, [the MBEventHandling project](https://github.com/emaloney/MBEventHandling) adds the ability to listen for `NSNotification` events and perform actions in response. The *listeners* and *actions* are declared through MBML tags that have been added by the `MBEventHandlingModule`.

To include this module, the `MBEventHandling` code would need to be linked to your application, typically by including it in your `Podfile`. Then, you can specify the module in the manifest file's opening `<MBML>` tag:

```xml
<MBML modules="MBEventHandlingModule">
```

When the manifest containing this declaration is loaded, `MBEventHandling` functionality will be available in the environment.

### Types of MBML declarations

While any included modules may introduce additional MBML declarations, by itself, the Mockingbird Data Environment provides the ability to declare:

* *Includes* — The manifest file is so named because in a larger application, it's considered a best practice to break discrete parts of the application into separate MBML files that are *included* from the manifest. Include declarations specify the MBML files that should be loaded when the environment itself is loaded.

* *Variables* — Values for Mockingbird variables can be set in MBML.

* *Functions* — The capabilities of Mockingbird expressions can be extended by introducing new MBML functions.

#### Includes

An MBML file can *include* another file. When a file is included, any declarations in that file are processed as though they were declared in the including file at the point where the `<Include>` tag was encountered.

The `<Include>` tag requires the `file` attribute and accepts an optional `if` attribute:

* The `file` attribute specifies the name of the MBML file being included.

* If present, the value of the `if` attribute will be evaluated as a boolean expression, and the specified file will be included only if the expression evaluates to `true`.

For example:

```xml
<Include file="onboarding.xml" if="$isFirstLaunch"/>
<Include file="landing.xml"/>
```

According to the declarations above, the `onboarding.xml` file will be included only if `$isFirstLaunch` evaluates to `true` in a boolean context, while the `landing.xml` file is included unconditionally. Further, if `onboarding.xml` is included, any declarations it contains will be processed before any declarations from `landing.xml`.

> `<Include>` tags are always processed *before* any other declarations in an MBML file.

#### Variables

The `<Var>` tag is used to declare values for Mockingbird variables.

Three types of variable declarations are possible:

* *Concrete* — A *variable name* is associated with an Objective-C object instance, which represents the concrete variable's *value*. A concrete variable's initial value is set when its declaration is processed.

* *Singleton* — A *variable name* is associated with a class method that returns a singleton object instance. The object returned by that method represents the singleton variable's *value*. A singleton variable's value is set once, when its declaration is processed.

* *Dynamic* — A *variable name* is associated with a Mockingbird expression. Whenever the variable is referenced, the associated expression is evaluated, and the value it yields represents the dynamic variable's *value*.

##### Concrete Variables

The `<Var>` tag provides support for specifying explicit values for types such as `NSString`s, `NSNumber`s, `NSArray`s, `NSDictionary`s and `BOOL`s.

Additional types can also be created using MBML functions, and values from other sources can be referenced through Mockingbird expressions.

###### Text Literals

Concrete text literals can be specified using the `literal` attribute. Within a literal, expressions are not evaluated, so there's no need to perform any escaping:

```xml
<Var name="currency" literal="$USD"/>
```

The declaration above sets `$currency` to an `NSString` containing "`$USD`".

###### Expression Values

If literals won't suffice, you can use the `value` attribute along with an object expression that will be evaluated when the declaration is processed. The variable's value is set to the value yielded by the expression.

```xml
<Var name="price" value="#(99.99)"/>
<Var name="priceLabel" value="${currency}${price}"/>
<Var name="appLaunchTime" value="^currentTime()"/>
```

The value in the first line above is wrapped in the `#(` ... `)` notation, so it is evaluated as a numeric expression. As a result, `$price` is set to an `NSNumber` containing the value `99.99`.

In the second line, the `value` attribute contains an expression referencing two values: `${currency}` and `${price}`. Whenever more than one value is referenced at the top level of an expression, string interpolation is used, so the resulting value will be an `NSString`. In this case, the value yielded is "`$USD99.99`".

The third line shows `$appLaunchTime` being set to the value returned by the `^currentTime()` function, which will be an `NSDate`.

> `<Var>` tags are always processed from the top of the document down. As a result, a `<Var>` declaration can *only* reference values declared above it or in any included file (because includes are processed first). Attempts to reference variables whose declarations haven't yet been processed will fail.

###### Boolean Values

Variables can be declared with boolean values using the `boolean` attribute:

```xml
<Var name="useLargeImageSizes" boolean="$Network.isWifiConnected -AND $Device.isRetina"/>
```

The `boolean` attribute's value is evaluated as a boolean expression, and the result is used as the variable's value.

In the example above, `$useLargeImageSizes` would be set to `true` if and only if `$Network.isWifiConnected` and `$Device.isRetina` both evaluate to `true`.

> In an actual application, `$useLargeImageSizes` should be declared as a *dynamic variable*, not a *concrete variable*. See the [**Dynamic Variables**](#dynamic-variables) section below for an explanation why.

###### Array Values

Arrays can be declared using the `type="list"` attribute. One such use might be to declare a list of U.S. states:

```xml
<Var name="states" type="list" mutable="F">
	<Var literal="Alabama"/>
	<Var literal="Alaska"/>
	<Var literal="Arizona"/>
	...
</Var>
```

The declaration above results in an `NSArray` containing the text literals specified. Notice that the inner `<Var>` tags do not take a `name` attribute, because an array is simply a list of unnamed values.

###### Dictionary Values

Mappings—which are `NSDictionary` instances—can be declared similarly, using the `type="map"` attribute. This declaration shows a mapping between state names and their corresponding postal codes:

```xml
<Var name="statesToPostalCodes" type="map" mutable="F">
	<Var name="Alabama" literal="AL"/>
	<Var name="Alaska"  literal="AK"/>
	<Var name="Arizona" literal="AZ"/>
	...
</Var>
```

In the resulting `NSDictionary`, the value of the `name` attribute specifies the *dictionary key* while the value of the `literal` attribute specifies the associated *dictionary value*.

> Although shown above with only `literal` attributes, the nested `<Var>`s within a list or map can also take either a `boolean` or a `value` attribute instead.

##### Singleton Variables

You can use the `<Var>` declaration with a `type="singleton"` attribute to expose singleton object instances to the variable space.

The singleton declaration requires a `class` attribute that specifies the name of the class vending the singleton, and a `method` attribute that specifies the name of a (no-argument) class method that returns the singleton instance.

```xml
<Var name="UIApplication" type="singleton" class="UIApplication" method="sharedApplication"/>
```

The declaration above, which can be found in [the `MBDataEnvironmentModule.xml` file](https://rawgit.com/emaloney/MBDataEnvironment/blob/master/Resources/MBDataEnvironmentModule.xml), exposes the value returned by the method `[UIApplication sharedApplication]` through the variable `$UIApplication`.

Because the value of the singleton variable is set when the `<Var>` tag is processed, this type of variable declaration should only be used for true singletons, which must behave as follows:

* The singleton instance is expected to exist for the lifetime of the running application.

* The value returned by the singleton accessor method must never change during the lifetime of the application.

##### Dynamic Variables

Dynamic variables associate an *expression* with a variable name rather than a specific *value*. When a dynamic variable is referenced, Mockingbird evaluates the associated expression, and the value yielded by that expression becomes the value yielded by the dynamic variable.

In the Concrete Variables section on [**Boolean Values**](#boolean-values) above, we saw the following declaration for `$useLargeImageSizes`:

```xml
<Var name="useLargeImageSizes" boolean="$Network.isWifiConnected -AND $Device.isRetina"/>
```

Because this declaration is not dynamic, `$useLargeImageSizes` is set when the `<Var>` tag is processed. The value of `$useLargeImageSizes` will therefore always reflect whatever the value of `$Network.isWifiConnected` was when the MBML was first loaded.

What we want is for `$useLargeImageSizes` to always reflect the *current* value of `$Network.isWifiConnected`. To do that, we would simply declare `$useLargeImageSizes` as a *dynamic variable*:

```xml
<Var name="useLargeImageSizes" type="dynamic" boolean="$Network.isWifiConnected -AND $Device.isRetina"/>
```

To understand the difference between concrete variables and dynamic variables, consider these two declarations:

```xml
<Var name="inThePast" value="^currentTime()"/>
<Var name="alwaysNow" type="dynamic" value="^currentTime()"/>
```

These declarations both associate a variable name with the `NSDate` returned by the `^currentTime()` function.

However, the concrete declaration of `$inThePast` ensures that the expression contained in the `value` attribute is evaluated just once, when the variable is declared. Unless the underlying value is explicitly changed, any time `$inThePast` is referenced, the value will be the same as it was when the declaration was originally processed.

The `$alwaysNow` variable works differently: the expression contained in the `value` attribute is evaluated whenever `$alwaysNow` is referenced. So the value of `$alwaysNow` will always yield an `NSDate` that was freshly fetched from a call to the `^currentTime()` function.

#### Functions

MBML functions are declared using the `<Function>` tag. Here are some examples taken from [the `MBDataEnvironmentModule.xml` file](https://rawgit.com/emaloney/MBDataEnvironment/blob/master/Resources/MBDataEnvironmentModule.xml):

```xml
<Function class="MBMLCollectionFunctions" name="mutableCopy" method="mutableCopyOf" input="object"/>
<Function class="MBMLDataProcessingFunctions" name="filter" input="pipedExpressions"/>
<Function class="MBMLDateFunctions" name="currentTime" input="none"/>
<Function class="MBMLStringFunctions" name="q" input="raw"/>
```

Declaring and implementing MBML functions is beyond the scope of this document. For details on the `<Function>` declaration and how it can be used, see the documentation for [the `MBMLFunction` class](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBMLFunction.html).

## Further Reading

If you'd like to learn more about how the Mockingbird Data Environment works, a good place to start would be the API documentation for the following classes:

* [`MBVariableSpace`](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBVariableSpace.html)
* [`MBEnvironment`](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBEnvironment.html)
* [`MBExpression`](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBExpression.html)
* [`MBDataModel`](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBDataModel.html)
* [`MBMLFunction`](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBMLFunction.html)
* [`MBStringConversions`](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBStringConversions.html)
* [`MBScopedVariables`](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/html/Classes/MBScopedVariables.html)

And, of course, feel free to delve into [the code](https://github.com/emaloney/MBDataEnvironment/tree/master/Code)!

## Additional Resources

For XML parsing, the Mockingbird Data Environment uses [a custom fork](https://github.com/emaloney/RaptureXML) of [the RaptureXML project](https://github.com/ZaBlanc/RaptureXML) created by [John Blanco](https://github.com/ZaBlanc).


### API documentation

For detailed information on using MBDataEnvironment, [API documentation](https://rawgit.com/emaloney/MBDataEnvironment/master/Documentation/API/index.html) is available.


## About

Over the years, Gilt Groupe has used and refined Mockingbird Library as the base for its various Apple Platform projects.

Mockingbird began life as AppFramework, created by Jesse Boyes.

AppFramework found a home at Gilt Groupe and eventually became Mockingbird Library.

In recent years, Mockingbird Library has been developed and maintained by Evan Maloney.


### Acknowledgements

API documentation is generated using [appledoc](http://gentlebytes.com/appledoc/) from [Gentle Bytes](http://gentlebytes.com/).
