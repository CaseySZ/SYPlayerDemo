//
//  SYPlayerMovieView.h
//  SYPlayerDemo
//
//  Created by ksw on 2017/9/14.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AVPlayer;

@interface SYAVMovieView : UIView


@property (nonatomic, strong)AVPlayer *player;

- (void)setPlayer:(AVPlayer*)player;

- (void)setVideoFillMode:(NSString *)fillMode;




@end
