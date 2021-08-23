//
//  AudioPlayer.h
//  iOSAVDemo
//
//  Created by bytedance on 2021/8/7.
//

#import <Foundation/Foundation.h>

@protocol AudioPlayer

@required

- (void) play: (NSString*) path sampleRate:(NSInteger) sampleRate channels:(NSInteger) channels;

- (void) stop;

@optional

- (void) seek;

@end
