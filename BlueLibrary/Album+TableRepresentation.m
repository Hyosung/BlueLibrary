//
//  Album+TableRepresentation.m
//  BlueLibrary
//
//  Created by ismallstar on 13-11-8.
//  Copyright (c) 2013年 Eli Ganem. All rights reserved.
//

#import "Album+TableRepresentation.h"

@implementation Album (TableRepresentation)

- (NSDictionary *)tr_tableRepresentation{
    return @{@"titles":@[@"Artist", @"Album", @"Genre", @"Year"],@"values":@[self.artist, self.title, self.genre, self.year]};
}

@end
