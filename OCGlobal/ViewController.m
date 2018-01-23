//
//  ViewController.m
//  OCGlobal
//
//  Created by Eddie on 2018/1/12.
//  Copyright © 2018年 yl. All rights reserved.
//

#import "ViewController.h"
#import "KeychainManager.h"
#import "UIImage+Webp.h"
#import <AVFoundation/AVFoundation.h>
#import <pop/pop.h>

#define QA_SCREENH ([UIScreen mainScreen].bounds.size.height)
#define QA_SCREENW ([UIScreen mainScreen].bounds.size.width)
typedef void (^qa_animationDidStartBlock)(POPAnimation *anim);
typedef void (^qa_completionBlock)(POPAnimation *anim, BOOL finished);

@interface ViewController ()
{
    NSInteger _time;
    NSDate *_enterBgDate;
    UIImageView *imageView;
}
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@end

//    KeychainManager *manager = [KeychainManager manager];
//    if (![manager selectKeyChainWord]) {
//        [manager addKeychainWord];
//        NSLog(@"第一次写");
//    }else {
//        NSLog(@"之前已经写过了");
//    }
//    if ([KeychainManager existKeychainAccount:@"boboshipin" service:@"221"]) {
//        NSLog(@"boboshipin已存在");
//    }else {
//        [KeychainManager addKeychainAccount:@"boboshipin" service:@"221" saveValue:@"1231231"];
//    }
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *img = [UIImage imageNamed:@"1.jpeg"];
    imageView = [UIImageView new];
    imageView.frame = [UIScreen mainScreen].bounds;
    imageView.image = img;
    [self.view addSubview:imageView];
    [self.view bringSubviewToFront:self.actionBtn];
    [self.actionBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)click:(UIButton *)btn {
    btn.selected = !btn.selected;
    [self.view bringSubviewToFront:btn];
    if (btn.selected) {
        [self headerView:imageView ShowWithHeader:true animation:true];
    }else {
        [self headerView:imageView ShowWithHeader:false animation:true];
    }
}

- (void)headerView:(UIView *)view ShowWithHeader:(BOOL)show animation:(BOOL)animation {
    if(animation){
        if(show){
            [self popViewFrameAnimation:view
                                   from:view.frame
                                     to:CGRectMake(QA_SCREENW/2 - 23, 80, 46, 46.0)
                               duration:3
                                    key:@"headerViewToTop"
                          didStartBlock:nil
                             completion:^(POPAnimation *anim, BOOL finished) {
                                 view.frame = CGRectMake(QA_SCREENW/2 - 23, 80, 46, 46.0*QA_SCREENH/QA_SCREENW);
                                 UIBezierPath *paht = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 46, 46) cornerRadius:23];
                                 CAShapeLayer *sha = [CAShapeLayer layer];
                                 sha.frame = CGRectMake(0, 0, 46, 46);
                                 sha.path = paht.CGPath;
                                 view.layer.mask = sha;
                             }];
            [self popLayerRaduisAnimation:view.layer
                                     from:view.layer.cornerRadius
                                       to:23
                                 duration:0.1
                                      key:@"headerLayerToTop"
                            didStartBlock:nil
                               completion:nil];
        }else{
            view.layer.mask = nil;
            view.frame = CGRectMake(QA_SCREENW/2 - 23, 80, 46, 46.0);
            [self popViewFrameAnimation:view
                                   from:view.frame
                                     to:CGRectMake(0, 0, QA_SCREENW, QA_SCREENH)
                               duration:3
                                    key:@"headerViewToTop"
                          didStartBlock:nil
                             completion:nil];
            
            [self popLayerRaduisAnimation:view.layer
                                     from:view.layer.cornerRadius
                                       to:0
                                 duration:0.1
                                      key:@"headerLayerToTop"
                            didStartBlock:nil
                               completion:nil];
        }
    }else{
        if(show){
            view.frame = CGRectMake(QA_SCREENW/2 - 23, 80, 46, 46);
            view.layer.cornerRadius = 23;
        }else{
            view.frame = CGRectMake(0, 0, QA_SCREENW, QA_SCREENH);
            view.layer.cornerRadius = 0;
        }
    }
}

- (void)popViewFrameAnimation:(UIView *)view
                         from:(CGRect)fromValue
                           to:(CGRect)toValue
                     duration:(CGFloat)duration
                          key:(NSString *)key
                didStartBlock:(qa_animationDidStartBlock)startBlock
                   completion:(qa_completionBlock)completeBlock{
    if(!view)return;
    [POPBasicAnimation pop_removeAnimationForKey:key];
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fromValue = [NSValue valueWithCGRect:fromValue];
    anim.toValue = [NSValue valueWithCGRect:toValue];
    anim.duration = duration;
    if(startBlock){
        anim.animationDidStartBlock = startBlock;
    }
    if(completeBlock){
        anim.completionBlock = completeBlock;
    }
    [view pop_addAnimation:anim forKey:key];
}

- (void)popLayerRaduisAnimation:(CALayer *)layer
                           from:(CGFloat)fromValue
                             to:(CGFloat)toValue
                       duration:(NSTimeInterval)duration
                            key:(NSString *)key
                  didStartBlock:(qa_animationDidStartBlock)startBlock
                     completion:(qa_completionBlock)completeBlock{
    if(!layer)return;
    [POPBasicAnimation pop_removeAnimationForKey:key];
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerCornerRadius];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = @(fromValue);
    animation.toValue = @(toValue);
    animation.duration = duration;
    if(startBlock){
        animation.animationDidStartBlock = startBlock;
    }
    if(completeBlock){
        animation.completionBlock = completeBlock;
    }
    [layer pop_addAnimation:animation forKey:key];
}
@end
