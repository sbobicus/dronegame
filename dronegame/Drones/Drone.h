//
//  Drone.h
//  dronegame
//
//  Created by Lionel Seidman on 7/15/17.
//  Copyright © 2017 ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Drone : UIView

@property (nonatomic) BOOL selected;

- (void)flyToLocation:(CGPoint)pt;

@end
