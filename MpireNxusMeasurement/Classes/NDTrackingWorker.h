//
//  TrackingWorker.h
//  MpireNxusMeasurement
//
//  Copyright © 2016 TechMpire ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NDDeviceInformation.h"
#import "TrackingItem.h"
#import "SafariServices/SFSafariViewController.h"

@interface NDTrackingWorker : NSObject

@property (nonatomic, assign) BOOL operationScheduled;
@property (nonatomic, assign) BOOL operationRunning;

+(void) trackLaunch;
+(void) track:(NSString *) event params:(NSMutableDictionary *) params;
+(void) track:(TrackingItem *)trackingItem;

@end
