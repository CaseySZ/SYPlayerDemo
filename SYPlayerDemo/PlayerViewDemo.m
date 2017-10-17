//
//  SYPlayerView.m
//  ExamProject
//
//  Created by apple on 2017/10/12.
//  Copyright © 2017年 SunYong. All rights reserved.
//

#import "PlayerViewDemo.h"
#import "SYPlayerMovieView.h"
#import "UIView+SYLayout.h"

@interface PlayerViewDemo ()<SYPlayerMoviewViewDelegate>{

}
@end

@implementation PlayerViewDemo


- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [_slider addTarget:self action:@selector(sliderStart:) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDownRepeat];
    
    [_slider addTarget:self action:@selector(sliderScrolling:) forControlEvents:(UIControlEventValueChanged|UIControlEventTouchDragInside)];
    
    [_slider addTarget:self action:@selector(sliderFinish:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel)];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (self.isFullScreen) {
     
        _toolView.x = 0;
        _toolView.y = self.width - _toolView.height;
        
    }else{
        
        _playerView.x = 0;
        _playerView.y = 0;
        _toolView.x = 0;
        _toolView.bottom = self.height;
    }
    
    
    //_slider.continuous = NO;
   // _playerView.size = self.size;
    
    
}


+ (instancetype)instanceView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    PlayerViewDemo *view = [nibView objectAtIndex:0];
    [view playerController];
    return view;
}

- (void)setVideoUrl:(NSURL *)videoUrl {
    _playerView.movieUrl = videoUrl;
    [_playerView play];
    [_playerView start:^(BOOL isSuccess, NSString *desc) {
        // 加载完成
    }];
}

- (void)setIsFullScreen:(BOOL)isFullScreen {
    
    _isFullScreen = isFullScreen;
}

- (void)playerController {
    _playerView.delegate = self;
    [_slider setThumbImage:[UIImage imageNamed:@"播放进度"] forState:UIControlStateNormal];
}

#pragma mark - palyerDelegate
// 时间监听
- (void)currentMoviePlayTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    _timeLb.text = [NSString stringWithFormat:@"%02lld:%02lld/%02lld:%02lld",(long long int) currentTime / 60, (long long int)currentTime % 60,(long long int) totalTime / 60,(long long int)totalTime % 60];
    
    //更新播放进度
    [_slider setValue:currentTime/totalTime animated:YES];
    
}
// 预加载
- (void)currentMoviePreloadPlayTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    [_progressView setProgress:currentTime/totalTime];
}

// 播放结束
- (void)moviePlayEndTime:(NSDictionary*)errorDes {
    
}

- (IBAction)sliderStart:(UISlider*)sender{
    
    NSLog(@"sliderStart::%f:: %f",_playerView.totalTime, sender.value);
    _playerView.delegate = nil;
    
}

- (IBAction)sliderScrolling:(UISlider *)sender {
    
    NSLog(@"slider:: %f",sender.value);
    
    int skipToTime = sender.value*_playerView.totalTime;
    int totoalTime = _playerView.totalTime;
    _playerView.skipToTime = sender.value*_playerView.totalTime;
    _timeLb.text = [NSString stringWithFormat:@"%02d:%02d/%02d:%02d", (int)skipToTime/60, (int)skipToTime%60, (int)totoalTime/60, (int)totoalTime%60];
    
}

- (IBAction)sliderFinish:(UISlider*)sender{
    NSLog(@"sliderFinish::%f:: %f",_playerView.totalTime, sender.value);
    _playerView.delegate = self;
    _playerView.skipToTime = sender.value*_playerView.totalTime;

}

- (IBAction)playerMovieEvent:(UIButton*)sender{
    if (sender.selected) {
        [_playerView play];
    }else {
        [_playerView pause];
    }
    sender.selected = !sender.selected;
}


//倍数播放
- (IBAction)speedBtnEvent:(UIButton *)sender {
    
   
}

@end
