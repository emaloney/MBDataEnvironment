//
//  MBDataModel.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 8/22/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBToolbox.h>

#import "MBExpression.h"
#import "MBDataEnvironmentConstants.h"

@class RXMLElement;

/******************************************************************************/
#pragma mark MBML Attribute Marking
/******************************************************************************/

/*!
 A marker used in conjunction with an Objective-C property declaration that
 indicates the property is intended to be used as an MBML attribute. The 
 initial value of such attributes is set via MBML; further access is provided
 through the standard Objective-C getter/setter property interface.
 */
#define MBMLAttribute

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

extern NSString* const kMBDataModelDefaultRelation;

/******************************************************************************/
#pragma mark -
#pragma mark MBDataModel class
/******************************************************************************/

/*!
 An implementation of a generic class representing a data model. Each data
 model instance contains attributes and related objects that are typically
 populated from XML.
 
 When populated from an XML element, a data model may contain _attributes_ 
 and _related objects_. The data model's attributes are populated from the
 element's attributes, and the model will contain related objects for any
 child XML elements.
 
 Data models support validation, wherein their attributes and related objects
 are inspected to see whether they contain the expected values. Subclasses
 may implement any of the following methods to participate in validation:
 
 * +requiredAttributes
 * +supportedAttributes
 * +unsupportedAttributes
 * -validateAttributes
 * -validateAsRelativeOf:relatedBy:dataModelRoot:
 
 Mockingbird uses instances of this class to represent data loaded from
 MBML (the XML-based **M**ocking**b**ird **M**arkup **L**anguage), and
 validation is performed to notify MBML developers of any errors in their code.
 */
@interface MBDataModel : MBFormattedDescriptionObject < NSCopying, NSMutableCopying, NSCoding >

/*******************************************************************************
 @name Factory & initializer methods
 ******************************************************************************/

/*!
 Creates and returns a new data model populated with the contents of the
 passed-in XML element. Attribute values will be set from the attributes of
 the XML element, and further object relationships may be established by
 processing the children of the element.
 
 @param     xml The XML to use for populating the data model
 */
+ (instancetype) dataModelFromXML:(RXMLElement*)xml;

/*!
 Default initializer; returns an empty data model instance.
 */
- (id) init;

/*!
 Populates the receiver with the data model inherent in the provided
 XML element. Attribute values will be set from the attributes of the XML
 element, and further object relationships may be established by processing
 the children of the element.
 
 @param     xml The XML to use for populating the data model
 */
- (id) initWithXML:(RXMLElement*)xml;

/*!
 For each key/value pair contained in the passed-in dictionary, a
 corresponding attribute name and value will be set on the receiver.
 
 @param     attrs A dictionary containing the attribute names
            and values to use for initializing the data model object.
                
 */
- (id) initWithAttributes:(NSDictionary*)attrs;

/******************************************************************************
 @name NSCopying support
 ******************************************************************************/

/*!
 Returns a copy of the receiver. Since all `MBDataModel` instances are
 mutable, this method simply calls mutableCopyWithZone:.
 
 @param     zone Identifies a memory zone to use for allocating any new
            object instances. If `nil`, the default zone returned by
            `NSDefaultMallocZone()` is used.
 */
- (id) copyWithZone:(NSZone*)zone;

/*!
 Returns a copy of the receiver.
 
 @param     zone Identifies a memory zone to use for allocating any new
            object instances. If `nil`, the default zone returned by
            `NSDefaultMallocZone()` is used.
 */
- (id) mutableCopyWithZone:(NSZone*)zone;

/*!
 Turns the receiver into a clone of the passed-in data model. Any attributes
 and relatives held by the receiver are thrown away, and then the receiver
 is configured to contain all the same attributes and relatives as
 `cloneFrom`.
 
 @param     cloneFrom The data model to clone.
 */
- (void) cloneDataModel:(MBDataModel*)cloneFrom;

/*!
 Turns the receiver into a clone of the passed-in data model. Any attributes
 and relatives held by the receiver are thrown away, and then the receiver
 is configured to contain all the same attributes and relatives as
 `cloneFrom`.
 
 @param     cloneFrom The data model to clone.
 
 @param     zone The `NSZone` to use for any objects that need to be copied
            as a result of the cloning process. If `nil`, the default zone 
            returned by `NSDefaultMallocZone()` is used.
 */
- (void) cloneDataModel:(MBDataModel*)cloneFrom withZone:(NSZone*)zone;

/*******************************************************************************
 @name Class posing
 ******************************************************************************/

/*!
 Returns a new data model instance of the specified class that contains
 the exact same attributes and relatives as the receiver.

 This is useful in cases where you need to instantiate generic data models
 from XML before doing the work of deciding what each node should be. Allows
 for faster loading of data models from XML.

 @param     cls The class to pose as.
 
 @return    A new data model instance of type `cls` containing the same
            data model attributes and related objects as the receiver, or
            `nil` if `cls` is not a type of `MBDataModel` class.
 */
- (id) poseAsClass:(Class)cls;

/*******************************************************************************
 @name XML parsing convenience
 ******************************************************************************/

/*!
 A convenience method for parsing an XML document from a file.
 
 @param     filePath The path of the XML file to be processed.
 
 @param     errPtr If non-`nil` and an error occurs, this pointer will be
            set to an `NSError` instance indicating the error.
 
 @return    An object representing the top-level element of the XML.
 */
+ (RXMLElement*) xmlFromFile:(NSString*)filePath error:(NSError**)errPtr;

/*!
 A convenience method for parsing an XML document from an `NSData` instance.
 
 @param     xmlData The XML data to be processed.
 
 @param     errPtr If non-`nil` and an error occurs, this pointer will be
            set to an `NSError` instance indicating the error.
 
 @return    An object representing the top-level element of the XML.
 */
+ (RXMLElement*) xmlFromData:(NSData*)xmlData error:(NSError**)errPtr;

/*******************************************************************************
 @name Populating the data model
 ******************************************************************************/

/*!
 Amends the data model by overlaying attributes and potentially adding
 relatives to the receiver based on the contents of the passed-in XML.
 If the receiver contains attributes also present on the XML element, 
 the receiver's attributes are replaced, while new attributes are added.
 If the XML element contains child elements, they are added to the receiver
 as related objects.
 
 @param     xml The XML element to use for amending the data model.
 */
- (void) amendDataModelWithXML:(RXMLElement*)xml;

/*!
 Amends the data model by overlaying attributes and potentially adding
 relatives to the receiver based on the contents of the passed-in XML.
 If the receiver contains attributes also present on the XML element, 
 the receiver's attributes are replaced, while new attributes are added.
 If the XML element contains child elements, they are added to the receiver
 as related objects.

 @param     filePath The path of the file containing the XML to process.
 
 @return    `YES` if the XML file was processed successfully; `NO` otherwise.
 */
- (BOOL) amendDataModelWithXMLFromFile:(NSString*)filePath;

/*!
 Amends the data model by overlaying attributes and potentially adding
 relatives to the receiver based on the contents of the passed-in XML.
 If the receiver contains attributes also present on the XML element, 
 the receiver's attributes are replaced, while new attributes are added.
 If the XML element contains child elements, they are added to the receiver
 as related objects.
 
 @param     filePath The path of the file containing the XML to process.

 @param     errPtr If non-`nil` and an error occurs, this pointer will be
            set to an `NSError` instance indicating the error.
 
 @return    `YES` if the XML file was processed successfully; `NO` otherwise.
*/
- (BOOL) amendDataModelWithXMLFromFile:(NSString*)filePath error:(NSError**)errPtr;

/*!
 Amends the data model by overlaying attributes and potentially adding
 relatives to the receiver based on the contents of the passed-in XML.
 If the receiver contains attributes also present on the XML element, 
 the receiver's attributes are replaced, while new attributes are added.
 If the XML element contains child elements, they are added to the receiver
 as related objects.
 
 @param     xmlData An `NSData` instance containing the XML to process.
 
 @return    `YES` if the XML data was processed successfully; `NO` otherwise.
*/
- (BOOL) amendDataModelWithXMLFromData:(NSData*)xmlData;

/*!
 Amends the data model by overlaying attributes and potentially adding
 relatives to the receiver based on the contents of the passed-in XML.
 If the receiver contains attributes also present on the XML element, 
 the receiver's attributes are replaced, while new attributes are added.
 If the XML element contains child elements, they are added to the receiver
 as related objects.
 
 @param     xmlData An `NSData` instance containing the XML to process.
 
 @param     errPtr If non-`nil` and an error occurs, this pointer will be
            set to an `NSError` instance indicating the error.
 
 @return    `YES` if the XML data was processed successfully; `NO` otherwise.
 */
- (BOOL) amendDataModelWithXMLFromData:(NSData*)xmlData error:(NSError**)errPtr;

/*!
 For each attribute value on the passed-in XML element, a corresponding
 attribute will be set on the receiver. If the receiver contains attributes
 also present on the XML element, the receiver's attributes are replaced, while
 new attributes are added.
 
 @param     el The XML element to process.
 */
- (void) addAttributesFromXML:(RXMLElement*)el;

/*!
 For each key/value pair contained in the passed-in dictionary, a corresponding
 attribute will be set on the receiver. If the receiver contains attributes
 also present on the XML element, the receiver's attributes are replaced, while
 new attributes are added.
 
 @param     dict The dictionary containing the attributes values to be set.
*/
- (void) addAttributesFromDictionary:(NSDictionary*)dict;

/*!
 For each attribute key contained in the passed-in dictionary, the receiver
 will be checked for an attribute having the same name. If the receiver has
 no attribute with that name, the corresponding key/value pair in the
 dictionary will be set on the receiver. Existing attributes will **not** be
 overwritten.
 
 @param     dict The dictionary containing the attributes values to overlay.
 */
- (void) overlayAttributesFromDictionary:(NSDictionary*)dict;

/*!
 Adds related objects, if appropriate, for each XML element contained in
 the passed-in element. The default implementation creates `MBDataModel`
 objects to represent the structure of the contained XML elements, and
 adds them as related objects to the receiver using the default relation
 type.
 
 @param     container The XML element whose child elements will be used
            to populate the receiver.
 */
- (void) populateDataModelFromXML:(RXMLElement*)container;

/*!
 Called to notify the data model that it has been loaded or instantiated.
 
 @note      Subclasses overriding this method must always call `super`.
 */
- (void) dataModelDidLoad;

/*!
 Called to notify the data model that it has been amended using the contents
 of the given file.
 
 @param     filePath The path of the file whose XML was loaded.
 
 @note      Subclasses overriding this method must always call `super`.
 */
- (void) didAmendDataModelWithXMLFromFile:(NSString*)filePath;

/*******************************************************************************
 @name XML representation
 ******************************************************************************/

/*!
 The entity name used to represent instances of the receiver's class. Used
 for the XML tag in simulated XML output when the `xmlTagName` method would
 return `nil`.
 */
+ (NSString*) dataEntityName;

/*!
 If the receiver was created from an XML element, this method returns the name 
 of the XML tag from which it originated.
 
 @return    The XML tag name used to create the receiver, or `nil` if
            the receiver was not created from XML.
 */
@property(nonatomic, readonly) NSString* xmlTagName;

/*!
 Returns a string containing a simulated XML representation of the receiver's
 attributes and related objects. This method works even if the receiver was not
 populated from XML in the first place.
 
 @note      The XML output is simulated and may not be a byte-for-byte
            representation of the originating XML (if any). Non-significant
            whitespace and attribute order may differ, and if any attributes
            were applied from an MBStyledDataModel, they will be represented
            in the simulated XML as well.
 */
@property(nonatomic, readonly) NSString* simulatedXML;

/*!
 Provides simulated XML output similar to that of the `simulatedXML` property,
 but with XML comments added that describe the relation type of any related
 objects.
*/
@property(nonatomic, readonly) NSString* debuggingXML;

/*******************************************************************************
 @name Data model enforcement
 ******************************************************************************/

/*!
 Returns the set of attributes required by the receiving class (and not any
 superclass or subclass).
 
 A data model object that is missing one or more of the required attributes 
 will not pass validation.
 
 @return    The default implementation returns `nil`, indicating that no
            attributes are explicitly required. Subclasses must provide their
            own implementation if they require specific attributes to be present
            in order to pass validation.
 
 @warning   Subclasses overriding this method **must never** call `super`.
 */
+ (NSSet*) requiredAttributes;

/*!
 Returns the set of attributes supported by the receiving class (and not any
 superclass or subclass).
 
 During validation, a data model object will issue a warning if it contains 
 one or more attributes not appearing in the set of supported attributes.
 
 @note      Implementations do not need to report an attribute as supported
            if it is also reported as required. 

 @return    The default implementation returns `nil`, indicating that no
            attributes are explicitly supported. Subclasses must provide their
            own implementation if they will report specific attributes as
            unsupported when performing validation.

 @warning   Subclasses overriding this method **must never** call `super`.
 */
+ (NSSet*) supportedAttributes;

/*!
 Returns the set of attributes supported that are supported by one of the
 receiving class's superclasses that are unsupported by the receiving class.
 
 This mechanism allows a class to declare that it does not support one or
 more attributes supported by a superclass.
 
 A data model object will issue warnings for each unsupported attribute
 present during validation.
 
 @return    The default implementation returns `nil`, indicating that no
            attributes are explicitly unsupported.

 @warning   Subclasses overriding this method **must never** call `super`.
*/
+ (NSSet*) unsupportedAttributes;

/*!
 Returns the name of an attribute that specifies an alternate implementing
 class for the data model object, allowing external classes to participate
 in attribute validation.
 
 @return    The default implementation returns `nil`, indicating that the 
            receiver will not consult an external class for determining
            which data model attributes are valid.
 */
- (NSString*) implementingClassAttributeName;

/*!
 Returns the names of the attributes that are required by the receiver in
 order to pass validation.
 */
- (NSSet*) requiredAttributes;

/*!
 Returns the names of the attributes that will ignored by the receiver.
 */
- (NSSet*) ignoredAttributes;

/*!
 Marks an attribute as being deprecated in favor of another attribute. This
 mechanism is used to rename an attribute while still maintaining backwards
 compatibility with existing code.
 
 Whenever a deprecated attribute is encountered during validation, a warning
 is issued and the value of the deprecated attribute is copied to the new
 attribute (assuming the new attribute doesn't already exist, in which case
 the value of the deprecated attribute is ignored altogether).
 
 @note      This method must be called prior to invoking the superclass 
            implementation of the `validateAttributes` method.
 
 @param     deprecatedAttribute The name of the deprecated attribute.
 
 @param     newAttribute The name of the attribute to use instead of
            `deprecatedAttribute`.
 */
- (void) deprecateAttribute:(NSString*)deprecatedAttribute inFavorOf:(NSString*)newAttribute;

/*******************************************************************************
 @name Data model validation
 ******************************************************************************/

/*!
 Attempts to validate the data model using the receiver as the root node.

 Validation will occur even if the receiver is not marked as needing validation.
 Use validateDataModelIfNeeded to ensure validation occurs only when necessary.

 @return    `YES` if the receiver's data model is valid; `NO` otherwise. 
 
 @warning   Subclasses shouldn't override this method. Instead, to hook into the
            validation process, subclasses should override `validateAttributes`
            or `validateAsRelativeOf:relatedBy:dataModelRoot:`.
 */
- (BOOL) validateDataModel;

/*!
 If the data model is marked as needing validation, this method returns the
 result of calling validateDataModel; otherwise, this method returns the
 result of calling isDataModelValid.
 
 @return    `YES` if the receiver's data model is valid; `NO` otherwise. 

 @warning   Subclasses shouldn't override this method. Instead, to hook into the
            validation process, subclasses should override `validateAttributes`
            or `validateAsRelativeOf:relatedBy:dataModelRoot:`.
 */
- (BOOL) validateDataModelIfNeeded;

/*!
 Asks the receiver to validate its data model attributes (but not any related
 objects).
 
 A data model object's attributes are considered valid if all required 
 attributes are present.
 
 Subclasses that need to hook into the attribute validation process may 
 override this method, but should call the superclass implementation.
 
 @note      For each unsupported attribute encountered during attribute 
            validation, a warning will be logged to the console. However,
            the presence of unsupported attributes will not cause the data
            model to be considered invalid.
 
 @return    `YES` if the receiver's attributes are valid; `NO` otherwise.
 */
- (BOOL) validateAttributes;

/*!
 Called by validateDataModel to attempt to validate a member of a larger data
 model.
 
 Subclasses that need to hook into the data model validation process may 
 override this method. However, if subclasses only need to perform attribute 
 validation, they should override the simpler validateAttributes method.
 
 If a subclass implementation detects no problem with the data model, it
 should return the value returned by calling the superclass's 
 validateAsRelativeOf:relatedBy:dataModelRoot: method.
 
 At the first sign of an invalid data model, subclass implementations
 should return `NO`.
 
 @param     relative If the receiver is being validated as a relative of
            another data model object, this parameter will contain the
            relative. This parameter will be `nil` if the receiver is the
            root node of the data model.
 
 @param     relationType If the receiver is being validated as a relative of
            another data model object, this parameter will contain the name of
            the relation type by which the receiver is related to `relative`.
            This parameter will be `nil` if the receiver is the root node of
            the data model.
 
 @param     root If the receiver is being validated as a relative of another
            data model object, this parameter will contain the root node of the
            data model (in other words, the original receiver of the call to
            validateDataModel). If the receiver is the root node of the data
            model being validated, this parameter will equal `self`.
 
 @return    `YES` if the receiver's data model is valid; `NO` otherwise.

 @warning   This method should not be called directly, except by subclasses 
            calling the superclass implementation.
 */
- (BOOL) validateAsRelativeOf:(MBDataModel*)relative
                    relatedBy:(NSString*)relationType
                dataModelRoot:(MBDataModel*)root;

/*! 
 This method is called to mark the receiver as needing validation.
 */
- (void) markDataModelNeedsValidation;

/*!
 Returns `YES` if the receiver needs data model validation, `NO` otherwise. 
 Whenever the data model changes, it will be marked as needing validation.
 
 @note      At instantiation time, a data model is considered invalid and is 
            marked as needing validation. After a call to validateDataModel 
            returns, the receiver is marked as no longer needing validation,
            even if validation fails.
 */
- (BOOL) doesDataModelNeedValidation;

/*! 
 This method is called to mark the receiver's data model as invalid.
 */
- (void) markDataModelInvalid;

/*!
 Returns `YES` if the receiver's most recent validation attempt succeeded
 and if the receiver is not marked as needing validation.
*/
- (BOOL) isDataModelValid;

/*******************************************************************************
 @name Copying data model attributes
 ******************************************************************************/

/*!
 Returns a copy of the receiver's attribute values.
 */
- (NSDictionary*) objectAttributes;

/*!
 Adds the receiver's attributes to the passed-in `NSMutableDictionary`.
 
 @param     dict The dictionary to which the receiver's attribute names
            and values will be added.
 */
- (void) addAttributesToDictionary:(NSMutableDictionary*)dict;

/*******************************************************************************
 @name Accessing data model values
 ******************************************************************************/

/*!
 Represents the content of this data model object. When the data model is
 populated from an XML element containing text content, this property will
 contain that text.
 */
@property(nonatomic, strong) id content;

/*!
 Returns `YES` if the value of the `content` property is a string, and if
 that string contains at least one non-whitespace character.
 */
@property(nonatomic, assign) BOOL hasStringContent;

/*!
 Returns the number of attributes currently set on the receiver.
 */
- (NSUInteger) countAttributes;

/*!
 Returns an array containing the names of the attributes that currently
 have values set on the receiver.
 */
- (NSArray*) attributeNames;

/*!
 Returns `YES` if the receiver has an attribute with the specified name,
 `NO` otherwise.
 
 @param     attrName The name of the attribute to check.
 */
- (BOOL) hasAttribute:(NSString*)attrName;

/*!
 Returns the value of the attribute with the specified name.
 
 @param     attrName The name of the attribute whose value is to be retrieved.
 */
- (id) valueOfAttribute:(NSString*)attrName;

/*!
 Returns the value of the attribute with the specified name as a string,
 making a reasonable attempt to convert the attribute value's type if
 necessary.
 
 @param     attrName The name of the attribute whose value is to be retrieved.
 */
- (NSString*) stringValueOfAttribute:(NSString*)attrName;

/*!
 Returns the value of the attribute with the specified name as a string,
 making a reasonable attempt to convert the attribute value's type if
 necessary.
 
 @param     attrName The name of the attribute whose value is to be retrieved.
 */
- (NSDecimalNumber*) numberValueOfAttribute:(NSString*)attrName;

/*!
 Returns the value of the attribute with the specified name as a boolean,
 making a reasonable attempt to convert the attribute value's type if
 necessary.
 
 @param     attrName The name of the attribute whose value is to be retrieved.
 */
- (BOOL) booleanValueOfAttribute:(NSString*)attrName;

/*!
 Returns the value of the attribute with the specified name as an integer,
 making a reasonable attempt to convert the attribute value's type if
 necessary.
 
 @param     attrName The name of the attribute whose value is to be retrieved.
 */
- (NSInteger) integerValueOfAttribute:(NSString*)attrName;

/*!
 Returns the value of the attribute with the specified name as a double,
 making a reasonable attempt to convert the attribute value's type if
 necessary.

 @param     attrName The name of the attribute whose value is to be retrieved.
 */
- (double) doubleValueOfAttribute:(NSString*)attrName;

/*******************************************************************************
 @name Keyed subscripting support
 ******************************************************************************/

/*!
 Allows accessing data model attributes using the Objective-C keyed 
 subscripting notation.
 
 Assuming a data model object `node`, the following expression:
 
    node[@"title"]
 
 would yield `node`'s value of the attribute named `title`.

 @param     attrName The name of the attribute whose value is to be retrieved.
 
 @return    The value of the attribute with the name `attrName`.
 */
- (id) objectForKeyedSubscript:(NSString*)attrName;

/*!
 Allows setting data model attributes using the Objective-C keyed
 subscripting notation.

 Assuming a data model object `node`. the following expression:
 
    node[@"title"] = @"Mockingbird";
 
 would set `node`'s attribute named `title` to the string "`Mockingbird`".

 @param     obj The new value for the attribute.

 @param     attrName The name of the attribute whose value is to be set.
 */
- (void) setObject:(id)obj forKeyedSubscript:(NSString*)attrName;

/*******************************************************************************
 @name Performing expression evaluation on attribute values
 ******************************************************************************/

/*!
 Returns the object result of evaluating the string value of the specified 
 attribute as an MBML object expression.
 
 @param     attrName The name of the attribute whose value will be evaluated.
 */
- (id) evaluateAsObject:(NSString*)attrName;

/*!
 Returns the object result of evaluating the string value of the specified 
 attribute as an MBML object expression.
 
 @param     attrName The name of the attribute whose value will be evaluated.
 
 @param     def The value to return if the receiver has no attribute named
            `attrName`, or if expression evaluation failed for some reason.
 */
- (id) evaluateAsObject:(NSString*)attrName defaultValue:(id)def;

/*!
 Returns the string result of evaluating the string value of the specified 
 attribute as an MBML string expression.

 @param     attrName The name of the attribute whose value will be evaluated.
 */
- (NSString*) evaluateAsString:(NSString*)attrName;

/*!
 Returns the string result of evaluating the string value of the specified 
 attribute as an MBML string expression.
 
 @param     attrName The name of the attribute whose value will be evaluated.
 
 @param     def The value to return if the receiver has no attribute named
            `attrName`, or if expression evaluation failed for some reason.
 */
- (NSString*) evaluateAsString:(NSString*)attrName defaultValue:(NSString*)def;

/*!
 Returns the numeric result of evaluating the string value of the specified 
 attribute as an MBML number expression.
 
 @param     attrName The name of the attribute whose value will be evaluated.
 */
- (NSDecimalNumber*) evaluateAsNumber:(NSString*)attrName;

/*!
 Returns the numeric result of evaluating the string value of the specified 
 attribute as an MBML number expression.
 
 @param     attrName The name of the attribute whose value will be evaluated.
 
 @param     def The value to return if the receiver has no attribute named
            `attrName`, or if expression evaluation failed for some reason.
 */
- (NSDecimalNumber*) evaluateAsNumber:(NSString*)attrName defaultValue:(NSDecimalNumber*)def;

/*!
 Returns the boolean result of evaluating the string value of the specified 
 attribute as an MBML boolean expression.
 
 @param     attrName The name of the attribute whose value will be evaluated.
 */
- (BOOL) evaluateAsBoolean:(NSString*)attrName;

/*!
 Returns the boolean result of evaluating the string value of the specified 
 attribute as an MBML boolean expression.
 
 @param     attrName The name of the attribute whose value will be evaluated.
 
 @param     def The value to return if the receiver has no attribute named
            `attrName`, or if expression evaluation failed for some reason.
 */
- (BOOL) evaluateAsBoolean:(NSString*)attrName defaultValue:(BOOL)def;

/*******************************************************************************
 @name Setting data model attribute values
 ******************************************************************************/

/*!
 Sets a data model attribute value.
 
 @param     attrVal The new value of the attribute.
 
 @param     attrName The name of the attribute whose value is being set.
 */
- (void) setAttribute:(id)attrVal forName:(NSString*)attrName;

/*!
 Sets a boolean data model attribute value.
 
 @param     attrVal The new value of the attribute.
 
 @param     attrName The name of the attribute whose value is being set.
 */
- (void) setBooleanAttribute:(BOOL)attrVal forName:(NSString*)attrName;

/*!
 Sets a boolean data model attribute value.
 
 @param     attrVal The new value of the attribute.
 
 @param     attrName The name of the attribute whose value is being set.
 */
- (void) setIntegerAttribute:(NSInteger)attrVal forName:(NSString*)attrName;

/*!
 Sets a double data model attribute value.
 
 @param     attrVal The new value of the attribute.
 
 @param     attrName The name of the attribute whose value is being set.
*/
- (void) setDoubleAttribute:(double)attrVal forName:(NSString*)attrName;

/*******************************************************************************
 @name Renaming and removing attributes
 ******************************************************************************/

/*!
 Renames an attribute, moving the value from the old attribute name to the
 new name.
 
 @param     oldName The name of the attribute to rename to `newName`.
 
 @param     newName The new name for the attribute currently known as `oldName`.
 */
- (void) renameAttribute:(NSString*)oldName to:(NSString*)newName;

/*!
 Removes the specified attribute from the receiver.
 
 @param     attrName The name of the attribute to remove from the receiver.
 */
- (void) removeAttribute:(NSString*)attrName;

/*******************************************************************************
 @name Determining relation types
 ******************************************************************************/

/*!
 Returns the name of the default relation used by the class.
 */
+ (NSString*) defaultRelationType;

/*!
 Returns an array containing the names of each relation type for which
 there is currently at least one related object. The order of the elements
 in the returned array is nondeterministic and has no significance.
 */
- (NSArray*) currentRelationTypes;

/*******************************************************************************
 @name Counting related objects
 ******************************************************************************/

/*!
 Returns the count of all related objects in the data model.
 */
- (NSUInteger) countRelatives;

/*!
 Returns the count of the related objects in the data model that
 have the specified relation type.
 
 @param     relation The relation type whose relatives are to
            be counted.
 */
- (NSUInteger) countRelativesWithRelationType:(NSString*)relation;

/*!
 Returns the count of the related objects in the data model that
 have the default relation type.
 */
- (NSUInteger) countRelativesWithDefaultRelation;

/*******************************************************************************
 @name Accessing related objects
 ******************************************************************************/

/*!
 The owning data model relative (if any) of the receiver. Will be set if
 the receiver was added as a relative to another data model instance.
 */
@property(nonatomic, weak) MBDataModel* containingRelative;

/*!
 Returns an array containing all objects related to the receiver regardless
 of relation type.
 */
- (NSArray*) allRelatives;

/*!
 Returns all objects related to the receiver by the specified relation
 type.
 
 @param     relation The name of the relation type for which the related objects
            will be returned.
 */
- (NSArray*) relativesWithRelationType:(NSString*)relation;

/*!
 Returns all objects related to the receiver by the default relation type.
 */
- (NSArray*) relativesWithDefaultRelation;

/*!
 Returns the first object related to the receiver by the default relation 
 type.
 */
- (MBDataModel*) firstRelativeWithDefaultRelation;

/*!
 Returns the first object related to the receiver by the specified relation
 type.
 
 @param     relation The name of the relation type for which the first related
            object will be returned.
 */
- (MBDataModel*) firstRelativeWithRelationType:(NSString*)relation;

/*******************************************************************************
 @name Adding related objects to the data model
 ******************************************************************************/

/*!
 Relates the passed-in data model object to the receiver using the default
 relation type.
 
 @param     relative The data model object to add as a relative to the receiver.
 */
- (void) addRelative:(MBDataModel*)relative;

/*!
 Relates the passed-in data model object to the receiver using the specified
 relation type.
 
 @param     relative The data model object to add as a relative to the receiver.

 @param     relation The name of the relation type by which `relative` will be
            added to the receiver.
 */
- (void) addRelative:(MBDataModel*)relative withRelationType:(NSString*)relation;

/*!
 Relates each data model object returned by the passed-in enumeration
 to the receiver using the default relation type.
 
 @param     relatives An enumeration of relatives to add as relatives to the
            receiver.
 */
- (void) addRelatives:(NSObject<NSFastEnumeration>*)relatives;

/*!
 Relates each data model object returned by the passed-in enumeration
 to the receiver using the specified relation type.
 
 @param     relatives An enumeration of relatives to add as relatives to the
            receiver.

 @param     relation The name of the relation type by which the relatives will
            be added to the receiver.
 */
- (void) addRelatives:(NSObject<NSFastEnumeration>*)relatives withRelationType:(NSString*)relation;

/*******************************************************************************
 @name Building out the data model from an XML structure
 ******************************************************************************/

/*!
 Creates a data model object of the given class based on the specified XML
 element, and adds it to the receiver as a relative using the XML tag name
 of the element as the relation type.
 
 @param     relCls The class of `MBDataModel` to create.
 
 @param     element The XML element that will be used to populate the
            newly-created data model object.
 */
- (void) addRelativeOfClass:(Class)relCls
                 forElement:(RXMLElement*)element;

/*!
 Creates a data model object of the given class based on the specified XML
 element, and adds it to the receiver as a relative using the specified
 relation type.
 
 @param     relCls The class of `MBDataModel` to create.

 @param     relation The relation type to use for adding the newly-created
            data model object to the receiver. If `nil`, the receiver's
            default relation type is used.
 
 @param     element The XML element that will be used to populate the
            newly-created data model object.
 */
- (void) addRelativeOfClass:(Class)relCls
           withRelationType:(NSString*)relation
                 forElement:(RXMLElement*)element;

/*!
 Creates a data model object of the given class based on the first child 
 element of the passed-in XML having the given XML tag, and adds it to the
 receiver as a relative using `tagName` as the relation type.

 If `container` has no child element with the tag `tagName`, no action is taken.
 
 @param     relCls The class of `MBDataModel` to create.

 @param     container The XML element whose first child element having
            the tag name `tagName` will be used to populate the newly-created
            data model object.
 
 @param     tagName The tag name of the first child element of `container` to
            use for populating the newly-created data model object. 
 */
- (void) addRelativeOfClass:(Class)relCls
            forFirstChildOf:(RXMLElement*)container
                  havingTag:(NSString*)tagName;

/*!
 Creates a data model object of the given class based on the first child 
 element of the passed-in XML having the given XML tag, and adds it to the
 receiver as a relative using `relation` as the relation type.

 If `container` has no child element with the tag `tagName`, no action is taken.

 @param     relCls The class of `MBDataModel` to create.
 
 @param     relation The relation type to use for adding the newly-created
            data model object as a relative to the receiver. If `nil`, the
            receiver's default relation type is used.
 
 @param     container The XML element whose first child element having
            the tag name `tagName` will be used to populate the newly-created
            data model object.
 
 @param     tagName The tag name of the first child element of `container` to
            use for populating the newly-created data model object. 
 */
- (void) addRelativeOfClass:(Class)relCls
           withRelationType:(NSString*)relation
            forFirstChildOf:(RXMLElement*)container
                  havingTag:(NSString*)tagName;

/*!
 Constructs a data model object of the given class for each child element of
 the passed-in XML. Each data model object instantiated is added to the receiver
 as a relative using the default relation type.

 If `container` has no children with the tag `tagName`, no action is taken.

 @param     relCls The class of `MBDataModel` to create.

 @param     container The XML element whose child elements will be used to
            populate any newly-created data model objects.
 */
- (void) addRelativeOfClass:(Class)relCls
             forEachChildOf:(RXMLElement*)container;

/*!
 Constructs a data model object of the given class for each child element of
 the passed-in XML. Each data model object instantiated is added to the receiver
 as a relative using the specified relation type.

 @param     relCls The class of `MBDataModel` to create.
 
 @param     relation The relation type to use for adding the newly-created
            data model object as a relative to the receiver. If `nil`, the
            receiver's default relation type is used.

 @param     container The XML element whose child elements will be used to
            populate any newly-created data model objects.
 */
- (void) addRelativeOfClass:(Class)relCls
           withRelationType:(NSString*)relation
             forEachChildOf:(RXMLElement*)container;

/*! 
 Constructs a data model object of the given class for each child element of
 the passed-in XML that has the specified tag name. Each data model object
 instantiated is added to the receiver as a relative using `tagName` as the
 relation type.

 @param     relCls The class of `MBDataModel` to create.
 
 @param     container The XML element whose child elements will be used to
            populate any newly-created data model objects.

 @param     tagName The tag name of the child elements of `container` to
            use for populating any newly-created data model objects. 
 */
- (void) addRelativeOfClass:(Class)relCls
             forEachChildOf:(RXMLElement*)container
                  havingTag:(NSString*)tagName;

/*!
 Constructs a data model object of the given class for each child element of
 the passed-in XML that has the specified tag name. Each data model object
 instantiated is added to the receiver as a relative using `relation` as the
 relation type.
 
 @param     relCls The class of `MBDataModel` to create.
 
 @param     relation The relation type to use for adding the newly-created
            data model object as a relative to the receiver. If `nil`, the
            receiver's default relation type is used.
 
 @param     container The XML element whose child elements will be used to
            populate any newly-created data model objects.

 @param     tagName The tag name of the child elements of `container` to
            use for populating any newly-created data model objects. 
 */
- (void) addRelativeOfClass:(Class)relCls
           withRelationType:(NSString*)relation
             forEachChildOf:(RXMLElement*)container
                  havingTag:(NSString*)tagName;

/*******************************************************************************
 @name Building out the data model automatically
 ******************************************************************************/

/*!
 Returns the relation type to use when automatically creating related data
 objects from XML.
 
 The default implementation returns the default relation type for the
 receiver's class.
 
 @note      This method is called from within the base implementation of
            `populateDataModelFromXML:`. Subclasses may override that method
            to perform custom XML handling, in which case this method may not
            be called.

 @param     tagName The XML tag name for which the relation type is desired.
 
 @return    The relation type. Implementations may return `nil` if they do
            not support the specified tag name.
 */
- (NSString*) relationTypeForTag:(NSString*)tagName;

/*!
 Determines whether the receiver should attempt to add an automatically-created
 related object for the given relation type.
 
 This mechanism allows `MBDataModel` implementations to limit the number of
 related objects of a given type.
 
 @note      This method is called from within the base implementation of
            `populateDataModelFromXML:`. Subclasses may override that method
            to perform custom XML handling, in which case this method may not
            be called.

 @param     relationType The relation type.
 
 @param     tagName The XML tag name for which the related object may be
            created.
 
 @return    `YES` if a relative should be automatically added for the given
            relation type; `NO` otherwise. The default implementation returns
            `YES`.
 */
- (BOOL) shouldAutomaticallyAddRelativeOfType:(NSString*)relationType fromTag:(NSString*)tagName;

/*!
 Called to query the implementation to determine the `Class` that should be used
 for instances of related objects that are created automatically from XML by the
 `MBDataModel` superclass.
 
 @note      This method is called from within the base implementation of
            `populateDataModelFromXML:`. Subclasses may override that method
            to perform custom XML handling, in which case this method may not
            be called.
 
 @param     relationType The relation type.
 
 @param     tagName The XML tag name for which the related object is being
            created.
 
 @return    The `Class` to create for the related object, or `nil` if the
            receiver does not support the specified relation type. If a non-`nil`
            value is returned, the class *must* be a type of `MBDataModel`.
            The default implementation returns `[``MBDataModel class``]`.
 */
- (Class) implementingClassForRelativeOfType:(NSString*)relationType fromTag:(NSString*)tagName;

/*******************************************************************************
 @name Removing related objects from the data model
 ******************************************************************************/

/*!
 Removes from the receiver all instances of the given relative from any relation
 type in which it occurs.
 
 @param     relative The data model relative to remove.
 */
- (void) removeRelative:(MBDataModel*)relative;

/*!
 Removes from the receiver any instance of the given relative from the
 specified relation.
 
 @param     relative The data model relative to remove.

 @param     relation The name of the relation type for which `relative` should
            be removed.
*/
- (void) removeRelative:(MBDataModel*)relative withRelationType:(NSString*)relation;

/*******************************************************************************
 @name Notification of changes to the set of relatives
 ******************************************************************************/

/*!
 Notifies the receiver that one or more relatives have been added or removed

 @note      Subclasses overriding this method must always call `super`.
 */
- (void) dataModelDidAddOrRemoveRelatives;

@end
