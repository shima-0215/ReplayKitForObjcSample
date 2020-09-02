//
//  AppGroupsManager.h
//  ReplayKitForObjcSample
//
//  Created by jun shima on 2020/09/02.
//  Copyright © 2020 jun shima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReplayKit/ReplayKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BroadcastState) {
    BroadcastStateStart,
    BroadcastStatePaused,
    BroadcastStateResumed,
    BroadcastStateFinish
};

typedef NS_ENUM(NSInteger, AppState) {
    AppStateNotReady,
    AppStateCanBroadcast
};

@protocol AppGroupsManagerDelegate <NSObject>

@optional

// Broadcast Extension -> ContainingApp
- (void)changeState:(BroadcastState)state;
- (void)sampleBufferType:(RPSampleBufferType)type;
- (void)videoSampleBuffer:(NSData*)data;

// ContainingApp -> Broadcast Extension
- (void)canBroadcast:(AppState)can;

@end

@interface AppGroupsManager : NSObject

@property (nonatomic, assign) id<AppGroupsManagerDelegate> delegate;

// Broadcast Extension -> ContainingApp
@property (nonatomic, assign) BroadcastState state;
@property (nonatomic, assign) RPSampleBufferType sampleBufferType;
@property (nonatomic, assign) CMSampleBufferRef videoSampleBuffer;

// ContainingApp -> Broadcast Extension
@property (nonatomic, assign) AppState canBroadcast;

@end

NS_ASSUME_NONNULL_END
