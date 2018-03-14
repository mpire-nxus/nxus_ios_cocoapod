//
//  ParamsTableCell.h
//  NxusTestApplication
//
//  Copyright © 2016 TechMpire ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParamsCellDelegate.h"

@interface ParamsTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *paramKey;
@property (weak, nonatomic) IBOutlet UITextField *paramValue;

@property (strong, nonatomic) id<ParamsCellDelegate> delegate;
@property (assign, nonatomic) int cellIndex;

- (IBAction)deleteRow:(id)sender;
- (IBAction)keyChanged:(UITextField *)sender;
- (IBAction)valueChanged:(UITextField *)sender;

@end
