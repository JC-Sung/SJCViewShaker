//
//  UIView+SJCShaker.h
//  Yehwang
//
//  Created by Yehwang on 2020/12/23.
//  Copyright © 2020 Yehwang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// shaker for one view
@interface UIView (SJCShaker)<CAAnimationDelegate>

@property (nonatomic, copy) void (^completionBlock)(void);

- (void)sjc_shake;

- (void)sjc_shakeWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion;


@end



/// shaker for multiple views
@interface NSArray (SJCShaker)<CAAnimationDelegate>

@property (nonatomic, assign) NSUInteger views;
@property (nonatomic, assign) NSUInteger completedAnimations;
@property (nonatomic, copy) void (^completionBlock)(void);

- (void)sjc_shake;

- (void)sjc_shakeWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion;


@end

NS_ASSUME_NONNULL_END
