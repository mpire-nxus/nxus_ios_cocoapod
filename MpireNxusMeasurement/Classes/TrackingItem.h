//
//  TrackingItem.h
//  MpireNxusMeasurement
//
//  Copyright © 2016 TechMpire ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface TrackingItem : NSObject

@property (nonatomic, retain) NSString *eventIndex;
@property (nonatomic, retain) NSString *event;
@property (nonatomic, retain) NSMutableDictionary *params;
@property (nonatomic, assign) double time;

-(id)initWithEventIndex:(NSString *)eventIndex event:(NSString *)event params:(NSMutableDictionary *)params;
-(id)initWithEventData:(NSString *)event params:(NSMutableDictionary *)params;
-(id)initWithTrackData:(NSString *)trackData;

-(NSString *)getTrack;
-(NSString *)getTrackingItemKey;
-(NSString *)getParams;
-(NSString *)getFormattedTime;

@end
