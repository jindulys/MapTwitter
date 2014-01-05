//
//  TweetsResultVC.m
//  mapTwitter
//
//  Created by Li Yansong on 14-1-2.
//  Copyright (c) 2014年 Liyansong. All rights reserved.
//

#import "TweetsResultVC.h"
#import "UWBEAppDelegate.h"
#import "ArrayDataSource.h"
#import "TwitterAPI.h"
#import "TweetsResultCell.h"
#import "Tweet.h"
#import "UIFont+Additions.h"
#import "NSString+Additions.h"
#import "SearchInfo.h"
#import "SearchInfo+create.h"
#import "PersistentStack.h"

#define TableViewCellAdjustBottomHeight (12 + 5 + 8)
#define DEFAULT_CELL_HEIGHT 44

static NSString *const TweetsCellIdentifier = @"TweetCell";

@interface TweetsResultVC ()

@property (nonatomic, strong) ArrayDataSource *tweetsArrayDataSource;
@property (nonatomic) BOOL didSaveTweets;
@property (nonatomic, strong) SearchInfo *searchInfo;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation TweetsResultVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Tweets";
    [self buildSearchInfoObject];
    [self getTweets];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!self.didSaveTweets) {
        [self.context deleteObject:self.searchInfo];
    }
    [self.context save:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CoreData Method

- (void)buildSearchInfoObject {
    
    self.context = [UWBEAppDelegate sharedDelegate].persistentStack.managedObjectContext;
    NSDate *date = [NSDate date];
    self.searchInfo = [SearchInfo insertSearchInfoWithLocation:self.searchLocStr searchTitle:self.query searchTime:date inManagedObjectContext:self.context];
}

- (void)generateModelData:(NSArray *)array {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in array) {
            NSDictionary *userdic = dic[@"user"];
            Tweet *tweet = [[Tweet alloc] init];
            tweet.name = userdic[@"name"];
            tweet.profileImageURL = userdic[@"profile_image_url"];
            tweet.text = dic[@"text"];
            [resultsArray addObject:tweet];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupTableViewWithData:resultsArray];
            [self.tableView reloadData];
        });
    });
}

- (void)setupTableViewWithData:(NSArray *)dataArray {
    TableViewCellConfigureBlock configureCell = ^(TweetsResultCell *cell, id tweet) {
        Tweet *t = tweet;
        [cell setCellHeight:t.desiredHeight];
        cell.containingTableView = self.tableView;
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
        
        cell.textFont = [UIFont YSSystemFontOfSize:14.0f];
        cell.textColor = [UIColor colorWithDesignIndex:2];
        cell.timeStampFont = [UIFont YSSystemFontOfSize:12.0f];
        cell.timeStampColor = [UIColor colorWithDesignIndex:3];
        cell.nameFont = [UIFont YSBoldSystemFontOfSize:14.0f];
        cell.nameColor = [UIColor colorWithDesignIndex:34];
        cell.textPaddingLeft = 50.0f;
        cell.textPaddingTop = 12.0f;
        cell.underlined = NO;
        [cell setModel:(Tweet *)tweet];
    };
    self.tweetsArrayDataSource = [[ArrayDataSource alloc] initWithItem:dataArray cellIdentifier:TweetsCellIdentifier configuerCellBlock:configureCell];
    self.tableView.dataSource = self.tweetsArrayDataSource;
    [self.tableView registerClass:[TweetsResultCell class] forCellReuseIdentifier:TweetsCellIdentifier];
}

- (void)getTweets {
    
    [[UWBEAppDelegate sharedDelegate].twitterAPI searchTweetsWithQuery:self.query geocode:self.locationString complete:^(NSArray *array, NSDictionary *searchMetaData) {
        if (array && [array count]>0) {
            [self generateModelData:array];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"text is %@",cell.textLabel.text);
    NSLog(@"detailText is %@",cell.detailTextLabel.text);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.tweetsArrayDataSource itemCount]) {
        Tweet *tweet = (Tweet *)[self.tweetsArrayDataSource itemAtIndexPath:indexPath];
        if (tweet.desiredHeight != 0) {
            return ceil(tweet.desiredHeight);
        }
        
        UIFont *font = [UIFont YSBoldSystemFontOfSize:14.0f];
        CGFloat rowWidth = 320-50-10;
        CGFloat rowHeight = [NSString measureFrameHeightForText:tweet.text font:font constrainedToWidth:rowWidth].height;
        tweet.contentHeight = rowHeight;
        
        CGFloat nameHeight = [NSString measureFrameHeightForText:tweet.name font:font constrainedToWidth:rowWidth].height - 6;// minus 6 to compenate the single line
        tweet.nameHeight = nameHeight;
        rowHeight += (TableViewCellAdjustBottomHeight + nameHeight);
        
        tweet.desiredHeight = rowHeight;
        
        return ceil(tweet.desiredHeight);
    }
    return DEFAULT_CELL_HEIGHT;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"Save"];
    
    return rightUtilityButtons;
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSLog(@"More button was pressed");
            UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
            [alertTest show];
            
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
