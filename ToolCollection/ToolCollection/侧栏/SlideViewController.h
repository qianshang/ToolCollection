//
//  SlideViewController.h
//  ToolCollection
//
//  Created by 程维 on 15/11/3.
//  Copyright © 2015年 程维. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, Direction) {
    DirectionAboutLeft,
    DirectionAboutRight,
};

@interface SlideViewController : UIViewController

+ (SlideViewController *)shareSlideViewController;

- (void)showMenuAboutDirection:(Direction )direction;

@end
