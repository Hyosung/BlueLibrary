//
//  HorizontalScroller.h
//  BlueLibrary
//
//  Created by ismallstar on 13-11-8.
//  Copyright (c) 2013年 Eli Ganem. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HorizontalScrollerDelegate;

@interface HorizontalScroller : UIView

@property (weak) id<HorizontalScrollerDelegate> delegate;

- (void)reload;

@end

@protocol HorizontalScrollerDelegate <NSObject>

@required

- (NSInteger)numberOfViewsForHorizontalScroller:(HorizontalScroller *) scroller;

- (UIView*)horizontalScroller:(HorizontalScroller*)scroller viewAtIndex:(NSUInteger) index;

- (void)horizontalScroller:(HorizontalScroller*)scroller clickedViewAtIndex:(NSUInteger)index;

@optional

- (NSInteger)initialViewIndexForHorizontalScroller:(HorizontalScroller*)scroller;
@end
