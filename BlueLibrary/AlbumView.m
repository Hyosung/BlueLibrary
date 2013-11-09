//
//  AlbumView.m
//  BlueLibrary
//
//  Created by ismallstar on 13-11-8.
//  Copyright (c) 2013年 Eli Ganem. All rights reserved.
//

#import "AlbumView.h"

@implementation AlbumView
{
    UIImageView *coverImage;
    UIActivityIndicatorView *indicator;
}

- (id)initWithFrame:(CGRect)frame albumCover:(NSString *)albumCover{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(frame) - 10, CGRectGetHeight(frame) - 10)];
        [self addSubview:coverImage];
        
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicator startAnimating];
        [self addSubview:indicator];
        
        [coverImage addObserver:self forKeyPath:@"image" options:0 context:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BLDownloadImageNotification" object:self userInfo:@{@"imageView":coverImage,@"coverUrl":albumCover}];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"image"]) {
        [indicator stopAnimating];
    }
}

- (void)dealloc{
    [coverImage removeObserver:self forKeyPath:@"image" context:nil];
}

@end
