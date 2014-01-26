//
//  SearchHistoryVC.m
//  mapTwitter
//
//  Created by Li Yansong on 13-12-28.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import "SearchHistoryVC.h"
#import "searchMapVC.h"
#import "FetchResultsControllerDataSource.h"
#import "SearchInfo+create.h"
#import "UWBEAppDelegate.h"
#import "PersistentStack.h"
#import "SearchHistoryCell.h"
#import "TweetsResultVC.h"

#define DEFAULT_CELL_HEIGHT 80

@interface SearchHistoryVC () <FetchedResultsControllerDataSourceDelegate>

@property (nonatomic, strong) FetchResultsControllerDataSource *fetchResultsControllerDataSource;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation SearchHistoryVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Search History";
    
    // Map Button
    UIBarButtonItem *button = nil;
    UIButton *topicsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [topicsButton setImage:[UIImage imageNamed:@"icon-reader-topics"] forState:UIControlStateNormal];
    [topicsButton setImage:[UIImage imageNamed:@"icon-reader-topics-active"] forState:UIControlStateHighlighted];
    
    CGSize imageSize = [UIImage imageNamed:@"icon-reader-topics"].size;
    topicsButton.frame = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
    topicsButton.contentEdgeInsets = UIEdgeInsetsMake(0, 16, 0, -16);
    [topicsButton addTarget:self action:@selector(mapAction:) forControlEvents:UIControlEventTouchUpInside];
    
    button = [[UIBarButtonItem alloc] initWithCustomView:topicsButton];
    self.navigationItem.rightBarButtonItem = button;
    [self setupFetchedResultsController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.fetchResultsControllerDataSource.paused = NO;
    [self.fetchResultsControllerDataSource refreshData];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.fetchResultsControllerDataSource.paused = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupFetchedResultsController {
    self.fetchResultsControllerDataSource = [[FetchResultsControllerDataSource alloc] initWithTableView:self.tableView];
    self.fetchResultsControllerDataSource.fetchedResultsController = [SearchInfo AllSearchInfoFetchedResultsControllerWithContext:self.context];
    self.fetchResultsControllerDataSource.delegate = self;
    self.fetchResultsControllerDataSource.reuseIdentifier = @"HistoryCell";
    [self.tableView registerClass:[SearchHistoryCell class] forCellReuseIdentifier:@"HistoryCell"];
}

- (NSManagedObjectContext *)context {
    return [UWBEAppDelegate sharedDelegate].persistentStack.managedObjectContext;
}

- (void)mapAction:(id)sender
{
    searchMapVC *searchMap = [[searchMapVC alloc] init];
    [self.navigationController pushViewController:searchMap animated:YES];
}

#pragma mark Fetched Results Controller Delegate

- (void)configureCell:(id)theCell withObject:(id)object
{
    SearchHistoryCell *cell = theCell;
    
    [cell setCellHeight:DEFAULT_CELL_HEIGHT];
    cell.containingTableView = self.tableView;
    //cell.rightUtilityButtons = [self rightButtons];
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
    [cell setModel:(SearchInfo *)object];
}

- (void)deleteObject:(id)object
{
    SearchInfo *info = object;
    [self.context deleteObject:info];
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
  
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return DEFAULT_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchInfo *searchInfo = [self.fetchResultsControllerDataSource.fetchedResultsController objectAtIndexPath:indexPath];
    TweetsResultVC *vc = [[TweetsResultVC alloc] initWithSearchInfo:searchInfo];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
