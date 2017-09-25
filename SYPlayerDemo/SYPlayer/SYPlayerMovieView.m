//
//  SYPlayerMoviewView.m
//  SYPlayerDemo
//
//  Created by ksw on 2017/9/16.
//  Copyright © 2017年 EOC. All rights reserved.
//

#define SYAssetProTracksTracks @"tracks"
#define SYAssetProTracksPlayable  @"playable"

#import "SYPlayerMovieView.h"
#import <AVFoundation/AVFoundation.h>
#import "NSObject+SYKVO.h"

@interface SYPlayerMovieView (){
    id _mTimeObserver;
}

@property (nonatomic, copy)playPreloadFinish preloadFinishBlock;
@property (nonatomic,strong) AVPlayerItem* mPlayerItem;
@property (nonatomic, strong)SYAVMovieView *syPlayerView;

@property (nonatomic, assign)float totalTime;
@property (nonatomic, assign)float currentTime;

@end

@implementation SYPlayerMovieView


- (void)start:(playPreloadFinish)finishBlock{
    
    if (!_movieUrl) {
        
        return;
    }
    _preloadFinishBlock = finishBlock;
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:_movieUrl] options:nil];
        weakSelf.totalTime = asset.duration.value / asset.duration.timescale;
        
        NSArray *loadProAry = [NSArray arrayWithObjects:SYAssetProTracksTracks, SYAssetProTracksPlayable, nil];
        
        [asset loadValuesAsynchronouslyForKeys:loadProAry completionHandler:^{
            
            [weakSelf prepareToPlayAsset:asset withKeys:loadProAry finishBlock:weakSelf.preloadFinishBlock];
            
        }];
        
    });
    
    
}

- (void)playerNextMovieWithUrl:(NSString*)movieUrl loadFinish:(playPreloadFinish)block{
    
    _movieUrl = movieUrl;
    _preloadFinishBlock = block;
    [self start:_preloadFinishBlock];
}

- (void)play{
    
    _isPlaying = YES;
    [self.player play];
    
}

- (void)pause{
    _isPlaying = NO;
    [self.player pause];
}

- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)loadProAry finishBlock:(playPreloadFinish)finishBlock{
    
    __weak typeof(self) weakSelf = self;
    
    if (!asset.playable){
    
        [weakSelf executeInMainQueue:finishBlock status:NO desc:@"AVKeyValueStasset no playableatusFailed"];
        return;
    }
    
    for (NSString *propertyS in loadProAry){
        
        AVKeyValueStatus keyStatus = [asset statusOfValueForKey:propertyS error:nil];
        if (keyStatus == AVKeyValueStatusFailed){
            
            [weakSelf removePlayerTimeObserver];
            [weakSelf executeInMainQueue:finishBlock status:NO desc:@"AVKeyValueStatusFailed"];
            return;
        }
    }
    
    
    if (self.mPlayerItem) {
        [self removePlayEndTimeNotificationWithPlayerItem:self.mPlayerItem];
    }
    
    //// 创建播放Item
    self.mPlayerItem = [AVPlayerItem playerItemWithAsset:asset];
    [self addStatusKVOWithPlayerItem:self.mPlayerItem finishiBlock:finishBlock];
    [self addLoadedTimeRangesKVOWithPlayerItem:self.mPlayerItem];
    
    [self addPlayEndTimeNotificationWithPlayerItem:self.mPlayerItem];
    
    //// layer设置 AVPlayer对象
    if (!self.player){
        
        self.player = [AVPlayer playerWithPlayerItem:self.mPlayerItem];
        [self addCurrentItemKVOWithAVPlayer:self.player finish:finishBlock];
    }
    
    // 切换视频内容
    if (self.player.currentItem != self.mPlayerItem){
        
        self.playRate = 1.0;
        self.currentTime = 0;
        [self.player replaceCurrentItemWithPlayerItem:self.mPlayerItem];
    }
    
}

- (void)seekToTime:(float)seekTime finish:(playPreloadFinish)seekFinishBlock{
    
    __weak typeof(self) weakSelf = self;
    [self.player seekToTime:CMTimeMakeWithSeconds(seekTime, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
        
        if (seekFinishBlock) {
            [weakSelf executeInMainQueue:seekFinishBlock status:finished desc:nil];
        }
    }];
    
}

- (void)setPlayRate:(float)playRate{
    
    _playRate = playRate;
    self.player.rate = playRate;
}

- (void)executeInMainQueue:(playPreloadFinish)block status:(BOOL)isSuccess desc:(NSString*)desc{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (block) {
            block(isSuccess, desc);
        }
        
    });
}


-(void)addMoviePlayTimeListen
{
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration)){
        return;
    }
    [self addPlayerTimeObserver];
}

#pragma mark - notification 处理

- (void)addPlayEndTimeNotificationWithPlayerItem:(AVPlayerItem*)playerItem{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:playerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemFailedToPlayToEndTimeErrorKey object:playerItem];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    NSDictionary *errorDict = nil;
    if (self.playFinishBlock) {
        if ([notification.name isEqualToString:@"AVPlayerItemFailedToPlayToEndTimeNotification"] || [notification.name isEqualToString:@"AVPlayerItemFailedToPlayToEndTimeErrorKey"]) {
            errorDict = notification.userInfo;
        }
        self.playFinishBlock(errorDict);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(moviePlayFinish:)]) {
        
        if ([notification.name isEqualToString:@"AVPlayerItemFailedToPlayToEndTimeNotification"] || [notification.name isEqualToString:@"AVPlayerItemFailedToPlayToEndTimeErrorKey"]) {
            errorDict = notification.userInfo;
        }
        [self.delegate moviePlayFinish:errorDict];
    }
    [self pause];
}

- (void)removePlayEndTimeNotificationWithPlayerItem:(AVPlayerItem*)playerItem{
    
    [[NSNotificationCenter defaultCenter] removeObserver:playerItem name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:playerItem name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:playerItem name:AVPlayerItemFailedToPlayToEndTimeErrorKey object:nil];
}

#pragma mark - KVO 播放器属性监听处理

- (void)addStatusKVOWithPlayerItem:(AVPlayerItem*)playerItem finishiBlock:(playPreloadFinish)finishBlock{
    __weak typeof(self) weakSelf = self;
    __weak AVPlayerItem *tmpPlayerItem = playerItem;
    [playerItem addObserverSuny:self keyPath:@"status" options:SYKVOOptionInitAndNew block:^(id newValue) {
        
        AVPlayerStatus status = [newValue integerValue];
        if(status == AVPlayerStatusReadyToPlay){
            
            [weakSelf addMoviePlayTimeListen];
            [weakSelf play];
            
            
        }else if(status == AVPlayerStatusFailed){
            
            NSLog(@"AVPlayerStatusFailed");
            [weakSelf removePlayerTimeObserver];
            [weakSelf executeInMainQueue:finishBlock status:NO desc:[NSString stringWithFormat:@"AVPlayerStatusFailed:%@", tmpPlayerItem.error]];
            
        }else{
            NSLog(@"AVPlayerStatusUnknown");
            //[weakSelf executeInMainQueue:finishBlock status:NO desc:@"AVPlayerStatusUnknown"];
            
        }
    }];
}

- (void)addLoadedTimeRangesKVOWithPlayerItem:(AVPlayerItem*)playerItem{
    
    __weak typeof(self) weakSelf = self;
    [playerItem addObserverSuny:self keyPath:@"loadedTimeRanges" options:SYKVOOptionInitAndNew block:^(id newValue) {
        
        NSArray<NSValue*> *loadedTimeRanges = [[weakSelf.player currentItem] loadedTimeRanges];

       // CMTimeRange timeRange = [[loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
        if (weakSelf.delegate && [weakSelf respondsToSelector:@selector(currentMoviePreloadPlayTime:)]) {
            [weakSelf.delegate currentMoviePreloadPlayTime:loadedTimeRanges];
        }
        if (weakSelf.listenPreloadTimeBlock) {
            weakSelf.listenPreloadTimeBlock(loadedTimeRanges);
        }
    }];
 
}

- (void)addCurrentItemKVOWithAVPlayer:(AVPlayer*)player finish:(playPreloadFinish)finishBlock{
    
    __weak typeof(self) weakSelf = self;
    [player addObserverSuny:self keyPath:@"currentItem" options:SYKVOOptionInitAndNew block:^(id newValue) {
        
        AVPlayerItem *newPlayerItem = newValue;
        
        if (newPlayerItem && ![newPlayerItem isEqual:[NSNull null]]) {
            
            [weakSelf setVideoFillMode:AVLayerVideoGravityResizeAspect];
            [weakSelf executeInMainQueue:weakSelf.preloadFinishBlock status:YES desc:@""];
            
        }else{
            
            [weakSelf executeInMainQueue:finishBlock status:NO desc:@"currentItem error"];
        }
        
    }];
    
}



- (void)addPlayerTimeObserver{
    
    __weak typeof(self) weakSelf = self;
    double interval = .1f;
  
    _mTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)
                                                               queue:NULL
                                                          usingBlock:^(CMTime time)
                      {
                          [weakSelf getCurrentPlayTime];
                      }];
}

-(void)removePlayerTimeObserver
{
    if (_mTimeObserver)
    {
        [self pause];
        [self.player removeTimeObserver:_mTimeObserver];
        _mTimeObserver = nil;
    }
}


#pragma mark - 时间处理

- (void)getCurrentPlayTime
{
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration)){
        
        self.currentTime = 0.0;
    }else{
    
        CMTime currentTime = self.player.currentItem.currentTime;
        CGFloat currentPlayTime = (CGFloat)currentTime.value/currentTime.timescale;
       // double duration = CMTimeGetSeconds(playerDuration);
        self.currentTime = currentPlayTime;
    }
    
    if (self.listenTimeBlock) {
        
        if ([[NSThread currentThread] isMainThread]) {
            self.listenTimeBlock(self.currentTime, self.totalTime);
        }else{
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.listenTimeBlock(weakSelf.currentTime, weakSelf.totalTime);
            });
        }
    }
    if (self.delegate) {
        
        if ([self.delegate respondsToSelector:@selector(currentMoviePlayTime:totalTime:)]) {
            [self.delegate currentMoviePlayTime:self.currentTime totalTime:self.totalTime];
        }
    }
    
 //   NSLog(@"%f, %f, %f, %f", self.currentTime, self.totalTime, duration, self.boundaryTime);
}

- (CMTime)playerItemDuration
{
    AVPlayerItem *playerItem = [self.player currentItem];
    if (playerItem.status == AVPlayerItemStatusReadyToPlay){
        
        return([playerItem duration]);
    }
    
    return(kCMTimeInvalid);
}

- (void)dealloc{
    
    if (self.mPlayerItem) {
        [self removePlayEndTimeNotificationWithPlayerItem:self.mPlayerItem];
    }
}


@end
