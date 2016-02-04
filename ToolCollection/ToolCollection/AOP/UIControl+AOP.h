//
//  UIControl+AOP.h
//  Test
//
//  Created by admin on 16/2/4.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (AOP)
/**
 *  间隔时间
 */
@property (nonatomic, assign) NSTimeInterval interval;
/**
 *  是否忽视control原本的点击事件(在单元格复用时需要在prepareForResouse中设置为NO)
 */
@property (nonatomic, assign) BOOL isIgnoreEvent;
/**
 *  过渡事件
 */
@property (nonatomic, strong) void(^transitionAction)(void);
/**
 *  重复点击处理,自定义中间的过渡事件
 *
 *  @param interval         间隔时间
 *  @param transitionAction 过渡事件
 */
- (void)dealWithRepeatClickAboutInterval:(NSTimeInterval )interval forTransitionAction:(void(^)(void))transitionAction;
/**
 *  重复点击处理,展示一句提示语
 *
 *  @param interval 间隔时间
 *  @param mssage   提示信息
 */
- (void)dealWithRepeatClickAboutInterval:(NSTimeInterval )interval showMessage:(NSString *)message;

@end
