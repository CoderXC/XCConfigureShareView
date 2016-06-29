//
//  XCShareView.h
//  XCConfigureShare
//
//  Created by 小蔡 on 16/6/28.
//  Copyright © 2016年 小蔡. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define XCBlock_Safe(block, ...) if (block) { block(__VA_ARGS__); };

@protocol XCShareViewDelegate <NSObject>

- (void)itemActionWithIndex:(NSInteger)index;

@end

@interface XCShareView : UIView


/**
 *  分享面板
 */
@property (nonatomic, strong) UIView * sharePanel;

@property (nonatomic, weak) id<XCShareViewDelegate> delegate;

- (instancetype)initWithImageNames:(NSArray *)imageNames andTitles:(NSArray *)titles;

@end
