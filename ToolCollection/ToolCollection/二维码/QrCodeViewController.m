//
//  QrCodeViewController.m
//  ToolCollection
//
//  Created by 程维 on 15/11/2.
//  Copyright © 2015年 程维. All rights reserved.
//

#import "QrCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

static const char *kScanQRCodeQueueName = "ScanQRCodeQueue";

#define SYSTEMVERSION(version) [[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedDescending
#define iOS8 SYSTEMVERSION(@"8.0")
#define iOS9 SYSTEMVERSION(@"9.0")

@interface QrCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic , weak) IBOutlet UIImageView *prompt_imageView;
@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation QrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopReading];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  @author
 *
 *  打开闪光灯
 */
- (IBAction)openTheLight:(id)sender {
    
}
/**
 *  @author
 *
 *  再次扫描二维码
 */
- (IBAction)replay {
    [self startReading];
}
/**
 *  @author
 *
 *  开始扫描
 *
 *  @return 是否可以开始扫描
 */
- (BOOL)startReading {
    
    if (self.captureSession) {
        [self.videoPreviewLayer setFrame:self.prompt_imageView.bounds];
        [self.prompt_imageView.layer addSublayer:self.videoPreviewLayer];
        [self.captureSession startRunning];
        return YES;
    }
    
    return NO;
}
/**
 *  @author
 *
 *  停止扫描
 */
- (void)stopReading
{
    [self.captureSession stopRunning];
    self.captureSession = nil;
}
/**
 *  @author
 *
 *  展示结果
 *
 *  @param result 二维码内容
 */
- (void)reportScanResult:(NSString *)result
{
    [self stopReading];
#ifdef iOS8
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"扫描二维码"
                                                                          message:result
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertControl animated:YES completion:NULL];
#else
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"二维码扫描"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles: nil];
    [alert show];
#endif
}
#pragma AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSString *result;
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            result = metadataObj.stringValue;
        } else {
            NSLog(@"不是二维码");
        }
        [self performSelectorOnMainThread:@selector(reportScanResult:) withObject:result waitUntilDone:NO];
    }
}
#pragma mark - getter
- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
        // 初始化输入流
        NSError * error;
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        if (!input) {
            NSLog(@"%@", [error localizedDescription]);
            return nil;
        }
        // 添加输入流
        [_captureSession addInput:input];
        // 初始化输出流
        AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
        // 添加输出流
        [_captureSession addOutput:captureMetadataOutput];
        
        // 创建dispatch queue.
        dispatch_queue_t dispatchQueue;
        dispatchQueue = dispatch_queue_create(kScanQRCodeQueueName, NULL);
        [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
        // 设置元数据类型 AVMetadataObjectTypeQRCode
        [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
        
    }
    return _captureSession;
}
- (AVCaptureVideoPreviewLayer *)videoPreviewLayer {
    if (!_videoPreviewLayer) {
        _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    }
    return _videoPreviewLayer;
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
