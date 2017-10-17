//
//  NSDictionary+Sort.m
//  ExamProject
//
//  Created by ksw on 2017/9/28.
//  Copyright © 2017年 SunYong. All rights reserved.
//

#import "NSDictionary+Sort.h"
#import "NSString+FormatType.h"

@implementation NSDictionary (Sort)

- (NSArray*)allKeysWithAscendingSort{
    
    NSMutableArray *keyAry = [[self allKeys] mutableCopy];
    // 安全判断
    for (NSInteger i = 0; i < keyAry.count; i++) {
        if ([keyAry[i] length] == 0) {
            return nil;
        }
    }
    
    // 排序
    for (NSInteger i = 0; i < keyAry.count; i++) {
        
        NSString *keyA = keyAry[i];
        char compareA = [keyA cStringUsingEncoding:NSUTF8StringEncoding][0];
        for (NSInteger j = i+1; j < keyAry.count; j++) {
            
            NSString *keyB = keyAry[j];
            char compareB = [keyB cStringUsingEncoding:NSUTF8StringEncoding][0];
            if (compareB < compareA) {
                compareA = compareB;
                [keyAry exchangeObjectAtIndex:i withObjectAtIndex:j];
                keyA = keyB;
                
            }else if(compareB == compareA){
                
                NSInteger minKeyLenght = (keyA.length > keyB.length)?keyB.length:keyA.length;
                BOOL isExchange = NO;
                for(NSInteger k = 1; k < minKeyLenght; k++){
                    char compareSubB = [keyB cStringUsingEncoding:NSUTF8StringEncoding][k];
                    char compareSubA = [keyA cStringUsingEncoding:NSUTF8StringEncoding][k];
                    if(compareSubB < compareSubA){
                        [keyAry exchangeObjectAtIndex:i withObjectAtIndex:j];
                        keyA = keyB;
                        isExchange = YES;
                    }else if(compareSubB > compareSubA){
                        isExchange = YES;
                        break;
                    }else{
                        
                    }
                }
                // 前面都一样，短的放前面（如keyOneE,keyOne）
                if(!isExchange){
                    if(keyB.length < keyA.length){
                        [keyAry exchangeObjectAtIndex:i withObjectAtIndex:j];
                        keyA = keyB;
                    }
                }
            }else{
                
            }
        }
    }
    return keyAry;
}


- (NSString *)jointKeyAndValueByAscendKey{
 
    NSArray *keySortAry = [self allKeysWithAscendingSort];
    
    if (keySortAry.count == 0) {
        return nil;
    }
    
    NSMutableString *backStr = [NSMutableString string];
    [backStr appendFormat:@"%@=%@", keySortAry[0], self[keySortAry[0]]];
    for (NSInteger i = 1; i < keySortAry.count; i++) {
        [backStr appendFormat:@"&%@=%@", keySortAry[i], self[keySortAry[i]]];
    }
    
    return backStr;
}

- (NSString*)md5WithCondition:(NSString*)condition{
    
    NSString *sortKeyJoint = [self jointKeyAndValueByAscendKey];
    return [sortKeyJoint md5WithExamPCondition:condition];
}

@end
