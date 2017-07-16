//
//  GameViewController.m
//  dronegame
//
//  Created by Steven Blessing on 7/15/17.
//  Copyright (c) 2017 ho. All rights reserved.
//

#import "GameViewController.h"
#import "DroneManager.h"
#import "Drone.h"
#import "TouchInputHandler.h"

GameViewController * sharedGameViewController;

@interface GameViewController()

@property (nonatomic, strong) TouchInputHandler * touchInputHandler;

@end

@implementation GameViewController

+ (instancetype)instance
{
    if (!sharedGameViewController) {
        sharedGameViewController = [[GameViewController alloc] init];
    }
    return sharedGameViewController;
}

+ (void)destroyInstance
{
    sharedGameViewController = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor greenColor];
    
    _touchInputHandler = [TouchInputHandler new];
    
    [[DroneManager instance] prepareDrones];
    
    for (Drone * drone in [DroneManager instance].drones) {
        [self.view addSubview:drone];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_touchInputHandler touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_touchInputHandler touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_touchInputHandler touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_touchInputHandler touchesEnded:touches withEvent:event];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
