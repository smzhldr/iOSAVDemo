//
//  AudioPlayer.h
//  iOSAVDemo
//
//  Created by bytedance on 2021/8/7.
//

#import <Foundation/Foundation.h>

@protocol AudioPlayer

@required

- (instancetype) initWithValue:(NSInteger) sampleRate channels:(NSInteger) channels bitDepth:(NSInteger) bitDepth;

- (void) start: (NSString*) path;

- (void) stop;

@optional

- (void) seek;

@end
