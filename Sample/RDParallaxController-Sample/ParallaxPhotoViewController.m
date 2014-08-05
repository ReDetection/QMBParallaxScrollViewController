//
//  ParallaxPhotoViewController.m
//  RDParallaxController-Sample
//
//  Created by Toni Möckel on 07.11.13.
//  Copyright (c) 2014 ReDetection. All rights reserved.
//

#import "RDParallaxController.h"
#import "ParallaxPhotoViewController.h"
#import "KIImagePager.h"


@interface ParallaxPhotoViewController ()<RDParallaxControllerDelegate, KIImagePagerDataSource>
@property (nonatomic, weak) IBOutlet RDParallaxController *parallaxController;
@property (nonatomic, weak) IBOutlet KIImagePager *imagePagerView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *arrayWithImages;

@end

@implementation ParallaxPhotoViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.arrayWithImages = @[
        [UIImage imageNamed:@"NGC6559.jpg"],
        [UIImage imageNamed:@"2.jpg"],
        [UIImage imageNamed:@"3.jpg"],
        [UIImage imageNamed:@"1.jpg"],
        [UIImage imageNamed:@"4.jpg"],
    ];

    self.parallaxController.fullHeight = self.scrollView.frame.size.height - 50.0f;
}

- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - RDParallaxControllerDelegate

- (void)parallaxScrollViewController:(RDParallaxController *)controller didChangeState:(RDParallaxState)state{
    self.imagePagerView.slideshowTimeInterval = controller.state == RDParallaxStateFullSize ? 0 : 3;
}

#pragma mark - KIImagePagerDataSource

- (UIViewContentMode)contentModeForImage:(NSUInteger)image {
    return UIViewContentModeScaleAspectFill;
}


@end
