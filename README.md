# SYPlayerDemo
视频播放器

SYPlayer使用方式：
playerMovieView = [SYPlayerMovieView new]初始化
playerMovieView.movieUrl = @"" 配置播放地址
[playerMovieView start:];  开始播放

就这么简单。

对播放器状态处理，提供了两种方式 block和代理SYPlayerMoviewViewDelegate
或者需要更多的，就监听该对象相关的属性

playerMovieView内部负责数据处理，和AVPlayer的渲染。

具体使用方式，看demo


