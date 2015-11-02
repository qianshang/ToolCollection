//
//  ScreenShotsViewController.m
//  ToolCollection
//
//  Created by 程维 on 15/11/2.
//  Copyright © 2015年 程维. All rights reserved.
//

#import "ScreenShotsViewController.h"

@interface ScreenShotsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *image_old;
@property (weak, nonatomic) IBOutlet UIImageView *image_new;

@end

@implementation ScreenShotsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)screenShot {
    //   按制定区域截取
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect shotFrame  = self.image_old.frame;
    
    //原始区域
    UIGraphicsBeginImageContext(screenSize);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*parentImage=UIGraphicsGetImageFromCurrentImageContext();
    
    CGImageRef imageRef = parentImage.CGImage;
    //myInmageRect想要截取的区域
    CGRect myImageRect = shotFrame;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    
    //转换img
    UIImage* image = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    [self.image_new setImage:image];
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
