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
@property (nonatomic, strong) CustomerDestination * nearestCustomerDestination;

@end

@implementation TouchInputHandler

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [self positionForTouches:touches];
    _selectedDrone = [[DroneManager instance] getDroneNearPosition:pt];
    _selectedDrone.selected = YES;
    
    [self updateNearestObjectWithPosition:pt];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [self positionForTouches:touches];
    
    CGFloat dX = pt.x - _selectedDrone.center.x;
    CGFloat dY = pt.y - _selectedDrone.center.y;
    CGFloat angle = -atan(dX / dY);
    
    _selectedDrone.transform = CGAffineTransformMakeRotation(angle);
    
    [self updateNearestObjectWithPosition:pt];
}

- (void)updateNearestObjectWithPosition:(CGPoint)pt
{
    if (_selectedDrone) {
        CustomerDestination * destinaiton = [_selectedDrone getCustomerDestinationNearPoint:pt];
        
        if (destinaiton != _nearestCustomerDestination) {
            _nearestCustomerDestination.highlighted = NO;
            _nearestCustomerDestination = destinaiton;
            _nearestCustomerDestination.highlighted = YES;
        }
    }
    
    Customer * nearestCustomer = [[GameViewController instance] getNearestCustomer:pt];
    
    if (_nearestCustomerDestination) {
        nearestCustomer = nil;
    }
    
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
    NSAssert(!(_nearestCustomer && _nearestCustomerDestination), @"at least one of these must be nil");
    
    if (_nearestCustomer) {
        [_selectedDrone pickUpCustomer:_nearestCustomer];
    } else if (_nearestCustomerDestination) {
        [_selectedDrone flyToDestination:_nearestCustomerDestination];
    } else {
        CGPoint pt = [self positionForTouches:touches];
        [_selectedDrone flyToLocation:pt];
    }
    
    _nearestCustomerDestination.highlighted = NO;
    _nearestCustomer.selected = NO;
    _selectedDrone.selected = NO;
    
    _nearestCustomerDestination = nil;
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
