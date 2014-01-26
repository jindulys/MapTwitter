//
//  searchMapVC.m
//  mapTwitter
//
//  Created by Li Yansong on 13-12-29.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import "searchMapVC.h"
#import <GoogleMaps/GoogleMaps.h>
#import "SearchPostView.h"
#import "IOS7CorrectedTextView.h"
#import "UWBEAppDelegate.h"
#import "TwitterAPI.h"
#import "TweetsResultVC.h"

#define SearchViewHeight 90

@interface searchMapVC () <GMSMapViewDelegate, SearchPostViewDelegate>
{
    GMSMapView *_mapView;
    GMSGeocoder *_geoCoder;
    CGFloat keyboardOffset;
}

@property (nonatomic, strong) GMSMarker *searchMarker;
@property (nonatomic) CLLocationCoordinate2D searchLocation;

@property (nonatomic) BOOL isFinishedShowCurrentLocation;

@property (nonatomic, strong) SearchPostView *searchPostView;
@property (nonatomic, copy) NSString *searchLocStr;

@end

@implementation searchMapVC

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
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(searchAction:)];
    self.navigationItem.rightBarButtonItem = button;
    
    // Create a GMSCameraPosition that tells the map to display the
    // Coordinate at current location
    GMSCameraPosition *camera = [GMSCameraPosition
                                 cameraWithLatitude:-33.86
                                          longitude:151.20
                                               zoom:6];
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    _mapView.myLocationEnabled = YES;
    _mapView.delegate = self;
    self.view = _mapView;
    
    _geoCoder = [[GMSGeocoder alloc] init];
    
    CGRect frame = CGRectMake(0.0f, self.view.bounds.size.height, 320, SearchViewHeight);
    self.searchPostView = [[SearchPostView alloc] initWithFrame:frame];
    _searchPostView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _searchPostView.navigationItem = self.navigationItem;
    _searchPostView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView removeObserver:self forKeyPath:@"myLocation"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"myLocation"]&&[object isKindOfClass:[GMSMapView class]]) {
        if (!self.isFinishedShowCurrentLocation) {
            [_mapView animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:_mapView.myLocation.coordinate.latitude longitude:_mapView.myLocation.coordinate.longitude zoom:16]];
            self.isFinishedShowCurrentLocation = YES;
        }
    }
}

#pragma mark - Private Methods
- (void)searchAction:(id)sender
{
    /* A Twitter Query Test Here
    NSString *query = @"waterloo";
    NSString *searchLocationStr = [self locationString];
    [self.twitterAPI getSearchTweetsWithQuery:query geocode:searchLocationStr lang:@"en" locale:nil resultType:nil count:@"100" until:nil sinceID:nil maxID:nil includeEntities:nil callback:nil successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
        if (statuses) {
            for (NSDictionary *dic in statuses) {
                NSLog(@"text is %@ \n",dic[@"text"]);
            }
        }
    } errorBlock:^(NSError *error) {
        NSLog(@"error is %@",error.description);
    }];
    */
    [self showSearchPostView];
    
}

- (void)showSearchPostView {
    if (_searchPostView.superview != nil) return;
    CGRect mapFrame = _mapView.frame;
    CGFloat y = mapFrame.origin.y + mapFrame.size.height - SearchViewHeight;
    _searchPostView.frame = CGRectMake(0.0f, y, self.view.bounds.size.width, SearchViewHeight);
    [self.view.superview addSubview:_searchPostView];
    [self.searchPostView.textView becomeFirstResponder];
}

- (void)hideSearchPostView {
    if (_searchPostView.superview == nil) return;
    
    [_searchPostView removeFromSuperview];
    [self.view endEditing:YES];
}

- (void)handleKeyboardDidShow:(NSNotification *)notification {
    UIView *view = self.view.superview;
    CGRect frame = view.frame;
    CGRect startFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGPoint point = [view.window convertPoint:startFrame.origin toView:view];
    keyboardOffset = point.y - (frame.origin.y + frame.size.height);
    
    point = [view.window convertPoint:endFrame.origin toView:view];
    CGSize tabBarSize = [self tabBarSize];
    frame.size.height = point.y + tabBarSize.height;
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        view.frame = frame;
    } completion:^(BOOL finished) {
    }];
}

- (void)handleKeyboardWillHide:(NSNotification *)notification {
    UIView *view = self.view.superview;
    CGRect frame = view.frame;
    
    CGRect keyFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGPoint point = [view.window convertPoint:keyFrame.origin toView:view];
    frame.size.height = point.y - (frame.origin.y + keyboardOffset);
    view.frame = frame;
}

- (NSString *)locationString
{
    NSString *locStr = [NSString stringWithFormat:@"%f,%f,500mi",self.searchLocation.latitude,self.searchLocation.longitude];
    return locStr;
}

- (CGSize)tabBarSize {
    CGSize tabBarSize = CGSizeZero;
    if ([self tabBarController]) {
        tabBarSize = [[[self tabBarController] tabBar] bounds].size;
    }
    return tabBarSize;
}

#pragma mark - SearchPostViewDelegate

- (void)SearchPostViewWillSend:(SearchPostView *)SearchPostView {
    [self hideSearchPostView];
    TweetsResultVC *vc = [[TweetsResultVC alloc] init];
    vc.query = [self.searchPostView text];
    vc.locationString = [self locationString];
    vc.searchLocStr = self.searchLocStr;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)SearchPostViewDidCancel:(SearchPostView *)SearchPostView {
    [self hideSearchPostView];
}

#pragma mark - GMSMapViewDelegate
- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    __weak GMSMapView *wmapView = _mapView;
    __weak searchMapVC *wself = self;
    GMSReverseGeocodeCallback handler = ^(GMSReverseGeocodeResponse *response, NSError *error) {
        GMSMapView *smapView = wmapView;
        if (response && response.firstResult) {
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = coordinate;
            marker.title = response.firstResult.addressLine1;
            wself.searchLocStr = marker.title;
            marker.snippet = response.firstResult.addressLine2;
            marker.appearAnimation = kGMSMarkerAnimationPop;
            [smapView clear];
            marker.map = smapView;
        }else{
            NSLog(@"Could not reverse geocode point (%f,%f): %@",coordinate.latitude,coordinate.longitude, error);
        }
    };
    self.searchLocation = coordinate;
    [_geoCoder reverseGeocodeCoordinate:coordinate completionHandler:handler];
}
@end
