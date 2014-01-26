//
//  SearchInfo.h
//  mapTwitter
//
//  Created by Li Yansong on 14-1-4.
//  Copyright (c) 2014年 Liyansong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ResultTweet;

@interface SearchInfo : NSManagedObject

@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSDate * searchTime;
@property (nonatomic, retain) NSString * searchTitle;
@property (nonatomic, retain) NSNumber * desiredHeight;
@property (nonatomic, retain) NSSet *tweets;
@end

@interface SearchInfo (CoreDataGeneratedAccessors)

- (void)addTweetsObject:(ResultTweet *)value;
- (void)removeTweetsObject:(ResultTweet *)value;
- (void)addTweets:(NSSet *)values;
- (void)removeTweets:(NSSet *)values;

@end
