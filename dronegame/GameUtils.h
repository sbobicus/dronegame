//
//  GameUtils.h
//  dronegame
//
//  Created by Lionel Seidman on 7/15/17.
//  Copyright © 2017 ho. All rights reserved.
//

#import <Foundation/Foundation.h>

CGFloat pythag(CGPoint pt1, CGPoint pt2);

@interface GameUtils : NSObject

+ (UIView *)getViewNearPosition:(CGPoint)pt array:(NSMutableArray *)array;

@end
