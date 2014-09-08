//
//  ParallaxMapViewController.m
//  RDParallaxController-Sample
//
//  Created by Toni Möckel on 06.11.13.
//  Copyright (c) 2014 ReDetection. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "ParallaxMapViewController.h"
#import "RDParallaxController.h"

@interface ParallaxMapViewController ()
@property (nonatomic, weak) IBOutlet RDParallaxController *parallaxController;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@end

@implementation ParallaxMapViewController

- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
