//
//  CustomerDestination.h
//  dronegame
//
//  Created by Lionel Seidman on 7/15/17.
//  Copyright © 2017 ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Customer;

@interface CustomerDestination : UIView

@property (nonatomic) BOOL visible, highlighted;
@property (nonatomic, weak) Customer * customer;

@end
