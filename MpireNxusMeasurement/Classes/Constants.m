//
//  Constants.m
//  MpireNxusMeasurement
//
//  Copyright © 2016 TechMpire ltd. All rights reserved.
//

#import "Constants.h"

@implementation Constants

NSString * const ND_SERVER_BASE_URL_POSTBACK        = @"https://mpire.postnx.us/";

NSString * const ND_APP_FIRST_RUN                   = @"app-first-run";
NSString * const ND_FINGERPRINT                     = @"fingerprint";

NSString * const ND_DSP_API_KEY                     = @"dsp.api.key";

NSString * const ND_DI_DEVICE_APPLE_IDFA            = @"device_apple_idfa";
NSString * const ND_DI_IDFA                         = @"idfa";
NSString * const ND_DI_APP_USER_UUID                = @"app_user_uuid";
NSString * const ND_DI_DEVICE_FINGERPRINT_ID        = @"device_fingerprint_id";
NSString * const ND_DI_DEVICE_GOOGLE_ADVERT_ID      = @"device_google_advert_id";
NSString * const ND_DI_NETWORK_CONNECTION_TYPE      = @"network_connection_type";
NSString * const ND_DI_NETWORK_IP                   = @"network_ip";
NSString * const ND_DI_NETWORK_SIM_OPERATOR         = @"network_sim_operator";
NSString * const ND_DI_NETWORK_SIM_COUNTRY          = @"network_sim_country";
NSString * const ND_DI_DEVICE_TYPE                  = @"device_type";
NSString * const ND_DI_DEVICE_OS                    = @"device_os";
NSString * const ND_DI_DEVICE_OS_VERSION            = @"device_os_version";
NSString * const ND_DI_DEVICE_MODEL                 = @"device_model";
NSString * const ND_DI_DEVICE_MANUFACTURER          = @"device_manufacturer";
NSString * const ND_DI_DEVICE_HARDWARE_NAME         = @"device_hardware_name";
NSString * const ND_DI_DEVICE_SCREEN_SIZE           = @"device_screen_size";
NSString * const ND_DI_DEVICE_SCREEN_FORMAT         = @"device_screen_format";
NSString * const ND_DI_DEVICE_SCREEN_DPI            = @"device_screen_dpi";
NSString * const ND_DI_DEVICE_SCREEN_WIDTH          = @"device_screen_width";
NSString * const ND_DI_DEVICE_SCREEN_HEIGHT         = @"device_screen_height";
NSString * const ND_DI_DEVICE_LANG                  = @"device_lang";
NSString * const ND_DI_DEVICE_COUNTRY               = @"device_country";
NSString * const ND_DI_DEVICE_USER_AGENT            = @"device_user_agent";
NSString * const ND_DI_DEVICE_ACCEPT_LANGUAGE       = @"device_accept_language";
NSString * const ND_DI_DEVICE_ABI                   = @"device_abi";
NSString * const ND_DI_DEVICE_API_LEVEL             = @"device_api_level";
NSString * const ND_DI_APP_PACKAGE_NAME             = @"app_package_name";
NSString * const ND_DI_APP_PACKAGE_VERSION          = @"app_package_version";
NSString * const ND_DI_APP_PACKAGE_VERSION_CODE     = @"app_package_version_code";
NSString * const ND_DI_APP_INSTALL_TIME             = @"app_install_time";
NSString * const ND_DI_APP_FIRST_LAUNCH             = @"app_first_launch";
NSString * const ND_DI_SDK_VERSION                  = @"sdk_version";
NSString * const ND_DI_SDK_PLATFORM                 = @"sdk_platform";

NSString * const ND_DI_APP_INSTALL_TRUST_TIME       = @"app_install_trust_time";
NSString * const ND_DI_APP_INSTALL_TRUST_KEY        = @"app_install_trust_key";

NSString * const ND_TRACK_APPLICATION_STATS         = @"application_stats";
NSString * const ND_TRACK_EVENT_INDEX               = @"event_index";
NSString * const ND_TRACK_EVENT_NAME                = @"event_name";
NSString * const ND_TRACK_EVENT_PARAM               = @"event_param";
NSString * const ND_TRACK_EVENT_TIME                = @"event_time";
NSString * const ND_TRACK_EVENT_TIME_EPOCH          = @"event_time_epoch";
NSString * const ND_TRACK_EVENT_REVENUE_USD         = @"event_revenue_usd";
NSString * const ND_TRACK_CLICK_ID                  = @"click_id";
NSString * const ND_TRACK_AFFILIATE_ID              = @"affiliate_id";
NSString * const ND_TRACK_CAMPAIGN_ID               = @"campaign_id";
NSString * const ND_TRACK_ATTRIBUTION_DATA          = @"attribution_data";

NSString * const ND_REQ_DSP_TOKEN                   = @"dsp-token";

NSString * const NS_REQ_APP_KEY                     = @"app_key";

NSString * const ND_CUSTOM_USER_IP                  = @"user_ip";

NSString * const ND_CONF_LAST_LAUNCH_INTERNAL       = @"internal.tracking.last.launch";

NSString * const ND_TRACKING_EVENT_FIRST_APP_LAUNCH = @"first_app_launch";
NSString * const ND_TRACKING_EVENT_APP_LAUNCH       = @"app_start";

NSString * const ND_TRACKING_EVENT_KEY_PREFIX       = @"ND_TRACKING_ITEM_";

NSString * const ND_ADVERTISING_IDENTIFIER          = @"nd.advertising.identifier";

NSString * const ND_SDK_VERSION                     = @"1.1.3";
NSString * const ND_SDK_PLATFORM                    = @"ios_native";
NSString * const ND_SDK_PLATFORM_CUSTOM             = @"sdk_platform_custom";

int const ND_TRACKING_OPERATION_SLEEP = 1800;

@end
