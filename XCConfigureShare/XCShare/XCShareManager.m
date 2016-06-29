//
//  XCShareManager.m
//  XCConfigureShare
//
//  Created by 小蔡 on 16/6/28.
//  Copyright © 2016年 小蔡. All rights reserved.
//

#import "XCShareManager.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"

static XCShareManager * manager = nil;

@interface XCShareManager ()<XCShareViewDelegate>
{
    UIViewController * _shareVC;
    NSString * _shareContent;
    UIImage * _shareImage;
    NSString * _shareUrlStr;
}

@property (nonatomic, strong) XCShareView * shareBackView;

@end

@implementation XCShareManager

+ (instancetype)defaultManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        NSArray * titles = @[@"微信",@"朋友圈",@"新浪微博",@"QQ",@"QQ空间"];
        NSArray * imageNames = @[@"share_微信",@"share_朋友圈",@"share_微博",@"share_qq",@"share_QQ空间"];
        self.shareBackView = [[XCShareView alloc] initWithImageNames:imageNames andTitles:titles];
        self.shareBackView.frame = [UIScreen mainScreen].bounds;
        self.shareBackView.delegate = self;
    }
    return self;
}

- (void)setShareAppKey
{
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:K_UM_AppKey];
    
    //微信
    [UMSocialWechatHandler setWXAppId:K_WX_AppID appSecret:K_WX_AppSecret url:K_Share_Url];
    //QQ
    [UMSocialQQHandler setQQWithAppId:K_QQ_AppId appKey:K_QQ_AppKey url:K_Share_Url];
    [UMSocialQQHandler setSupportWebView:YES];
    //新浪微博
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:K_Sina_AppKey secret:K_WX_AppSecret RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
}

- (void)showSharePanel{
    
    self.shareBackView.hidden = NO;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.shareBackView];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self.shareBackView];
    
    CGFloat panelHeight = CGRectGetHeight(self.shareBackView.sharePanel.frame);
    [UIView animateWithDuration:0.3 animations:^{
        self.shareBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        self.shareBackView.sharePanel.frame = CGRectMake(0, ScreenHeight - panelHeight, ScreenWidth, panelHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setShareVC:(UIViewController *)shareVC content:(NSString *)content image:(UIImage *)image urlStr:(NSString *)urlStr{
    
    _shareVC = shareVC;
    _shareContent = content;
    _shareImage = image;
    _shareUrlStr = urlStr;
}

#pragma mark - XCShareViewDelegate
- (void)itemActionWithIndex:(NSInteger)index{
    
    NSLog(@"==== %zd", index);
    NSString * titleStr = _shareContent;
    NSString * urlStr = _shareUrlStr;
    UIImage  * image = _shareImage;
    NSArray *shareType;
    if (index == 0) {
        // 微信
        shareType = @[UMShareToWechatSession];
        [UMSocialData defaultData].extConfig.wechatSessionData.url = urlStr;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = titleStr;
    }else if (index == 1) {
        // 朋友圈
        shareType = @[UMShareToWechatTimeline];
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = urlStr;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = titleStr;
    }else if (index == 2) {
        // 新浪
        titleStr = [NSString stringWithFormat:@"%@   猛戳->>>%@(分享来自@m小兵e)",titleStr,urlStr];
        shareType = @[UMShareToSina];
    }else{
        if ([TencentOAuth iphoneQQInstalled]) {
            if (index == 3) {
                // QQ
                shareType = @[UMShareToQQ];
                [UMSocialData defaultData].extConfig.qqData.url = urlStr;
                [UMSocialData defaultData].extConfig.qqData.title = titleStr;
            }else if (index == 4) {
                // QQ空间
                shareType = @[UMShareToQzone];
                [UMSocialData defaultData].extConfig.qzoneData.url = urlStr;
                [UMSocialData defaultData].extConfig.qzoneData.title = titleStr;
            }
        } else {
            NSLog(@"程序未安装,请到App Store下载");
            return;
        }
    }
    [self postShareWith:shareType content:titleStr image:image];
}

- (void)postShareWith:(NSArray *)type content:(NSString *)content image:(id)image{
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:type content:content image:image location:nil urlResource:nil presentedController:_shareVC completion:^(UMSocialResponseEntity *response){
        [self shareFinishWith:response];
    }];
}

// 分享完成
- (void)shareFinishWith:(UMSocialResponseEntity *)response{
  
    if (response.responseCode == UMSResponseCodeSuccess) {
        NSLog(@"分享成功！");
        XCBlock_Safe(self.shareIsSuccess, YES);
    }else if (response.responseCode == UMSResponseCodeCancel) {
        NSLog(@"取消");
        XCBlock_Safe(self.shareIsSuccess, NO);
    }else {
        NSLog(@"失败");
        XCBlock_Safe(self.shareIsSuccess, NO);
    }
}




@end
