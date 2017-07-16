//
//  Drone.m
//  dronegame
//
//  Created by Lionel Seidman on 7/15/17.
//  Copyright © 2017 ho. All rights reserved.
//

#import "Drone.h"

@interface Drone()

@end

@implementation Drone

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 44.0, 44.0);
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    self.backgroundColor = selected ? [UIColor redColor] : [UIColor grayColor];
}

- (void)flyToLocation:(CGPoint)pt
{
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = pt;
    } completion:nil];
}

@end
