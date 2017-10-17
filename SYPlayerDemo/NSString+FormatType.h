//
//  NSString+FormatType.h
//  ExamProject
//
//  Created by ksw on 2017/9/20.
//  Copyright © 2017年 SunYong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (FormatType)


- (NSString*)timeFormat;

/**
 是否为电话号码
 */
- (BOOL)isMobileNumber;


/**
 返回高度
 */
- (CGFloat)getHeightInViewWidth:(CGFloat)viewWidth font:(UIFont*)font;

/**
 返回宽度
 */
- (CGFloat)getWidthInViewWithFont:(UIFont*)font;
/*
 md5
 */

- (NSString*)md5WithExamPCondition:(NSString*)condition;


@end
