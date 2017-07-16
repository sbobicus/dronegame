//
//  DirectionalIndicator.m
//  dronegame
//
//  Created by Lionel Seidman on 7/16/17.
//  Copyright © 2017 ho. All rights reserved.
//

#import "DirectionalIndicator.h"

@implementation DirectionalIndicator

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 10, 10);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.7 alpha:1.0];
    }
    return self;
}

@end
