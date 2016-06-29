//
//  ViewController.m
//  XCConfigureShare
//
//  Created by 小蔡 on 16/6/28.
//  Copyright © 2016年 小蔡. All rights reserved.
//

#import "ViewController.h"
#import "XCShareManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    XCShareManager * manager = [XCShareManager defaultManager];
    [manager setShareVC:self content:@"测试分享" image:[UIImage imageNamed:@"test"] urlStr:@"https://github.com/CoderXC"];
    [manager showSharePanel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
