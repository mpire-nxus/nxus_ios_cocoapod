//
//  TrackingWorker.m
//  MpireNxusMeasurement
//
//  Copyright © 2016 TechMpire ltd. All rights reserved.
//

#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#import "NDTrackingWorker.h"
#import "NDDataContainer.h"
#import "TrackingWorkerNSOperation.h"
#import "NDLogger.h"

@interface NDTrackingWorker()

@property (strong, nonatomic) UIWindow *secondWindow;

@end

@implementation NDTrackingWorker

static NDTrackingWorker *ndTrackingWorkerInstance = nil;

+(void) trackLaunch {
    static dispatch_once_t onceTokenNDTrackingWorker;
    dispatch_once(&onceTokenNDTrackingWorker, ^ {
        ndTrackingWorkerInstance = [[self alloc] init];
    });
    
    double lastLaunch = [NDDataContainer pullDoubleValue:ND_CONF_LAST_LAUNCH_INTERNAL];
    double current = [[NSDate date] timeIntervalSince1970];
    [NDDataContainer storeDoubleValue:ND_CONF_LAST_LAUNCH_INTERNAL value:current];
    
    if (lastLaunch == 0) {
        [NDTrackingWorker track:ND_TRACKING_EVENT_FIRST_APP_LAUNCH params:nil];
    } else {
        [NDTrackingWorker track:ND_TRACKING_EVENT_APP_LAUNCH params:nil];
    }
}


+(void) track:(NSString *)event params:(NSMutableDictionary *)params {
    TrackingItem *trackingItem = [[TrackingItem alloc]initWithEventData:event params:params];
    [NDDataContainer storeTrackingEvent:trackingItem];
    
    [NDTrackingWorker startTrackingOperation];
}

+(void) track:(TrackingItem *)trackingItem {
    [NDDataContainer storeTrackingEvent:trackingItem];
    
    [NDTrackingWorker startTrackingOperation];
}

+(void) startTrackingOperation {
    if (!ndTrackingWorkerInstance.operationRunning) {
        TrackingWorkerNSOperation *trackingOperation = [[TrackingWorkerNSOperation alloc] init];
        
        trackingOperation.completionBlock = ^{
            ndTrackingWorkerInstance.operationRunning = NO;
            
            if (!ndTrackingWorkerInstance.operationScheduled) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, ND_TRACKING_OPERATION_SLEEP * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
                    ndTrackingWorkerInstance.operationScheduled = NO;
                    [NDTrackingWorker startTrackingOperation];
                });
                
                ndTrackingWorkerInstance.operationScheduled = YES;
            }
        };
        
        [[NSOperationQueue mainQueue] addOperation:trackingOperation];
        ndTrackingWorkerInstance.operationRunning = YES;
    }
}

-(id) init {
    self = [super init];
    
    if (self == nil) return nil;
    
    self.operationScheduled = NO;
    self.operationRunning = NO;
    
    [NDDeviceInformation initializeDeviceInformation];
    
    return self;
}

@end
