//
//  TwitterAPI.h
//  mapTwitter
//
//  Created by Li Yansong on 14-1-2.
//  Copyright (c) 2014年 Liyansong. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^TwitterSearchCompleteBlock)(NSArray *array, NSDictionary *searchMetaData);

@interface TwitterAPI : NSObject


+ (instancetype)Twitter;

// This api is for Specific Location Tweets Search.
// TODO: Future this api may adapt the refresh action.
- (void)searchTweetsWithQuery:(NSString *)query geocode:(NSString *)location complete:(TwitterSearchCompleteBlock) block;

@end
