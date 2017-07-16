//
//  Customer.h
//  dronegame
//
//  Created by Lionel Seidman on 7/15/17.
//  Copyright © 2017 ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomerDestination;

@interface Customer : UIView

@property (nonatomic) BOOL selected, scheduledToBePickedUp, seated;
@property (nonatomic, strong) Drone * containingDrone;
@property (nonatomic) CustomerDestination * destination;

- (void)popIn;
- (void)popOut;

@end
