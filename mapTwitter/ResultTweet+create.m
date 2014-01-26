//
//  ResultTweet+create.m
//  mapTwitter
//
//  Created by Li Yansong on 14-1-4.
//  Copyright (c) 2014年 Liyansong. All rights reserved.
//

#import "ResultTweet+create.h"
#import "SearchInfo.h"

@implementation ResultTweet (create)

+ (instancetype)insertResultTweetWithName:(NSString *)name
                               profileURL:(NSString *)profileURL
                                     text:(NSString *)text
                               searchInfo:(SearchInfo *)searchInfo
                   inManagedObjectContext:(NSManagedObjectContext *)context {
    NSUInteger order = searchInfo.tweets.count;
    ResultTweet *tweet = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:context];
    tweet.name = name;
    tweet.profileURL = profileURL;
    tweet.text = text;
    tweet.searchInfo = searchInfo;
    tweet.order = @(order);
    return tweet;
}

+ (NSString *)entityName {
    return @"ResultTweet";
}

@end
