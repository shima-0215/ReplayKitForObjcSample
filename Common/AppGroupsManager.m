//
//  AppGroupsManager.m
//  ReplayKitForObjcSample
//
//  Created by jun shima on 2020/09/02.
//  Copyright © 2020 jun shima. All rights reserved.
//

#import "AppGroupsManager.h"

static NSString *const kGroupID = @"group.com.jun shima.ReplayKitForObjcSample";
static NSString *const kState = @"state";
static NSString *const kSampleBufferType = @"sampleBufferType";
static NSString *const kSampleBuffer = @"sampleBuffer";
static NSString *const kCanBroadcast = @"canBroadcast";

@interface AppGroupsManager () {
    NSUserDefaults *userDefaults;
    int count;
}

@end


@implementation AppGroupsManager

- (id)init {
    if (self = [super init]) {
        [self setup];
        count = 0;
    }
    return self;
}

- (void)setup {
    userDefaults = [[NSUserDefaults alloc] initWithSuiteName:kGroupID];
    
    [userDefaults addObserver:self forKeyPath:kState options:NSKeyValueObservingOptionNew context:nil];
    [userDefaults addObserver:self forKeyPath:kSampleBufferType options:NSKeyValueObservingOptionNew context:nil];
    [userDefaults addObserver:self forKeyPath:kSampleBuffer options:NSKeyValueObservingOptionNew context:nil];
    [userDefaults addObserver:self forKeyPath:kCanBroadcast options:NSKeyValueObservingOptionNew context:nil];
}

- (void)tearDown {
    [userDefaults removeObserver:self forKeyPath:kState];
    [userDefaults removeObserver:self forKeyPath:kSampleBufferType];
    [userDefaults removeObserver:self forKeyPath:kSampleBuffer];
    [userDefaults removeObserver:self forKeyPath:kCanBroadcast];
    
    [userDefaults removeObjectForKey:kState];
    [userDefaults removeObjectForKey:kSampleBufferType];
    [userDefaults removeObjectForKey:kSampleBuffer];
    [userDefaults removeObjectForKey:kCanBroadcast];
}

- (void)dealloc {
    [self tearDown];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kState]) {
        if ([_delegate respondsToSelector:@selector(changeState:)]) {
            BroadcastState value = (BroadcastState)[change[NSKeyValueChangeNewKey] integerValue];
            [_delegate changeState:value];
        }
        
    } else if ([keyPath isEqualToString:kSampleBufferType]) {
        if ([_delegate respondsToSelector:@selector(sampleBufferType:)]) {
            RPSampleBufferType value = (RPSampleBufferType)[change[NSKeyValueChangeNewKey] integerValue];
            [_delegate sampleBufferType:value];
        }
        
    } else if ([keyPath isEqualToString:kSampleBuffer]) {
        if ([_delegate respondsToSelector:@selector(videoSampleBuffer:)]) {
            NSData *value = [userDefaults dataForKey:kSampleBuffer];
            [_delegate videoSampleBuffer:value];
        }
        
    } else if ([keyPath isEqualToString:kCanBroadcast]) {
        if ([_delegate respondsToSelector:@selector(canBroadcast:)]) {
            AppState value = (AppState)[change[NSKeyValueChangeNewKey] integerValue];
            [_delegate canBroadcast:value];
        }
    }
}

#pragma mark - State

- (void)setState:(BroadcastState)state {
    [userDefaults setInteger:state forKey:kState];
}

#pragma mark - RPSampleBufferType

- (void)setSampleBufferType:(RPSampleBufferType)sampleBufferType {
    [userDefaults setInteger:sampleBufferType forKey:kSampleBufferType];
}

#pragma mark - CMSampleBufferRef

- (void)setVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    NSData *data = [NSData dataWithBytes:sampleBuffer length:sizeof(sampleBuffer)];
    [userDefaults setObject:data forKey:kSampleBuffer];
}

- (NSData*)samleBufferToNSData:(CMSampleBufferRef)sampleBuffer {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    void *src_buff = CVPixelBufferGetBaseAddress(imageBuffer);

    NSData *data = [NSData dataWithBytes:src_buff length:bytesPerRow * height];
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    return data;
}

- (NSData*)sampleBufferToNSData2:(CMSampleBufferRef)sampleBuffer {
    CMBlockBufferRef buff = CMSampleBufferGetDataBuffer(sampleBuffer);
    size_t len = CMBlockBufferGetDataLength(buff);
    char * data = NULL;
    CMBlockBufferGetDataPointer(buff, 0, NULL, &len, &data);
    NSData * d = [[NSData alloc] initWithBytes:data length:len];
    return d;
}

- (UIImage*)samleBufferToUIImage:(CMSampleBufferRef)sampleBuffer {
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *ciimage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    UIImage *image = [UIImage imageWithCIImage:ciimage];
    return image;
}

#pragma mark - canBroadcast

- (void)setCanBroadcast:(AppState)canBroadcast {
    [userDefaults setInteger:canBroadcast forKey:kCanBroadcast];
}

- (AppState)canBroadcast {
    AppState value = (AppState)[userDefaults integerForKey:kCanBroadcast];
    return value;
}

@end
