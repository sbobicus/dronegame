//
//  UIView+Shortcuts.h
//  metro-tycoon
//
//  Created by Lionel Seidman on 9/17/13.
//
//

#import <UIKit/UIKit.h>

@interface UIView (Shortcuts)

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat xCenter;
@property (nonatomic) CGFloat yCenter;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGPoint bottomLeft;
@property (nonatomic) CGSize size;

@property (nonatomic, readonly) UIImage * screenshot;
@property (nonatomic, strong) void (^tapAction)(void);
@property (nonatomic, readonly) CGPoint boundsCenter;

- (UIImage *)screenshotWithScale:(CGFloat)scale;
- (void)removeAllSubviewsRecursively;

- (void)setTapActionSelector:(SEL)selector target:(id)target;
- (void)applyShadowWithColor:(UIColor *)color radius:(CGFloat)radius alpha:(CGFloat)alpha offset:(CGSize)offset;

@end
