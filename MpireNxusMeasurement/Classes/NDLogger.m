//
//  NDLogger.m
//  MpireNxusMeasurement
//
//  Copyright © 2016. TechMpire ltd. All rights reserved.
//

#import "NDLogger.h"
#import "NDHelpers.h"

static NSString * const kLogTag = @"MpireNxusMeasurement";

@interface NDLogger()

@property (nonatomic, assign) NDLogLevel logLevel;

@end

@implementation NDLogger

static NDLogger *ndLoggerInstance = nil;

+ (void)setLogLevel:(NDLogLevel)logLevel {
    [NDLogger checkInstance];
    
    ndLoggerInstance.logLevel = logLevel;
}

+ (void)verbose:(NSString *)format, ... {
    [NDLogger checkInstance];
    
    if (ndLoggerInstance.logLevel > NDLogLevelVerbose) return;
    va_list parameters; va_start(parameters, format);
    [NDLogger logLevel:@"v" format:format parameters:parameters];
}

+ (void)debug:(NSString *)format, ... {
    [NDLogger checkInstance];
    
    if (ndLoggerInstance.logLevel > NDLogLevelDebug) return;
    va_list parameters; va_start(parameters, format);
    [NDLogger logLevel:@"d" format:format parameters:parameters];
}

+ (void)info:(NSString *)format, ... {
    [NDLogger checkInstance];
    
    if (ndLoggerInstance.logLevel > NDLogLevelInfo) return;
    va_list parameters; va_start(parameters, format);
    [NDLogger logLevel:@"i" format:format parameters:parameters];
}

+ (void)warn:(NSString *)format, ... {
    [NDLogger checkInstance];
    
    if (ndLoggerInstance.logLevel > NDLogLevelWarn) return;
    va_list parameters; va_start(parameters, format);
    [NDLogger logLevel:@"w" format:format parameters:parameters];
}

+ (void)error:(NSString *)format, ... {
    [NDLogger checkInstance];
    
    if (ndLoggerInstance.logLevel > NDLogLevelError) return;
    va_list parameters; va_start(parameters, format);
    [NDLogger logLevel:@"e" format:format parameters:parameters];
}

+ (void)assert:(NSString *)format, ... {
    [NDLogger checkInstance];
    
    if (ndLoggerInstance.logLevel > NDLogLevelAssert) return;
    va_list parameters; va_start(parameters, format);
    [NDLogger logLevel:@"a" format:format parameters:parameters];
}

+ (void)logLevel:(NSString *)logLevel format:(NSString *)format parameters:(va_list)parameters {
    NSString *string = [[NSString alloc] initWithFormat:format arguments:parameters];
    va_end(parameters);
    
    NSArray *lines = [string componentsSeparatedByString:@"\n"];
    for (NSString *line in lines) {
        NSLog(@"\t[%@]%@: %@", kLogTag, logLevel, line);
    }
}

+ (void)checkInstance {
    static dispatch_once_t onceTokenNDLogger;
    dispatch_once(&onceTokenNDLogger, ^ {
        ndLoggerInstance = [[self alloc] init];
        ndLoggerInstance.logLevel = NDLogLevelDebug;
    });
}

@end
