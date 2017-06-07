//
//  QRCodeViewController.m
//  IntegrationMediate
//
//  Created by 张兆卿 on 16/8/6.
//  Copyright © 2016年 zzq. All rights reserved.
//

#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "BaseTapSound.h"
#import "BaseNavigationController.h"
#import "MediateMessageViewController.h"
@interface QRCodeViewController () <AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    SystemSoundID soundID;
    float move;
}
@property (strong, nonatomic) AVCaptureDevice * device;
@property (strong, nonatomic) AVCaptureDeviceInput * input;
@property (strong, nonatomic) AVCaptureMetadataOutput * output;
@property (strong, nonatomic) AVCaptureSession * session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * preview;
@property (strong, nonatomic) UIImageView  *qrView;
@property (strong, nonatomic) UIImageView *lineLabel;
@property (strong, nonatomic) NSTimer *lineTimer;
@property (strong, nonatomic) UIView *otherPlatformLoginView;
@property (assign, nonatomic) BOOL isPopHomeCtrl;

@end

@implementation QRCodeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:HexRGB(0xFFFFFF)];
}

- (void)notificAction{
    self.isPopHomeCtrl = YES;
}

- (void)dealloc{
    if ([_lineTimer isValid]) {
        [_lineTimer invalidate];
        _lineTimer = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    XSYLog(@"安全扫码控制器QRCodeViewController----->被销毁了");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    if (_session) {
        [_session startRunning];
        if (_lineTimer) {
            [_lineTimer invalidate];
            _lineTimer = nil;
        }
        _lineTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(moveLine) userInfo:nil repeats:YES];
        _lineLabel.hidden = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"安全扫码", nil);
    
    move = 1.0;
    //扫描区域宽、高大小
    float QRWIDTH = 200/320.0*kScreenWidth;
    
    //创建扫描区域框
    _qrView=[[UIImageView alloc]init];
    _qrView.bounds = CGRectMake(0, 0, QRWIDTH, QRWIDTH);
    _qrView.center = CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0);
    _qrView.backgroundColor = [UIColor clearColor];
    _qrView.image = [UIImage imageNamed:@"QR_CodeView"];
    [self.view addSubview:_qrView];
    
    _lineLabel = [[UIImageView alloc]initWithFrame:CGRectMake(_qrView.frame.origin.x+2.0, _qrView.frame.origin.y + 2.0, _qrView.frame.size.width - 4.0, 3.0)];
    _lineLabel.image = [UIImage imageNamed:@"QRLine.png"];
    [self.view addSubview:_lineLabel];
    
    //半透明背景
    UIView *qrBacView = [[UIView alloc]init];//上
    qrBacView.frame = CGRectMake(0, 64, kScreenWidth, _qrView.frame.origin.y - 64);
    qrBacView.backgroundColor = [UIColor blackColor];
    qrBacView.alpha = 0.6;
    [self.view addSubview:qrBacView];
    
    qrBacView = [[UIView alloc]init];//左
    qrBacView.frame = CGRectMake(0, _qrView.frame.origin.y, _qrView.frame.origin.x,kScreenHeight - _qrView.frame.origin.y);
    qrBacView.backgroundColor = [UIColor blackColor];
    qrBacView.alpha = 0.6;
    [self.view addSubview:qrBacView];
    
    qrBacView = [[UIView alloc]init];//下
    qrBacView.frame = CGRectMake(_qrView.frame.origin.x, _qrView.frame.origin.y + QRWIDTH, kScreenWidth - _qrView.frame.origin.x, kScreenHeight - _qrView.frame.origin.y - QRWIDTH);
    qrBacView.backgroundColor = [UIColor blackColor];
    qrBacView.alpha = 0.6;
    [self.view addSubview:qrBacView];
    
    qrBacView = [[UIView alloc]init];//右
    qrBacView.frame = CGRectMake(_qrView.frame.origin.x + QRWIDTH, _qrView.frame.origin.y, kScreenWidth - _qrView.frame.origin.x - QRWIDTH, QRWIDTH);
    qrBacView.backgroundColor = [UIColor blackColor];
    qrBacView.alpha = 0.6;
    [self.view addSubview:qrBacView];
    
    UILabel *msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_qrView.frame) + 25 , kScreenWidth, 30 )];
    msgLabel.text = NSLocalizedString(@"将二维码放入框内、即可自动扫码", nil);
    msgLabel.textAlignment = NSTextAlignmentCenter;
    msgLabel.font = [UIFont systemFontOfSize:14];
    msgLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:msgLabel];
    
    [self canUseSystemCamera];
}

//创建扫描
- (void)createQRView{
    
    //扫描区域宽、高大小
    float QRWIDTH = 200/320.0*kScreenWidth;

    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    // Output
    _output = [[AVCaptureMetadataOutput alloc] init];
    [ _output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue ()];
    // Session
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input]){
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output]){
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    // 设置扫描有效区域(上、左、下、右)
    [_output setRectOfInterest : CGRectMake (( _qrView.frame.origin.y )/ kScreenHeight ,(_qrView.frame.origin.x)/ kScreenWidth , QRWIDTH / kScreenHeight , QRWIDTH / kScreenWidth)];
    // Preview
    _preview =[ AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill ;
    _preview.frame = self.view.layer.bounds ;
    [self.view.layer insertSublayer:_preview atIndex:0];
    // Start
    [_session startRunning];
    
    _lineTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(moveLine) userInfo:nil repeats:YES];
}

- (void)leftButtonHaveClick:(UIButton *)sender{
    if ([_lineTimer isValid]) {
        [_lineTimer invalidate];
        _lineTimer = nil;
    }
    [_device lockForConfiguration:nil];
    [_device setTorchMode:AVCaptureTorchModeOff];
    [_device unlockForConfiguration];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moveLine{
    float upY = _qrView.frame.origin.y + _qrView.frame.size.height - 2.0 - 3.0;
    float y = _lineLabel.frame.origin.y;
    y = y+move;
    CGRect lineFrame=CGRectMake(_lineLabel.frame.origin.x, y, _qrView.frame.size.width - 4.0, 3.0);
    _lineLabel.frame = lineFrame;
    if (y < _qrView.frame.origin.y + 2.0 || y > upY) {
        move = -move;
    }
}

//扫描成功后的代理方法
- ( void )captureOutput:( AVCaptureOutput *)captureOutput didOutputMetadataObjects:( NSArray *)metadataObjects fromConnection:( AVCaptureConnection *)connection{
    NSString *stringValue;//扫描结果
    if ([metadataObjects count ] > 0 ){
        // 停止扫描
        [self.session stopRunning];
        
        if ([self.lineTimer isValid]) {
            [self.lineTimer invalidate];
            self.lineTimer = nil;
            self.lineLabel.hidden = YES;
        }
        
        [[BaseTapSound shareTapSound] playSystemSound];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        stringValue = metadataObject.stringValue ;
        
        
        if ([stringValue rangeOfString:@"?mediatorId="].location !=NSNotFound) {
            NSRange range = [stringValue rangeOfString:@"="];
            NSString *sessionId = [stringValue substringFromIndex:range.location+1];
            MediateMessageViewController *doneQRCodeCtrl = [[MediateMessageViewController alloc]init];
            doneQRCodeCtrl.mediatorId = sessionId;
            doneQRCodeCtrl.isQR = YES;
            [self.navigationController pushViewController:doneQRCodeCtrl animated:YES];
        
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"很抱歉,暂不支持扫描外部二维码!", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
            alert.tag = 200;
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 200) {
        [self startingQRCode];
    } else {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [Utils openSystemSettingView];
            
            // 延时0.35秒后消失
            __block QRCodeViewController *weakSelf = self;
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    }
}

//允许访问相机
- (void)canUseSystemCamera {
    if (![BaseTapSound ifCanUseSystemCamera]) {
        _lineLabel.hidden = YES;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"“在线法院”已禁用相机", nil) message:NSLocalizedString(@"请在iPhone的“设置”选项中,允许“在线法院”访问你的相机", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"设置", nil), nil];
        alert.tag = 100;
        [alert show];
    } else {
        _lineLabel.hidden = NO;
        [self createQRView];
    }
}

//开始扫描
- (void)startingQRCode{
    if (self.session) {
        [self.session startRunning ];
        if (self.lineTimer) {
            [self.lineTimer invalidate];
            self.lineTimer = nil;
        }
        self.lineTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(moveLine) userInfo:nil repeats:YES];
        self.lineLabel.hidden = NO;
    }
}

@end
