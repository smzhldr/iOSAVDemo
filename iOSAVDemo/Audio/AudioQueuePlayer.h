//
//  AudioQueuePlayer.h
//  iOSAVDemo
//
//  Created by bytedance on 2021/8/9.
//

#import <Foundation/Foundation.h>
#import "AudioPlayer.h"


@interface  AudioQueuePlayer : NSObject<AudioPlayer>

- (instancetype) initWithValue:(NSInteger) sampleRate channels:(NSInteger) channels bitDepth:(NSInteger) bitDepth;

- (void) start:(NSString *)path;

- (void) stop;

@end

