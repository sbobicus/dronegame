//
//  TouchInputHandler.m
//  dronegame
//
//  Created by Lionel Seidman on 7/15/17.
//  Copyright © 2017 ho. All rights reserved.
//

#import "TouchInputHandler.h"
#import "DroneManager.h"
#import "Drone.h"

@interface TouchInputHandler()

@property (nonatomic, strong) Drone * selectedDrone;

@end

@implementation TouchInputHandler

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [self positionForTouches:touches];
    _selectedDrone = [[DroneManager instance] getDroneNearPosition:pt];
    _selectedDrone.selected = YES;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [self positionForTouches:touches];
    
    CGFloat dX = pt.x - _selectedDrone.center.x;
    CGFloat dY = pt.y - _selectedDrone.center.y;
    CGFloat angle = -atan(dX / dY);
    
    _selectedDrone.transform = CGAffineTransformMakeRotation(angle);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [self positionForTouches:touches];
    _selectedDrone.selected = NO;
    [_selectedDrone flyToLocation:pt];
}

- (CGPoint)positionForTouches:(NSSet *)touches
{
    UITouch * touch = touches.anyObject;
    CGPoint pt = [touch locationInView:_view];
    return pt;
}

@end
