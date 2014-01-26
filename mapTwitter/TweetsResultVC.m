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
#import "ResultTweet+create.h"

#define TableViewCellAdjustBottomHeight (12 + 5 + 8)
#define DEFAULT_CELL_HEIGHT 44

static NSString *const TweetsCellIdentifier = @"TweetCell";

@interface TweetsResultVC ()

@property (nonatomic, strong) ArrayDataSource *tweetsArrayDataSource;
@property (nonatomic) BOOL didSaveTweets;
@property (nonatomic, strong) SearchInfo *searchInfo;
@property (nonatomic, strong) NSManagedObjectContext *context;

@property (nonatomic, strong) NSURLSession *session;
// If we are in the searchInfoResult Mode.
@property (nonatomic) BOOL isSearchInfoResults;

@end

@implementation TweetsResultVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    return self;
}

- (id)initWithSearchInfo:(SearchInfo *)searchInfo {
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        //set the searchInfoResult Mode.
        self.searchInfo = searchInfo;
        self.isSearchInfoResults = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Tweets";
    
    if (!self.isSearchInfoResults) {
        [self buildSearchInfoObject];
        [self getTweets];
    } else {
        [self generateModelDataFromSearchInfo];
    }
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

#pragma mark - Normal Twitter Request Mode.

- (void)buildSearchInfoObject {
    
    self.context = [UWBEAppDelegate sharedDelegate].persistentStack.managedObjectContext;
    NSDate *date = [NSDate date];
    self.searchInfo = [SearchInfo insertSearchInfoWithLocation:self.searchLocStr searchTitle:self.query searchTime:date inManagedObjectContext:self.context];
}

- (void)getTweets {
    [[UWBEAppDelegate sharedDelegate].twitterAPI searchTweetsWithQuery:self.query geocode:self.locationString complete:^(NSArray *array, NSDictionary *searchMetaData) {
        if (array && [array count]>0) {
            [self generateModelData:array];
        }
    }];
}

- (void)generateModelData:(NSArray *)array {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
        // Test:
        NSMutableArray *tweetsTextArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in array) {
            NSDictionary *userdic = dic[@"user"];
            Tweet *tweet = [[Tweet alloc] init];
            tweet.name = userdic[@"name"];
            tweet.profileImageURL = userdic[@"profile_image_url"];
            tweet.text = dic[@"text"];
            [resultsArray addObject:tweet];
            [tweetsTextArray addObject:tweet];
        }
        [self postTweetsToRemoteServer:tweetsTextArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupTableViewWithData:resultsArray];
            [self.tableView reloadData];
        });
    });
}

# pragma mark - post to remote server

- (void)postTweetsToRemoteServer:(NSMutableArray *)tweetsArray {
    NSMutableString *requestStr = [[NSMutableString alloc] init];
    
    static NSString *seperator = @"!/-_";
//    for (Tweet *tweet in tweetsArray) {
//        [requestStr appendFormat:@"%@%@",tweet.text,seperator];
//    }
    Tweet *tweet = [tweetsArray lastObject];
    [requestStr appendFormat:@"%@%@",tweet.text,seperator];
    NSString *finalStr;
    if (requestStr.length > 0) {
        finalStr = [requestStr substringToIndex:[requestStr length]-4];
    }
    
    NSString *remoteURL = [NSString stringWithFormat:@"http://map-twitter.appspot.com/process?data=%@",finalStr];
    NSURL *url = [NSURL URLWithString:remoteURL];
    [[_session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
            if (httpResp.statusCode == 200) {
                NSError *jsonError;
                NSArray *tweetsJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                NSMutableArray *returnTweets = [[NSMutableArray alloc] init];
                
                if (!jsonError) {
                    for (NSDictionary *TweetsMetadata in
                         tweetsJSON) {
                    }
                }
            }
        }
    }] resume];
}

# pragma mark - searchInfo Mode

- (void)generateModelDataFromSearchInfo {
    NSSet *tweetSet = self.searchInfo.tweets;
    NSMutableArray *tweetArray = [NSMutableArray arrayWithArray:[tweetSet allObjects]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    [tweetArray sortUsingDescriptors:@[sortDescriptor]];
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    [tweetArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Tweet *tweet = [self createTweetWithResultTweet:obj];
        [results addObject:tweet];
    }];
    [self setupTableViewWithData:(NSArray *)results];
}

- (Tweet *)createTweetWithResultTweet:(id)obj {
    ResultTweet *result = obj;
    Tweet *tweet = [[Tweet alloc] init];
    tweet.name = result.name;
    tweet.profileImageURL = result.profileURL;
    tweet.text = result.text;
    return tweet;
}

# pragma mark - common private methods

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    if (self.isSearchInfoResults) {
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                    title:@"Delete"];
    } else {
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                    title:@"Save"];
    }
    return rightUtilityButtons;
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

# pragma mark - UITableViewDelegate

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



#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            Tweet *tweet = [self.tweetsArrayDataSource itemAtIndexPath:indexPath];
            [ResultTweet insertResultTweetWithName:tweet.name profileURL:tweet.profileImageURL text:tweet.text searchInfo:self.searchInfo inManagedObjectContext:self.context];
            
            [cell hideUtilityButtonsAnimated:YES];
            self.didSaveTweets = YES;
            break;
        }
        
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}

@end
