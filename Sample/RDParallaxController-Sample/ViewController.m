//
//  ViewController.m
//  RDParallaxController-Sample
//
//  Created by Toni Möckel on 02.11.13.
//  Copyright (c) 2014 ReDetection. All rights reserved.
//

#import "ViewController.h"
#import "RDParallaxController.h"

@interface ViewController ()<RDParallaxControllerDelegate>
@property (nonatomic, weak) IBOutlet RDParallaxController *parallaxController;
@property (nonatomic, weak) IBOutlet UIImageView *topView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.parallaxController.overPanHeight = 250;
}

#pragma mark - RDParallaxControllerDelegate

- (void)parallaxScrollViewController:(RDParallaxController *)controller didChangeTopHeight:(CGFloat)height {
    [self.topView setAlpha:MAX(.7f,height/self.parallaxController.fullHeight)];
}

@end
