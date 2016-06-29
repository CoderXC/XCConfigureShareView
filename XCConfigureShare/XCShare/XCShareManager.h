//
//  XCShareManager.h
//  XCConfigureShare
//
//  Created by 小蔡 on 16/6/28.
//  Copyright © 2016年 小蔡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCShareView.h"

// 测试 - AppKey

// 友盟AppKey
#define K_UM_AppKey      @"53290df956240b6b4a0084b3"

/*sina*/
#define K_Sina_AppKey    @"3921700954"
#define K_Sina_AppSecret @"04b48b094faeb16683c32669824ebdad"
/*QQ*/
#define K_QQ_AppId       @"100424468"
#define K_QQ_AppKey      @"c7394704798a158208a74ab60104f0ba"
/*微信*/
#define K_WX_AppID       @"wxdc1e388c3822c80b"
#define K_WX_AppSecret   @"a393c1527aaccb95f3a4c88d6d1455f6"

#define K_Share_Url      @"http://www.umeng.com/social"

@interface XCShareManager : NSObject

/**
 *  单例获取
 */
+ (instancetype)defaultManager;

/**
 *  分享回调
 */
@property (nonatomic, copy) void(^shareIsSuccess)(BOOL isSuccess);

/**
 *  配置第三方APPID
 */
- (void)setShareAppKey;

/**
 *  设置分享内容
 *
 *  @param shareVC 当前分享界面的控制器
 *  @param content 分享的内容
 *  @param image   分享的图片
 *  @param urlStr  分享的网页
 */
- (void)setShareVC:(UIViewController *)shareVC content:(NSString *)content image:(UIImage *)image urlStr:(NSString *)urlStr;

/**
 *  弹出分享面板
 */
- (void)showSharePanel;

@end
