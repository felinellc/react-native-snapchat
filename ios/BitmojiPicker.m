//
//  BitmojiPicker.m
//  RNSnapSDK
//
//  Created by Sam Gehly on 2/22/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTUIManager.h>
#import "react_native_snapchat-Swift.h"
#import "BitmojiPicker.h"

@implementation BitmojiPickerManager

RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(config, NSDictionary *)
RCT_EXPORT_VIEW_PROPERTY(onBitmojiSelected, RCTBubblingEventBlock);


- (UIView *)view {
    BitmojiPickerView *view = [BitmojiPickerView new];
    return view;
}

@end
