//
//  QMBParallaxController.m
//  QMBParallaxScrollView-Sample
//
//  Created by Toni Möckel on 02.11.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import "QMBParallaxController.h"

@interface QMBParallaxController (){
    BOOL _isAnimating;
    float _lastOffsetY;
}

@property (nonatomic, strong) UITapGestureRecognizer *topViewGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *bottomViewGestureRecognizer;
@property (nonatomic, strong) UIScrollView *parallaxScrollView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, assign) CGFloat currentTopHeight;

@property (nonatomic, assign, readwrite) CGFloat topHeight;
@property (nonatomic, readwrite) QMBParallaxState state;
@property (nonatomic, readwrite) QMBParallaxGesture lastGesture;

@end

@implementation QMBParallaxController

#pragma mark - QMBParallaxController Methods

- (void)setupWithTopView:(UIView *)topView topHeight:(CGFloat)height bottomView:(UIScrollView *)bottomView {

    self.topView = topView;
    self.topHeight = height;

    [topView setClipsToBounds:YES];
    [bottomView setClipsToBounds:YES];

    [topView setAutoresizingMask:UIViewAutoresizingNone];
    _parallaxScrollView = bottomView;
    _parallaxScrollView.alwaysBounceVertical = YES;
    
    //Configs
    
    [self changeTopHeight:height];
    [self setOverPanHeight:height * 1.5];
    [self setFullHeight:_parallaxScrollView.frame.size.height];

    self.topViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.topViewGestureRecognizer setNumberOfTouchesRequired:1];
    [self.topViewGestureRecognizer setNumberOfTapsRequired:1];
    [self.topView setUserInteractionEnabled:YES];
    [self enableTapGestureTopView:YES];
    
    self.bottomViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBottomTouch:)];
    [self.bottomViewGestureRecognizer setNumberOfTouchesRequired:1];
    [bottomView setUserInteractionEnabled:YES];

    //Register Observer
    [_parallaxScrollView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    [self addObserver:self forKeyPath:@"state" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    
}

#pragma mark - Observer

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"]){
        [self parallaxScrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    }
    
    if([keyPath isEqualToString:@"state"]){
        if ([[change valueForKey:NSKeyValueChangeOldKey] intValue] == [[change valueForKey:NSKeyValueChangeNewKey] intValue]){
            return;
        }
        if ([self.delegate respondsToSelector:@selector(parallaxScrollViewController:didChangeState:)]){
            [(id<QMBParallaxScrollViewControllerDelegate>) self.delegate parallaxScrollViewController:self didChangeState:[[change valueForKey:NSKeyValueChangeNewKey] intValue]];
        }

    }

}


- (void)dealloc{
    [_parallaxScrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self removeObserver:self forKeyPath:@"state"];
}
#pragma mark - Configs

- (void)setFullHeight:(CGFloat)fullHeight{

    _fullHeight = MAX(fullHeight, _topHeight);
    
}

- (void)setOverPanHeight:(CGFloat)overPanHeight{
    
    _overPanHeight = MAX(_topHeight,overPanHeight);
    
}

- (void) changeTopHeight:(CGFloat) height{
    self.topView.frame = CGRectMake(_parallaxScrollView.frame.origin.x, _parallaxScrollView.frame.origin.y, _parallaxScrollView.frame.size.width, height);
    _parallaxScrollView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);
    _currentTopHeight = height;

    if ([self.delegate respondsToSelector:@selector(parallaxScrollViewController:didChangeTopHeight:)]){
        [self.delegate parallaxScrollViewController:self didChangeTopHeight:height];
    }
}

#pragma mark - ScrollView Methods

- (void)parallaxScrollViewDidScroll:(CGPoint)contentOffset {
    
    if (_parallaxScrollView.contentOffset.y > _lastOffsetY){
        self.lastGesture = QMBParallaxGestureScrollsUp;
    }else {
        self.lastGesture = QMBParallaxGestureScrollsDown;
    }
    _lastOffsetY = _parallaxScrollView.contentOffset.y;
    
    if (_isAnimating){
        return;
    }
    float y = _parallaxScrollView.contentOffset.y + _currentTopHeight;
    
    /*
     * if top-view height is full screen
     * dont resize top view -> Fullscreen Mode
     */
    if (self.lastGesture == QMBParallaxGestureScrollsDown && _parallaxScrollView.contentOffset.y < -_overPanHeight){
        if (self.state != QMBParallaxStateFullSize){
            [self showFullTopView:YES];
        }
        
        return;
    }
    
    if (self.state == QMBParallaxStateFullSize && self.lastGesture == QMBParallaxGestureScrollsUp){
        [self showFullTopView:NO];
        return;
    }
    
    if (y > 0) {
        
        CGFloat newHeight = _currentTopHeight - y;

        [self.topView setHidden:(newHeight <= 0)];

        if (!self.topView.hidden) {

            self.topView.frame = CGRectMake(_parallaxScrollView.frame.origin.x, _parallaxScrollView.frame.origin.y, _parallaxScrollView.frame.size.width, newHeight);

            if ([self.delegate respondsToSelector:@selector(parallaxScrollViewController:didChangeTopHeight:)]){
                [self.delegate parallaxScrollViewController:self didChangeTopHeight:self.topView.frame.size.height];
            }
            
        }
        
        if (y >= _topHeight) {
            _parallaxScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } else {
            _parallaxScrollView.contentInset = UIEdgeInsetsMake(_currentTopHeight - y , 0, 0, 0);
        }
        
 
    } else {

        [self.topView setHidden:NO];

        CGFloat newHeight = _currentTopHeight - y;
        CGRect newFrame =  CGRectMake(_parallaxScrollView.frame.origin.x, _parallaxScrollView.frame.origin.y, _parallaxScrollView.frame.size.width, newHeight);
        self.topView.frame = newFrame;
        if ([self.delegate respondsToSelector:@selector(parallaxScrollViewController:didChangeTopHeight:)]){
            [self.delegate parallaxScrollViewController:self didChangeTopHeight:self.topView.frame.size.height];
        }
        
        _parallaxScrollView.contentInset = UIEdgeInsetsMake(_currentTopHeight, 0, 0, 0);
    }

    [_parallaxScrollView setShowsVerticalScrollIndicator:self.topView.hidden];
}

#pragma mark - User Interactions

- (void)enableTapGestureTopView:(BOOL)enable{
    if (enable) {
        [self.topView addGestureRecognizer:self.topViewGestureRecognizer];
    }else {
        [self.topView removeGestureRecognizer:self.topViewGestureRecognizer];
    }
}

- (void) handleTap:(id)sender {
    
    self.lastGesture = QMBParallaxGestureTopViewTap;
    
    [self showFullTopView: self.state != QMBParallaxStateFullSize];
    
}

- (void) handleBottomTouch:(id)sender {
    
    if (self.state == QMBParallaxStateFullSize){
        [self showFullTopView:NO];
    }
    
    
}

- (void) showFullTopView:(BOOL)show {

    _isAnimating = YES;
    
    [_parallaxScrollView setScrollEnabled:NO];
    [_parallaxScrollView scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];


    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self changeTopHeight:show ?  _fullHeight : _topHeight];

    } completion:^(BOOL finished) {
        [_parallaxScrollView setContentOffset:CGPointMake(0,- _parallaxScrollView.contentInset.top) animated:NO];
        [_parallaxScrollView setScrollEnabled:YES];
        _isAnimating = NO;

        self.state = show ? QMBParallaxStateFullSize : QMBParallaxStateVisible;
    }];

}



@end