//
//  PlatformTypeIndependence.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 6/25/15.
//  Copyright (c) 2015 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBAvailability.h>

#if MB_BUILD_IOS

#define MBViewNoIntrinsicMetric UIViewNoIntrinsicMetric

#elif MB_BUILD_OSX

#define MBViewNoIntrinsicMetric -1

#else

#error "Unsupported platform"

#endif
