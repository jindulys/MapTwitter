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

static NSString *const TweetsCellIdentifier = @"TweetCell";

@interface TweetsResultVC ()

@property (nonatomic, strong) ArrayDataSource *tweetsArrayDataSource;

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
    [self getTweets];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTableViewWithData:(NSArray *)dataArray {
    TableViewCellConfigureBlock configureCell = ^(UITableViewCell *cell, NSDictionary *dic) {
        NSDictionary *diction = (NSDictionary *)dic;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        NSDictionary *userdic = diction[@"user"];
        [cell.textLabel setText:userdic[@"name"]];
        [cell.detailTextLabel setText:diction[@"text"]];
    };
    self.tweetsArrayDataSource = [[ArrayDataSource alloc] initWithItem:dataArray cellIdentifier:TweetsCellIdentifier configuerCellBlock:configureCell];
    self.tableView.dataSource = self.tweetsArrayDataSource;
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TweetsCellIdentifier];
}

- (void)getTweets {
    
    [[UWBEAppDelegate sharedDelegate].twitterAPI searchTweetsWithQuery:self.query geocode:self.locationString complete:^(NSArray *array, NSDictionary *searchMetaData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupTableViewWithData:array];
            [self.tableView reloadData];
        });
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"text is %@",cell.textLabel.text);
    NSLog(@"detailText is %@",cell.detailTextLabel.text);
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
