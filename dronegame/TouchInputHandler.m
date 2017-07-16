//
//  TouchInputHandler.m
//  dronegame
//
//  Created by Lionel Seidman on 7/15/17.
//  Copyright © 2017 ho. All rights reserved.
//

@interface TouchInputHandler()

@property (nonatomic, strong) Drone * selectedDrone;
@property (nonatomic, strong) Customer * nearestCustomer;

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
    
    Customer * nearestCustomer = [[GameViewController instance] getNearestCustomer:pt];
    
    if (nearestCustomer != _nearestCustomer) {
        _nearestCustomer.selected = NO;
        _nearestCustomer = nearestCustomer;
        _nearestCustomer.selected = YES;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_nearestCustomer) {
        [_selectedDrone pickUpCustomer:_nearestCustomer];
    } else {
        CGPoint pt = [self positionForTouches:touches];
        [_selectedDrone flyToLocation:pt];
    }
    
    _nearestCustomer.selected = NO;
    _selectedDrone.selected = NO;
    
    _nearestCustomer = nil;
    _selectedDrone = nil;
}

- (CGPoint)positionForTouches:(NSSet *)touches
{
    UITouch * touch = touches.anyObject;
    CGPoint pt = [touch locationInView:_view];
    return pt;
}

@end
