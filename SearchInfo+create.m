//
//  SearchInfo+create.m
//  mapTwitter
//
//  Created by Li Yansong on 14-1-4.
//  Copyright (c) 2014年 Liyansong. All rights reserved.
//

#import "SearchInfo+create.h"

@implementation SearchInfo (create)

+ (instancetype)insertSearchInfoWithLocation:(NSString *)searchLocString
                                 searchTitle:(NSString *)searchTitle
                                  searchTime:(NSDate *)searchTime
                      inManagedObjectContext:(NSManagedObjectContext *)context {
    SearchInfo *info = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:context];
    info.searchTitle = searchTitle;
    info.location = searchLocString;
    info.searchTime = searchTime;
    return info;
}

+ (NSString *)entityName {
    return @"SearchInfo";
}

@end
