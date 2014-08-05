//
//  RDParallaxController.m
//  RDParallaxController-Sample
//
//  Created by Toni Möckel on 02.11.13.
//  Copyright (c) 2014 ReDetection. All rights reserved.
//

#import "RDParallaxController.h"

@interface RDParallaxController (){
    BOOL _isAnimating;
    float _lastOffsetY;
}

@property (nonatomic, strong) UITapGestureRecognizer *topViewGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *bottomViewGestureRecognizer;
@property (nonatomic, assign) CGFloat currentTopHeight;

@property (nonatomic, assign, readwrite) CGFloat topHeight;
@property (nonatomic, readwrite) RDParallaxState state;
@property (nonatomic, readwrite) RDParallaxGesture lastGesture;

@property (atomic, assign) BOOL observersRegistered;

@end

@implementation RDParallaxController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.topViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.topViewGestureRecognizer setNumberOfTouchesRequired:1];
        [self.topViewGestureRecognizer setNumberOfTapsRequired:1];

        self.bottomViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBottomTouch:)];
        [self.bottomViewGestureRecognizer setNumberOfTouchesRequired:1];

        [self addObserver:self forKeyPath:@"observersRegistered" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    }
    return self;
}

#pragma mark - RDParallaxController Methods

- (void)setupWithTopView:(UIView *)topView topHeight:(CGFloat)height bottomView:(UIScrollView *)bottomView {
    self.observersRegistered = NO;
    self.topHeight = height;
    [self changeTopHeight:height];
    [self setOverPanHeight:height * 1.5];
    [self checkAndSetup];
}

- (void)setBottomScrollView:(UIScrollView *)bottomView {
    self.observersRegistered = NO;
    [_bottomScrollView removeObserver:self forKeyPath:@"contentOffset"];
    _bottomScrollView = bottomView;

    [_bottomScrollView setClipsToBounds:YES];
    _bottomScrollView.alwaysBounceVertical = YES;
    self.fullHeight = _bottomScrollView.frame.size.height;
    [_bottomScrollView setUserInteractionEnabled:YES];
    [self changeTopHeight:self.topHeight];
    [self checkAndSetup];
}

- (void)setTopView:(UIView *)topView {
    if ([[topView gestureRecognizers] containsObject:self.topViewGestureRecognizer]) {
        [topView removeGestureRecognizer:self.topViewGestureRecognizer];
    }
    _topView = topView;
    [topView setClipsToBounds:YES];
    [topView setAutoresizingMask:UIViewAutoresizingNone];

    [topView setUserInteractionEnabled:YES];
    [self enableTapGestureTopView:YES];    //todo check config in the interface
    [self checkAndSetup];
}

- (void)checkAndSetup {
    if (self.topView != nil && self.bottomScrollView != nil) {
        self.observersRegistered = YES;
    }
}

#pragma mark - Observer

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"]){
        [self parallaxScrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];

    } else if ([keyPath isEqualToString:@"state"]){
        BOOL valuesAreEqual = [change[NSKeyValueChangeOldKey] intValue] == [change[NSKeyValueChangeNewKey] intValue];
        BOOL shouldNotifyDelegate = [self.delegate respondsToSelector:@selector(parallaxScrollViewController:didChangeState:)];
        if ( !valuesAreEqual && shouldNotifyDelegate){
            [self.delegate parallaxScrollViewController:self didChangeState:(RDParallaxState) [change[NSKeyValueChangeNewKey] intValue]];
        }

    } else if ([keyPath isEqualToString:@"observersRegistered"]) {
        BOOL old = [change[NSKeyValueChangeOldKey] boolValue];
        BOOL new = [change[NSKeyValueChangeNewKey] boolValue];

        if (!old && new) {
            [_bottomScrollView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
            [self addObserver:self forKeyPath:@"state" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];

        } else if (old && !new) {
            [_bottomScrollView removeObserver:self forKeyPath:@"contentOffset"];
            [self removeObserver:self forKeyPath:@"state"];
        }
    }
}


- (void)dealloc{
    self.observersRegistered = NO;
    [self removeObserver:self forKeyPath:@"observersRegistered"];
}
#pragma mark - Configs

- (void)setFullHeight:(CGFloat)fullHeight{

    _fullHeight = MAX(fullHeight, _topHeight);
    
}

- (void)setOverPanHeight:(CGFloat)overPanHeight{
    
    _overPanHeight = MAX(_topHeight,overPanHeight);
    
}

- (void) changeTopHeight:(CGFloat) height{
    self.topView.frame = CGRectMake(_bottomScrollView.frame.origin.x, _bottomScrollView.frame.origin.y, _bottomScrollView.frame.size.width, height);
    _bottomScrollView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);
    _currentTopHeight = height;

    if ([self.delegate respondsToSelector:@selector(parallaxScrollViewController:didChangeTopHeight:)]){
        [self.delegate parallaxScrollViewController:self didChangeTopHeight:height];
    }
}

#pragma mark - ScrollView Methods

- (void)parallaxScrollViewDidScroll:(CGPoint)contentOffset {
    
    if (_bottomScrollView.contentOffset.y > _lastOffsetY){
        self.lastGesture = RDParallaxGestureScrollsUp;
    }else {
        self.lastGesture = RDParallaxGestureScrollsDown;
    }
    _lastOffsetY = _bottomScrollView.contentOffset.y;
    
    if (_isAnimating){
        return;
    }
    float y = _bottomScrollView.contentOffset.y + _currentTopHeight;
    
    /*
     * if top-view height is full screen
     * dont resize top view -> Fullscreen Mode
     */
    if (self.lastGesture == RDParallaxGestureScrollsDown && _bottomScrollView.contentOffset.y < -_overPanHeight){
        if (self.state != RDParallaxStateFullSize){
            [self showFullTopView:YES];
        }
        
        return;
    }
    
    if (self.state == RDParallaxStateFullSize && self.lastGesture == RDParallaxGestureScrollsUp){
        [self showFullTopView:NO];
        return;
    }
    
    if (y > 0) {
        
        CGFloat newHeight = _currentTopHeight - y;

        [self.topView setHidden:(newHeight <= 0)];

        if (!self.topView.hidden) {

            self.topView.frame = CGRectMake(_bottomScrollView.frame.origin.x, _bottomScrollView.frame.origin.y, _bottomScrollView.frame.size.width, newHeight);

            if ([self.delegate respondsToSelector:@selector(parallaxScrollViewController:didChangeTopHeight:)]){
                [self.delegate parallaxScrollViewController:self didChangeTopHeight:self.topView.frame.size.height];
            }
            
        }
        
        if (y >= _topHeight) {
            _bottomScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } else {
            _bottomScrollView.contentInset = UIEdgeInsetsMake(_currentTopHeight - y , 0, 0, 0);
        }
        
 
    } else {

        [self.topView setHidden:NO];

        CGFloat newHeight = _currentTopHeight - y;
        CGRect newFrame =  CGRectMake(_bottomScrollView.frame.origin.x, _bottomScrollView.frame.origin.y, _bottomScrollView.frame.size.width, newHeight);
        self.topView.frame = newFrame;
        if ([self.delegate respondsToSelector:@selector(parallaxScrollViewController:didChangeTopHeight:)]){
            [self.delegate parallaxScrollViewController:self didChangeTopHeight:self.topView.frame.size.height];
        }
        
        _bottomScrollView.contentInset = UIEdgeInsetsMake(_currentTopHeight, 0, 0, 0);
    }

    [_bottomScrollView setShowsVerticalScrollIndicator:self.topView.hidden];
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
    
    self.lastGesture = RDParallaxGestureTopViewTap;
    
    [self showFullTopView: self.state != RDParallaxStateFullSize];
    
}

- (void) handleBottomTouch:(id)sender {
    
    if (self.state == RDParallaxStateFullSize){
        [self showFullTopView:NO];
    }
    
    
}

- (void) showFullTopView:(BOOL)show {

    _isAnimating = YES;
    
    [_bottomScrollView setScrollEnabled:NO];
    [_bottomScrollView scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];


    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self changeTopHeight:show ?  _fullHeight : _topHeight];

    } completion:^(BOOL finished) {
        [_bottomScrollView setContentOffset:CGPointMake(0, -_bottomScrollView.contentInset.top) animated:NO];
        [_bottomScrollView setScrollEnabled:YES];
        _isAnimating = NO;

        self.state = show ? RDParallaxStateFullSize : RDParallaxStateVisible;
    }];

}



@end
