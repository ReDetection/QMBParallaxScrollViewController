//
//  RDParallaxController.h
//  RDParallaxController-Sample
//
//  Created by Toni Möckel on 02.11.13.
//  Copyright (c) 2014 ReDetection. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RDParallaxController;

typedef NS_ENUM(NSUInteger, RDParallaxState) {
    RDParallaxStateVisible = 0,
    RDParallaxStateFullSize = 1,
    RDParallaxStateHidden = 2,
};

typedef NS_ENUM(NSUInteger, RDParallaxGesture) {
    RDParallaxGestureTopViewTap = 0,
    RDParallaxGestureScrollsDown = 1,
    RDParallaxGestureScrollsUp = 2,
};

@protocol RDParallaxControllerDelegate <NSObject>

@optional

/**
 * Callback when the user tapped the top-view 
 * sender is usually the UITapGestureRecognizer instance
 */
- (void) parallaxScrollViewController:(RDParallaxController *) controller didChangeGesture:(RDParallaxGesture)newGesture oldGesture:(RDParallaxGesture)oldGesture;

/**
 * Callback when the state changed to RDParallaxStateFullSize, RDParallaxStateVisible or RDParallaxStateHidden
 */
- (void) parallaxScrollViewController:(RDParallaxController *) controller didChangeState:(RDParallaxState) state;

/**
 * Callback when the top height changed
 */
- (void) parallaxScrollViewController:(RDParallaxController *) controller didChangeTopHeight:(CGFloat) height;

@end



@interface RDParallaxController : NSObject<UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UIView *topView;
@property (nonatomic, strong) IBOutlet UIScrollView *bottomScrollView;
@property (nonatomic, strong) IBOutlet id<RDParallaxControllerDelegate> delegate;

@property (nonatomic, assign) CGFloat topHeight;
@property (nonatomic, assign, setter = setOverPanHeight:) CGFloat overPanHeight;

@property (nonatomic, readonly) RDParallaxState state;
- (void)parallaxScrollViewDidScroll:(CGPoint)contentOffset;

/**
* Configures topView height for RDParallaxStateFullSize state.
* Setting this property will take effect on bottomGap
*/
@property (nonatomic, assign, setter = setFullHeight:) CGFloat fullHeight;

/**
* Setter calculates and sets fullHeight property. It is useful when configuring RDParallaxController from interface builder
* This property is not KVO-compliant.
*/
@property (nonatomic, assign) CGFloat bottomGap;

/**
 * Config to enable or disable top-view tap control
 * Call will be responsed by RDParallaxControllerDelegate instance
 */
- (void) enableTapGestureTopView:(BOOL) enable;

/**
 * Expands top view to the RDParallaxStateFullSize state
 */
- (void)showFullTopView:(BOOL)show;

@end
