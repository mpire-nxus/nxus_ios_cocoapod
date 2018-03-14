//
//  UIViewController+Tracking.m
//  MpireNxusMeasurement
//
//  Copyright © 2017 TechMpire ltd. All rights reserved.
//

#import "UIViewController+Tracking.h"
#import <objc/runtime.h>
#import "MpireNxusMeasurement.h"

@implementation UIViewController (Tracking)

+ (void) load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalViewDidAppearSelector = @selector(viewDidAppear:);
        SEL swizzledViewDidAppearSelector = @selector(tracking_viewDidAppear:);
        
        SEL originalViewDidDisappearSelector = @selector(viewDidDisappear:);
        SEL swizzledViewDidDisappearSelector = @selector(tracking_viewDidDisappear:);
        
        Method originalViewDidAppearMethod = class_getInstanceMethod(class, originalViewDidAppearSelector);
        Method swizzledViewDidAppearMethod = class_getInstanceMethod(class, swizzledViewDidAppearSelector);
        
        Method originalViewDidDisappearMethod = class_getInstanceMethod(class, originalViewDidDisappearSelector);
        Method swizzledViewDidDisappearMethod = class_getInstanceMethod(class, swizzledViewDidDisappearSelector);
        
        BOOL didAddViewDidAppearMethod = class_addMethod(class, originalViewDidAppearSelector, method_getImplementation(swizzledViewDidAppearMethod), method_getTypeEncoding(swizzledViewDidAppearMethod));
        
        BOOL didAddViewDidDisappearMethod = class_addMethod(class, originalViewDidDisappearSelector, method_getImplementation(swizzledViewDidDisappearMethod), method_getTypeEncoding(swizzledViewDidDisappearMethod));
        
        if (didAddViewDidAppearMethod) {
            class_replaceMethod(class, swizzledViewDidAppearSelector, method_getImplementation(originalViewDidAppearMethod), method_getTypeEncoding(originalViewDidAppearMethod));
        } else {
            method_exchangeImplementations(originalViewDidAppearMethod, swizzledViewDidAppearMethod);
        }
        
        if (didAddViewDidDisappearMethod) {
            class_replaceMethod(class, swizzledViewDidDisappearSelector, method_getImplementation(originalViewDidDisappearMethod), method_getTypeEncoding(originalViewDidDisappearMethod));
        } else {
           method_exchangeImplementations(originalViewDidDisappearMethod, swizzledViewDidDisappearMethod);
        }
    });
}

#pragma mark - Method Swizzling

- (void) tracking_viewDidAppear:(BOOL)animated {
    [self tracking_viewDidAppear:animated];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:NSStringFromClass([self class]) forKey:@"viewController"];
    [MpireNxusMeasurement trackEvent:@"view_controller_appeared" params:params];
}

- (void) tracking_viewDidDisappear:(BOOL)animated {
    [self tracking_viewDidDisappear:animated];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:NSStringFromClass([self class]) forKey:@"viewController"];
    [MpireNxusMeasurement trackEvent:@"view_controller_disappeared" params:params];
}

@end
