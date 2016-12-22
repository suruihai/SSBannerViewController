//
//  SSPageControl.m
//  SSBannerViewController
//
//  Created by suruihai on 2016/12/19.
//  Copyright © 2016年 ruihai. All rights reserved.
//

#import "SSPageControl.h"

@implementation SSPageControl

- (void)setCurrentPage:(NSInteger)page {
    _currentPage = MIN(MAX(0, page), _numberOfPages - 1);
    [self setNeedsDisplay];
}

- (void)setNumberOfPages:(NSInteger)pages {
    _numberOfPages = MAX(0, pages);
    _currentPage = MIN(MAX(0, _currentPage), _numberOfPages - 1);
    [self setNeedsDisplay];
}

- (void)setDotDiameter:(CGFloat)dotDiameter {
    _dotDiameter = dotDiameter;
    [self refreshFrame];
    [self setNeedsDisplay];
}

- (void)setDotGap:(CGFloat)dotGap {
    _dotGap = dotGap;
    [self refreshFrame];
    [self setNeedsDisplay];
}

- (void)setRightPadding:(CGFloat)rightPadding {
    _rightPadding = rightPadding;
    [self refreshFrame];
    [self setNeedsDisplay];
}

- (void)setBottomPadding:(CGFloat)bottomPadding {
    _bottomPadding = bottomPadding;
    [self refreshFrame];
    [self setNeedsDisplay];
}

- (void)setPlaceAtCenter:(BOOL)placeAtCenter {
    _placeAtCenter = placeAtCenter;
    [self refreshFrame];
    [self setNeedsDisplay];
}

- (void)refreshFrame {
    CGFloat pageControlWidth = self.numberOfPages * self.dotDiameter + MAX(0, self.numberOfPages - 1) * self.dotGap;
    
    if (self.placeAtCenter) {
        self.frame = CGRectMake((self.superview.bounds.size.width - pageControlWidth) * 0.5, self.superview.bounds.size.height - self.dotDiameter - self.bottomPadding, pageControlWidth, self.dotDiameter);
    } else {
        self.frame = CGRectMake(self.superview.bounds.size.width - pageControlWidth - self.rightPadding, self.superview.bounds.size.height - self.dotDiameter - self.bottomPadding, pageControlWidth, self.dotDiameter);
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextSetAllowsAntialiasing(context, YES);
    
    CGRect currentBounds = self.bounds;
    
    CGFloat dotsWidth = self.numberOfPages * self.dotDiameter + MAX(0, self.numberOfPages - 1) * self.dotGap;
    CGFloat x = CGRectGetMidX(currentBounds) - dotsWidth * 0.5;
    CGFloat y = CGRectGetMidY(currentBounds) - self.dotDiameter * 0.5;
    for (int i = 0; i < self.numberOfPages; i++) {
        CGRect circleRect = CGRectMake(x, y, self.dotDiameter, self.dotDiameter);
        if (i == self.currentPage) {
            CGContextSetFillColorWithColor(context, self.dotColorCurrentPage.CGColor);
        }
        else {
            CGContextSetFillColorWithColor(context, self.dotColorOtherPage.CGColor);
        }
        CGContextFillEllipseInRect(context, circleRect);
        x += self.dotDiameter + self.dotGap;
    }
    
    CGContextRestoreGState(context);
}

@end
