//
//  ArrayDataSource.h
//  mapTwitter
//
//  Created by Li Yansong on 14-1-2.
//  Copyright (c) 2014年 Liyansong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TableViewCellConfigureBlock)(id cell, id item);

@interface ArrayDataSource : NSObject <UITableViewDataSource>

- (id)initWithItem:(NSArray *)anItems
    cellIdentifier:(NSString *)aCellIdentifier
configuerCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
- (id)itemAtIndex:(NSInteger)index;

- (NSInteger)itemCount;

@end
