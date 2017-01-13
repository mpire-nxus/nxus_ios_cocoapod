//
//  TrackingWorkerNSOperation.m
//  NxusDSP
//
//  Copyright © 2016 TechMpire ltd. All rights reserved.
//

#import "TrackingWorkerNSOperation.h"
#import "NDDeviceInformation.h"
#import "NDLogger.h"
#include <CommonCrypto/CommonDigest.h>

@implementation TrackingWorkerNSOperation

- (void) main {
    NSMutableArray *allTrackingItems = [NDDataContainer pullAllTrackingEvents];
    
    for (int i = 0; i < [allTrackingItems count]; i++) {
        TrackingItem *trackingItem = allTrackingItems[i];
        
        //[NDLogger debug:@"TRACKING ITEM: %@", [trackingItem getTrack]];
        
        NSString* postObject = [self getJsonObjectForTrackingItem:trackingItem];
        
        [NDLogger debug:@"TRACKING ITEM: %@", postObject];
        
        NSString *serverStringURL = ND_SERVER_BASE_URL_EVENT;
        
        if ([[trackingItem event] isEqualToString:ND_TRACKING_EVENT_FIRST_APP_LAUNCH]) {
            serverStringURL = ND_SERVER_BASE_URL_ATTRIBUTION;
            
            NSURL *serverURL = [NSURL URLWithString:serverStringURL];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serverURL
                                                                   cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
            NSData *requestData = [postObject dataUsingEncoding:NSUTF8StringEncoding];
            NSString *dspToken = [NDDataContainer pullStringValue:ND_DSP_API_KEY];
            
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:dspToken forHTTPHeaderField:ND_REQ_DSP_TOKEN];
            [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postObject length]] forHTTPHeaderField:@"Content-Length"];
            [request setHTTPBody:requestData];
            
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error) {
                    [NDLogger debug:@"dataTaskWithRequest error: %@", error];
                } else {
                    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                        if (statusCode != 200) {
                            [NDLogger debug:@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode];
                        } else {
                            [self sendEventToS3:trackingItem];
                            NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                            [NDLogger debug:@"requestReply: %@", requestReply];
                            [NDDataContainer clearTrackingEvent:trackingItem];
                        }
                    }
                }
                dispatch_semaphore_signal(semaphore);
            }] resume];
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        } else {
            [self sendEventToS3:trackingItem];
        }
    }
}

- (void) sendEventToS3:(TrackingItem *)item {
    NSString *serverStringURL = ND_SERVER_BASE_URL_EVENT;
    serverStringURL = [NSString stringWithFormat:@"%@%@", serverStringURL, [self getS3UrlForTrackingItem: item]];
    NSURL *serverURL = [NSURL URLWithString:serverStringURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serverURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    
    NSString *dspToken = [NDDataContainer pullStringValue:ND_DSP_API_KEY];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"iosSDK/1.0" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"" forHTTPHeaderField:@"Content-Type"];
    [request setValue:dspToken forHTTPHeaderField:ND_REQ_DSP_TOKEN];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            [NDLogger debug:@"dataTaskWithRequest error: %@", error];
        } else {
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                if (statusCode != 200) {
                    [NDLogger debug:@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode];
                } else {
                    NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                    [NDLogger debug:@"requestReply: %@", requestReply];
                    [NDDataContainer clearTrackingEvent:item];
                }
            }
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

- (NSString *) getJsonObjectForTrackingItem: (TrackingItem *)item {
    NSMutableDictionary* deviceInformations = [[NDDeviceInformation getDeviceInformation] mutableCopy];

    [deviceInformations setObject:[item event] forKey:ND_TRACK_EVENT_NAME];
    [deviceInformations setObject:[item getParams] forKey:ND_TRACK_EVENT_PARAM];
    [deviceInformations setObject:[item getFormattedTime] forKey:ND_TRACK_EVENT_TIME];
    
    NSDictionary *attributionData = @{
                                      ND_TRACK_CLICK_ID : @"",
                                      ND_TRACK_AFFILIATE_ID : @"",
                                      ND_TRACK_CAMPAIGN_ID : @""
                                      };
    
    [deviceInformations setObject:attributionData forKey:ND_TRACK_ATTRIBUTION_DATA];
    
    //build string object
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:deviceInformations
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (!jsonData) {
        [NDLogger debug:@"Json build from NSMutableDictionary failed: %@", error];
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    
    
    // return
    return @"";
}

- (NSString *) getS3UrlForTrackingItem: (TrackingItem *)item {
    // get device information
    NSMutableDictionary* deviceInformations = [[NDDeviceInformation getDeviceInformation] mutableCopy];
    NSString *s3endpoint = [NSString stringWithFormat:@"apple.%@", [deviceInformations objectForKey:ND_DI_APP_PACKAGE_NAME]];
    NSString *response = [NSString stringWithFormat:@"%@", [self sha1: s3endpoint]];

    NSString *delimiter = @"?";
    
    for (id key in deviceInformations) {
        NSString *encodedValue = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                        NULL,
                                                                                                        (CFStringRef)[deviceInformations objectForKey:key],
                                                                                                        NULL,
                                                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                        kCFStringEncodingUTF8 ));
        NSString *item = [NSString stringWithFormat:@"%@%@=%@", delimiter, key, encodedValue];
        response = [response stringByAppendingString: item];
        delimiter = @"&";
    };
    
    NSString *eventName = [NSString stringWithFormat:@"%@%@=%@", delimiter, ND_TRACK_EVENT_NAME, [item event]];
    response = [response stringByAppendingString: eventName];
    NSString *eventParam = [NSString stringWithFormat:@"%@%@=%@", delimiter, ND_TRACK_EVENT_PARAM, [item getParams]];
    response = [response stringByAppendingString: eventParam];
    NSString *eventTime = [NSString stringWithFormat:@"%@%@=%@", delimiter, ND_TRACK_EVENT_TIME, [item getFormattedTime]];
    response = [response stringByAppendingString: eventTime];
    
    return response;
}

- (NSString *) sha1:(NSString*) input {
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

@end
