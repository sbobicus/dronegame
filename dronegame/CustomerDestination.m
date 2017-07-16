//
//  CustomerDestination.m
//  dronegame
//
//  Created by Lionel Seidman on 7/15/17.
//  Copyright © 2017 ho. All rights reserved.
//

#import "CustomerDestination.h"

@interface CustomerDestination()

@property (nonatomic) CGFloat normalScale, circleDiameter;

@end

@implementation CustomerDestination

- (instancetype)init
{
    self = [super init];
    if (self) {
        _circleDiameter = 100.0;
        _normalScale = 0.5;
        
        self.frame = CGRectMake(0, 0, _circleDiameter, _circleDiameter);
        self.center = [[GameViewController instance] randomPosition];
        self.alpha = 0;
        
        self.layer.cornerRadius = 0.5 * _circleDiameter;
        self.layer.borderWidth = 2.0;
        self.layer.borderColor = [UIColor blueColor].CGColor;
    }
    return self;
}

- (void)setVisible:(BOOL)visible
{
    _visible = visible;
    
    if (visible) {
        self.alpha = 1.0;
        self.transform = CGAffineTransformMakeScale(0.15, 0.15);
        
        [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:1 options:0 animations:^{
            self.transform = CGAffineTransformMakeScale(_normalScale, _normalScale);
        } completion:nil];
    } else {
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.transform = CGAffineTransformMakeScale(0.25, 0.25);
            self.alpha = 0.0;
        } completion:nil];
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    _highlighted = highlighted;
    
    if (highlighted) {
        [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:1 options:0 animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
    } else {
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.transform = CGAffineTransformMakeScale(_normalScale, _normalScale);
        } completion:nil];
    }
}

@end
