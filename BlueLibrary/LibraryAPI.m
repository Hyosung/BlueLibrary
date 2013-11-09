//
//  LibraryAPI.m
//  BlueLibrary
//
//  Created by ismallstar on 13-11-8.
//  Copyright (c) 2013年 Eli Ganem. All rights reserved.
//

#import "LibraryAPI.h"

#import "PersistencyManager.h"
#import "HTTPClient.h"

@interface LibraryAPI()
{
    PersistencyManager *persitencyManager;
    HTTPClient *httpClient;
    BOOL isOnline;//isOnline决定了是否服务器中任何专辑数据的改变应该被更新，例如增加或者删除专辑。
}

@end

@implementation LibraryAPI

+ (LibraryAPI *)sharedInstance{
    static LibraryAPI *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[LibraryAPI alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        persitencyManager = [[PersistencyManager alloc] init];
        httpClient = [[HTTPClient alloc] init];
        
        isOnline = NO;//初始状态未被更新
        
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(downloadImage:) name:@"BLDownloadImageNotification" object:nil];
    }
    return self;
}

- (void)downloadImage:(NSNotification *) note{
    UIImageView *imageView = [note userInfo][@"imageView"];
    NSString *coverUrl = [note userInfo][@"coverUrl"];
    
    imageView.image = [persitencyManager getImage:[coverUrl lastPathComponent]];
    
    if (!imageView.image) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [httpClient downloadImage:coverUrl];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = image;
                [persitencyManager saveImage:image filename:[coverUrl lastPathComponent]];
            });
        });
    }
}

- (NSArray *)getAlbums{
    return [persitencyManager getAlbums];
}

- (void)addAlbum:(Album *)album atIndex:(NSUInteger)index{
    [persitencyManager addAlbum:album atIndex:index];
    
    if (isOnline) {
        [httpClient postRequest:@"/api/addAlbum" body:[album description]];
    }
}

- (void)deleteAlbumAtIndex:(NSUInteger)index{
    [persitencyManager deleteAlbumAtIndex:index];
    
    if (isOnline) {
        [httpClient postRequest:@"/api/deleteAlbum" body:[@(index) description]];
    }
}

- (void)saveAlbums{
    [persitencyManager saveAlbums];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLDownloadImageNotification" object:nil];
}

@end
