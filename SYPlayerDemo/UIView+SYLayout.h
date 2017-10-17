//
//  UIView+EOCLayout.h
//  WeiXinFriendCircle
//
//  Created by EOC on 2017/5/8.
//  Copyright © 2017年 @八点钟学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EOCLayout)

@property (nonatomic, assign)CGRect portraitStyleFrame;

@property (nonatomic, assign)CGRect landscapeStyleFrame;


- (CGFloat)height;
- (CGFloat)width;
- (CGFloat)x;
- (CGFloat)y;
- (CGSize)size;
- (CGPoint)origin;
- (CGFloat)centerX;
- (CGFloat)centerY;


- (CGFloat)left;
- (CGFloat)top;
- (CGFloat)bottom;
- (CGFloat)right;

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setLeft:(CGFloat)left;
- (void)setRight:(CGFloat)right;
- (void)setTop:(CGFloat)top;
- (void)setBottom:(CGFloat)bottom;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setCenterX:(CGFloat)centerX;
- (void)setCenterY:(CGFloat)centerY;
- (void)setSize:(CGSize)size;

- (void)equalToView:(UIView*)view;
- (void)equalToSuperView:(UIView*)view;
- (void)equalSizeToView:(UIView*)view;
- (void)equalLeftToView:(UIView *)view;
- (void)equalTopToView:(UIView *)view;

- (void)bottomEqualSuperViewBottom;
- (void)setBottomToSuperBotttomGap:(CGFloat)Gap;


- (void)bottomEqualToTopOfView:(UIView*)targetView;

@end
