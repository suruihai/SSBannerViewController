//
//  SSPageControl.h
//  SSBannerViewController
//
//  Created by suruihai on 2016/12/19.
//  Copyright © 2016年 ruihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSPageControl : UIView

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) NSInteger numberOfPages;

// default = white, alpha = 1.0
@property (nonatomic, strong) UIColor *dotColorCurrentPage;

// default = black, alpha = 0.3
@property (nonatomic, strong) UIColor *dotColorOtherPage;

// default = 10.0
@property (nonatomic, assign) CGFloat dotDiameter;

// default = 5.0
@property (nonatomic, assign) CGFloat dotGap;

// frame.right, default = 10.0
@property (assign, nonatomic) CGFloat rightPadding;

// frame.bottom, default = 5.0
@property (assign, nonatomic) CGFloat bottomPadding;

// decides whether placeControl should place at the center of its superview, if set to YES, will ignore rightPadding, default = NO
@property (assign, nonatomic) BOOL placeAtCenter;

@end
