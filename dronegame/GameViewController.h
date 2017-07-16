//
//  GameViewController.h
//  dronegame
//

//  Copyright (c) 2017 ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Customer;

@interface GameViewController : UIViewController

@property (nonatomic, strong) NSMutableArray * customers;

+ (instancetype)instance;
+ (void)destroyInstance;

- (CGPoint)randomPosition;
- (Customer *)getNearestCustomer:(CGPoint)pt;

@end
