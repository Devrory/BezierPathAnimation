//
//  ViewController.m
//  BezierPathAnimation
//
//  Created by Rory on 15/12/5.
//  Copyright (c) 2015年 Rory. All rights reserved.
//

#import "ViewController.h"
#import "Macro.h"

typedef enum{
    TowardLeft = 0,
    TowardRight
}ButterFlyDirection;

@interface ViewController ()
{
    CGPoint flyEndPoint;
    ButterFlyDirection flyDirection;
    NSInteger animationTag;
    UIBezierPath *flyPath;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    animationTag = 0;
    [self customButterfly];
    [self bezierPathFly];
}

#define kButterflyTag     0x33

- (void)customButterfly{
    UIImage *butter_01 = [UIImage imageNamed:@"butterfly_blue_01"];
    UIImage *butter_02 = [UIImage imageNamed:@"butterfly_blue_02"];
    UIImage *butter_03 = [UIImage imageNamed:@"butterfly_blue_03"];
    
    UIImageView *butterfly = [[UIImageView alloc] init];
    butterfly.tag = kButterflyTag;
    [butterfly setFrame:CGRectMake(SCREEN_WIDTH + 20, 150, butter_01.size.width/2.0, butter_01.size.height/2.0)];
    CGRect frameRect = butterfly.frame;
    frameRect.origin = flyEndPoint;
    butterfly.frame = frameRect;
    [butterfly setAnimationImages:@[butter_01,butter_02,butter_03]];
    [butterfly setAnimationDuration:0.2];
    [butterfly setAnimationRepeatCount:0];
    [butterfly startAnimating];
    [self.view addSubview:butterfly];
}

- (void)bezierPathFly{
    CGPoint startPoint = flyEndPoint;
    CGPoint controlPoint1;
    int direction = -1;
    
    //如果飞出右侧屏幕了，则直接往左飞
    UIImageView *butterfly = (UIImageView *)[self.view viewWithTag:kButterflyTag];
    if (startPoint.x > SCREEN_WIDTH + 10) {
        if (flyDirection == TowardRight) {
            butterfly.transform = CGAffineTransformMakeRotation(270);
        }
        flyDirection = TowardLeft;
        int maxX = startPoint.x + 10;
        int endPointX = startPoint.x - arc4random() % maxX;
        flyEndPoint = CGPointMake (endPointX, arc4random() % (int)(SCREEN_HEIGHT - 64));
        int controllPointX;
        if (startPoint.x == flyEndPoint.x) {
            controllPointX = 0;
        }else {
            controllPointX = arc4random() % (int)(startPoint.x - flyEndPoint.x)+flyEndPoint.x;
        }
        
        if (flyEndPoint.y == 0) {
            flyEndPoint.y += 1;
        }
        
        controlPoint1 = CGPointMake(controllPointX, arc4random() % (int)flyEndPoint.y );
        
    }else if (startPoint.x < 0) {  //如果飞出左侧屏幕了，直接往右飞
        if (flyDirection == TowardLeft) {
            butterfly.transform = CGAffineTransformMakeRotation(90);
        }
        flyDirection = TowardRight;
        int endPointX = arc4random() % (int)SCREEN_WIDTH/2 + startPoint.x;
        flyEndPoint = CGPointMake (endPointX, arc4random() % (int)(SCREEN_HEIGHT - 64));
        int controllPointX;
        if (startPoint.x == flyEndPoint.x) {
            controllPointX = 0;
        }else {
            controllPointX = arc4random() % (int)(flyEndPoint.x - startPoint.x) + startPoint.x;
        }
        if (flyEndPoint.y == 0) {
            flyEndPoint.y += 1;
        }
        controlPoint1 = CGPointMake(controllPointX, arc4random() % (int)flyEndPoint.y );
        
    }else {                //如果在屏幕间飞，则去随机飞行方向
        direction = arc4random() % 2;
        //往左飞
        if (direction == TowardLeft) {
            if (flyDirection == TowardRight) {
                butterfly.transform = CGAffineTransformMakeRotation(270);
            }
            flyDirection = TowardLeft;
            int maxX = startPoint.x + 10;
            int endPointX = startPoint.x - arc4random() % maxX;
            flyEndPoint = CGPointMake (endPointX, arc4random() % (int)(SCREEN_HEIGHT - 64));
            int controllPointX;
            if (startPoint.x == flyEndPoint.x) {
                controllPointX = 0;
            }else {
                controllPointX =arc4random() % (int)(startPoint.x - flyEndPoint.x)+flyEndPoint.x;
            }
            
            if (flyEndPoint.y == 0) {
                flyEndPoint.y += 1;
            }
            
            controlPoint1 = CGPointMake(controllPointX, arc4random() % (int)flyEndPoint.y );
            
            //往右飞
        }else {
            if (flyDirection == TowardLeft) {
                butterfly.transform = CGAffineTransformMakeRotation(90);
            }
            flyDirection = TowardRight;
            int endPointX = arc4random() % (int)SCREEN_WIDTH/2 + startPoint.x;
            flyEndPoint = CGPointMake (endPointX, arc4random() % (int)(SCREEN_HEIGHT - 64));
            int controllPointX;
            if (startPoint.x == flyEndPoint.x) {
                controllPointX = 0;
            }else {
                controllPointX =arc4random() % (int)(flyEndPoint.x - startPoint.x)+startPoint.x;
            }
            if (flyEndPoint.y == 0) {
                flyEndPoint.y += 1;
            }
            controlPoint1 = CGPointMake(controllPointX, arc4random() % (int)flyEndPoint.y );
        }
    }
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:startPoint];
    [path1 addQuadCurveToPoint:flyEndPoint controlPoint:controlPoint1];
    
    [butterfly.layer removeAnimationForKey:@"animation.new"];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    animation.path = path1.CGPath;
    
    animation.fillMode              = kCAFillModeForwards;
    animation.removedOnCompletion   = NO;
    animation.duration              = 3.0;
    animation.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.removedOnCompletion   = NO;
    animation.delegate = self;

    [butterfly.layer addAnimation:animation forKey:@"animation.new"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self performSelector:@selector(bezierPathFly) withObject:nil afterDelay:1];
}

@end
