//
//  SampleHandler.m
//  RepalyKitForObjcSampleUploadExtension
//
//  Created by jun shima on 2020/09/02.
//  Copyright © 2020 jun shima. All rights reserved.
//


#import "SampleHandler.h"


@interface SampleHandler () {
    AppGroupsManager *_appGroupsManager;
}

@end

@implementation SampleHandler

- (void)broadcastStartedWithSetupInfo:(NSDictionary<NSString *,NSObject *> *)setupInfo {
    // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
    _appGroupsManager = [[AppGroupsManager alloc] init];

    switch (_appGroupsManager.canBroadcast) {
        case AppStateNotReady: {
            [self canBroadcast:AppStateNotReady];
            return;
        }
        case AppStateCanBroadcast:
            break;
    }

    _appGroupsManager.delegate = self;
    _appGroupsManager.state = BroadcastStateStart;
}

- (void)broadcastPaused {
    // User has requested to pause the broadcast. Samples will stop being delivered.
    _appGroupsManager.state = BroadcastStatePaused;
}

- (void)broadcastResumed {
    // User has requested to resume the broadcast. Samples delivery will resume.
    _appGroupsManager.state = BroadcastStateResumed;
}

- (void)broadcastFinished {
    // User has requested to finish the broadcast.
    _appGroupsManager.state = BroadcastStateFinish;
}

- (void)finishBroadcastWithError:(NSError *)error {
    [super finishBroadcastWithError:error];
}

- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType {
    switch (sampleBufferType) {
        case RPSampleBufferTypeVideo: {
            // Handle video sample buffer
            _appGroupsManager.videoSampleBuffer = sampleBuffer;
            break;
        }
        case RPSampleBufferTypeAudioApp:
            // Handle audio sample buffer for app audio
            break;
        case RPSampleBufferTypeAudioMic:
            // Handle audio sample buffer for mic audio
            break;
            
        default:
            break;
    }
}

#pragma mark - AppGroupsManager

- (void)canBroadcast:(AppState)can {
    NSLog(@"%s: %ld", __FUNCTION__, can);
    NSDictionary *info = @{NSLocalizedFailureReasonErrorKey: @"停止します"};
    [self finishBroadcastWithError:[NSError errorWithDomain:@"BroadcastSample" code:-1 userInfo:info]];
}

@end
