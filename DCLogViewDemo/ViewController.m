//
//  ViewController.m
//  HTClassLogViewDemo
//
//  Created by DarielChen on 16/12/30.
//  Copyright © 2016年 DarielChen. All rights reserved.
//

#import "ViewController.h"
#import "HTClassLog.h"
#import "HTClassLogView.h"

#if DEBUG
#define DLog(FORMAT, ...)  NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(FORMAT), ##__VA_ARGS__] );
#else
#define DLog(FORMAT, ...) nil
#endif


@interface ViewController ()

@property (nonatomic, strong) HTClassLogView *logView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(giveLog) userInfo:nil repeats:YES];
    
}


- (void)giveLog {
    
    DLog(@"NSTimer");
}



- (IBAction)crashButtonClick:(id)sender {
    
    NSAssert(0, @"The crash reason");
}


- (IBAction)logButtonClick:(id)sender {
    
    DLog(@"logButtonClick");
}

@end
