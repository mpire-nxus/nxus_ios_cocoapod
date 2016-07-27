//
//  NDDataContainer.m
//  NxusDSP
//
//  Centralized data storage for library
//  Copyright © 2016. TechMpire ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NDDataContainer.h"
#import "NDLogger.h"

@implementation NDDataContainer

+ (NSString *) pullStringValue: (NSString *) key {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *response = @"";
    
    if ([preferences objectForKey:key] == nil) {
        //.. nooooo data for that key!
    } else {
        response = [preferences stringForKey:key];
        [NDLogger debug:@"Value found in storage: %@", response];
    }
    
    return response;
}


+ (void) storeStringValue: (NSString *) key value:(NSString *) value {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:value forKey:key];
    
    [NDLogger debug:@"Storing value %@ stored: %@", key, value];

    const BOOL didSave = [preferences synchronize];
    if (!didSave) {
        [NDLogger debug:@"NxusDSP failed to store value!"];
    }
    
}

+ (int) pullIntValue: (NSString *) key {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    int response = 0;
    
    if ([preferences objectForKey:key] == nil) {
        //.. nooooo data for that key!
    } else {
        response = [preferences integerForKey:key];
        [NDLogger debug:@"Value found in storage: %i", response];
    }
    
    return response;
}


+ (void) storeIntValue: (NSString *) key value:(int) value {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setInteger:value forKey:key];
    
    [NDLogger debug:@"Storing value %@ stored: %i", key, value];

    const BOOL didSave = [preferences synchronize];
    if (!didSave) {
        [NDLogger debug:@"NxusDSP failed to store value!"];
    }
    
}

+ (double) pullDoubleValue: (NSString *) key {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];

    double response = 0.0;
    if ([preferences objectForKey:key] == nil) {
        //.. nooooo data for that key!
    } else {
        response = [preferences doubleForKey:key];
        [NDLogger debug:@"Value found in storage: %f", response];
    }
    return response;
}


+ (void) storeDoubleValue: (NSString *) key value:(double) value {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setDouble:value forKey:key];
    
    [NDLogger debug:@"Storing value %@ stored: %f", key, value];

    const BOOL didSave = [preferences synchronize];
    if (!didSave) {
        [NDLogger debug:@"NxusDSP failed to store value!"];
    }
    
}

+ (void) storeTrackingEvent:(TrackingItem *)trackingEvent {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setValue:[trackingEvent getTrack] forKey:[trackingEvent getTrackingItemKey]];
    
    [NDLogger debug:@"Storing tracking item %@.", [trackingEvent getTrackingItemKey]];
    
    const BOOL didSave = [preferences synchronize];
    if (!didSave) {
        [NDLogger debug:@"NxusDSP failed to store tracking item!"];
    }
}

+ (NSMutableArray *) pullAllTrackingEvents {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@", ND_TRACKING_EVENT_KEY_PREFIX];
    NSArray *eventKeys = [[[preferences dictionaryRepresentation] allKeys] filteredArrayUsingPredicate:predicate];
    eventKeys = [eventKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    if ([eventKeys count] > 0) {
        NSMutableArray *trackingEvents = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < [eventKeys count]; i++) {
            NSString *eventTrack = [preferences stringForKey:eventKeys[i]];
            TrackingItem *trackingItem = [[TrackingItem alloc] initWithTrackData:eventTrack];
            [trackingEvents addObject:trackingItem];
        }
        return trackingEvents;
    } else {
        return nil;
    }
}

+ (TrackingItem *) pullTrackingEvent {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@", ND_TRACKING_EVENT_KEY_PREFIX];
    NSArray *eventKeys = [[[preferences dictionaryRepresentation] allKeys] filteredArrayUsingPredicate:predicate];
    eventKeys = [eventKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    if ([eventKeys count] > 0) {
        NSString *eventTrack = [preferences stringForKey:eventKeys[0]];
        TrackingItem *trackingItem = [[TrackingItem alloc] initWithTrackData:eventTrack];
        return trackingItem;
    } else {
        return nil;
    }
}

+ (void) clearTrackingEvent:(TrackingItem *)trackingEvent {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[trackingEvent getTrackingItemKey]];
}

+ (NSString *) pullAdvertisingIdentifier {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *response = nil;
    
    if ([preferences objectForKey:ND_ADVERTISING_IDENTIFIER] == nil) {
        //.. nooooo data for that key!
    } else {
        response = [preferences stringForKey:ND_ADVERTISING_IDENTIFIER];
        [NDLogger debug:@"Value found in storage: %@", response];
    }
    
    return response;
}

+ (void) storeAdvertisingIdentifier:(NSString *)advertisingIdentifier {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:advertisingIdentifier forKey:ND_ADVERTISING_IDENTIFIER];
    
    [NDLogger debug:@"Storing value %@ stored: %@", ND_ADVERTISING_IDENTIFIER, advertisingIdentifier];
    
    const BOOL didSave = [preferences synchronize];
    if (!didSave) {
        [NDLogger debug:@"NxusDSP failed to store value!"];
    }
}

@end