//
//  GameUtils.m
//  dronegame
//
//  Created by Lionel Seidman on 7/15/17.
//  Copyright © 2017 ho. All rights reserved.
//

#import "GameUtils.h"

@implementation GameUtils

+ (UIView *)getViewNearPosition:(CGPoint)pt array:(NSMutableArray *)array
{
    CGFloat minDist = CGFLOAT_MAX;
    UIView * nearestView = nil;
    
    for (UIView * v in array) {
        CGFloat dist = pythag(v.center, pt);
        
        if (dist < minDist) {
            minDist = dist;
            nearestView = v;
        }
    }
    
    if (minDist < 44.0) {
        return nearestView;
    }
    
    return nil;
}

CGFloat pythag(CGPoint pt1, CGPoint pt2)
{
    CGFloat dX = pt1.x - pt2.x;
    CGFloat dY = pt1.y - pt2.y;
    CGFloat distSQ = dX * dX + dY * dY;
    CGFloat d = sqrt(distSQ);
    return d;
}


@end
