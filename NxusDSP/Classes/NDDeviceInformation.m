//
//  NDDeviceInformation.m
//  NxusDSP
//
//  Copyright © 2016. TechMpire ltd. All rights reserved.
//

#import "AdSupport/ASIdentifierManager.h"
#import "NDDeviceInformation.h"
#import "NDDataContainer.h"
#import "CoreTelephony/CTTelephonyNetworkInfo.h"
#import "SystemConfiguration/SystemConfiguration.h"
#import "ifaddrs.h"
#import "arpa/inet.h"
#import "sys/utsname.h"
#import "NDLogger.h"
#import "CommonCrypto/CommonDigest.h"
#import "SAMKeychain.h"

@import UIKit;

@interface NDDeviceInformation()

@property (nonatomic, retain) UIDevice *device;
@property (nonatomic, retain) NSLocale *locale;
@property (nonatomic, retain) NSBundle *bundle;
@property (nonatomic, retain) NSDictionary *infoDictionary;

@property (nonatomic, retain) NSString *trustInstallTime;
@property (nonatomic, retain) NSString *trustInstallKey;

@end

@implementation NDDeviceInformation

static NDDeviceInformation *ndDeviceInformationInstance = nil;
static NSDictionary *ndDeviceModelAndPpi = nil;

+ (void) initializeDeviceInformation {
    static dispatch_once_t onceTokenNDDeviceInformation;
    dispatch_once(&onceTokenNDDeviceInformation, ^ {
        ndDeviceInformationInstance = [[self alloc] initDeviceData];
    });
}

- (id) initDeviceData {
    self = [super init];
    if (self == nil) return nil;
    
    ndDeviceModelAndPpi = @{
                            @"iPhone1,1": @[@"iPhone 1st Gen", @"163"],
                            @"iPhone1,2": @[@"iPhone 3G", @"163"],
                            @"iPhone2,1": @[@"iPhone 3GS", @"163"],
                            @"iPhone3,1": @[@"iPhone 4", @"326"],
                            @"iPhone3,2": @[@"iPhone 4", @"326"],
                            @"iPhone3,3": @[@"iPhone 4", @"326"],
                            @"iPhone4,1": @[@"iPhone 4S", @"326"],
                            @"iPhone5,1": @[@"iPhone 5", @"326"],
                            @"iPhone5,2": @[@"iPhone 5", @"326"],
                            @"iPhone5,3": @[@"iPhone 5C", @"326"],
                            @"iPhone5,4": @[@"iPhone 5C", @"326"],
                            @"iPhone6,1": @[@"iPhone 5S", @"326"],
                            @"iPhone6,2": @[@"iPhone 5S", @"326"],
                            @"iPhone7,1": @[@"iPhone 6 Plus", @"401"],
                            @"iPhone7,2": @[@"iPhone 6", @"326"],
                            @"iPhone8,1": @[@"iPhone 6S", @"326"],
                            @"iPhone8,2": @[@"iPhone 6S Plus", @"401"],
                            @"iPhone8,4": @[@"iPhone SE", @"326"],
                            @"iPhone9,1": @[@"iPhone 7", @"326"],
                            @"iPhone9,3": @[@"iPhone 7", @"326"],
                            @"iPhone9,2": @[@"iPhone 7 Plus", @"401"],
                            @"iPhone9,4": @[@"iPhone 7 Plus", @"401"],
                            @"iPad1,1": @[@"iPad 1", @"132"],
                            @"iPad2,1": @[@"iPad 2", @"132"],
                            @"iPad2,2": @[@"iPad 2", @"132"],
                            @"iPad2,3": @[@"iPad 2", @"132"],
                            @"iPad2,4": @[@"iPad 2", @"132"],
                            @"iPad2,5": @[@"iPad Mini", @"163"],
                            @"iPad2,6": @[@"iPad Mini", @"163"],
                            @"iPad2,7": @[@"iPad Mini", @"163"],
                            @"iPad3,1": @[@"iPad 3", @"264"],
                            @"iPad3,2": @[@"iPad 3", @"264"],
                            @"iPad3,3": @[@"iPad 3", @"264"],
                            @"iPad3,4": @[@"iPad 4", @"264"],
                            @"iPad3,5": @[@"iPad 4", @"264"],
                            @"iPad3,6": @[@"iPad 4", @"264"],
                            @"iPad4,1": @[@"iPad Air", @"264"],
                            @"iPad4,2": @[@"iPad Air", @"264"],
                            @"iPad4,3": @[@"iPad Air", @"264"],
                            @"iPad4,4": @[@"iPad Mini 2", @"326"],
                            @"iPad4,5": @[@"iPad Mini 2", @"326"],
                            @"iPad4,6": @[@"iPad Mini 2", @"326"],
                            @"iPad4,7": @[@"iPad Mini 3", @"326"],
                            @"iPad4,8": @[@"iPad Mini 3", @"326"],
                            @"iPad4,9": @[@"iPad Mini 3", @"326"],
                            @"iPad5,1": @[@"iPad Mini 4", @"326"],
                            @"iPad5,2": @[@"iPad Mini 4", @"326"],
                            @"iPad5,3": @[@"iPad Air 2", @"264"],
                            @"iPad5,4": @[@"iPad Air 2", @"264"],
                            @"iPad6,7": @[@"iPad Pro 12.9 inch", @"264"],
                            @"iPad6,8": @[@"iPad Pro 12.9 inch", @"264"],
                            @"iPad6,3": @[@"iPad Pro 9.7 inch", @"264"],
                            @"iPad6,4": @[@"iPad Pro 9.7 inch", @"264"],
                            @"iPod1,1": @[@"iPod 1st Gen", @"163"],
                            @"iPod2,1": @[@"iPod 2nd Gen", @"163"],
                            @"iPod3,1": @[@"iPod 3rd Gen", @"163"],
                            @"iPod4,1": @[@"iPod 4th Gen", @"326"],
                            @"iPod5,1": @[@"iPod 5th Gen", @"326"],
                            @"iPod7,1": @[@"iPod 6th gen", @"326"]
                            };
    
    self.device = UIDevice.currentDevice;
    self.locale = NSLocale.currentLocale;
    self.bundle = NSBundle.mainBundle;
    self.infoDictionary = self.bundle.infoDictionary;

    self.idForAdvertisers = [self getAdvertisingIdentifier];
    
    self.clientSdkVersion = [self getSdkVersion];
    self.clientSdkPlatform = [self getSdkPlatform];
    
    self.bundleIdentifier = [self getBundleIdentifier];
    self.bundleVersion = [self getBundleVersion];
    self.bundleShortVersion = [self getBundleShortVersion];
    
    self.deviceLanguageCode = [self getDeviceLanguageCode];
    self.deviceCountryCode = [self getDeviceCountryCode];
    self.deviceOsName = [self getDeviceOsName];
    self.deviceOsVersion = [self getDeviceOsVersion];
    self.deviceFingerprint = [self getDeviceFingerprint];
    self.deviceType = [self getDeviceType];
    self.deviceModel = [self getDeviceModel];
    self.deviceName = [self getDeviceName];
    self.deviceManufacturer = [self getDeviceManufacturer];
    self.deviceHardwareName = [self getDeviceHardwareName];
    self.deviceUserAgent = [self getDeviceUserAgent];
    self.deviceAcceptLanguage = [self getDeviceAcceptLanguage];
    self.deviceScreenWidth = [self getDeviceScreenWidth];
    self.deviceScreenHeight = [self getDeviceScreenHeight];
    self.deviceScreenDpi = [self getDeviceScreenDpi];
    
    self.applicationInstallTime = [self getApplicationInstallTime];
    self.applicationFirstRunTime = [self getApplicationFirstRunTime];
    self.applicationUserUuid = [self getApplicationUserUuid];
    
    self.networkConnectionType = [self getNetworkConnectionType];
    self.networkIpAddress = [self getNetworkIpAddress];
    
    self.trustInstallTime = [SAMKeychain passwordForService:ND_DI_APP_INSTALL_TRUST_TIME account:self.bundleIdentifier];
    self.trustInstallKey = [SAMKeychain passwordForService:ND_DI_APP_INSTALL_TRUST_KEY account:self.bundleIdentifier];
    if (self.trustInstallTime == nil) {
        self.trustInstallTime = self.applicationInstallTime;
        self.trustInstallKey = self.applicationUserUuid;
        [SAMKeychain setPassword:self.trustInstallTime forService:ND_DI_APP_INSTALL_TRUST_TIME account:self.bundleIdentifier];
        [SAMKeychain setPassword:self.trustInstallKey forService:ND_DI_APP_INSTALL_TRUST_KEY account:self.bundleIdentifier];
    }

    return self;
}

/*
 * Read creation date for Documents folder
 * maybe change this to unix time
 * change data format to match SDK format time
 */
- (NSString *) getApplicationInstallTime {
    NSURL* docFolderUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    __autoreleasing NSError *error;
    
    NSDate *installDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:docFolderUrl.path error:&error] objectForKey:NSFileCreationDate];
    
    return [NDDeviceInformation formatDate:installDate];
}

- (NSString *) getApplicationFirstRunTime {
    double firstRunTime = [NDDataContainer pullDoubleValue:ND_APP_FIRST_RUN];
    if (firstRunTime == 0) {
        firstRunTime = [[NSDate date] timeIntervalSince1970];
        [NDDataContainer storeDoubleValue:ND_APP_FIRST_RUN value:firstRunTime];
    }
    NSDate *firstRunDate = [NSDate dateWithTimeIntervalSince1970:firstRunTime];
    return [NDDeviceInformation formatDate:firstRunDate];
}

- (NSString *) getApplicationUserUuid {
    NSString *combination = [NSString stringWithFormat:@"%@%@%@", self.idForAdvertisers, self.bundleIdentifier, self.applicationInstallTime];
    NSString *hashedCombo = [self md5Hash:combination];
    
    return [self formatHashedValue:hashedCombo];
}

- (NSString *) formatHashedValue:(NSString *)value {
    int chunkSize = 4;
    int chunkCount = (int)([value length] / chunkSize) + (([value length] % chunkSize) == 0 ? 0 : 1);
    
    NSString *delimiter = @"";
    NSString *delimitedHashedCombo = @"";
    
    for (int i = 0; i < chunkCount; i++) {
        delimitedHashedCombo = [NSString stringWithFormat:@"%@%@%@", delimitedHashedCombo, delimiter, [value substringWithRange:NSMakeRange(i * chunkSize, chunkSize)]];
        delimiter = @"-";
    }
    
    return delimitedHashedCombo;
}

- (NSString *) md5Hash:(NSString *)value {
    // Create pointer to the string as UTF8
    const char *ptr = [value UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

+ (NSString *) formatDate:(NSDate *)date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'Z"];
    return [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:date]];
}

- (NSString*) getDeviceLanguageCode {
    return [self.locale objectForKey:NSLocaleLanguageCode];
//    return [[NSLocale preferredLanguages] objectAtIndex:0];
}

- (NSString *) getDeviceCountryCode {
    return [self.locale objectForKey:NSLocaleCountryCode];
}

- (NSString *) getDeviceOsName {
    return @"ios";
}

- (NSString *) getDeviceOsVersion {
    return self.device.systemVersion;
}

- (NSString *) getDeviceFingerprint {
    NSString *tempId = [self getAdvertisingIdentifier];
    NSString *hashedTempId = [self md5Hash:tempId];
    
    return [self formatHashedValue:hashedTempId];
}

- (NSString *) getDeviceType {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return @"phone";
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return @"tablet";
    } else {
        return @"";
    }
}

- (NSString *) getDeviceModel {
//    return self.device.model;
    if (TARGET_IPHONE_SIMULATOR) {
        return @"Simulator";
    } else {
        NSString *hardwareName = [self getDeviceHardwareName];
        NSArray *resolvedData = [ndDeviceModelAndPpi objectForKey:hardwareName];
        if (resolvedData) {
            return resolvedData[0];
        } else {
            return @"Unknown";
        }
    }
}

- (NSString *) getDeviceName {
    return self.device.name;
}

- (NSString *) getDeviceManufacturer {
    return @"Apple";
}

- (NSString *) getDeviceHardwareName {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

- (NSString *) getDeviceUserAgent {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    return [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
}

- (NSString *) getDeviceAcceptLanguage {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    return [webView stringByEvaluatingJavaScriptFromString:@"navigator.language"];
}

- (NSString *) getDeviceScreenWidth {
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    CGRect screenRect = [mainScreen bounds];
    
    return [NSString stringWithFormat:@"%i", (int)roundf((screenRect.size.width * scale))];
}

- (NSString *) getDeviceScreenHeight {
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    CGRect screenRect = [mainScreen bounds];
    
    return [NSString stringWithFormat:@"%i", (int)roundf((screenRect.size.height) * scale)];
}

- (NSString *) getDeviceScreenDpi {
    if (TARGET_IPHONE_SIMULATOR) {
        return @"0";
    } else {
        NSString *hardwareName = [self getDeviceHardwareName];
        NSArray *resolvedData = [ndDeviceModelAndPpi objectForKey:hardwareName];
        if (resolvedData) {
            return resolvedData[1];
        } else {
            return @"Unknown";
        }
    }
}

- (NSString *) getBundleIdentifier {
    return [self.infoDictionary objectForKey:(NSString *)kCFBundleIdentifierKey];
}

- (NSString *) getBundleVersion {
    return [self.infoDictionary objectForKey:(NSString *)kCFBundleVersionKey];
}

- (NSString *) getBundleShortVersion {
    return [self.infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

- (NSString *) getAdvertisingIdentifier {
//    NSString *savedIdentifier = [NDDataContainer pullAdvertisingIdentifier];
//    if (savedIdentifier) {
//        return savedIdentifier;
//    } else {
//        savedIdentifier = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//        [NDDataContainer storeAdvertisingIdentifier:savedIdentifier];
//        return savedIdentifier;
//    }
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

+ (NSString *) getAdvertisingIdentifier {
    if (ndDeviceInformationInstance == nil) {
        [NDLogger debug:@"You have to first initialize the library!"];
        
        return nil;
    } else {
        return [ndDeviceInformationInstance getAdvertisingIdentifier];
    }
}

- (NSString *) getNetworkConnectionType {
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, "8.8.8.8");
    SCNetworkReachabilityFlags flags;
    BOOL success = SCNetworkReachabilityGetFlags(reachability, &flags);
    CFRelease(reachability);
    if (!success) {
        return @"-";
    }
    BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0);
    BOOL isNetworkReachable = (isReachable && !needsConnection);
    if (!isNetworkReachable) {
        return @"-";
    } else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0) {
        CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
        NSString *currentTechnology = telephonyInfo.currentRadioAccessTechnology;
        if ([currentTechnology isEqualToString:CTRadioAccessTechnologyGPRS]
            || [currentTechnology isEqualToString:CTRadioAccessTechnologyEdge]
            || [currentTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
            return @"2G";
        } else if ([currentTechnology isEqualToString:CTRadioAccessTechnologyWCDMA]
                   || [currentTechnology isEqualToString:CTRadioAccessTechnologyHSDPA]
                   || [currentTechnology isEqualToString:CTRadioAccessTechnologyHSUPA]
                   || [currentTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]
                   || [currentTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]
                   || [currentTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]
                   || [currentTechnology isEqualToString:CTRadioAccessTechnologyeHRPD]) {
            return @"3G";
        } else if ([currentTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
            return @"4G";
        } else {
            return @"Unknown";
        }
    } else {
        return @"WIFI";
    }
}

- (NSString *) getNetworkIpAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

- (NSString *) getSdkVersion {
    return ND_SDK_VERSION;
}

- (NSString *) getSdkPlatform {
    return ND_SDK_PLATFORM;
}

+ (NSDictionary *) getDeviceInformation {
    if (ndDeviceInformationInstance == nil) {
        [NDLogger debug:@"You have to first initialize the library!"];
        
        return nil;
    } else {
        NSDictionary *response = @{
                                   ND_DI_APP_FIRST_LAUNCH : ndDeviceInformationInstance.applicationFirstRunTime,
                                   ND_DI_APP_INSTALL_TIME : ndDeviceInformationInstance.applicationInstallTime,
                                   ND_DI_APP_PACKAGE_NAME : ndDeviceInformationInstance.bundleIdentifier,
                                   ND_DI_APP_PACKAGE_VERSION : ndDeviceInformationInstance.bundleShortVersion,
                                   ND_DI_APP_PACKAGE_VERSION_CODE : ndDeviceInformationInstance.bundleVersion,
                                   ND_DI_DEVICE_ABI : @"",
                                   ND_DI_DEVICE_API_LEVEL : @"",
                                   ND_DI_DEVICE_COUNTRY : ndDeviceInformationInstance.deviceCountryCode,
                                   ND_DI_APP_USER_UUID: ndDeviceInformationInstance.applicationUserUuid,
                                   ND_DI_DEVICE_FINGERPRINT_ID : ndDeviceInformationInstance.deviceFingerprint,
                                   ND_DI_DEVICE_APPLE_IDFA : ndDeviceInformationInstance.idForAdvertisers,
                                   ND_DI_IDFA : ndDeviceInformationInstance.idForAdvertisers,
                                   ND_DI_DEVICE_GOOGLE_ADVERT_ID : @"",
                                   ND_DI_DEVICE_HARDWARE_NAME : ndDeviceInformationInstance.deviceHardwareName,
                                   ND_DI_DEVICE_LANG : ndDeviceInformationInstance.deviceLanguageCode,
                                   ND_DI_DEVICE_MANUFACTURER : ndDeviceInformationInstance.deviceManufacturer,
                                   ND_DI_DEVICE_MODEL : ndDeviceInformationInstance.deviceModel,
                                   ND_DI_DEVICE_OS : ndDeviceInformationInstance.deviceOsName,
                                   ND_DI_DEVICE_OS_VERSION : ndDeviceInformationInstance.deviceOsVersion,
                                   ND_DI_DEVICE_SCREEN_DPI : ndDeviceInformationInstance.deviceScreenDpi,
                                   ND_DI_DEVICE_SCREEN_FORMAT : @"",
                                   ND_DI_DEVICE_SCREEN_HEIGHT : ndDeviceInformationInstance.deviceScreenHeight,
                                   ND_DI_DEVICE_SCREEN_SIZE : @"",
                                   ND_DI_DEVICE_SCREEN_WIDTH : ndDeviceInformationInstance.deviceScreenWidth,
                                   ND_DI_DEVICE_TYPE : ndDeviceInformationInstance.deviceType,
                                   ND_DI_DEVICE_USER_AGENT : ndDeviceInformationInstance.deviceUserAgent,
                                   ND_DI_DEVICE_ACCEPT_LANGUAGE : ndDeviceInformationInstance.deviceAcceptLanguage,
                                   ND_DI_NETWORK_CONNECTION_TYPE : ndDeviceInformationInstance.networkConnectionType,
                                   ND_DI_NETWORK_IP : ndDeviceInformationInstance.networkIpAddress,
                                   ND_DI_SDK_PLATFORM : ndDeviceInformationInstance.clientSdkPlatform,
                                   ND_DI_SDK_VERSION : ndDeviceInformationInstance.clientSdkVersion,
                                   ND_DI_APP_INSTALL_TRUST_TIME : ndDeviceInformationInstance.trustInstallTime,
                                   ND_DI_APP_INSTALL_TRUST_KEY : ndDeviceInformationInstance.trustInstallKey,
                                   };
        
        return response;
    }
}

@end
