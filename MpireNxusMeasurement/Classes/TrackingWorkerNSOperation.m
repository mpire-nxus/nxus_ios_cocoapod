//
//  TrackingWorkerNSOperation.m
//  MpireNxusMeasurement
//
//  Copyright © 2016 TechMpire ltd. All rights reserved.
//

#import "TrackingWorkerNSOperation.h"
#import "NDDeviceInformation.h"
#import "NDLogger.h"
#include <CommonCrypto/CommonDigest.h>
#include "CustomTrackingEvents.h"

@implementation TrackingWorkerNSOperation

- (void) main {
    NSMutableArray *allTrackingItems = [NDDataContainer pullAllTrackingEvents];
    
    for (int i = 0; i < [allTrackingItems count]; i++) {
        TrackingItem *trackingItem = allTrackingItems[i];
        
        [self sendEventToPostback:trackingItem];
    }
}

- (void) sendEventToPostback:(TrackingItem *)item {
    if ([[item event] isEqualToString:ND_TRACKING_EVENT_FIRST_APP_LAUNCH]) {
        item.eventIndex = ND_CTE_INSTALL_INDEX;
        item.event = ND_CTE_INSTALL_NAME;
    }
    
    NSString* postObject = [self getJsonObjectForTrackingItem:item];
    [NDLogger debug:@"SENDING TRACKING ITEM: %@", postObject];
    
    NSDictionary *trackingItemDict = [self getJsonDictionaryForTrackingItem:item];
    
    NSString *dspToken = [NDDataContainer pullStringValue:ND_DSP_API_KEY];
    
    NSString *serverStringUrl = ND_SERVER_BASE_URL_POSTBACK;
    
    NSString *paramTemplate = @"%@&%@=%@";
    NSString *paramsUri = [NSString stringWithFormat:@"%@=%@", NS_REQ_APP_KEY, dspToken];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_TRACK_EVENT_INDEX, item.eventIndex];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_TRACK_EVENT_NAME, item.event];
    
    NSString *encodedEventTime = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                        NULL,
                                                                                                        (CFStringRef)[item getFormattedTime],
                                                                                                        NULL,
                                                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                        kCFStringEncodingUTF8 ));
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_TRACK_EVENT_TIME, encodedEventTime];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_TRACK_EVENT_REVENUE_USD, @""]; // TODO set event_revenue_usd
    
    NSDictionary *params = [item getParamsDictionary];
    if (params) {
        NSError *error;
        NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
        if (!paramsData) {
            [NDLogger debug:@"Json build from NSMutableDictionary failed: %@", error];
            paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_TRACK_EVENT_PARAM, @""];
        } else {
            NSString *paramsString = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];
            NSString *encodedParams = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                             NULL,
                                                                                                             (CFStringRef)paramsString,
                                                                                                             NULL,
                                                                                                             (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                             kCFStringEncodingUTF8 ));
            paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_TRACK_EVENT_PARAM, encodedParams];
        }
    } else {
        paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_TRACK_EVENT_PARAM, @""];
    }
    
    NSDictionary *attributionData = [trackingItemDict objectForKey:ND_TRACK_ATTRIBUTION_DATA];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_TRACK_CLICK_ID, [attributionData objectForKey:ND_TRACK_CLICK_ID]];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_TRACK_CAMPAIGN_ID, [attributionData objectForKey:ND_TRACK_CAMPAIGN_ID]];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_TRACK_AFFILIATE_ID, [attributionData objectForKey:ND_TRACK_AFFILIATE_ID]];
    
    NSString *encodedUserAgent = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                        NULL,
                                                                                                        (CFStringRef)[trackingItemDict objectForKey:ND_DI_DEVICE_USER_AGENT],
                                                                                                        NULL,
                                                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                        kCFStringEncodingUTF8 ));
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_DEVICE_USER_AGENT, encodedUserAgent];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_DEVICE_ABI, [trackingItemDict objectForKey:ND_DI_DEVICE_ABI]];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_DEVICE_ACCEPT_LANGUAGE, [trackingItemDict objectForKey:ND_DI_DEVICE_ACCEPT_LANGUAGE]];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_DEVICE_COUNTRY, [trackingItemDict objectForKey:ND_DI_DEVICE_COUNTRY]];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_DEVICE_FINGERPRINT_ID, [trackingItemDict objectForKey:ND_DI_DEVICE_FINGERPRINT_ID]];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_DEVICE_HARDWARE_NAME, [trackingItemDict objectForKey:ND_DI_DEVICE_HARDWARE_NAME]];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_DEVICE_LANG, [trackingItemDict objectForKey:ND_DI_DEVICE_LANG]];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_DEVICE_MANUFACTURER, [trackingItemDict objectForKey:ND_DI_DEVICE_MANUFACTURER]];
    
    NSString *encodedDeviceModel = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                          NULL,
                                                                                                          (CFStringRef)[trackingItemDict objectForKey:ND_DI_DEVICE_MODEL],
                                                                                                          NULL,
                                                                                                          (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                          kCFStringEncodingUTF8 ));
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_DEVICE_MODEL, encodedDeviceModel];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_DEVICE_OS, [trackingItemDict objectForKey:ND_DI_DEVICE_OS]];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_DEVICE_OS_VERSION, [trackingItemDict objectForKey:ND_DI_DEVICE_OS_VERSION]];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_DEVICE_SCREEN_DPI, [trackingItemDict objectForKey:ND_DI_DEVICE_SCREEN_DPI]];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_DEVICE_SCREEN_HEIGHT, [trackingItemDict objectForKey:ND_DI_DEVICE_SCREEN_HEIGHT]];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_DEVICE_SCREEN_WIDTH, [trackingItemDict objectForKey:ND_DI_DEVICE_SCREEN_WIDTH]];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_DEVICE_TYPE, [trackingItemDict objectForKey:ND_DI_DEVICE_TYPE]];
    
    NSString *encodedInstallTime = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                          NULL,
                                                                                                          (CFStringRef)[trackingItemDict objectForKey:ND_DI_APP_INSTALL_TIME],
                                                                                                          NULL,
                                                                                                          (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                          kCFStringEncodingUTF8 ));
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_APP_INSTALL_TIME, encodedInstallTime];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_APP_PACKAGE_NAME, [trackingItemDict objectForKey:ND_DI_APP_PACKAGE_NAME]];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_APP_PACKAGE_VERSION, [trackingItemDict objectForKey:ND_DI_APP_PACKAGE_VERSION]];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_NETWORK_CONNECTION_TYPE, [trackingItemDict objectForKey:ND_DI_NETWORK_CONNECTION_TYPE]];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_IDFA, [trackingItemDict objectForKey:ND_DI_IDFA]];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_CUSTOM_USER_IP, [trackingItemDict objectForKey:ND_CUSTOM_USER_IP]];
    
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_DEVICE_API_LEVEL, [trackingItemDict objectForKey:ND_DI_DEVICE_API_LEVEL]];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_DEVICE_SCREEN_FORMAT, [trackingItemDict objectForKey:ND_DI_DEVICE_SCREEN_FORMAT]];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_DEVICE_SCREEN_SIZE, [trackingItemDict objectForKey:ND_DI_DEVICE_SCREEN_SIZE]];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_SDK_PLATFORM, [trackingItemDict objectForKey:ND_DI_SDK_PLATFORM]];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_SDK_VERSION, [trackingItemDict objectForKey:ND_DI_SDK_VERSION]];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_APP_PACKAGE_VERSION_CODE, [trackingItemDict objectForKey:ND_DI_APP_PACKAGE_VERSION_CODE]];
    
    NSString *encodedAppFirstLaunch = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                             NULL,
                                                                                                             (CFStringRef)[trackingItemDict objectForKey:ND_DI_APP_FIRST_LAUNCH],
                                                                                                             NULL,
                                                                                                             (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                             kCFStringEncodingUTF8 ));
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_APP_FIRST_LAUNCH, encodedAppFirstLaunch];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_APP_INSTALL_TRUST_KEY, [trackingItemDict objectForKey:ND_DI_APP_INSTALL_TRUST_KEY]];
    paramsUri = [NSString stringWithFormat:paramTemplate, paramsUri, ND_DI_APP_USER_UUID, [trackingItemDict objectForKey:ND_DI_APP_USER_UUID]];
    
    NSURL *serverURL = [NSURL URLWithString:serverStringUrl];
    
    [NDLogger debug:@"Sending Tracking event to endpoint: %@", serverStringUrl];
    [NDLogger debug:@"Event POST params: %@", paramsUri];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serverURL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    NSData *requestData = [paramsUri dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"utf-8" forHTTPHeaderField:@"charset"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[paramsUri length]] forHTTPHeaderField:@"Content-Length"];
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

- (NSDictionary *) getJsonDictionaryForTrackingItem:( TrackingItem *)item {
    NSMutableDictionary* deviceInformations = [[NDDeviceInformation getDeviceInformation] mutableCopy];
    
    [deviceInformations setObject:[item eventIndex] forKey:ND_TRACK_EVENT_INDEX];
    [deviceInformations setObject:[item event] forKey:ND_TRACK_EVENT_NAME];
    [deviceInformations setObject:[item getParams] forKey:ND_TRACK_EVENT_PARAM];
    [deviceInformations setObject:[item getFormattedTime] forKey:ND_TRACK_EVENT_TIME];
    
    NSDictionary *attributionData = @{
                                      ND_TRACK_CLICK_ID : @"",
                                      ND_TRACK_AFFILIATE_ID : @"",
                                      ND_TRACK_CAMPAIGN_ID : @""
                                      };
    
    [deviceInformations setObject:attributionData forKey:ND_TRACK_ATTRIBUTION_DATA];
    
    [deviceInformations setObject:[self testAndConvertArabDateFormat:[deviceInformations objectForKey:ND_DI_APP_INSTALL_TIME]] forKey:ND_DI_APP_INSTALL_TIME];
    [deviceInformations setObject:[self testAndConvertArabDateFormat:[deviceInformations objectForKey:ND_TRACK_EVENT_TIME]] forKey:ND_TRACK_EVENT_TIME];
    [deviceInformations setObject:[self testAndConvertArabDateFormat:[deviceInformations objectForKey:ND_DI_APP_FIRST_LAUNCH]] forKey:ND_DI_APP_FIRST_LAUNCH];
    [deviceInformations setObject:[self testAndConvertArabDateFormat:[deviceInformations objectForKey:ND_DI_APP_INSTALL_TRUST_TIME]] forKey:ND_DI_APP_INSTALL_TRUST_TIME];
    
    return deviceInformations;
}

- (NSString *) getJsonObjectForTrackingItem: (TrackingItem *)item {
    NSMutableDictionary* deviceInformations = [[NDDeviceInformation getDeviceInformation] mutableCopy];
    
    [deviceInformations setObject:[item eventIndex] forKey:ND_TRACK_EVENT_INDEX];
    [deviceInformations setObject:[item event] forKey:ND_TRACK_EVENT_NAME];
    [deviceInformations setObject:[item getParams] forKey:ND_TRACK_EVENT_PARAM];
    [deviceInformations setObject:[item getFormattedTime] forKey:ND_TRACK_EVENT_TIME];
    
    NSDictionary *attributionData = @{
                                      ND_TRACK_CLICK_ID : @"",
                                      ND_TRACK_AFFILIATE_ID : @"",
                                      ND_TRACK_CAMPAIGN_ID : @""
                                      };
    
    [deviceInformations setObject:attributionData forKey:ND_TRACK_ATTRIBUTION_DATA];
    
    [deviceInformations setObject:[self testAndConvertArabDateFormat:[deviceInformations objectForKey:ND_DI_APP_INSTALL_TIME]] forKey:ND_DI_APP_INSTALL_TIME];
    [deviceInformations setObject:[self testAndConvertArabDateFormat:[deviceInformations objectForKey:ND_TRACK_EVENT_TIME]] forKey:ND_TRACK_EVENT_TIME];
    [deviceInformations setObject:[self testAndConvertArabDateFormat:[deviceInformations objectForKey:ND_DI_APP_FIRST_LAUNCH]] forKey:ND_DI_APP_FIRST_LAUNCH];
    [deviceInformations setObject:[self testAndConvertArabDateFormat:[deviceInformations objectForKey:ND_DI_APP_INSTALL_TRUST_TIME]] forKey:ND_DI_APP_INSTALL_TRUST_TIME];
    
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
    
    return @"";
}

- (NSString*) testAndConvertArabDateFormat:(NSString*)input {
    NSLog (@"Date is in arab format. Convert.");
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"fa"];
    for (NSInteger i = 0; i < 10; i++) {
        NSNumber *num = @(i);
        input = [input stringByReplacingOccurrencesOfString:[formatter stringFromNumber:num] withString:num.stringValue];
    }
    
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"ar"];
    for (NSInteger i = 0; i < 10; i++) {
        NSNumber *num = @(i);
        input = [input stringByReplacingOccurrencesOfString:[formatter stringFromNumber:num] withString:num.stringValue];
    }
    return input;
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
