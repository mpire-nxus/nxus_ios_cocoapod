//
//  MpireNxusMeasurement.m
//  MpireNxusMeasurement
//
//  Copyright © 2016. TechMpire ltd. All rights reserved.
//

#import "MpireNxusMeasurement.h"
#import "NDLogger.h"
#import "NDDataContainer.h"
#import "Constants.h"
#import "NDTrackingWorker.h"
#import "CustomTrackingEvents.h"

#if !__has_feature(objc_arc)
#error MpireNxusMeasurement Library requires ARC
// see README for details
#endif

@implementation MpireNxusMeasurement

static MpireNxusMeasurement *nxusDspInstance = nil;

+ (void) debuggingEnabled:(BOOL)enabled {
    if (enabled) {
        [NDLogger setLogLevel:NDLogLevelDebug];
    } else {
        [NDLogger setLogLevel:NDLogLevelOff];
    }
}

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

    [NDLogger debug:@"MpireNxusMeasurement library initialized"];
    
    return self;
}

+(void) trackEvent:(NSString *)event {
    [MpireNxusMeasurement trackEvent:event params:nil];
}

+(void) trackEvent:(NSString *)event params:(NSMutableDictionary *)params {
    if (nxusDspInstance == nil) {
        [NDLogger debug:@"You have to first initialize the library!"];
    } else {
        [NDTrackingWorker track:event params:params];
    }
}

+(void) trackEventInstall:(NSMutableDictionary *)params {
    if (nxusDspInstance == nil) {
        [NDLogger debug:@"You have to first initialize the library!"];
    } else {
        TrackingItem *trackingItem = [[TrackingItem alloc]initWithEventIndex:ND_CTE_INSTALL_INDEX event:ND_CTE_INSTALL_NAME params:params];
        [NDTrackingWorker track:trackingItem];
    }
}

+(void) trackEventOpen:(NSMutableDictionary *)params {
    if (nxusDspInstance == nil) {
        [NDLogger debug:@"You have to first initialize the library!"];
    } else {
        TrackingItem *trackingItem = [[TrackingItem alloc]initWithEventIndex:ND_CTE_OPEN_INDEX event:ND_CTE_OPEN_NAME params:params];
        [NDTrackingWorker track:trackingItem];
    }
}

+(void) trackEventRegistration:(NSMutableDictionary *)params {
    if (nxusDspInstance == nil) {
        [NDLogger debug:@"You have to first initialize the library!"];
    } else {
        TrackingItem *trackingItem = [[TrackingItem alloc]initWithEventIndex:ND_CTE_REGISTRATION_INDEX event:ND_CTE_REGISTRATION_NAME params:params];
        [NDTrackingWorker track:trackingItem];
    }
}

+(void) trackEventPurchase:(NSMutableDictionary *)params {
    if (nxusDspInstance == nil) {
        [NDLogger debug:@"You have to first initialize the library!"];
    } else {
        TrackingItem *trackingItem = [[TrackingItem alloc]initWithEventIndex:ND_CTE_PURCHASE_INDEX event:ND_CTE_PURCHASE_NAME params:params];
        [NDTrackingWorker track:trackingItem];
    }
}

+(void)trackEventLevel:(NSMutableDictionary *)params {
    if (nxusDspInstance == nil) {
        [NDLogger debug:@"You have to first initialize the library!"];
    } else {
        TrackingItem *trackingItem = [[TrackingItem alloc]initWithEventIndex:ND_CTE_LEVEL_INDEX event:ND_CTE_LEVEL_NAME params:params];
        [NDTrackingWorker track:trackingItem];
    }
}

+(void) trackEventTutorial:(NSMutableDictionary *)params {
    if (nxusDspInstance == nil) {
        [NDLogger debug:@"You have to first initialize the library!"];
    } else {
        TrackingItem *trackingItem = [[TrackingItem alloc]initWithEventIndex:ND_CTE_TUTORIAL_INDEX event:ND_CTE_TUTORIAL_NAME params:params];
        [NDTrackingWorker track:trackingItem];
    }
}

+(void) trackEventAddToCart:(NSMutableDictionary *)params {
    if (nxusDspInstance == nil) {
        [NDLogger debug:@"You have to first initialize the library!"];
    } else {
        TrackingItem *trackingItem = [[TrackingItem alloc]initWithEventIndex:ND_CTE_ADD_TO_CART_INDEX event:ND_CTE_ADD_TO_CART_NAME params:params];
        [NDTrackingWorker track:trackingItem];
    }
}

+(void) trackEventCheckout:(NSMutableDictionary *)params {
    if (nxusDspInstance == nil) {
        [NDLogger debug:@"You have to first initialize the library!"];
    } else {
        TrackingItem *trackingItem = [[TrackingItem alloc]initWithEventIndex:ND_CTE_CHECKOUT_INDEX event:ND_CTE_CHECKOUT_NAME params:params];
        [NDTrackingWorker track:trackingItem];
    }
}

+(void) trackEventInvite:(NSMutableDictionary *)params {
    if (nxusDspInstance == nil) {
        [NDLogger debug:@"You have to first initialize the library!"];
    } else {
        TrackingItem *trackingItem = [[TrackingItem alloc]initWithEventIndex:ND_CTE_INVITE_INDEX event:ND_CTE_INVITE_NAME params:params];
        [NDTrackingWorker track:trackingItem];
    }
}

+(void) trackEventAchievement:(NSMutableDictionary *)params {
    if (nxusDspInstance == nil) {
        [NDLogger debug:@"You have to first initialize the library!"];
    } else {
        TrackingItem *trackingItem = [[TrackingItem alloc]initWithEventIndex:ND_CTE_ACHIEVEMENT_INDEX event:ND_CTE_ACHIEVEMENT_NAME params:params];
        [NDTrackingWorker track:trackingItem];
    }
}

@end
