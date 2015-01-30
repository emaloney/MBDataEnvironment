![Gilt Tech logo](Documentation/images/gilt-tech-logo.png)

# MBDataEnvironment

This repository hosts the Mockingbird Data Environment, an open-source project from Gilt Groupe that builds upon [the Mockingbird Toolbox](https://github.com/emaloney/MBToolbox) project to provide a dynamic data processing engine for iOS applications.

## About the Mockingbird Data Environment

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

## Integrating with your project

Currently, the only officially supported method to integrate the Mockingbird Data Environment into your project is using CocoaPods.

(An experimental—but unsupported—`MBDataEnvironment.framework` can be built for iOS 8 within `MBDataEnvironment.xcworkspace`.)

If you aren't already using CocoaPods, you'll find [documentation on the CocoaPods website](http://guides.cocoapods.org/using/index.html) to help you get started.

Once you've got CocoaPods up and running, you can add the Mockingbird Data Environment to your project simply by adding this line to your `Podfile`:

```ruby
pod 'MBDataEnvironment'
```

After you've added `MBDataEnvironment` to your `Podfile`, you can then install the CocoaPod from the command line. From within your project directory, issue the command:

```bash
pod install
```

**Important:** Take note of the output of the `pod install` command. If you were not previously using an Xcode workspace for your project, CocoaPods will create one for you that includes your project and any installed CocoaPods. Going forward, you will need to use that workspace for development instead of your old project file.

Once you've run the `pod install` command, you will be to reference the Mockingbird Data Environment from within your project.

You should reference header files using the “library header” import notation. For added convenience, you can reference the umbrella header, which ensures that you'll have access to the entire public API of the Mockingbird Data Environment:

```objc
#import <MBDataEnvironment/MBDataEnvironment.h>
```

In the future, we may issue binary releases of the Mockingbird Data Environment as iOS frameworks; using the notation above will allow you to seamlessly transition to using a framework.

## Initializing the Mockingbird Data Environment

Before making use of the Mockingbird Data Environment, your application first loads an `MBEnvironment` instance.

The simplest way to do this is to load the *default environment*:

```objc
[MBEnvironment loadDefaultEnvironment];
```

The default environment contains everything you need to get started using the Mockingbird Data Environment.

You can also provide your own *manifest file* that contains additional declarations allowing you to customize the initial state of the environment when it is loaded. 

The manifest is an XML file (typically named `manifest.xml`) that contains MBML markup for customizing and configuring the Mockingbird environment. (MBML is an XML derivative that stands for **M**ocking**b**ird **M**arkup **L**anguage.)

If your application provides a `manifest.xml` file in its resources, instead of calling `loadDefaultEnvironment`, you could load the environment using:

```objc
[MBEnvironment loadFromManifest];
```

Once an environment is loaded, you can start using *expressions* to interact with the Mockingbird Data Environment.

## An Introduction to Mockingbird Expressions

Mockingbird expressions are strings containing zero or more *literals* or *expression tokens*.

Depending on the context, Mockingbird expressions can contain:
 
 - text literals
 - numeric literals
 - references to variables of any Objective-C type
 - simple mathematical expressions
 - boolean logic expressions
 - function calls

The process of resolving an expression down to the specific value(s) it references is called _evaluation_. During evaluation, literals are passed through untouched, but any expression tokens encountered are replaced by the values they represent.

The primary interface for evaluating expressions is through several `MBExpression` class methods:

Expressions yielding|are evaluating using
--------------------|--------------------
`NSString`|`asString:`
`NSNumber`|`asNumber:`
`BOOL`|`asBoolean:`
`id` or `NSObject`|`asObject:`

#### An example

One use of a Mockingbird expression is to perform string replacement when populating user interface views, such as a `UILabel`:
 
```objc
	UILabel* greeting = // created elsewhere
	greeting.text = [MBExpression asString:@"Hello, $userName!"];
```

In the code above, the `text` property of the `greeting` label will be set to the result of evaluating the *string expression* "`Hello, $userName!`".

This particular expression consists of three parts: a text literal ("`Hello, `") followed by a reference to a Mockingbird variable called `userName`, followed by another text literal ("`!`").

When the expression is evaluated, the "`$userName`" portion of the expression is replaced by the value of the `userName` variable in the current *variable space*.

If the value of `userName` is "`Cooper`", then the label would display the text "`Hello, Cooper!`".

#### The Variable Space

The *variable space* is where Mockingbird variable values are stored.

Any native runtime object instance can be stored in the Mockingbird variable space. When an object is stored in the variable space, it is associated with a *variable name* and is then considered a *variable value*.

Variable values can be exposed to the variable space via Objective-C:

```objc
[[MBVariableSpace instance] setVariable:@"cats"
								  value:@[@"Barrett", @"Duncan", @"Gabby"]];
```

The code above associates the variable name "`cats`" with an `NSArray` instance containing three items (the strings "`Barrett`", "`Duncan`" and "`Gabby`").

Using an MBML manifest file to load the Mockingbird environment allows the variable space to be pre-populated with values.

You could ensure that the Mockingbird environment always has the same values for the variable "`cats`", for example, using an MBML *variable declaration* in the manifest:

```xml
<Var name="cats" type="list" mutable="F">
    <Var literal="Barrett"/>
    <Var literal="Duncan"/>
    <Var literal="Gabby"/>
</Var>
```

Using a manifest file allows you to avoid needing to programmatically populate the variable space with common values every time your application is launched.

#### Variable References

Regardless of how the value was introduced to the variable space, the array associated with the Mockingbird variable named "`cats`" can be accessed using the expression:

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
five = [MBExpression asNumber:@"25 % 10"];
```

All of the expressions above yield an `NSNumber` containing the value `5`.

As you can see, numeric expressions can contain simple math expressions. The `+`, `-`, `*`, `/` and `%` operators are supported. (Operators must be separated from surrounding tokens with a space.)

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

#### Expression Contexts

The four expression types—*string*, *object*, *numeric* and *boolean*—all handle their input and output differently. Therefore, an expression evaluated in a *string context* may yield a different result from the same expression evaluated in an *boolean context*. Likewise, an expression that's valid in a *numeric context* might not be valid in any other context.

For example, tokens like `-EQ`, `-LTE`, `-GT`, etc. are only valid in a boolean expression context. When encountered outside of a boolean context, the expression engine will treat those values as simple text literals. If you've got an expression that's not behaving as you expect, double-check that the expression context is what you assume it is.

Sometimes, you might want to mix contexts. For example, you might want to display a string in a `UILabel` that includes a mathematical calculation. Or you might want to display a message that contains some conditional text within it.

##### Forcing a Numeric Context

You can embed a numeric expression within any other expression context using the notation: **`#(`** *numeric expression* **`)`**.

For example:

```objc
[MBExpression asString:@"There are #(10 - 3) days in the week."];
```

In this example, the expression consists of three components: the text literal "`There are `", then the numeric expression `#(10 - 3)`, followed by another text literal: "` days in the week.`".

As usual, the text literals are returned as-is, but the numeric expression is evaluated as such, resulting in the value `7`. So, the expression above would return the value `"There are 7 days in the week."`

##### Forcing a Boolean Context

You can evaluate a boolean expression within a non-boolean context using the notation: **`^if(`** *boolean expression* **`|`** *true result* [ **`|`** *false result* ] **`)`**. 

When this notation is encountered, *boolean expression* is evaluated in the boolean context, and based on the resulting value, either *true result* or *false result* is returned.

```objc
[MBExpression asString:@"You ^if($user.isAdmin|have|do not have) admin privileges"];
```

The result of evaluating the expression above depends on the boolean value of the `$user.isAdmin` expression. If it evaluates to `true`, the return value will be "`You have admin privileges`"; otherwise, it will be "`You do not have admin privileges`".

Because either *true result* or *false result* can be empty strings, the expression above could be rewritten slightly more succinctly while achieving the same result:

```objc
[MBExpression asString:@"You ^if($user.isAdmin||do not )have admin privileges"];
```

Which is also the logical equivalent of:

```objc
[MBExpression asString:@"You ^if(!$user.isAdmin|do not |)have admin privileges"];
```

Note that the entire *false result* clause is optional. If the *false result* clause and the `|` (pipe character) that precedes it are omitted, `nil` is returned when the *boolean expression* evaluates to `false`:

```objc
[MBExpression asObject:@"^if(F|hello)"];
```

The expression above will always return `nil` because in a boolean context, the uppercase letter '`F`' represents the boolean constant `false`. (In all other contexts, '`F`' is simply a text literal with no special meaning.)

##### Quoting

In some cases, an expression may contain characters that you don't want to be recognized as part of an expression. 

For example, consider this string expression:

```
It will cost $total for your $quantity tickets to the Ke$ha concert
```

The `$` character signals the beginning of a variable reference, so while `$total` and `$quantity` are correctly recognized as variables, the text "`$ha`" in the name "`Ke$ha`" will be incorrectly interpreted as a variable reference.

Assuming there is no value for `$ha`, the expression will yield a string that ends in "`Ke concert`" instead of the intended "`Ke$ha concert`".

To avoid this problem, you can use *quoting* to ensure that portions of your expression are not evaluated. You can think of quoting as representing a *raw context* wherein values are passed through as-is during expression evaluation.

To quote a range of text within an expression, you would precede the text you want to quote with "`^q(`" and close it with "`)`". The text that appears within the parentheses is returned as-is when the expression containing the quote is evaluated.

A quoted form of the expression above is:

```
It will cost $total for your $quantity tickets to the ^q(Ke$ha) concert
```

When this expression is evaluated, the string returned will correctly contain the text "`Ke$ha`" instead of just "`Ke`".

##### Escape Sequences

A technique similar to quoting is to use *escape sequences* to represent a character that can't be represented by itself.

For example, the string "`$$`" is an escape sequence representing the dollar-sign character '`$`'. Just as quoting was used to ensure that "`Ke$ha`" was handled correctly, this escape sequence could also be used:

```
It will cost $total for your $quantity tickets to the Ke$$ha concert
```

**Note:** The expression engine is able to interpret escape sequences more efficiently than quoting, so if it is possible to represent what you need without using quoting, you should strive to do so.

The following escape sequences are supported:

Escape sequence|represents
---------------|----------
`$$`|'`$`'
`##`|'`#`'
`^^`|'`^`'
`\n`|Newline character
`\t`|Tab character

#### Additional Variable Reference Notations

So far, we've seen one form of variable reference notation: `$` followed by the name of a variable. This is called the *simple variable reference notation*.

This notation can be used when the variable name is considered an *identifier*. Identifiers are names that are constructed as follows:

- The first character can be an uppercase or lowercase alphabetic character or an underscore ('`_`').

- Subsequent characters can be uppercase or lowercase alphabetic characters, numeric digits, underscores ('`_`'), hyphens ('`-`'), or colons ('`:`').

In some cases, the simple notation can't be used to reference a given variable because the name of the variable is not a valid identifier.

In other cases, you may want to ensure that the parser recognizes a boundary between a variable name and a literal or another expression.

There are additional variable reference notations that you can use to ensure your expression is interpreted as you intend.

##### Curly-Brace Notation

The curly-brace variable reference notation can be used to prevent the expression engine from interpreting characters following a variable reference as being part of the reference itself. The notation is used by surrounding the variable name with curly braces.

The curly-brace notation is similar to the simple notation in that it only accepts variable names that are also valid identifiers. The expressions `$userName` and `${userName}` both refer to the same variable, but they cause the expression evaluator to treat the characters following the variable name differently.

Let's say you have a variable called `lastName` that contains a person's surname, and you want to construct a message such as "How are the Butterfields doing?" that refers to the surname in the plural form.

You couldn't use the unquoted notation (eg., "`How are the $lastNames doing?`") because the '`s`' at the end of `$lastName` would be interpreted as part of the variable name. Instead of referencing the variable `lastName` followed by the character literal '`s`', the expression actually references an entirely different variable called `lastNames`.

One way to ensure the variable reference is handled correctly would be to quote the '`s`', such as:

```
How are the $lastName^q(s) doing?
```

This works, but it involves a function call and the overhead of marshaling the parameters and processing the return value.

The curly-brace notation provides a better solution that allows you to separate the variable reference from any surrounding text that should be considered a literal. Using this notation, the expression can instad be written as:

```
How are the ${lastName}s doing?
```

This expression will be interpreted as the text literal "`How are the `" followed by a reference to the Mockingbird variable `lastName`, followed by another text literal, "`s doing?`".

##### Bracket Notation

The bracket variable reference notation can be used to access Mockingbird variables whose names aren't valid identifiers.

For example, the space character and the dollar sign ('`$`') are not valid identifier characters. Normally, when a space is encountered while interpreting a variable name, the expression engine assumes that the space signals the end of the variable name. When a dollar sign is encountered within an expression, the expression engine assumes it signals the beginning of a variable reference.

Because Mockingbird variable names don't *have* to be identifiers, the bracket notation exists to allow access to variables whose names aren't identifiers.

Let's say your application connects to a backend system that introduces a Mockingbird variable named "`total $`". You could reference the value of this variable with the expression:

```
$[total $]
```

Using the bracket notation allows subreferences after the closing bracket. Assuming the variable `total $` is a string, the following expression would yield the length of the string:

```
$[total $].length
```

##### Parentheses Notation

As with the bracket notation, the parentheses variable reference notation can be used to access Mockingbird variables whose names aren't valid identifiers. And like the curly-brace notation, the parentheses notation prevents the expression engine from misconstruing adjacent characters as being part of the variable reference.

For example, consider these two expressions:

```
$[total $].length
$(total $).length
```

The top expression uses the bracket notation, which allows subreferences after the closing bracket. The bottom expression uses the parentheses notation, which does not allow subreferences.

Because subreferences are not allowed by the parentheses notation, any text that appears after the closing parenthesis will be considered the start of a new statement. In this case, since "`.length`" is not a valid variable reference, function call, or math expression, it is interpreted as a text literal.

So while `$[total $].length` will yield the return value of the `length` property of the variable named `total $`, `$(total $).length` will yield the value of the variable `total $` followed by the text literal "`.length`".

#### Variable Notation Summary

Notation|Variable Name|Example|Example With Subreference|Follow-on Subreferences|
--------|---------------|-------|-----------------|-----------------------|
simple|must be an identifier|`$variableName`|`$string.length`|allowed|
curly-brace|must be an identifier|`${variableName}`|`${string.length}`|not recognized|
bracket|can contain any character except `[` or `]`|`$[variable name]`|`$[a string].length`|allowed|
parentheses|can contain any character except `(` or `)`|`$(variable name)`|not possible|not recognized|

#### MBML Functions

MBML functions allow native Objective-C code to be called from within Mockingbird expressions. Functions can take zero or more input parameters, and they may return an object instance as a result.

When an expression containing a function call is evaluated, the implementing method of the function is executed, and the value returned by the method (if any) is yielded by the function. Values returned by function implementations can then be manipulated further within an expression.

Function calls begin with a caret character ('`^`'), followed by the name of the function, and end in a list of zero or more pipe-separated parameters surrounded by parentheses.

For example, to call a function that creates an array, you could write:

```
^array(pizza|pasta|sushi|lobster)
```

If this notation looks familiar, it's because you've already encountered two functions—`^if()` and `^q()`—in the documentation above.

In this example, the `^array()` function returns an `NSArray` containing four items: the strings "`pizza`", "`pasta`", "`sushi`" and "`lobster`".

Because this particular expression yields an object, we can access values in the returned object as if it were a regular Mockingbird object reference. To access the fourth element in the (zero-indexed) array, you would write:

```
^array(pizza|pasta|sushi|lobster)[3]
```

This expression yields the value "`lobster`".

The Mockingbird Data Environment ships with nearly 200 functions built in, and you can add more through `MBModule`s or by implementing them yourelf.

The list of included functions can be seen in the <code>MBDataEnvironmentModule.xml</code> file; they are declared using the `<Function ... />` tag.

The documentation for the functions themselves can be found alongside that of their implementing methods:

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
