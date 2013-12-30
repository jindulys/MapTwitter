//
//  searchMapVC.m
//  mapTwitter
//
//  Created by Li Yansong on 13-12-29.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import "searchMapVC.h"
#import <GoogleMaps/GoogleMaps.h>

@interface searchMapVC () <GMSMapViewDelegate>
{
    GMSMapView *_mapView;
    GMSGeocoder *_geoCoder;
}

@property (nonatomic, strong) GMSMarker *searchMarker;
@property (nonatomic) CLLocationCoordinate2D searchLocation;

@property (nonatomic) BOOL isFinishedShowCurrentLocation;

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView removeObserver:self forKeyPath:@"myLocation"];
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

- (void)searchAction:(id)sender
{
    NSLog(@"Search btn pressed");
}

#pragma mark - GMSMapViewDelegate
- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    __weak GMSMapView *wmapView = _mapView;
    GMSReverseGeocodeCallback handler = ^(GMSReverseGeocodeResponse *response, NSError *error) {
        GMSMapView *smapView = wmapView;
        if (response && response.firstResult) {
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = coordinate;
            marker.title = response.firstResult.addressLine1;
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
