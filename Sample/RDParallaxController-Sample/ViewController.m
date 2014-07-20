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
@property (nonatomic, weak) IBOutlet UIImageView *topView;
@property (nonatomic, strong) SampleTableViewController *sampleTableViewController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sampleTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SampleTableViewController"];
    
    self.parallaxController.delegate = self;
    
    [self.view insertSubview:self.sampleTableViewController.tableView belowSubview:self.topView];

    [self.parallaxController setupWithTopView:self.topView topHeight:200 bottomView:self.sampleTableViewController.tableView];
    self.parallaxController.overPanHeight = 250;

    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - QMBParallaxScrollViewControllerDelegate

- (void)parallaxScrollViewController:(RDParallaxController *)controller didChangeTopHeight:(CGFloat)height {
    [self.topView setAlpha:MAX(.7f,height/self.parallaxController.fullHeight)];
}

- (void)parallaxScrollViewController:(RDParallaxController *)controller didChangeGesture:(QMBParallaxGesture)newGesture oldGesture:(QMBParallaxGesture)oldGesture {
    
}

@end
