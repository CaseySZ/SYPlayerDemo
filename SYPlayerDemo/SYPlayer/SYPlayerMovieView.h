//
//  SYPlayerMoviewView.h
//  SYPlayerDemo
//
//  Created by ksw on 2017/9/16.
//  Copyright © 2017年 EOC. All rights reserved.
//

//#import "SYAVMovieView.h"

#import "SYAVMovieView.h"

/**
 播放时间和播放完成回调（提供两种方式，block和代理模式）
 */
@protocol  SYPlayerMoviewViewDelegate<NSObject>

// 播放加载完成
- (void)playPreloadFinish:(BOOL)isSuccess desc:(NSString*)desc;
// 当前播放时间回调
- (void)currentMoviePlayTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime;
/* 当前预加载播放时间回调，NSArray<NSValue*>存储的是CMTimeRange(开始时间和时间长度)
   注意：获取到的时间是毫秒ms 其他默认都是秒s
 */
- (void)currentMoviePreloadPlayTime:(NSArray<NSValue*>*)preloadAry;
// 播放完成
- (void)moviePlayFinish:(NSDictionary*)errorDes;

@end

typedef void(^playPreloadFinish)(BOOL isSuccess, NSString *desc);
typedef void(^listenPlayTimeBlock)(NSTimeInterval currentTime, NSTimeInterval totalTime);
typedef void(^listenPreloadPlayTimeBlock)(NSArray<NSValue*> *preloadAry);
typedef void(^playFinishBlock)(NSDictionary *errorDes);


@interface SYPlayerMovieView : SYAVMovieView

@property (nonatomic, weak)id<SYPlayerMoviewViewDelegate>delegate;

// 播放地址
@property (nonatomic, strong)NSURL *movieUrl;

// 播放速度 默认 x1
@property (nonatomic, assign, setter=setPlayRate:)float playRate;
@property (nonatomic, assign)BOOL isPlaying;
// 视频时长 单位时间秒(s)
@property (nonatomic, assign, readonly)float totalTime;

//当前的播放时间 单位时间秒(s)
@property (nonatomic, assign, readonly)float currentTime;

@property (nonatomic, assign)float skipToTime;

/**
  监听播放时间回调，也可以用delegate模式
 */
@property (nonatomic, copy)listenPlayTimeBlock listenTimeBlock;

/**
 监听播放器load多长时间 回调，也可以用delegate模式
 */
@property (nonatomic, copy)listenPreloadPlayTimeBlock listenPreloadTimeBlock;
/**
 监听播放完成回调，也可以用delegate模式
 */
@property (nonatomic, copy)playFinishBlock playFinishBlock;


/**
 播放视频
 @param finishBlock 视频数据加载完成回调
 */
- (void)start:(playPreloadFinish)finishBlock;


/**
 播放
 */
- (void)play;

/**
 暂停
 */
- (void)pause;

/**
 播放下一个视频

 @param movieUrl 视频地址
 @param block 视频加载完成回调
 */
- (void)playerNextMovieWithUrl:(NSURL*)movieUrl loadFinish:(playPreloadFinish)block;


/**
 播放到执行时间

 @param seekTime 时间
 @param seekFinishBlock 加载完成回调
 */
- (void)seekToTime:(float)seekTime finish:(playPreloadFinish)seekFinishBlock;


@end
