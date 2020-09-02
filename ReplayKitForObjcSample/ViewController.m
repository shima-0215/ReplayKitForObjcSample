//
//  ViewController.m
//  ReplayKitForObjcSample
//
//  Created by jun shima on 2020/09/02.
//  Copyright © 2020 jun shima. All rights reserved.
//

#import "ViewController.h"
#import <ReplayKit/ReplayKit.h>

static NSString *const kExtensionBundleID = @"com.jun shima.ReplayKitForObjcSample.RepalyKitForObjcSampleUploadExtension";

@interface ViewController ()

@property (nonatomic, assign) IBOutlet UIView *viewForBroadcastPicker;

@property (nonatomic, retain) AppGroupsManager *appGroupsManager;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAppGroups];
    [self setupBroadcastPickerView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setupAppGroups {
    _appGroupsManager = [[AppGroupsManager alloc] init];
    _appGroupsManager.delegate = self;
    _appGroupsManager.canBroadcast = AppStateCanBroadcast;
}

- (void)setupBroadcastPickerView {
    if (@available(iOS 12.0, *)) {
        RPSystemBroadcastPickerView *boradcastPickerView = [[RPSystemBroadcastPickerView alloc] initWithFrame:_viewForBroadcastPicker.bounds];
        boradcastPickerView.preferredExtension = kExtensionBundleID;
        boradcastPickerView.showsMicrophoneButton = YES;
        boradcastPickerView.backgroundColor = UIColor.clearColor;
        
        [_viewForBroadcastPicker addSubview:boradcastPickerView];
    }
}

- (IBAction)stopPressed:(id)sender {
    _appGroupsManager.canBroadcast = AppStateNotReady;
}


#pragma mark - AppGroupsManagerDelegate

- (void)changeState:(BroadcastState)state {
    NSLog(@"%s: %ld", __FUNCTION__, state);
}

- (void)sampleBufferType:(RPSampleBufferType)type {
    NSLog(@"%s: %ld", __FUNCTION__, type);
}

- (void)videoSampleBuffer:(NSData*)data {
    NSLog(@"%s:", __FUNCTION__);
}

@end
