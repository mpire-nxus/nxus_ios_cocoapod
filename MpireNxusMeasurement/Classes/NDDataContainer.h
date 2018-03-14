//
//  NDDataContainer.h
//  MpireNxusMeasurement
//
//  Copyright © 2016. TechMpire ltd. All rights reserved.
//

#import "TrackingItem.h"

@interface NDDataContainer : NSObject {}

+ (NSString *) pullStringValue: (NSString *) key;
+ (void) storeStringValue: (NSString *) key value:(NSString *) value;

+ (int) pullIntValue: (NSString *) key;
+ (void) storeIntValue: (NSString *) key value:(int) value;

+ (double) pullDoubleValue: (NSString *) key;
+ (void) storeDoubleValue: (NSString *) key value:(double) value;

+ (NSMutableArray *) pullAllTrackingEvents;
+ (TrackingItem *) pullTrackingEvent;
+ (void) storeTrackingEvent:(TrackingItem *)trackingEvent;
+ (void) clearTrackingEvent:(TrackingItem *)trackingEvent;

+ (NSString *) pullAdvertisingIdentifier;
+ (void) storeAdvertisingIdentifier:(NSString *)advertisingIdentifier;

@end
