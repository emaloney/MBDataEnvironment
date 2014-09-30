//
//  MBMLRuntimeFunctions.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 4/11/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <objc/runtime.h>
#import <MBToolbox/MBToolbox.h>

#import "MBMLRuntimeFunctions.h"
#import "MBExpressionError.h"
#import "MBMLFunction.h"

#define DEBUG_LOCAL     0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLRuntimeFunctions implementation
/******************************************************************************/

@implementation MBMLRuntimeFunctions

/******************************************************************************/
#pragma mark Helper for ensuring we've got Class
/******************************************************************************/

+ (Class) resolveClass:(id)resolveCls error:(MBMLFunctionError**)errPtr
{
    if ([resolveCls isKindOfClass:[NSString class]]) {
        Class cls = NSClassFromString(resolveCls);
        if (cls) {
            return cls;
        }
        [[MBMLFunctionError errorWithFormat:@"there doesn't seem to be a class named \"%@\"", resolveCls] reportErrorTo:errPtr];
    }
    else if (class_isMetaClass(object_getClass(resolveCls))) {
        // we've got an actual class
        return resolveCls;
    }
    else {
        [[MBMLFunctionError errorWithFormat:@"couldn't intepret \"%@\" (a %@) as a Class", [resolveCls description], [resolveCls class]] reportErrorTo:errPtr];
    }
    return nil;
}

/******************************************************************************/
#pragma mark Working with Class instances
/******************************************************************************/

+ (id) classExists:(NSString*)className
{
    debugTrace();
    
    return (NSClassFromString(className) != nil) ? @YES : @NO;
}

+ (id) getClass:(NSString*)className
{
    debugTrace();
    
    return NSClassFromString(className);
}

/******************************************************************************/
#pragma mark Acquiring singleton instances
/******************************************************************************/

+ (id) singleton:(id)forCls
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    Class cls = [self resolveClass:forCls error:&err];
    if (err) return err;

    if ([cls respondsToSelector:@selector(instance)]) {
        id singleton = [cls instance];
        if (!singleton) {
            return [MBMLFunctionError errorWithFormat:@"class for singleton %@ must return a non-nil value from +[%@ instance]", [cls description]];
        }
        return singleton;
    }
    else {
        return [MBMLFunctionError errorWithFormat:@"class must implement +[%@ instance] to be a valid singleton", [cls description]];
    }
}

/******************************************************************************/
#pragma mark Walking the class hierarchy
/******************************************************************************/

+ (id) inheritanceHierarchyForClass:(id)forCls
{
    debugTrace();

    MBMLFunctionError* err = nil;
    Class cls = [self resolveClass:forCls error:&err];
    if (err) return err;
    
    NSMutableArray* classes = [NSMutableArray array];
    while (cls) {
        [classes addObject:cls];
        cls = [cls superclass];
    }
    return classes;
}

/******************************************************************************/
#pragma mark Checking selector support
/******************************************************************************/

+ (id) objectRespondsToSelector:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    [MBMLFunction validateParameter:params isStringAtIndex:1 error:&err];
    if (err) return err;
    
    SEL selector = NSSelectorFromString(params[1]);
    if (!selector) {
        return [MBMLFunctionError errorWithFormat:@"The string \"%@\" does not represent a valid Objective-C selector", params[1]];
    }
    
    BOOL responds = [params[0] respondsToSelector:selector];
    return (responds ? @YES : @NO);
}

+ (id) classRespondsToSelector:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    [MBMLFunction validateParameter:params isStringAtIndex:1 error:&err];
    Class cls = [self resolveClass:params[0] error:&err];
    if (err) return err;
        
    SEL selector = NSSelectorFromString(params[1]);
    if (!selector) {
        return [MBMLFunctionError errorWithFormat:@"The string \"%@\" does not represent a valid Objective-C selector", params[1]];
    }
    
    BOOL responds = [cls respondsToSelector:selector];
    return (responds ? @YES : @NO);
}

@end
