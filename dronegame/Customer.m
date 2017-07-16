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
        self.center = [[GameViewController instance] randomPosition];
        
        [self updateColor];
        
        _destination = [CustomerDestination new];
        _destination.customer = self;
        
        CGFloat destinationAngle = angleOfElevationForPoints(self.center, _destination.center);
        CGFloat indicatorRadius = 15.0;
        
        _directionalIndicator = [DirectionalIndicator new];
        _directionalIndicator.center = self.boundsCenter;
        _directionalIndicator.x += indicatorRadius * cos(destinationAngle);
        _directionalIndicator.y += indicatorRadius * sin(destinationAngle);
        
        [self addSubview:_directionalIndicator];
    }
    return self;
}

- (void)popIn
{
    self.transform = CGAffineTransformMakeScale(0.25, 0.25);
    
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:1 options:0 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)popOut
{
    self.containingDrone = nil;
    [_destination removeFromSuperview];
    _destination = nil;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self updateColor];
    
    if (selected) {
        [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:1 options:0 animations:^{
            self.transform = CGAffineTransformMakeScale(3.0, 3.0);
        } completion:nil];
        
        _destination.visible = YES;
    } else {
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
        
        _destination.visible = NO;
    }
}

- (void)setScheduledToBePickedUp:(BOOL)scheduledToBePickedUp
{
    _scheduledToBePickedUp = scheduledToBePickedUp;
    [self updateColor];
}

- (void)setSeated:(BOOL)seated
{
    _seated = seated;
    [self updateColor];
    
    if (seated) {
        [_directionalIndicator removeFromSuperview];
    }
}

- (void)updateColor
{
    if (_selected) {
        self.backgroundColor = [UIColor blueColor];
    } else if (_seated) {
        self.backgroundColor = [UIColor blackColor];
    } else if (_scheduledToBePickedUp) {
        self.backgroundColor = [UIColor purpleColor];
    } else {
        self.backgroundColor = [UIColor yellowColor];
    }
}

@end
