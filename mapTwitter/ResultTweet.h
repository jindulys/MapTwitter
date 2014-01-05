//
//  ResultTweet.h
//  mapTwitter
//
//  Created by Li Yansong on 14-1-4.
//  Copyright (c) 2014年 Liyansong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SearchInfo;

@interface ResultTweet : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * profileURL;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) SearchInfo *searchInfo;

@end
