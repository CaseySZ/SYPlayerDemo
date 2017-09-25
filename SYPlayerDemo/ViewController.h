//
//  ViewController.h
//  SYPlayerDemo
//
//  Created by ksw on 2017/9/14.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    
    
    IBOutlet UISlider *_slider;
    
    IBOutlet UILabel *timeLabel;
}

@property (nonatomic, strong)NSString *test;

- (IBAction)nextEvent:(id)sender;
- (IBAction)rateEvent:(id)sender;
- (IBAction)stopEvent:(id)sender;
- (IBAction)seekEvent:(id)sender;


@end

