//
//  ParallaxMapViewController.m
//  RDParallaxController-Sample
//
//  Created by Toni Möckel on 06.11.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "ParallaxMapViewController.h"
#import "SampleScrollViewController.h"
#import "RDParallaxController.h"

@interface ParallaxMapViewController ()
@property (nonatomic, weak) IBOutlet RDParallaxController *parallaxController;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@end

@implementation ParallaxMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    SampleScrollViewController *sampleBottomViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SampleScrollViewController"];

    [self.parallaxController setupWithTopView:self.mapView topHeight:200 bottomView:sampleBottomViewController.scrollView];
    self.parallaxController.fullHeight = self.view.frame.size.height-50.0f;
}

- (IBAction) dismiss:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
