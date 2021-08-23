//
//  AudioQueuePlayer.m
//  iOSAVDemo
//
//  Created by bytedance on 2021/8/9.
//

#import "AudioQueuePlayer.h"
#import <AudioToolbox/AudioToolbox.h>

#define QUEUE_BUFFER_SIZE 5
#define MIN_SIZE_PER_FRAME 512

@implementation AudioQueuePlayer {
    AudioStreamBasicDescription audioDescription;
    AudioQueueRef audioQueue;
    AudioQueueBufferRef audioQueueBuffer[QUEUE_BUFFER_SIZE];
    NSLock *syncLock;
    Byte *pcmDataBuffer;
    NSInputStream *inputStream;
}

void AudioPlayerAQInputCallback(void *input, AudioQueueRef outQ, AudioQueueBufferRef outQb) {
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        audioDescription.mSampleRate = 48000;
        audioDescription.mFormatID = kAudioFormatLinearPCM;
        audioDescription.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
        audioDescription.mChannelsPerFrame = 2;
        audioDescription.mFramesPerPacket = 1;
        audioDescription.mBitsPerChannel = 16;
        audioDescription.mBytesPerFrame = audioDescription.mBitsPerChannel / 8 * audioDescription.mChannelsPerFrame;
        audioDescription.mBytesPerPacket = audioDescription.mBytesPerFrame;
        AudioQueueNewOutput(&audioDescription, AudioPlayerAQInputCallback, (__bridge void * _Nullable)(self), nil, nil, 0, &audioQueue);
        for (int i = 0; i < QUEUE_BUFFER_SIZE; ++i) {
            int result =  AudioQueueAllocateBuffer(audioQueue, MIN_SIZE_PER_FRAME, &audioQueueBuffer[i]);
            NSLog(@"AudioQueueAllocateBuffer i = %d,result = %d", i, result);
        }
    }
    return self;
}


- (void)play:(NSString *)path sampleRate:(NSInteger)sampleRate channels:(NSInteger)channels {
    
}

- (void)stop {
    
}

@end
