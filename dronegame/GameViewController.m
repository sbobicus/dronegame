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
@property (nonatomic, strong) CADisplayLink * displayLink;
@property (nonatomic) NSInteger frameIndex;

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
    
    _customers = [NSMutableArray new];
    
    _touchInputHandler = [TouchInputHandler new];
    _touchInputHandler.view = self.view;
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(gameLoop)];
    _displayLink.frameInterval = 1;
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    _pauseButton = [self newLabel];
    _pauseButton.textAlignment = NSTextAlignmentCenter;
    
    __weak GameViewController * _self = self;
    
    [_pauseButton setTapAction:^{
        _self.gamePaused ^= 1;
    }];
    
    [self updatePauseButton];
    [self.view addSubview:_pauseButton];
    
    _customersDeliveredLabel = [self newLabel];
    _customersDeliveredLabel.right = self.view.width - 5.0;
    
    _customersWaitingLabel = [self newLabel];
    _customersWaitingLabel.right = _customersDeliveredLabel.x - 5.0;
    
    _pauseButton.width = _pauseButton.height;
    _pauseButton.right = _customersWaitingLabel.x - 5.0;
    
    self.customersDelivered = 0;
    self.customersWaiting = 0;
}

- (UILabel *)newLabel
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 5.0, 80, 30)];
    label.font = [UIFont fontWithName:@"Helvetica-Light" size:15.0];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    label.layer.cornerRadius = 3.0;
    label.layer.masksToBounds = YES;
    
    [self.view addSubview:label];
    return label;
}

- (void)setGamePaused:(BOOL)gamePaused
{
    _gamePaused = gamePaused;
    _displayLink.paused = gamePaused;
    [self updatePauseButton];
}

- (void)updatePauseButton
{
    _pauseButton.text = _gamePaused ? @"▶" : @"❙❙";
}

- (void)setCustomersWaiting:(NSInteger)customersWaiting
{
    _customersWaiting = customersWaiting;
    _customersWaitingLabel.text = [NSString stringWithFormat:@" 🤔 %lu", customersWaiting];
}

- (void)setCustomersDelivered:(NSInteger)customersDelivered
{
    _customersDelivered = customersDelivered;
    _customersDeliveredLabel.text = [NSString stringWithFormat:@" 😎 %lu", customersDelivered];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor greenColor];

    [[DroneManager instance] prepareDrones];

    for (Drone * drone in [DroneManager instance].drones) {
        [self.view insertSubview:drone atIndex:0];
    }
}

- (void)gameLoop
{
    for (Drone * drone in [DroneManager instance].drones) {
        [drone updatePosition];
    }
    
    _frameIndex++;
    
    if (_frameIndex % 180 == 0) {
        [self addNewCustomer];
    }
}

- (void)addNewCustomer
{
    Customer * customer = [Customer new];
    [customer popIn];
    [_customers addObject:customer];
    
    [self.view insertSubview:customer atIndex:0];
    [self.view insertSubview:customer.destination atIndex:0];
}

- (Customer *)getNearestCustomer:(CGPoint)pt
{
    return (Customer *)[GameUtils getViewNearPosition:pt array:_customers];
}

- (CGPoint)randomPosition
{
    CGSize size = self.view.size;
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

- (BOOL)prefersStatusBarHidden
{
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
    [_displayLink invalidate];
}

@end
