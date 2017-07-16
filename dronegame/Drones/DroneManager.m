//
//  DroneManager.m
//  dronegame
//
//  Created by Lionel Seidman on 7/15/17.
//  Copyright © 2017 ho. All rights reserved.
//

#define RANDOM(__lowerBound__, __upperBound__) ((__lowerBound__) + ((__upperBound__) - (__lowerBound__)) * 1.0 * (arc4random() % 1000000) / 1000000.0)

#import "DroneManager.h"
#import "Drone.h"

DroneManager * sharedDroneManager;

@interface DroneManager()


@end

@implementation DroneManager

+ (instancetype)instance
{
    if (!sharedDroneManager) {
        sharedDroneManager = [[DroneManager alloc] init];
    }
    return sharedDroneManager;
}

+ (void)destroyInstance
{
    sharedDroneManager = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)prepareDrones
{
    _drones = [NSMutableArray new];
    int droneCount = 10;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    for (int i = 0; i < droneCount; i++) {
        Drone * drone = [Drone new];
        
        CGFloat x = RANDOM(0, screenSize.width);
        CGFloat y = RANDOM(0, screenSize.height);
        
        drone.center = CGPointMake(x, y);
        
        [_drones addObject:drone];
    }
}

CGFloat pythag(CGPoint pt1, CGPoint pt2) {
    CGFloat dX = pt1.x - pt2.x;
    CGFloat dY = pt1.y - pt2.y;
    CGFloat distSQ = dX * dX + dY * dY;
    CGFloat d = sqrt(distSQ);
    return d;
}

- (Drone *)getDroneNearPosition:(CGPoint)pt
{
    CGFloat minDist = CGFLOAT_MAX;
    Drone * nearestDrone = nil;
    
    for (Drone * drone in _drones) {
        CGFloat dist = pythag(drone.center, pt);
        
        if (dist < minDist) {
            minDist = dist;
            nearestDrone = drone;
        }
    }
    
    if (minDist < 44.0) {
        return nearestDrone;
    }
    
    return nil;
}

@end
