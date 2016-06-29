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
#define K_UM_AppKey      @"55a4c32567e58e0de20035a2"

/*sina*/
#define K_Sina_AppKey    @"1576918936"
#define K_Sina_AppSecret @"9e7cc97802d7188d824a6b2031f3d17e"
/*QQ*/
#define K_QQ_AppId       @"1103282484"
#define K_QQ_AppKey      @"APMyBXD2bu2KoVZo"
/*微信*/
#define K_WX_AppID       @"wxa1e5dfe7ee8b5af9"
#define K_WX_AppSecret   @"efcba398e449a5fd4b2a3bcdc8f1c4f8"

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
