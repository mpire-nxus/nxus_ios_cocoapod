//
//  NxusDSP.m
//  NxusDSP
//
//  Copyright © 2016. TechMpire ltd. All rights reserved.
//

#import "NxusDSP.h"
#import "NDLogger.h"
#import "NDDataContainer.h"
#import "Constants.h"
#import "NDTrackingWorker.h"

#if !__has_feature(objc_arc)
#error NxusDSP Library requires ARC
// see README for details
#endif

@implementation NxusDSP

static NxusDSP *nxusDspInstance = nil;

+ (void) initializeLibrary:(NSString *)dspApiKey {
    static dispatch_once_t onceTokenNxusDSP;
    dispatch_once(&onceTokenNxusDSP, ^ {
        nxusDspInstance = [[self alloc] initWithApiKey:dspApiKey];
    });
}

- (id) initWithApiKey:(NSString *)apiKey {
    self = [super init];
    if (self == nil) return nil;
    
    [NDDataContainer storeStringValue:ND_DSP_API_KEY value:apiKey];
    [NDTrackingWorker trackLaunch];

    [NDLogger debug:@"NxusDSP library initialized"];
    
    return self;
}

+(void) trackEvent:(NSString *)event {
    [NxusDSP trackEvent:event params:nil];
}

+(void) trackEvent:(NSString *)event params:(NSMutableDictionary *)params {
    if (nxusDspInstance == nil) {
        [NDLogger debug:@"You have to first initialize the library!"];
    } else {
        [NDTrackingWorker track:event params:params];
    }
}

@end
