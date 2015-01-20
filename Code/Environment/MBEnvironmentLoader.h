//
//  MBEnvironmentLoader.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 4/19/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RXMLElement;
@class MBEnvironment;

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

extern NSString* const kMBMLEnvironmentDidLoadNotification;     //!< @"Environment:didLoad" (fired when an MBML environment is loaded)

/******************************************************************************/
#pragma mark -
#pragma mark MBEnvironmentLoader class
/******************************************************************************/

/*!
 Instances of the `MBEnvironmentLoader` class are used to parse MBML tags when
 loading an `MBEnvironment`.
 
 For example, the `MBVariableSpace` class is an `MBEnvironmentLoader`, because
 `MBVariableSpace` is capable of populating itself with variables based on the
 contents of an MBML file.
 
 Functionality can also be added to the Mockingbird Data Environment 
 through the use of `MBModule`s. A module implementation has the option of
 providing additional `MBEnvironmentLoader`s to use during the environment
 loading process. This allows new MBML tags to be introduced without
 needing to modify the code of the Mockingbird Data Environment itself.
 See the documentation for the `MBEnvironment` class for more information
 on extending the Mockingbird Data Environment using modules.
 */
@interface MBEnvironmentLoader : NSObject

/*----------------------------------------------------------------------------*/
#pragma mark Properties
/*!    @name Properties                                                       */
/*----------------------------------------------------------------------------*/

/*! Returns `YES` if the receiver is associated with the active environment. */
@property(nonatomic, readonly) BOOL isActive;

/*----------------------------------------------------------------------------*/
#pragma mark MBML parsing
/*!    @name MBML parsing                                                     */
/*----------------------------------------------------------------------------*/

/*!
 Returns the names of the XML tags accepted by the receiver.
 */
- (NSArray*) acceptedTagNames;

/*!
 Asks the receiver to parse MBML represented by the passed-in XML element.
 Must be implemented by subclasses.
 
 @param     mbml the MBML element
 
 @param     match The criterion that caused the match. Normally this is the
            XML tag name, but in the case of a wildcard match, it will be "*"
 
 @return    YES if the element was recognized and successfully parsed; NO
            otherwise.
 */
- (BOOL) parseElement:(RXMLElement*)mbml forMatch:(NSString*)match;

/*----------------------------------------------------------------------------*/
#pragma mark Environment state changes
/*!    @name Environment state changes                                        */
/*----------------------------------------------------------------------------*/

/*!
 Called to notify that the environment loading is about to begin. Subclasses
 must call super.
 
 @param     env The `MBEnvironment` instance being loaded.
 */
- (void) environmentWillLoad:(MBEnvironment*)env;

/*!
 Called to notify that the environment loading has finished. Subclasses
 must call super.
 
 @param     env The `MBEnvironment` instance that was loaded.
 */
- (void) environmentDidLoad:(MBEnvironment*)env;

/*!
 Called to notify that the environment loading was stopped due to an error.
 Subclasses must call super.
 
 @param     env The `MBEnvironment` instance that failed to load.
 */
- (void) environmentLoadFailed:(MBEnvironment*)env;

/*!
 Called to notify that the environment is about to become active. Subclasses
 must call super.
 
 @param     env The `MBEnvironment` instance that will activate.
 */
- (void) environmentWillActivate:(MBEnvironment*)env;

/*!
 Called to notify that the environment became active. Subclasses
 must call super.
 
 @param     env The `MBEnvironment` instance that activated.
 */
- (void) environmentDidActivate:(MBEnvironment*)env;

/*!
 Called to notify that the environment is about to be deactived. Subclasses
 must call super.
 
 @param     env The `MBEnvironment` instance that will deactivate.
 */
- (void) environmentWillDeactivate:(MBEnvironment*)env;

/*!
 Called to notify that the environment was deactived. Subclasses
 must call super.
 
 @param     env The `MBEnvironment` instance that deactivated.
 */
- (void) environmentDidDeactivate:(MBEnvironment*)env;

@end
