//
//  GameViewController.m
//  dronegame
//
//  Created by Steven Blessing on 7/15/17.
//  Copyright (c) 2017 ho. All rights reserved.
//

#define RANDOM(__lowerBound__, __upperBound__) ((__lowerBound__) + ((__upperBound__) - (__lowerBound__)) * 1.0 * (arc4random() % 1000000) / 1000000.0)

GameViewController * sharedGameViewController;

@interface GameViewController()

@property (nonatomic, strong) TouchInputHandler * touchInputHandler;
@property (nonatomic, strong) NSTimer * customerCreationTimer;

@end

@implementation GameViewController

+ (instancetype)instance
{
    NSAssert(sharedGameViewController, @"this must not be nil");
    return sharedGameViewController;
}

+ (void)destroyInstance
{
    sharedGameViewController = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sharedGameViewController = self;
    
    self.view.backgroundColor = [UIColor greenColor];
    
    _customers = [NSMutableArray new];
    
    _touchInputHandler = [TouchInputHandler new];
    _touchInputHandler.view = self.view;
    
    [[DroneManager instance] prepareDrones];
    
    for (Drone * drone in [DroneManager instance].drones) {
        [self.view addSubview:drone];
    }
    
    _customerCreationTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(addNewCustomer) userInfo:nil repeats:YES];
}

- (void)addNewCustomer
{
    Customer * customer = [Customer new];
    
    [_customers addObject:customer];
    
    customer.center = [self randomPosition];
    
    [self.view addSubview:customer];
}

- (Customer *)getNearestCustomer:(CGPoint)pt
{
    return (Customer *)[GameUtils getViewNearPosition:pt array:_customers];
}

- (CGPoint)randomPosition
{
    CGSize size = self.view.frame.size;
    CGFloat x = RANDOM(0, size.width);
    CGFloat y = RANDOM(0, size.height);
    return CGPointMake(x, y);
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

- (void)dealloc
{
    [_customerCreationTimer invalidate];
}

@end
