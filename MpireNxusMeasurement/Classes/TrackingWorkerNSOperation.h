//
//  TrackingWorkerNSOperation.h
//  MpireNxusMeasurement
//
//  Copyright © 2016 TechMpire ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackingItem.h"
#import "NDDataContainer.h"

@interface TrackingWorkerNSOperation : NSOperation

-(NSString *) getJsonObjectForTrackingItem: (TrackingItem *)item;
-(NSString *) sha1:(NSString*)input;

@end
