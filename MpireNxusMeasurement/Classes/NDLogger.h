//
//  NDLogger.h
//  MpireNxusMeasurement
//
//  Copyright © 2016. TechMpire ltd. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>
#import "NDLogLevel.h"

@interface NDLogger : NSObject {}

+ (void)setLogLevel:(NDLogLevel)level;
+ (void)verbose:(NSString *)message, ...;
+ (void)debug:(NSString *)message, ...;
+ (void)info:(NSString *)message, ...;
+ (void)warn:(NSString *)message, ...;
+ (void)error:(NSString *)message, ...;
+ (void)assert:(NSString *)message, ...;

@end
