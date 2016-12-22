//
//  SSBannerViewController.m
//  SSBannerViewController
//
//  Created by suruihai on 2016/12/19.
//  Copyright © 2016年 ruihai. All rights reserved.
//

#import "SSBannerViewController.h"

#define kWidth  self.view.bounds.size.width
#define kHeight self.view.bounds.size.height

@interface SSBannerViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) UIScrollView *bannerView;
@property (strong, nonatomic) UIImageView *view1;
@property (strong, nonatomic) UIImageView *view2;

@property (assign, nonatomic) NSInteger currentPage;
@property (assign, nonatomic) NSInteger maxPages;
@end

@implementation SSBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.scrollAutomatically = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.scrollAutomatically) {
        [self startTimer];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopTimer];
}

- (void)dealloc {
    NSLog(@"dealloc---%@", [self class]);
}

#pragma mark - private methods

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.bannerView];
    [self.bannerView addSubview:self.view1];
    [self.bannerView addSubview:self.view2];
    [self.view addSubview:self.pageControl];
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.dotColorCurrentPage = [UIColor whiteColor];
    self.pageControl.dotColorOtherPage = [UIColor colorWithWhite:0.0 alpha:0.3];
    self.pageControl.dotDiameter = 10.0;
    self.pageControl.dotGap = 5.0;
    self.pageControl.rightPadding = 10.0;
    self.pageControl.bottomPadding = 5.0;
}

- (void)startTimer {
    if (self.images.count <= 1) {
        return;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeGap ?: 3.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)nextPage {
    if (self.bannerView.isTracking) { // crucial here!
        return;
    }
    
    self.bannerView.userInteractionEnabled = NO;
    NSInteger nextPage = self.currentPage + 1;
    [self.bannerView setContentOffset:CGPointMake(nextPage * kWidth, 0) animated:YES];
}

- (void)prepareToShowNextPage:(NSInteger)page {
    NSUInteger count = self.images.count;
    
    if (labs(page % 2) == 1) {
        self.view1.frame = CGRectMake(page * kWidth, 0, kWidth, kHeight);
        [self.view1 setImage:self.images[page % count]];
    } else {
        self.view2.frame = CGRectMake(page * kWidth, 0, kWidth, kHeight);
        [self.view2 setImage:self.images[page % count]];
    }
}

- (void)onTapImageView:(UITapGestureRecognizer *)tap {
    if (self.onTapImageBlock) {
        
        UIImage *image = ((UIImageView *)tap.view).image;
        NSString *link = nil;
        
        if (self.links.count > 0) {
            NSUInteger index = [self.images indexOfObject:image];
            
            if (index < self.images.count && index < self.links.count) {
                link = [self.links objectAtIndex:index];
            }
        }
        
        self.onTapImageBlock(link);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.currentPage = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + .5);
    self.pageControl.currentPage = self.currentPage % self.images.count;

    if ((scrollView.contentOffset.x / scrollView.frame.size.width) < self.currentPage) {
        [self prepareToShowNextPage:self.currentPage - 1];
    } else {
        [self prepareToShowNextPage:self.currentPage + 1];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.bannerView.userInteractionEnabled = YES;
    
    NSUInteger count = self.images.count;
    
    if (self.currentPage % count == 0) {
        self.currentPage = self.maxPages * 0.5;
        [self.bannerView setContentOffset:CGPointMake(self.currentPage * kWidth, 0) animated:NO];
        [self prepareToShowNextPage:self.currentPage];
    }
    [self prepareToShowNextPage:self.currentPage + 1];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.scrollAutomatically) {
        [self startTimer];
    }
}

#pragma mark - properties

- (void)setImages:(NSArray<UIImage *> *)images {
    _images = images;
    
    NSUInteger count = images.count;
    
    if (count <= 0) {
        self.view.hidden = YES;
        return;
    }
    
    NSUInteger maxPages = count * 5000; // set a big enough number here to ensure user wont swipe to the end
    self.maxPages = maxPages;
    
    self.pageControl.numberOfPages = count;
    self.pageControl.currentPage = 0;
    self.pageControl.hidden |= count <= 1;
    
    if (count <= 1) {
        self.bannerView.scrollEnabled = NO;
        self.currentPage = 0;
        [self prepareToShowNextPage:self.currentPage];
    } else {
        self.currentPage = maxPages * 0.5;
        [self.bannerView setContentSize:CGSizeMake(maxPages * kWidth, 0)];
        [self.bannerView setContentOffset:CGPointMake(kWidth * self.currentPage, 0)];
        [self prepareToShowNextPage:self.currentPage];
        [self prepareToShowNextPage:self.currentPage + 1];
        
        CGFloat dotDiameter = self.pageControl.dotDiameter;
        CGFloat pageControlWidth = count * dotDiameter + (count - 1) * self.pageControl.dotGap;
        self.pageControl.frame = CGRectMake(kWidth - pageControlWidth - self.pageControl.rightPadding, kHeight - dotDiameter - self.pageControl.bottomPadding, pageControlWidth, dotDiameter);
    }
}

- (UIScrollView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _bannerView.delegate = self;
        _bannerView.showsHorizontalScrollIndicator = NO;
        _bannerView.pagingEnabled = YES;
    }
    return _bannerView;
}

- (UIImageView *)view1 {
    if (!_view1) {
        _view1 = [[UIImageView alloc] init];
        _view1.userInteractionEnabled = YES;
        [_view1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImageView:)]];
    }
    return _view1;
}

- (UIImageView *)view2 {
    if (!_view2) {
        _view2 = [[UIImageView alloc] init];
        _view2.userInteractionEnabled = YES;
        [_view2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImageView:)]];
    }
    return _view2;
}

- (SSPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[SSPageControl alloc] init];
    }
    return _pageControl;
}

@end
