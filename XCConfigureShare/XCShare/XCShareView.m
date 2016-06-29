//
//  XCShareView.m
//  XCConfigureShare
//
//  Created by 小蔡 on 16/6/28.
//  Copyright © 2016年 小蔡. All rights reserved.
//

#import "XCShareView.h"

@interface XCShareView ()

@property (nonatomic, strong) NSArray * imageNames;
@property (nonatomic, strong) NSArray * titles;

@end

@implementation XCShareView

- (instancetype)initWithImageNames:(NSArray *)imageNames andTitles:(NSArray *)titles
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.imageNames = imageNames;
        self.titles = titles;
        [self configureUI];
    }
    return self;
}

- (void)configureUI
{
    UIView * topMaskView = [[UIView alloc] init];
    [topMaskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideShareView)]];
    [self addSubview:topMaskView];
    
    self.sharePanel = [[UIView alloc] init];
    self.sharePanel.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.sharePanel];
    
    /*********** 面板标题 ****************/
    UILabel * titleLable = [[UILabel alloc] init];
    titleLable.frame = CGRectMake(0, 0, ScreenWidth, 40);
    titleLable.text = @"分享到";
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont systemFontOfSize:14];
    [self.sharePanel addSubview:titleLable];
    
    /*********** 面板按钮布局 ****************/
    CGFloat itemW = ScreenWidth > 375 ? 70 : 65;
    CGFloat itemTitleH = [@"标题" boundingRectWithSize:CGSizeMake(itemW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size.height;
    CGFloat itemH = itemW + 8 + itemTitleH;
    CGSize itemSize = CGSizeMake(itemW, itemH);
    
    CGFloat maxY = 0;
    CGFloat marginHor = (ScreenWidth - 4 * itemW) / 5;
    CGFloat marginVer = 10;
    for (int i = 0; i < self.imageNames.count; i++) {
        CGFloat row = i / 4;
        CGFloat loc = i % 4;
        CGFloat originX = marginHor + loc * (marginHor + itemW);
        CGFloat originY = CGRectGetHeight(titleLable.frame) + row * (marginVer + itemH);
        UIView * itemView = [self createItemWithItemSize:itemSize itemTitleHieght:itemTitleH andIndex:i];
        itemView.frame = CGRectMake(originX, originY, itemW, itemH);
        [self.sharePanel addSubview:itemView];
        maxY = CGRectGetMaxY(itemView.frame);
    }
    
    /*********** 面板取消按钮 ****************/
    UIButton * canceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    canceBtn.frame = CGRectMake(12, maxY + 15, ScreenWidth - 24, 30);
    canceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    canceBtn.layer.borderWidth = 1;
    canceBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [canceBtn setTitle:@"取消" forState:UIControlStateNormal];
    [canceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [canceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [canceBtn addTarget:self action:@selector(hideShareView) forControlEvents:UIControlEventTouchUpInside];
    [self.sharePanel addSubview:canceBtn];
    
    self.sharePanel.frame = CGRectMake(0, ScreenHeight, ScreenWidth, CGRectGetMaxY(canceBtn.frame) + 12);
    topMaskView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - CGRectGetHeight(self.sharePanel.frame));
}

- (UIView *)createItemWithItemSize:(CGSize)itemSize itemTitleHieght:(CGFloat)itemTitleHieght andIndex:(NSInteger)index
{
    UIView * itemView = [[UIView alloc] init];
    itemView.tag = index;
    [itemView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemViewAction:)]];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imageNames[index]]];
    imageView.frame = CGRectMake(0, 0, itemSize.width, itemSize.width);
    [itemView addSubview:imageView];
    
    UILabel * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 8, itemSize.width, itemTitleHieght)];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont systemFontOfSize:12];
    titleLable.text = self.titles[index];
    [itemView addSubview:titleLable];
    
    return itemView;
}

- (void)itemViewAction:(UITapGestureRecognizer *)tap
{
    [self hideShareView];
    if ([self.delegate respondsToSelector:@selector(itemActionWithIndex:)]) {
        [self.delegate itemActionWithIndex:tap.view.tag];
    }
}

- (void)hideShareView
{
    CGFloat panelHeight = CGRectGetHeight(self.sharePanel.frame);
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.sharePanel.frame = CGRectMake(0, ScreenHeight, ScreenWidth, panelHeight);
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
