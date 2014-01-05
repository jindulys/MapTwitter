//
//  SearchInfo+create.h
//  mapTwitter
//
//  Created by Li Yansong on 14-1-4.
//  Copyright (c) 2014年 Liyansong. All rights reserved.
//

#import "SearchInfo.h"

@interface SearchInfo (create)

+ (instancetype)insertSearchInfoWithLocation:(NSString *)searchLocString
                                 searchTitle:(NSString *)searchTitle
                                  searchTime:(NSDate *)searchTime
                      inManagedObjectContext:(NSManagedObjectContext *)context;
@end
