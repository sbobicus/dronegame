//
//  DroneManager.m
//  dronegame
//
//  Created by Lionel Seidman on 7/15/17.
//  Copyright © 2017 ho. All rights reserved.
//

#import "DroneManager.h"

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
    
    for (int i = 0; i < droneCount; i++) {
        Drone * drone = [Drone new];
        drone.center = [[GameViewController instance] randomPosition];
        drone.flightDestination = drone.center;
        [_drones addObject:drone];
    }
}

- (Drone *)getDroneNearPosition:(CGPoint)pt
{
    return (Drone *)[GameUtils getViewNearPosition:pt array:_drones];
}

@end
