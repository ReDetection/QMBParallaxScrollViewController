//
//  ViewController.m
//  RDParallaxController-Sample
//
//  Created by Toni Möckel on 02.11.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import "ViewController.h"
#import "RDParallaxController.h"
#import "SampleTableViewController.h"

@interface ViewController ()<QMBParallaxScrollViewControllerDelegate>
@property (nonatomic, weak) IBOutlet RDParallaxController *parallaxController;
@property (nonatomic, strong) UIViewController *topViewController;
@property (nonatomic, strong) SampleTableViewController *sampleTableViewController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //TODO get rid of topViewController, place that view into storyboard directly
    
    self.sampleTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SampleTableViewController"];
    
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SampleTopViewController"];
    self.parallaxController.delegate = self;
    
    [self.view addSubview:self.sampleTableViewController.tableView];
    [self.view addSubview:self.topViewController.view];

    [self.parallaxController setupWithTopView:self.topViewController.view topHeight:200 bottomView:self.sampleTableViewController.tableView];
    self.parallaxController.overPanHeight = 250;

    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - QMBParallaxScrollViewControllerDelegate

- (void)parallaxScrollViewController:(RDParallaxController *)controller didChangeState:(QMBParallaxState)state {
    NSLog(@"didChangeState %d",state);
    [self.navigationController setNavigationBarHidden:state == QMBParallaxStateFullSize animated:YES];
    
}

- (void)parallaxScrollViewController:(RDParallaxController *)controller didChangeTopHeight:(CGFloat)height {
    [self.topViewController.view setAlpha:MAX(.7f,height/self.parallaxController.fullHeight)];
}

- (void)parallaxScrollViewController:(RDParallaxController *)controller didChangeGesture:(QMBParallaxGesture)newGesture oldGesture:(QMBParallaxGesture)oldGesture {
    
}

@end
