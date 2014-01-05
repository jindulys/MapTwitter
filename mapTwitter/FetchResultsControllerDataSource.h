//
//  FetchResultsControllerDataSource.h
//  mapTwitter
//
//  Created by Li Yansong on 14-1-4.
//  Copyright (c) 2014年 Liyansong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSFetchedResultsController;

@protocol FetchedResultsControllerDataSourceDelegate <NSObject>
- (void)configureCell:(id)cell withObject:(id)object;
- (void)deleteObject:(id)object;

@end

@interface FetchResultsControllerDataSource : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) id<FetchedResultsControllerDataSourceDelegate> delegate;
@property (nonatomic, copy) NSString *reuseIdentifier;
@property (nonatomic) BOOL paused;

- (id)initWithTableView:(UITableView *)tableView;
- (id)selectedItem;

@end
