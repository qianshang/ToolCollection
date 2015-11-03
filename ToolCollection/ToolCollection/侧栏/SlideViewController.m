//
//  SlideViewController.m
//  ToolCollection
//
//  Created by 程维 on 15/11/3.
//  Copyright © 2015年 程维. All rights reserved.
//

#import "SlideViewController.h"

#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height
#define kMenuWidth      200
#define kMenuHeight     kScreenHeight

@interface SlideViewController ()

@property (nonatomic , strong) UIImageView      *bg_imageView;
@property (nonatomic , strong) UIView           *menu_view;

@end

@implementation SlideViewController

+ (SlideViewController *)shareSlideViewController {
    static dispatch_once_t onceToken;
    static SlideViewController *slideVC;
    dispatch_once(&onceToken, ^{
        slideVC = [[SlideViewController alloc] init];
    });
    return slideVC;
}

- (void)loadView {
    [self configView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    [self.view addSubview:self.menu_view];
}

- (void)showMenuAboutDirection:(Direction)direction {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    __block UIViewController *fromVC = keyWindow.rootViewController;
    [keyWindow insertSubview:self.bg_imageView atIndex:0];
    [keyWindow addSubview:self.view];
    
    self.menu_view.frame = CGRectMake(direction==DirectionAboutLeft ?-kMenuWidth:kScreenWidth, 0, kMenuWidth, kMenuHeight);
    
    typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.menu_view.transform    = CGAffineTransformMakeTranslation(direction==DirectionAboutLeft ?kMenuWidth:-kMenuWidth, 0);
        fromVC.view.transform  = CGAffineTransformMakeScale(0.8, 0.8);
        CGFloat left = (kMenuWidth+kScreenWidth*0.4);
        fromVC.view.center     = CGPointMake(direction==DirectionAboutLeft ?left:(kScreenWidth-left), kScreenHeight/2.f);
    }];
}

- (void)hideMenu {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    __block UIViewController *fromVC = keyWindow.rootViewController;
    
    typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.menu_view.transform    = CGAffineTransformIdentity;
        fromVC.view.transform  = CGAffineTransformIdentity;
        fromVC.view.center     = CGPointMake(kScreenWidth/2.f, kScreenHeight/2.f);
    } completion:^(BOOL finished) {
        [weakSelf.view         removeFromSuperview];
        [weakSelf.bg_imageView removeFromSuperview];
//        weakSelf.fromVC         = nil;
        weakSelf.bg_imageView   = nil;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch      = [touches anyObject];
    CGPoint location    = [touch locationInView:self.view];
    
    if (!CGRectContainsPoint(self.menu_view.frame, location)) {
        [self hideMenu];
    }
}

#pragma mark - getter
- (UIImageView *)bg_imageView {
    if (!_bg_imageView) {
        _bg_imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bg_imageView.contentMode = UIViewContentModeScaleAspectFill;
        _bg_imageView.backgroundColor = [UIColor purpleColor];
    }
    return _bg_imageView;
}
- (UIView *)menu_view {
    if (!_menu_view) {
        _menu_view = [[UIView alloc] initWithFrame:CGRectZero];
        _menu_view.backgroundColor = [UIColor yellowColor];
    }
    return _menu_view;
}




@end
