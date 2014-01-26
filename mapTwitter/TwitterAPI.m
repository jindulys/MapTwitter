//
//  TwitterAPI.m
//  mapTwitter
//
//  Created by Li Yansong on 14-1-2.
//  Copyright (c) 2014年 Liyansong. All rights reserved.
//

#import "TwitterAPI.h"
#import "STTwitterAPI.h"
#import "MTGoogleMapAPIKey.h"

@interface TwitterAPI ()

@property (nonatomic, strong) STTwitterAPI *twitterAPI;

@end

@implementation TwitterAPI

+ (instancetype)Twitter {
    return [[self alloc] init];
}

- (id)init {
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    STTwitterAPI *twitterAPI = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:ConsumerKey consumerSecret:ConsumerSecret];
    [twitterAPI verifyCredentialsWithSuccessBlock:^(NSString *username) {
        NSLog(@"username is %@",username);
    } errorBlock:^(NSError *error) {
        NSLog(@"error with description %@",error.description);
    }];
    self.twitterAPI = twitterAPI;
}

- (void)searchTweetsWithQuery:(NSString *)query geocode:(NSString *)location complete:(TwitterSearchCompleteBlock)block{
    
    if (!query) {
        return;
    }
    if (!location) {
        return;
    }
    
    [self.twitterAPI getSearchTweetsWithQuery:query geocode:location lang:@"en" locale:nil resultType:nil count:@"100" until:nil sinceID:nil maxID:nil includeEntities:nil callback:nil successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
        block(statuses, searchMetadata);
    } errorBlock:^(NSError *error) {
        NSLog(@"error is %@",error.description);
    }];
}

@end
