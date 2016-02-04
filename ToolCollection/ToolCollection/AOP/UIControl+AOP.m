//
//  UIControl+AOP.m
//  Test
//
//  Created by admin on 16/2/4.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "UIControl+AOP.h"
#import "JRSwizzle.h"
#import <objc/runtime.h>

static const char *UIControl_Interval           = "UIControl_Interval";
static const char *UIControl_IsIgnoreEvent      = "UIControl_IsIgnoreEvent";
static const char *UIControl_TransitionAction   = "UIControl_TransitionAction";

@implementation UIControl (AOP)

+ (void)load {
    NSError *error = nil;
    [self jr_swizzleMethod:@selector(__aop_sendAction:to:forEvent:) withMethod:@selector(sendAction:to:forEvent:) error:&error];
    if (error) {
        NSLog(@"error = %@",error);
    }
}
#pragma mark - public
- (void)dealWithRepeatClickAboutInterval:(NSTimeInterval)interval forTransitionAction:(void (^)(void))transitionAction {
    self.interval = interval;
    self.transitionAction = transitionAction;
}
- (void)dealWithRepeatClickAboutInterval:(NSTimeInterval)interval showMessage:(NSString *)message {
    __weak typeof(self)weakSelf = self;
    [self dealWithRepeatClickAboutInterval:interval forTransitionAction:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf showMessage:message];
        });
    }];
}
#pragma mark - private
- (void)__aop_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (self.isIgnoreEvent) {
        if (self.transitionAction) {
            self.transitionAction();
        }
        return;
    }
    if (self.interval > 0) {
        self.isIgnoreEvent = YES;
        [self performSelector:@selector(setIsIgnoreEvent:) withObject:@(NO) afterDelay:self.interval];
    }
    [self __aop_sendAction:action to:target forEvent:event];
}
- (void)showMessage:(NSString *)message {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView   *_msgLabel = [keyWindow viewWithTag:10010];
    if (!_msgLabel) {
        UILabel *label  = [[UILabel alloc] initWithFrame:CGRectZero];
        label.numberOfLines         = 0;
        label.text                  = message;
        label.backgroundColor       = [UIColor colorWithWhite:0 alpha:0.5];
        label.textColor             = [UIColor whiteColor];
        label.font                  = [UIFont systemFontOfSize:15];
        label.textAlignment         = NSTextAlignmentCenter;
        label.layer.cornerRadius    = 5;
        label.layer.masksToBounds   = YES;
        
        CGSize size     = [label.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width/2, 100)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:label.font}
                                                   context:nil].size;
        size            = CGSizeMake(size.width+20, size.height+10);
        label.bounds    = (CGRect){CGPointZero,size};
        label.center    = CGPointMake(keyWindow.center.x, [UIScreen mainScreen].bounds.size.height-size.height-50);
        label.tag       = 10010;
        _msgLabel       = label;
    }
    if ([_msgLabel isDescendantOfView:keyWindow]) {
        return;
    }
    [keyWindow addSubview:_msgLabel];
    [keyWindow bringSubviewToFront:_msgLabel];
    
    [_msgLabel performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1];
}
#pragma mark - setter/getter
- (NSTimeInterval)interval {
    return [objc_getAssociatedObject(self, UIControl_Interval) doubleValue];
}
- (BOOL)isIgnoreEvent {
    return [objc_getAssociatedObject(self, UIControl_IsIgnoreEvent) boolValue];
}
- (void (^)(void))transitionAction {
    return objc_getAssociatedObject(self, UIControl_TransitionAction);
}
- (void)setInterval:(NSTimeInterval)interval {
    objc_setAssociatedObject(self, UIControl_Interval, @(interval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setIsIgnoreEvent:(BOOL)isIgnoreEvent {
    objc_setAssociatedObject(self, UIControl_IsIgnoreEvent, @(isIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setTransitionAction:(void (^)(void))transitionAction {
    objc_setAssociatedObject(self, UIControl_TransitionAction, transitionAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
