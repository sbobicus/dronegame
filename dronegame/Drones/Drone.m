//
//  Drone.m
//  dronegame
//
//  Created by Lionel Seidman on 7/15/17.
//  Copyright © 2017 ho. All rights reserved.
//

#import "Drone.h"

@interface Drone()

@property (nonatomic) CGFloat vehicleWidth;
@property (nonatomic, strong) NSMutableArray * boardedCustomers;

@end

@implementation Drone

- (instancetype)init
{
    self = [super init];
    if (self) {
        _vehicleWidth = 44.0;
        self.frame = CGRectMake(0, 0, _vehicleWidth, _vehicleWidth);
        _boardedCustomers = [NSMutableArray new];
        [self updateColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self updateColor];
    
    for (CustomerDestination * d in [self allCustomerDestinations]) {
        d.visible = selected;
    }
}

- (void)setFlying:(BOOL)flying
{
    _flying = flying;
    [self updateColor];
}

- (void)pickUpCustomer:(Customer *)customer
{
    customer.scheduledToBePickedUp = YES;
    CGPoint customerLocation = customer.center;
    CGFloat time = [self flightTimeForLocation:customerLocation];
    self.flying = YES;
    
    [UIView animateWithDuration:time delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = customerLocation;
    } completion:^(BOOL finished) {
        self.flying = NO;
        
        if (finished) {
            if (!customer.containingDrone) {
                [self boardCustomer:customer];
            }
        }
    }];
}

- (CustomerDestination *)getCustomerDestinationNearPoint:(CGPoint)pt
{
    NSMutableArray * destinations = [self allCustomerDestinations];
    return (CustomerDestination *)[GameUtils getViewNearPosition:pt array:destinations];
}

- (NSMutableArray *)allCustomerDestinations
{
    NSMutableArray * destinations = [NSMutableArray new];
    
    for (Customer * customer in _boardedCustomers) {
        [destinations addObject:customer.destination];
    }
    
    return destinations;
}

- (void)flyToDestination:(CustomerDestination *)destination
{
    self.flying = YES;
    CGPoint location = destination.center;
    CGFloat time = [self flightTimeForLocation:location];
    
    [UIView animateWithDuration:time delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = location;
    } completion:^(BOOL finished) {
        self.flying = NO;
        
        if (finished) {
            [self unboardCustomer:destination.customer];
        }
    }];
}

- (void)flyToLocation:(CGPoint)pt
{
    self.flying = YES;
    CGFloat time = [self flightTimeForLocation:pt];
    
    [UIView animateWithDuration:time delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = pt;
    } completion:^(BOOL finished) {
        self.flying = NO;
    }];
}

- (CGFloat)flightTimeForLocation:(CGPoint)location
{
    CGFloat distance = pythag(location, self.center);
    CGFloat time = 1.0 * pow(distance, 0.5);
    return time;
}

- (void)boardCustomer:(Customer *)customer
{
    customer.containingDrone = self;
    [_boardedCustomers addObject:customer];
    [self addSubview:customer];
    [self updateCustomerSeating];
}

- (void)unboardCustomer:(Customer *)customer
{
    [customer popOut];
    [_boardedCustomers removeObject:customer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateCustomerSeating];
    });
}

- (void)updateCustomerSeating
{
    for (int i = 0; i < _boardedCustomers.count; i++) {
        Customer * customer = _boardedCustomers[i];
        
        CGFloat x = (i == 0 || i == 2) ? 0.25 * _vehicleWidth : 0.75 * _vehicleWidth;
        CGFloat y = (i < 2) ? 0.25 * _vehicleWidth : 0.75 * _vehicleWidth;
        
        if (customer.seated) {
            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                customer.center = CGPointMake(x, y);
            } completion:nil];
        } else {
            customer.center = CGPointMake(x, y);
        }
        
        customer.seated = YES;
    }
}

- (void)updateColor
{
    if (_flying) {
        self.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    } else if (_selected) {
        self.backgroundColor = [UIColor redColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
