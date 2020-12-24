//
//  UIView+SJCShaker.m
//  Yehwang
//
//  Created by Yehwang on 2020/12/23.
//  Copyright © 2020 Yehwang. All rights reserved.
//

#import "UIView+SJCShaker.h"
#include <objc/runtime.h>

static NSString * const kSJCViewShakerAnimationKey = @"kSJCViewShakerAnimationKey";
static const NSString * kSJCViewShakerCompletionKey        = @"kSJCViewShakerCompletionKey";
static const NSString * kSJCcompletedAnimationsKey        = @"kSJCcompletedAnimationsKey";
static const NSString * kSJCViewsKey        = @"kSJCViewsKey";

@implementation UIView (SJCShaker)

- (void)sjc_shake {
    [self sjc_shakeWithDuration:0.5 completion:^{}];
}

- (void)sjc_shakeWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion {
    self.completionBlock = completion;
    [self addShakeAnimationForView:self withDuration:duration];
}

- (void)addShakeAnimationForView:(UIView *)view withDuration:(NSTimeInterval)duration {
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    CGFloat currentTx = view.transform.tx;
    
    animation.delegate = self;
    animation.duration = duration;
    animation.values = @[@(currentTx),
                         @(currentTx + 10),
                         @(currentTx - 8),
                         @(currentTx + 8),
                         @(currentTx - 5),
                         @(currentTx + 5),
                         @(currentTx)];
    animation.keyTimes = @[@(0), @(0.225), @(0.425), @(0.6), @(0.75), @(0.875), @(1)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    [view.layer addAnimation:animation forKey:kSJCViewShakerAnimationKey];
}

#pragma mark - CAAnimation Delegate

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
    if (self.completionBlock) {
        self.completionBlock();
    }
}

- (void)setCompletionBlock:(void (^)(void))completionBlock {
    objc_setAssociatedObject(self, &kSJCViewShakerCompletionKey, completionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(void))completionBlock {
    return objc_getAssociatedObject(self, &kSJCViewShakerCompletionKey);
}


@end



@implementation NSArray (SJCShaker)

- (void)sjc_shake {
    [self sjc_shakeWithDuration:0.5 completion:^{}];
}

- (void)sjc_shakeWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion {
    self.completionBlock = completion;
    
    __block NSUInteger views = 0;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (![obj isKindOfClass:[UIView class]]) {
//            NSAssert(NO, @"数组的元素必须是UIView或者其子类");
//            *stop = YES;
//        }
        if ([obj isKindOfClass:[UIView class]]) {
            //就算数组里装的不是UIView及其子类，也会过滤掉，统计过滤后的个数
            views++;
            @synchronized (self) {
                [self addShakeAnimationForView:obj withDuration:duration];
            }
        }
    }];
    self.views = views;
//    for (UIView * view in self) {
//        [self addShakeAnimationForView:view withDuration:duration];
//    }
}

- (void)addShakeAnimationForView:(UIView *)view withDuration:(NSTimeInterval)duration {
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    CGFloat currentTx = view.transform.tx;
    
    animation.delegate = self;
    animation.duration = duration;
    animation.values = @[@(currentTx),
                         @(currentTx + 10),
                         @(currentTx - 8),
                         @(currentTx + 8),
                         @(currentTx - 5),
                         @(currentTx + 5),
                         @(currentTx)];
    animation.keyTimes = @[@(0), @(0.225), @(0.425), @(0.6), @(0.75), @(0.875), @(1)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    [view.layer addAnimation:animation forKey:kSJCViewShakerAnimationKey];
}

#pragma mark - CAAnimation Delegate

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
    self.completedAnimations += 1;
    if (self.completedAnimations >= self.views) {//self.count
        self.completedAnimations = 0;
        self.views = 0;
        if (self.completionBlock) {
            self.completionBlock();
        }
    }
}


- (void)setCompletionBlock:(void (^)(void))completionBlock {
    objc_setAssociatedObject(self, &kSJCViewShakerCompletionKey, completionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(void))completionBlock {
    return objc_getAssociatedObject(self, &kSJCViewShakerCompletionKey);
}

- (void)setCompletedAnimations:(NSUInteger)completedAnimations {
    objc_setAssociatedObject(self, &kSJCcompletedAnimationsKey, @(completedAnimations), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)completedAnimations {
    return (NSUInteger)objc_getAssociatedObject(self, &kSJCcompletedAnimationsKey);
}

- (void)setViews:(NSUInteger)views {
    objc_setAssociatedObject(self, &kSJCViewsKey, @(views), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)views {
    return (NSUInteger)objc_getAssociatedObject(self, &kSJCViewsKey);
}

@end
