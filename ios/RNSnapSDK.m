
#import "RNSnapSDK.h"
#import <SCSDKLoginKit/SCSDKLoginKit.h>
#import <SCSDKCreativeKit/SCSDKCreativeKit.h>

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <React/RCTLog.h>

@implementation RNSnapSDK

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

RCT_EXPORT_MODULE()


RCT_EXPORT_METHOD(login)
{
    
    [SCSDKLoginClient loginFromViewController:[UIApplication sharedApplication].delegate.window.rootViewController completion:^(BOOL success, NSError * _Nullable error) {
    }];
}

RCT_EXPORT_METHOD(logout: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [SCSDKLoginClient unlinkCurrentSessionWithCompletion:^(BOOL success) {
        resolve();
    }];
}

RCT_EXPORT_METHOD(getUserData: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    
    NSString *graphQLQuery = @"{me{externalId, displayName, bitmoji{avatar}}}";
    
    NSDictionary *variables = @{@"page": @"bitmoji"};
    
    [SCSDKLoginClient fetchUserDataWithQuery:graphQLQuery
        variables:variables
        success:^(NSDictionary *resources) {
            NSDictionary *data = resources[@"data"];
            NSDictionary *me = data[@"me"];
            NSString *displayName = me[@"displayName"];
            NSDictionary *bitmoji = me[@"bitmoji"];
            NSString *bitmojiAvatarUrl = bitmoji[@"avatar"];
            
            resolve(data);
        } failure:^(NSError * error, BOOL isUserLoggedOut) {
            reject(@"error", @"ERROR", error);
        }];
}


RCT_EXPORT_METHOD(authenticateDeepLink: (NSString *)url)
{
    NSURL *finalUrl = [NSURL URLWithString:url];
    [SCSDKLoginClient application:[UIApplication sharedApplication] openURL:finalUrl options:[NSMutableDictionary dictionary]];
}

RCT_EXPORT_METHOD(shareSticker:(NSString *)image options:(NSDictionary *)options)
{
    SCSDKSnapSticker *source = NULL;
    
    RCTLogInfo(@"[RNSnapSDK] Generating Sticker...");
    
    if([image rangeOfString:@"data:image"].location == 0){
        RCTLogInfo(@"[RNSnapSDK] Using Base64 Image...");
        
        NSArray *array = [image componentsSeparatedByString:@","];
        
        UIImage *imageFinal = [self decodeBase64ToImage:array[1]];
        source = [[SCSDKSnapSticker alloc] initWithStickerImage:imageFinal];
    }else if([image rangeOfString:@"http"].location == 0){
        RCTLogInfo(@"[RNSnapSDK] Using HTTP Image...");
        source = [[SCSDKSnapSticker alloc] initWithStickerUrl:[[NSURL alloc] initWithString:image] isAnimated:true];
    }
    else{
        RCTLogError(@"[RNSnapSDK] shareSticker only supports URLs and Base64 Data URIs");
        return;
    }
    
    if([options objectForKey:@"width"] != nil){
        CGFloat width = [[options objectForKey:@"width"] floatValue];
        [source setWidth:width];
    }
    
    if([options objectForKey:@"height"] != nil){
        CGFloat height = [[options objectForKey:@"height"] floatValue];
        [source setHeight:height];
    }
    
    if([options objectForKey:@"rotation"] != nil){
        CGFloat rotation = [[options objectForKey:@"rotation"] floatValue];
        [source setRotation:rotation];
    }
    
    if([options objectForKey:@"posX"] != nil){
        CGFloat posX = [[options objectForKey:@"posX"] floatValue];
        [source setPosX:posX];
    }
    
    if([options objectForKey:@"posY"] != nil){
        CGFloat posY = [[options objectForKey:@"posY"] floatValue];
        [source setPosY:posY];
    }
    
    
    SCSDKNoSnapContent *content = [[SCSDKNoSnapContent alloc] init];
    
    [content setSticker:source];
    
    if([options objectForKey:@"caption"] != nil){
        [content setCaption:[options objectForKey:@"caption"]];
    }
    
    if([options objectForKey:@"attachment"] != nil){
        [content setAttachmentUrl:[options objectForKey:@"attachment"]];
    }
    
    SCSDKSnapAPI *api = [[SCSDKSnapAPI alloc] initWithContent:content];
    [api startSnappingWithCompletionHandler:^(NSError *error) {
        if(error != nil){
            RCTLogError(error);
        }
        RCTLogInfo(@"[RNSnapSDK] Callback.");
    }];
    return;
}
@end
