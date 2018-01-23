//
//  NavViewController.m
//  OCGlobal
//
//  Created by Eddie on 2018/1/22.
//  Copyright © 2018年 yl. All rights reserved.
//

#import "NavViewController.h"
#import <pop/pop.h>
#import "GLobalDelegate.h"

#define QA_SCREENH ([UIScreen mainScreen].bounds.size.height)
#define QA_SCREENW ([UIScreen mainScreen].bounds.size.width)
typedef void (^qa_animationDidStartBlock)(POPAnimation *anim);
typedef void (^qa_completionBlock)(POPAnimation *anim, BOOL finished);

@interface NavViewController ()
{
    UIImageView *imageView;
    UIView *view;
}
@property (nonatomic, strong) NSTimer *timer;
@property (strong, nonatomic) UIButton *actionBtn;
@property (nonatomic, weak) id <GLobalDelegate> delegate;
@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImage *img = [UIImage imageNamed:@"1.jpeg"];
    view = [UIView new];
    view.frame = CGRectMake(0, 0, QA_SCREENW, QA_SCREENH);
    [self.view addSubview:view];
    [view addSubview:imageView];
    imageView = [UIImageView new];
    imageView.frame = [UIScreen mainScreen].bounds;
    imageView.image = img;
    [view addSubview:imageView];
    view.backgroundColor = [UIColor blueColor];
    imageView.userInteractionEnabled = true;
    view.userInteractionEnabled = true;
    [self.navigationController setNavigationBarHidden:true];
    self.actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.actionBtn.frame = CGRectMake(170, 200, 40, 40);
    [self.actionBtn setTitle:@"缩放" forState:UIControlStateNormal];
    [self.actionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.actionBtn];
    [self.actionBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:self.actionBtn];

}

- (void)click:(UIButton *)btn {
    btn.selected = !btn.selected;
    [self.view bringSubviewToFront:btn];
    if (btn.selected) {
        [self headerView:imageView ShowWithHeader:true animation:true];
    }else {
        [self headerView:imageView ShowWithHeader:false animation:true];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(scaleBgView)]) {
        [self.delegate scaleBgView];
    }
}

- (void)headerView:(UIView *)view ShowWithHeader:(BOOL)show animation:(BOOL)animation {
    if(animation){
        if(show){
            [self popLayerRaduisAnimation:view.layer
                                     from:view.layer.cornerRadius
                                       to:23
                                 duration:0.1
                                      key:@"headerLayerToTop"
                            didStartBlock:nil
                               completion:nil];
            [self popViewFrameAnimation:view
                                   from:view.frame
                                     to:CGRectMake(QA_SCREENW/2 - 23, 80, 46, 46.0*QA_SCREENH/QA_SCREENW)
                               duration:0.2
                                    key:@"headerViewToTop"
                          didStartBlock:nil
                             completion:^(POPAnimation *anim, BOOL finished) {
                                 [UIView animateWithDuration:0.1 animations:^{
                                     UIBezierPath *paht = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 46, 46) cornerRadius:23];
                                     CAShapeLayer *sha = [CAShapeLayer layer];
                                     sha.frame = CGRectMake(0, 0, 46, 46);
                                     sha.path = paht.CGPath;
                                     view.layer.mask = sha;
                                 }];
                             }];
        }else{
            view.layer.mask = nil;
            [self popViewFrameAnimation:view
                                   from:view.frame
                                     to:CGRectMake(0, 0, QA_SCREENW, QA_SCREENH)
                               duration:0.2
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
