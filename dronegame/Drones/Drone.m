//
//  Drone.m
//  dronegame
//
//  Created by Lionel Seidman on 7/15/17.
//  Copyright © 2017 ho. All rights reserved.
//

#define MAX_FLIGHT_SPEED 0.5
#define ACCELERATION_RATE 0.01

#import "Drone.h"

@interface Drone()

@property (nonatomic) CGFloat vehicleWidth;
@property (nonatomic, strong) void (^flightCompletionBlock)(void);

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
    
    [self flyToLocation:customer.center withCompletion:^{
        if (!customer.containingDrone) {
            [self boardCustomer:customer];
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
    [self flyToLocation:destination.center withCompletion:^{
        if (CGPointEqualToPoint(self.center, destination.center)) {
            [self unboardCustomer:destination.customer];
        }
    }];
}

- (void)flyToLocation:(CGPoint)pt withCompletion:(void (^)(void))completion
{
    [self flyToLocation:pt];
    _flightCompletionBlock = completion;
}

- (void)flyToLocation:(CGPoint)pt
{
    self.flying = YES;
    _flightDestination = pt;
    _flightCompletionBlock = nil;
    [self updateAngleForDestination:pt];
}

- (CGFloat)flightTimeForLocation:(CGPoint)location
{
    CGFloat distance = pythag(location, self.center);
    CGFloat time = 0.2 * pow(distance, 0.9);
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
    if (_flying && _flightCompletionBlock) {
        self.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    } else if (_selected) {
        self.backgroundColor = [UIColor redColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)updatePosition
{
    CGPoint currentPosition = self.center;
    
    if (!CGPointEqualToPoint(currentPosition, _flightDestination)) {
        CGFloat flightAngle = angleOfElevationForPoints(currentPosition, _flightDestination);
        CGFloat distance = pythag(currentPosition, _flightDestination);
        
        if (distance < _flightSpeed) {
            self.center = _flightDestination;
            self.flying = NO;
            
            if (_flightCompletionBlock) {
                _flightCompletionBlock();
                _flightCompletionBlock = nil;
            }
        } else {
            _flightSpeed += 0.1;
            _flightSpeed = fmin(_flightSpeed, MAX_FLIGHT_SPEED);
            
            CGFloat dX = _flightSpeed * cos(flightAngle);
            CGFloat dY = _flightSpeed * sin(flightAngle);
            
            self.center = CGPointMake(currentPosition.x + dX, currentPosition.y + dY);
        }
    }
}

- (void)updateAngleForDestination:(CGPoint)pt
{
    CGFloat dX = pt.x - self.center.x;
    CGFloat dY = pt.y - self.center.y;
    CGFloat angle = -atan(dX / dY);
    self.transform = CGAffineTransformMakeRotation(angle);
}

@end
