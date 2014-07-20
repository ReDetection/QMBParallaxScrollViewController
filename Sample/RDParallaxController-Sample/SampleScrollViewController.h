//
//  SampleScrollViewController.h
//  RDParallaxController-Sample
//
//  Created by Toni Möckel on 02.11.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SampleScrollViewController : UIViewController<UIScrollViewDelegate, UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)closeButtonTouchUpInside:(id)sender;

@end
