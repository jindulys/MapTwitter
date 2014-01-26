//
//  ResultTweet+create.h
//  mapTwitter
//
//  Created by Li Yansong on 14-1-4.
//  Copyright (c) 2014年 Liyansong. All rights reserved.
//

#import "ResultTweet.h"

@class SearchInfo;
@interface ResultTweet (create)

+ (instancetype)insertResultTweetWithName:(NSString *)name
                               profileURL:(NSString *)profileURL
                                     text:(NSString *)text
                               searchInfo:(SearchInfo *)searchInfo
                   inManagedObjectContext:(NSManagedObjectContext *)context;


@end
