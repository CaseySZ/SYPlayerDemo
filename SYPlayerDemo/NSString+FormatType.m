//
//  NSString+FormatType.m
//  ExamProject
//
//  Created by ksw on 2017/9/20.
//  Copyright © 2017年 SunYong. All rights reserved.
//


#import <CoreText/CoreText.h>
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>
#import "NSString+FormatType.h"

@implementation NSString (FormatType)


- (BOOL)isMobileNumber{
    
    NSString * MOBILE = @"^1(3[0-9]|4[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|7[8]|8[2378])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|4[578]|7[0-9]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[0-9])[0-9]|349)\\d{7}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


- (NSString*)timeFormat{
    
    int seconds = [self intValue];
    
    if (seconds > 3600) {
        
        int hour = seconds/3600;
        int mini = (seconds%3600)/60;
        int sec  = seconds%60;
        return  [NSString stringWithFormat:@"%02d小时%02d分%02d秒", hour, mini,sec];
        
    }else{
        int mini = seconds/60;
        int sec  = seconds%60;
        if (sec > 0) {
            return  [NSString stringWithFormat:@"%02d分%02d秒", mini, sec];
        }else{
            return  [NSString stringWithFormat:@"%02d分钟", mini];
        }
        
    }
}

- (CGFloat)getHeightInViewWidth:(CGFloat)viewWidth font:(UIFont*)font
{
    if (!self || self.length == 0)
        return 0;
    
    NSMutableAttributedString *textS = [[NSMutableAttributedString alloc] initWithString:self];
    CTFontRef helveticaBold = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, nil);
    [textS addAttribute:(id)kCTFontAttributeName value:(__bridge id)helveticaBold range:NSMakeRange(0, self.length)];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)textS);
    
    CGSize result = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [textS length]), NULL, CGSizeMake(viewWidth, 700), NULL);
    
    return result.height + 5;
}

- (CGFloat)getWidthInViewWithFont:(UIFont*)font {
    if (!self || self.length == 0)
        return 0;
    
    NSMutableAttributedString *textS = [[NSMutableAttributedString alloc] initWithString:self];
    CTFontRef helveticaBold = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, nil);
    [textS addAttribute:(id)kCTFontAttributeName value:(__bridge id)helveticaBold range:NSMakeRange(0, self.length)];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)textS);
    
    CGSize result = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [textS length]), NULL, CGSizeMake(400, 40), NULL);
    
    return result.width;
}

- (NSString*)md5WithExamPCondition:(NSString*)condition{
    
    if(self.length == 0){
        return nil;
    }
    
    NSMutableString *str = [self mutableCopy];
    if (condition.length > 0) {
        [str appendFormat:@"&%@", condition];
    }
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (unsigned int)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
    
}


@end
