//
//  Drone.h
//  dronegame
//
//  Created by Lionel Seidman on 7/15/17.
//  Copyright © 2017 ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomerDestination;

@interface Drone : UIView

@property (nonatomic) BOOL selected, flying;
@property (nonatomic) CGFloat flightSpeed, flightAngle;
@property (nonatomic) CGPoint flightDestination;
@property (nonatomic, strong) NSMutableArray * boardedCustomers;

- (void)pickUpCustomer:(Customer *)customer;
- (void)flyToDestination:(CustomerDestination *)destination;
- (void)flyToLocation:(CGPoint)pt;
- (CustomerDestination *)getCustomerDestinationNearPoint:(CGPoint)pt;
- (void)updatePosition;
- (void)updateAngleForDestination:(CGPoint)pt;

@end
