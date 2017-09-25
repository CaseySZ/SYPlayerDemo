//
//  ViewController.m
//  SYPlayerDemo
//
//  Created by ksw on 2017/9/14.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "ViewController.h"

#import "SYPlayerMovieView.h"
#import "MBProgressHUD.h"
#import "NSObject+SYKVO.h"
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController (){
    
    SYPlayerMovieView *syPlayerMoviewV;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    syPlayerMoviewV = [[SYPlayerMovieView alloc] init];
    syPlayerMoviewV.movieUrl = @"http://mp4.examw.cn/m3u8/1/1.m3u8";
    [syPlayerMoviewV setFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 300)];
    [self.view addSubview:syPlayerMoviewV];
    
    MBProgressHUD *hud =  [MBProgressHUD new];
    [self.view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.labelFont = [UIFont systemFontOfSize:13.0f];
    
    hud.labelText = @"处理中...";
    [hud show:YES];
    
    [syPlayerMoviewV start:^(BOOL isSuccess, NSString *desc) {
        
        if (isSuccess) {
            
            NSLog(@"===OK");
            ;
            
        }else{
            NSLog(@"===OK __NO");
        }
        [hud hide:YES afterDelay:0.3];
        
    }];
    
    UILabel *tmTimeLb = timeLabel;
    
    __weak typeof(self) weakSelf = self;
    // 监听播放时间
    syPlayerMoviewV.listenTimeBlock = ^(NSTimeInterval currentTime, NSTimeInterval totalTime) {
        
        tmTimeLb.text = [NSString stringWithFormat:@"%ds::%ds", (int)currentTime, (int)totalTime];
        weakSelf.slider.value = currentTime/totalTime;
    };
    // 监听加载进度
    syPlayerMoviewV.listenPreloadTimeBlock = ^(NSArray<NSValue *> *preloadAry) {
        if (preloadAry.count > 0) {
            CMTimeRange timeRange = [[preloadAry firstObject] CMTimeRangeValue];
            
            float startTime = timeRange.start.value; // load开始时间点
            float duration = timeRange.duration.value;// load时长
            NSLog(@"pre load duration::%f",duration);
        }
    };
    // 播放完成
    syPlayerMoviewV.playFinishBlock = ^(NSDictionary *errorDes) {
        NSLog(@"playEndTimeBlock::::%@", errorDes);
    };
    
    NSLog(@"ViewDid finish");
}

- (UISlider*)slider{
    
    return _slider;
}

- (IBAction)nextEvent:(id)sender{
    
    MBProgressHUD *hud =  [MBProgressHUD new];
    [self.view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.labelFont = [UIFont systemFontOfSize:13.0f];
    
    hud.labelText = @"处理中...";
    [hud show:YES];
    // 下一个视频
    [syPlayerMoviewV playerNextMovieWithUrl:@"http://mp4.examw.cn/chuji/8/208_18/0b950a93-7947-2cdc-103f-e3e62f08c468/liuchang.mp4" loadFinish:^(BOOL isSuccess, NSString *desc) {
        
        [hud hide:YES];
        if (isSuccess) {
            
            NSLog(@"===OK");
        }else{
            NSLog(@"===OK __NO");
        }
        
    }];
    
    
}

- (IBAction)rateEvent:(id)sender{
    
    if (syPlayerMoviewV.playRate == 1.0) {
        
        syPlayerMoviewV.playRate = 2.0;
    }else{
        syPlayerMoviewV.playRate  = 1;
    }
    
}

- (IBAction)stopEvent:(id)sender{
    
    [syPlayerMoviewV pause];
}

- (IBAction)seekEvent:(id)sender{
    
    
    MBProgressHUD *hud =  [MBProgressHUD new];
    [self.view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.labelFont = [UIFont systemFontOfSize:13.0f];
    
    hud.labelText = @"处理中...";
    [hud show:YES];
    
    [syPlayerMoviewV seekToTime:_slider.value*syPlayerMoviewV.totalTime + 20 finish:^(BOOL isSuccess, NSString *desc) {
        
        [hud hide:YES afterDelay:0.3];
    }];
    
}

@end
