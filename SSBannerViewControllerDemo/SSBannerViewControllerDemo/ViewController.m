//
//  ViewController.m
//  SSBannerViewControllerDemo
//
//  Created by suruihai on 2016/12/19.
//  Copyright © 2016年 ruihai. All rights reserved.
//

#import "ViewController.h"
#import <SSBannerViewController/SSBannerViewController.h>

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray *images;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // banner1
    SSBannerViewController *bannerVc = [[SSBannerViewController alloc] init];
    bannerVc.view.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 260.0 / 600.0 * [UIScreen mainScreen].bounds.size.width);
    
    bannerVc.onTapImageBlock = ^(NSString *link){
        NSLog(@"%@", link);
        NSURL *url = [NSURL URLWithString:link];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    };
    
    bannerVc.images = self.images;
    bannerVc.links = @[@"http://www.sogou.com"];
    [self addChildViewController:bannerVc];
    [self.view addSubview:bannerVc.view];
    
    bannerVc.pageControl.placeAtCenter = YES;
    
    
    // banner2
    SSBannerViewController *bannerVc2 = [[SSBannerViewController alloc] init];
    CGFloat y = CGRectGetMaxY(bannerVc.view.frame);
    bannerVc2.view.frame = CGRectMake(0, y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - y);
    
    UIImage *catImage = [UIImage imageNamed:[[NSBundle mainBundle] pathForResource:@"cat" ofType:@"jpg"]];
    
    bannerVc2.images = @[catImage, catImage, catImage];
    [self addChildViewController:bannerVc2];
    [self.view addSubview:bannerVc2.view];
    
    bannerVc2.pageControl.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray arrayWithCapacity:5];
        [_images addObject:[UIImage imageNamed:@"img_01.png"]];
        [_images addObject:[UIImage imageNamed:@"img_02.png"]];
        [_images addObject:[UIImage imageNamed:@"img_03.png"]];
        [_images addObject:[UIImage imageNamed:@"img_04.png"]];
        [_images addObject:[UIImage imageNamed:@"img_05.png"]];
    }
    return _images;
}

@end
