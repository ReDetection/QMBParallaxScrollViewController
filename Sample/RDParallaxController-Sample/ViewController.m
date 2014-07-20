//
//  ViewController.m
//  RDParallaxController-Sample
//
//  Created by Toni Möckel on 02.11.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import "ViewController.h"
#import "RDParallaxController.h"

@interface ViewController ()<QMBParallaxScrollViewControllerDelegate>
@property (nonatomic, weak) IBOutlet RDParallaxController *parallaxController;
@property (nonatomic, weak) IBOutlet UIImageView *topView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.parallaxController setupWithTopView:self.topView topHeight:200 bottomView:self.tableView];
    self.parallaxController.delegate = self;
    self.parallaxController.overPanHeight = 250;
}

#pragma mark - QMBParallaxScrollViewControllerDelegate

- (void)parallaxScrollViewController:(RDParallaxController *)controller didChangeTopHeight:(CGFloat)height {
    [self.topView setAlpha:MAX(.7f,height/self.parallaxController.fullHeight)];
}

@end
