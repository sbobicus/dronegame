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

- (void)pickUpCustomer:(Customer *)customer
{
    CGPoint customerLocation = customer.center;
    CGFloat time = [self flightTimeForLocation:customerLocation];
    
    [UIView animateWithDuration:time delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = customerLocation;
    } completion:^(BOOL finished) {
        [self boardCustomer:customer];
    }];
}

- (void)boardCustomer:(Customer *)customer
{
    [self addSubview:customer];
    customer.frame = CGRectMake(2.0, 2.0, customer.frame.size.width, customer.frame.size.height);
}

- (void)flyToLocation:(CGPoint)pt
{
    CGFloat time = [self flightTimeForLocation:pt];
    
    [UIView animateWithDuration:time delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = pt;
    } completion:nil];
}

- (CGFloat)flightTimeForLocation:(CGPoint)location
{
    CGFloat distance = pythag(location, self.center);
    CGFloat time = 0.25 * pow(distance, 0.5);
    return time;
}

@end
