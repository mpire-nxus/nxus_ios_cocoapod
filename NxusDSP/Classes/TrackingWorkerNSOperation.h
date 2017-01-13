//
//  TrackingWorkerNSOperation.h
//  NxusDSP
//
//  Copyright © 2016 TechMpire ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackingItem.h"
#import "NDDataContainer.h"

@interface TrackingWorkerNSOperation : NSOperation

-(NSString *) getJsonObjectForTrackingItem: (TrackingItem *)item;
-(NSString *) getS3UrlForTrackingItem: (TrackingItem *)item;
-(NSString *) sha1:(NSString*)input;
-(void) sendEventToS3:(TrackingItem *) item;


@end
