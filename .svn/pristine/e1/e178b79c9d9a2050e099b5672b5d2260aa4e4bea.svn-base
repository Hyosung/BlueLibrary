//
//  Album.m
//  BlueLibrary
//
//  Created by ismallstar on 13-11-8.
//  Copyright (c) 2013年 Eli Ganem. All rights reserved.
//

#import "Album.h"

@implementation Album

- (id)initWithTitle:(NSString *)title
             artist:(NSString *)artist
           coverUrl:(NSString *)coverUrl
               year:(NSString *)year{
    self = [super init];
    if (self) {
        _title = title;
        _artist = artist;
        _genre = @"Pop";
        _coverUrl = coverUrl;
        _year = year;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_artist forKey:@"artist"];
    [aCoder encodeObject:_coverUrl forKey:@"coverUrl"];
    [aCoder encodeObject:_genre forKey:@"genre"];
    [aCoder encodeObject:_year forKey:@"year"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _title = [aDecoder decodeObjectForKey:@"title"];
        _artist = [aDecoder decodeObjectForKey:@"artist"];
        _coverUrl = [aDecoder decodeObjectForKey:@"coverUrl"];
        _genre = [aDecoder decodeObjectForKey:@"genre"];
        _year = [aDecoder decodeObjectForKey:@"year"];
    }
    return self;
}

@end
