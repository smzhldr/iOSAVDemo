//
//  ViewController.m
//  iOSAVDemo
//
//  Created by bytedance on 2021/8/7.
//

#import "ViewController.h"
#import "Audio/AudioQueuePlayer.h"

@implementation ViewController {
    AudioQueuePlayer *audioPlayer;
    bool isPlaying;
    NSString *path;
}

- (void)onHomeBtnClick {
    NSLog(@"Home button clicked \n");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    audioPlayer = [[AudioQueuePlayer alloc] initWithValue:48000 channels:2 bitDepth:16];
    isPlaying = false;
    
    path = [[NSBundle mainBundle] pathForResource:@"stereo_48000_16bit" ofType:@"pcm"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSLog(@"pcm file exist \n");
    } else {
        NSLog(@"pcm file not exist \n");
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onHomeBtnClick) name:@"background" object:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (IBAction)onCenterButtonClicked:(id)sender {
    isPlaying = !isPlaying;
    if (isPlaying) {
        [[self centerButton] setTitle:@"停止" forState:UIControlStateNormal];
        if (path != nil) {
            [audioPlayer start:path];
        } else {
            NSLog(@"file %@ not exit", path);
        }
    } else {
        [[self centerButton] setTitle:@"开始" forState:UIControlStateNormal];
        [audioPlayer stop];
    }
}
@end
