//
//  Customer.m
//  dronegame
//
//  Created by Lionel Seidman on 7/15/17.
//  Copyright © 2017 ho. All rights reserved.
//

#import "Customer.h"

@implementation Customer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 20.0, 20.0);
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    self.backgroundColor = selected ? [UIColor blueColor] : [UIColor yellowColor];
    
    if (selected) {
        [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:1 options:0 animations:^{
            self.transform = CGAffineTransformMakeScale(3.0, 3.0);
        } completion:nil];
    } else {
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
}

@end
