//
//  SYPlayerMovieView.m
//  SYPlayerDemo
//
//  Created by ksw on 2017/9/14.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "SYAVMovieView.h"
#import <AVFoundation/AVFoundation.h>


@implementation SYAVMovieView


+ (Class)layerClass{
    
    return [AVPlayerLayer class];
}

- (AVPlayer*)player{
    
    return [(AVPlayerLayer*)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player{
    
    [(AVPlayerLayer*)[self layer] setPlayer:player];
}


- (void)setVideoFillMode:(NSString *)fillMode
{
    AVPlayerLayer *playerLayer = (AVPlayerLayer*)[self layer];
    playerLayer.videoGravity = fillMode;
}


@end
