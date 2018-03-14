//
//  ParamsCellDelegate.h
//  NxusTestApplication
//
//  Copyright © 2016 TechMpire ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ParamsCellDelegate <NSObject>

-(void) deleteParamsTableRow:(NSInteger)cellIndex withData:(id)data;
-(void) updateKey:(NSInteger)cellIndex key:(NSString *)key;
-(void) updateValue:(NSInteger)cellIndex value:(NSString *)value;

@end
