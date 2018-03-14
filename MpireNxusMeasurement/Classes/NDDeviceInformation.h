//
//  NDDeviceInformation.h
//  MpireNxusMeasurement
//
//  Copyright © 2016. TechMpire ltd. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Constants.h"

@interface NDDeviceInformation : NSObject

@property (nonatomic, copy) NSString *idForAdvertisers;
@property (nonatomic, assign) BOOL trackingEnabled;

@property (nonatomic, copy) NSString *vendorId;

@property (nonatomic, copy) NSString *clientSdkVersion;
@property (nonatomic, copy) NSString *clientSdkPlatform;

@property (nonatomic, copy) NSString *bundleIdentifier;
@property (nonatomic, copy) NSString *bundleVersion;
@property (nonatomic, copy) NSString *bundleShortVersion;

@property (nonatomic, copy) NSString *networkConnectionType;
@property (nonatomic, copy) NSString *networkIpAddress;

@property (nonatomic, copy) NSString *applicationUserUuid;

@property (nonatomic, copy) NSString *deviceFingerprint;
@property (nonatomic, copy) NSString *deviceType;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *deviceOsName;
@property (nonatomic, copy) NSString *deviceOsVersion;
@property (nonatomic, copy) NSString *deviceLanguageCode;
@property (nonatomic, copy) NSString *deviceCountryCode;
@property (nonatomic, copy) NSString *deviceModel;
@property (nonatomic, copy) NSString *deviceCpu;
@property (nonatomic, copy) NSString *deviceManufacturer;
@property (nonatomic, copy) NSString *deviceHardwareName;
@property (nonatomic, copy) NSString *deviceUserAgent;
@property (nonatomic, copy) NSString *deviceAcceptLanguage;
@property (nonatomic, copy) NSString *deviceScreenWidth;
@property (nonatomic, copy) NSString *deviceScreenHeight;
@property (nonatomic, copy) NSString *deviceScreenDpi;

@property (nonatomic, copy) NSString *applicationInstallTime;
@property (nonatomic, copy) NSString *applicationFirstRunTime;

+ (void)initializeDeviceInformation;
- (id) initDeviceData;
- (NSString *) getApplicationInstallTime;
- (NSString *) getApplicationFirstRunTime;
- (NSString *) getApplicationUserUuid;
- (NSString *) getDeviceLanguageCode;
- (NSString *) getDeviceCountryCode;
- (NSString *) getDeviceOsName;
- (NSString *) getDeviceOsVersion;
- (NSString *) getDeviceFingerprint;
- (NSString *) getDeviceType;
- (NSString *) getDeviceModel;
- (NSString *) getDeviceName;
- (NSString *) getDeviceManufacturer;
- (NSString *) getDeviceHardwareName;
- (NSString *) getDeviceUserAgent;
- (NSString *) getDeviceAcceptLanguage;
- (NSString *) getDeviceScreenWidth;
- (NSString *) getDeviceScreenHeight;
- (NSString *) getDeviceScreenDpi;
- (NSString *) getBundleIdentifier;
- (NSString *) getBundleVersion;
- (NSString *) getBundleShortVersion;
- (NSString *) getAdvertisingIdentifier;
- (NSString *) getNetworkConnectionType;
- (NSString *) getNetworkIpAddress;
- (NSString *) getSdkVersion;
- (NSString *) getSdkPlatform;
+ (NSString *) formatDate:(NSDate *)date;
+ (NSDictionary *) getDeviceInformation;
+ (NSString *) getAdvertisingIdentifier;

@end
