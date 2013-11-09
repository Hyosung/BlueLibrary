//
//  PersistencyManager.h
//  BlueLibrary
//
//  Created by ismallstar on 13-11-8.
//  Copyright (c) 2013年 Eli Ganem. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Album.h"

@interface PersistencyManager : NSObject

- (NSArray *)getAlbums;
- (void)addAlbum:(Album *) album atIndex:(NSUInteger) index;
- (void)deleteAlbumAtIndex:(NSUInteger) index;

- (void)saveImage:(UIImage*) image filename:(NSString*) filename;
- (UIImage*)getImage:(NSString*) filename;
- (void)saveAlbums;

@end
