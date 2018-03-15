//
//  TrackingItem.m
//  MpireNxusMeasurement
//
//  Copyright © 2016 TechMpire ltd. All rights reserved.
//

#import "TrackingItem.h"
#import "NDDeviceInformation.h"

@interface TrackingItem()

@end

@implementation TrackingItem

-(id)initWithEventIndex:(NSString *)eventIndex event:(NSString *)event params:(NSMutableDictionary *)params {
    self = [super init];
    
    self.eventIndex = eventIndex;
    self.event = event;
    self.params = params;
    self.time = [[NSDate date] timeIntervalSince1970];
    
    return self;
}

-(id)initWithEventData:(NSString *)event params:(NSMutableDictionary *)params {
    self = [super init];
    
    self.eventIndex = @"";
    self.event = event;
    self.params = params;
    self.time = [[NSDate date] timeIntervalSince1970];
    
    return self;
}

-(id)initWithTrackData:(NSString *)trackData {
    self = [super init];
    
    NSArray *splitData = [trackData componentsSeparatedByString:@";"];
    self.eventIndex = [splitData objectAtIndex:0];
    self.event = [splitData objectAtIndex:1];
    
    if (![[splitData objectAtIndex:2] isEqualToString:@""]) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        NSArray *paramData = [[splitData objectAtIndex:2] componentsSeparatedByString:@"&"];
        
        for (int i = 0; i < [paramData count]; i++) {
            NSArray *currentParam = [paramData[i] componentsSeparatedByString:@"="];
            [params setValue:currentParam[1] forKey:currentParam[0]];
        }
        
        self.params = params;
    }
    
    self.time = [[splitData objectAtIndex:3] doubleValue];
    
    return self;
}

-(NSString *) getTrack {
    NSString *tempParams = @"";
    if (self.params) {
        NSString *concatenator = @"";
        for(NSString *key in self.params) {
            NSString *value = [self.params valueForKey:key];
            tempParams = [NSString stringWithFormat:@"%@%@%@=%@", tempParams, concatenator, key, value];
            concatenator = @"&";
        }
    }
    return [NSString stringWithFormat:@"%@;%@;%@;%f", self.eventIndex, self.event, tempParams, self.time];
}

-(NSString *)getTrackingItemKey {
    return [NSString stringWithFormat:@"%@%f", ND_TRACKING_EVENT_KEY_PREFIX, self.time];
}

-(NSString *)getParams {
    NSString *tempParams = @"";
    if (self.params) {
        NSString *concatenator = @"";
        for(NSString *key in self.params) {
            NSString *value = [self.params valueForKey:key];
            tempParams = [NSString stringWithFormat:@"%@%@%@=%@", tempParams, concatenator, key, value];
            concatenator = @"&";
        }
    }
    return tempParams;
}

- (NSMutableDictionary *)getParamsDictionary {
    return self.params;
}

-(NSString *)getFormattedTime {
    NSDate *tempTime = [NSDate dateWithTimeIntervalSince1970:self.time];
    return [NDDeviceInformation formatDate:tempTime];
}

@end
