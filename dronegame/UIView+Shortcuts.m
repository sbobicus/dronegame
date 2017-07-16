//
//  UIView+Shortcuts.m
//  metro-tycoon
//
//  Created by Lionel Seidman on 9/17/13.
//
//

#import "UIView+Shortcuts.h"

@implementation UIView (Shortcuts)

- (CGFloat)x { return self.frame.origin.x; }

- (void)setX:(CGFloat)x {
    CGRect r = self.frame;
    self.frame = CGRectMake(x, r.origin.y, r.size.width, r.size.height);
}

- (CGFloat)y { return self.frame.origin.y; }

- (void)setY:(CGFloat)y {
    CGRect r = self.frame;
    self.frame = CGRectMake(r.origin.x, y, r.size.width, r.size.height);
}

- (CGFloat)xCenter { return self.center.x; }

- (void)setXCenter:(CGFloat)xCenter {
    self.center = CGPointMake(xCenter, self.center.y);
}

- (CGFloat)yCenter { return self.center.y; }

- (void)setYCenter:(CGFloat)yCenter {
    self.center = CGPointMake(self.center.x, yCenter);
}

-(CGFloat)width { return self.frame.size.width; }

- (void)setWidth:(CGFloat)width {
    CGRect r = self.frame;
    self.frame = CGRectMake(r.origin.x, r.origin.y, width, r.size.height);
}

- (CGFloat)height { return self.frame.size.height; }

- (void)setHeight:(CGFloat)height {
    CGRect r = self.frame;
    self.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width, height);
}

- (CGFloat)bottom { return self.y + self.height; }

- (void)setBottom:(CGFloat)bottom {
    CGRect r = self.frame;
    self.frame = CGRectMake(r.origin.x, bottom - r.size.height, r.size.width, r.size.height);
}

- (CGPoint)bottomLeft { return CGPointMake(self.x, self.bottom); }

- (void)setBottomLeft:(CGPoint)bottomLeft {
    self.x = bottomLeft.x;
    self.bottom = bottomLeft.y;
}

- (CGFloat)right { return self.x + self.width; }

- (void)setRight:(CGFloat)right {
    CGRect r = self.frame;
    CGSize s = r.size;
    self.frame = CGRectMake(right - s.width, r.origin.y, s.width, s.height);
}

- (CGPoint)origin { return self.frame.origin; }

- (void)setOrigin:(CGPoint)origin {
    CGSize s = self.frame.size;
    self.frame = CGRectMake(origin.x, origin.y, s.width, s.height);
}

- (CGSize)size { return self.frame.size; }

- (void)setSize:(CGSize)size {
    CGPoint origin = self.frame.origin;
    self.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
}

- (CGPoint)boundsCenter { return CGPointMake(self.width / 2, self.height / 2); }

- (UIImage *)screenshot
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:ctx];
    UIImage * i = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return i;
}

- (UIImage *)screenshotWithScale:(CGFloat)scale
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:ctx];
    UIImage * i = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return i;
}

- (void)setTapAction:(void (^)(void))tapAction
{
    self.userInteractionEnabled = YES;
    [self.layer setValue:tapAction forKey:@"tapAction"];
    UIButton * b = [[UIButton alloc] initWithFrame:self.bounds];
    [b addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    b.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:b];
}

- (void (^)(void))tapAction
{
    void (^tapAction)(void) = [self.layer valueForKey:@"tapAction"];
    return tapAction;
}

- (void)setTapActionSelector:(SEL)selector target:(id)target
{
    self.userInteractionEnabled = YES;
    UIButton * b = [[UIButton alloc] initWithFrame:self.bounds];
    [b addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    b.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:b];
}

- (void)buttonTapped
{
    self.tapAction();
}

- (void)removeAllSubviewsRecursively
{
    for (UIView * v in self.subviews) {
        [v removeAllSubviewsRecursively];
        [v removeFromSuperview];
    }
}

- (id)debugQuickLookObject
{
    return self;
}

- (void)applyShadowWithColor:(UIColor *)color radius:(CGFloat)radius alpha:(CGFloat)alpha offset:(CGSize)offset
{
    CALayer * layer = self.layer;
    layer.shadowColor = color.CGColor;
    layer.shadowRadius = radius;
    layer.shadowOpacity = alpha;
    layer.shadowOffset = offset;
    layer.rasterizationScale = [UIScreen mainScreen].scale;
    layer.shouldRasterize = YES;
}

@end
