//
//  SSBannerViewController.h
//  SSBannerViewController
//
//  Created by suruihai on 2016/12/19.
//  Copyright © 2016年 ruihai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSPageControl.h"

@interface SSBannerViewController : UIViewController

@property (strong, nonatomic) NSArray<UIImage *> *images;

// the corresponding link to open when tapped on an image
@property (strong, nonatomic) NSArray<NSString *> *links;

@property (copy, nonatomic) void (^onTapImageBlock)(NSString *link);

// halt time, default = 3.0
@property (assign, nonatomic) CGFloat timeGap;

@property (strong, nonatomic) SSPageControl *pageControl;

// decides whether banner images should scroll with a timer
@property (assign, nonatomic) BOOL scrollAutomatically;

- (void)startTimer;
- (void)stopTimer;
@end
