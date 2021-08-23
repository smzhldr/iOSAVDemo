//
//  ViewController.m
//  iOSAVDemo
//
//  Created by bytedance on 2021/8/7.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"stereo_48000_16bit" ofType:@"pcm"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSLog(@"pcm file exist \n");
    } else {
        NSLog(@"pcm file not exist \n");
    }
}


@end
