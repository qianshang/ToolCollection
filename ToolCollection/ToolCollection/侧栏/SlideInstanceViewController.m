//
//  SlideInstanceViewController.m
//  ToolCollection
//
//  Created by 程维 on 15/11/3.
//  Copyright © 2015年 程维. All rights reserved.
//

#import "SlideInstanceViewController.h"
#import "SlideViewController.h"
@interface SlideInstanceViewController ()

@end

@implementation SlideInstanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:pan];
}

- (IBAction)showSlide {
    [[SlideViewController shareSlideViewController] showMenuAboutDirection:DirectionAboutRight];
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan velocityInView:self.view];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (point.x < 0) {
            [self showSlide];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
