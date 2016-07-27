//
//  ParamsTableCell.m
//  NxusTestApplication
//
//  Copyright © 2016 TechMpire ltd. All rights reserved.
//

#import "ParamsTableCell.h"

@implementation ParamsTableCell

- (IBAction)deleteRow:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteParamsTableRow:withData:)]) {
        [self.delegate deleteParamsTableRow:self.cellIndex withData:nil];
    }
}

- (IBAction)keyChanged:(UITextField *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateKey:key:)]) {
        [self.delegate updateKey:self.cellIndex key:sender.text];
    }
}

- (IBAction)valueChanged:(UITextField *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateValue:value:)]) {
        [self.delegate updateValue:self.cellIndex value:sender.text];
    }
}

@end
