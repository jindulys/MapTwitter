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

+ (NSFetchedResultsController *)AllSearchInfoFetchedResultsControllerWithContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"searchTime" ascending:NO];
    [request setSortDescriptors:@[sortDescriptor]];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
}

- (NSString *)constructText {
    return self.searchTitle;
}

- (NSString *)constructTweetNum {
    return [NSString stringWithFormat:@"total num:%lu",(self.tweets.count)];
}

@end
