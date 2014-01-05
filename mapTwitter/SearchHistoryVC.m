//
//  SearchHistoryVC.m
//  mapTwitter
//
//  Created by Li Yansong on 13-12-28.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import "SearchHistoryVC.h"
#import "searchMapVC.h"

@interface SearchHistoryVC ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapAction:(id)sender
{
    searchMapVC *searchMap = [[searchMapVC alloc] init];
    [self.navigationController pushViewController:searchMap animated:YES];
}

@end
