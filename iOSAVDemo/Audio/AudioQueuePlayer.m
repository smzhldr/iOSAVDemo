//
//  AudioQueuePlayer.m
//  iOSAVDemo
//
//  Created by bytedance on 2021/8/9.
//

#import "AudioQueuePlayer.h"
#import <AudioToolbox/AudioToolbox.h>

#define QUEUE_BUFFER_SIZE 5
#define MIN_SIZE_PER_FRAME 1024
#define EVERY_READ_LENGTH 1024

@implementation AudioQueuePlayer {
    AudioStreamBasicDescription audioDescription;
    AudioQueueRef audioQueue;
    AudioQueueBufferRef audioQueueBuffer[QUEUE_BUFFER_SIZE];
    NSLock *syncLock;
    Byte *pcmDataBuffer;
    NSInputStream *inputStream;
}

void AudioPlayerAQInputCallback(void *input, AudioQueueRef outQ, AudioQueueBufferRef outQb) {
    AudioQueuePlayer *player = (__bridge AudioQueuePlayer *)input;
    [player readPcm:outQ buffer:outQb];
}

- (void) readPcm:(AudioQueueRef)outQ buffer:(AudioQueueBufferRef)outQB {
    [syncLock lock];
    size_t readLen = [inputStream read:pcmDataBuffer maxLength:EVERY_READ_LENGTH];
    if (readLen == 0) {
        NSLog(@"文件已经读完 \n");
        return;
    }
    outQB->mAudioDataByteSize = (UInt32)readLen;
    memcpy(outQB->mAudioData, pcmDataBuffer, readLen);
    AudioQueueEnqueueBuffer(outQ, outQB, 0, NULL);
    [syncLock unlock];
}

- (instancetype)initWithValue:(NSInteger)sampleRate channels:(NSInteger)channels bitDepth:(NSInteger)bitDepth {
    audioDescription.mSampleRate = sampleRate;
    audioDescription.mFormatID = kAudioFormatLinearPCM;
    audioDescription.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    audioDescription.mChannelsPerFrame = (int)channels;
    audioDescription.mFramesPerPacket = 1;
    audioDescription.mBitsPerChannel = (int)bitDepth;
    audioDescription.mBytesPerFrame = audioDescription.mBitsPerChannel / 8 * audioDescription.mChannelsPerFrame;
    audioDescription.mBytesPerPacket = audioDescription.mBytesPerFrame;
    AudioQueueNewOutput(&audioDescription, AudioPlayerAQInputCallback, (__bridge void * _Nullable)(self), nil, nil, 0, &audioQueue);
    for (int i = 0; i < QUEUE_BUFFER_SIZE; ++i) {
        int result =  AudioQueueAllocateBuffer(audioQueue, MIN_SIZE_PER_FRAME, &audioQueueBuffer[i]);
        NSLog(@"AudioQueueAllocateBuffer i = %d,result = %d", i, result);
    }
    pcmDataBuffer = malloc(EVERY_READ_LENGTH);
    syncLock = [[NSLock alloc] init];
    return self;
}


- (void)start:(NSString *)path {
    inputStream = [[NSInputStream alloc] initWithFileAtPath:path];
    [inputStream open];
    AudioQueueStart(audioQueue, NULL);
    for(int i=0;i<QUEUE_BUFFER_SIZE;i++) {
        [self readPcm:audioQueue buffer:audioQueueBuffer[i]];
    }
}

- (void)stop {
    AudioQueueStop(audioQueue, true);
    [syncLock lock];
    [inputStream close];
    [syncLock unlock];
}

- (void)dealloc
{
    AudioQueueDispose(audioQueue, true);
    free(pcmDataBuffer);
}

@end
