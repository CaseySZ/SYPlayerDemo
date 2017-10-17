//
//  SYPlayerView.h
//  ExamProject
//
//  Created by apple on 2017/10/12.
//  Copyright © 2017年 SunYong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYPlayerMovieView;

@interface PlayerViewDemo : UIView
{
    IBOutlet UILabel *_timeLb;
    IBOutlet UISlider *_slider;
    IBOutlet UIProgressView *_progressView;
    IBOutlet UIButton *_speedBtn;
    IBOutlet UIButton *_playBtn;
    IBOutlet SYPlayerMovieView *_playerView;
    IBOutlet UIView *_toolView;
}
@property (weak, nonatomic) IBOutlet UIButton *fullBtn;

+ (instancetype)instanceView;

@property (nonatomic, assign) BOOL isFullScreen;
@property (nonatomic, strong) NSURL *videoUrl;

@end
