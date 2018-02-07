[![Version](https://img.shields.io/cocoapods/v/nxus_ios_cocoapod.svg?style=flat)](http://cocoapods.org/pods/nxus_ios_cocoapod)
[![License](https://img.shields.io/cocoapods/l/nxus_ios_cocoapod.svg?style=flat)](http://cocoapods.org/pods/nxus_ios_cocoapod)
[![Platform](https://img.shields.io/cocoapods/p/nxus_ios_cocoapod.svg?style=flat)](http://cocoapods.org/pods/nxus_ios_cocoapod)

## Summary
TechMpire nxus platform SDK CocoaPods distribution for iOS developers

## Installation

nxus_ios_cocoapod is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "nxus_ios_cocoapod"
```

## SDK initialisation
After you completed the previous step, you are ready to initialise the library and start sending events.
Open <b>AppDelegate.m</b> class and import the library header file:
```
#import "include/NxusDSP/NxusDSP.h"
```

Then, initialise it within AppDelegate's <b>didFinishLaunchingWithOptions</b> method:
```
[NxusDSP initializeLibrary:@"YOUR_API_KEY"];
```

## Sending custom events
You can send custom events by calling the method <b>trackEvent</b>:
```
[NxusDSP trackEvent:@"event-name"];
```

If you have any additional parameters you would like to send, pass in an instance of <b>NSMutableDictionary</b>:
```
NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
[params setValue:@"value" forKey:@"key"];
[NxusDSP trackEvent:event params:params];
```

## Sending predefined events
You can send predefined events using the SDK, with following methods:
```
[NxusDSP trackEventInstall:params];
[NxusDSP trackEventOpen:params];
[NxusDSP trackEventRegistration:params];
[NxusDSP trackEventPurchase:params];
[NxusDSP trackEventLevel:params];
[NxusDSP trackEventTutorial:params];
[NxusDSP trackEventAddToCart:params];
[NxusDSP trackEventCheckout:params];
[NxusDSP trackEventInvite:params];
[NxusDSP trackEventAchievement:params];
```
Every method takes additional parameters using <b>NSMutableDictionary</b>:
```
NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
[params setValue:@"value" forKey:@"key"];
```

## Logging
To enable logging, call the method debuggingEnabled before library initialisation:
```
[NxusDSP debuggingEnabled:YES];
```

## Author

TechMpire ltd.

## License

nxus_ios_cocoapod is available under the MIT license. See the LICENSE file for more info.
