//
//  DroneManager.h
//  dronegame
//
//  Created by Lionel Seidman on 7/15/17.
//  Copyright © 2017 ho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Drone;

@interface DroneManager : NSObject

@property (nonatomic, strong) NSMutableArray * drones;

+ (instancetype)instance;
+ (void)destroyInstance;

- (void)prepareDrones;
- (Drone *)getDroneNearPosition:(CGPoint)pt;

@end
