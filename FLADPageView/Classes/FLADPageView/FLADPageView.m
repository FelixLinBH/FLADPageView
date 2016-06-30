//
//  FLADPageView.m
//  Pods
//
//  Created by Felix.lin on 2016/6/28.
//
//

#import "FLADPageView.h"
#import "TAPageControl.h"
#import "Masonry.h"
#import "FLADPageView.h"
#import "FLADAnimatedImageView.h"


#define DefaultDotHeight 15
#define DefaultAutoScrollTimeInterval 3

@interface FLADPageView()<UIScrollViewDelegate,TAPageControlDelegate>
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) TAPageControl *pageControl;
@property (nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) BOOL isTouch;
@property (nonatomic, assign) BOOL isAdjustContentSize;
@end

@implementation FLADPageView

#pragma mark - leftcycle

- (instancetype)init{
    self = [super init];
    if (self) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc]init];
        [_tapGestureRecognizer addTarget:self action:@selector(didTapView)];
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _dotHeight = DefaultDotHeight;
        [_scrollView addGestureRecognizer:_tapGestureRecognizer];
        _pageControl = [[TAPageControl alloc]init];
        _pageControl.delegate = self;
        [self addSubview:_scrollView];
        [self addSubview:_pageControl];
        [DFImageManagerConfiguration setAllowsProgressiveImage:YES];
    }
    return self;
}

- (void)dealloc{
     [DFImageManagerConfiguration setAllowsProgressiveImage:NO];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _isAdjustContentSize = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * (self.dataSource.count + 2), self.scrollView.frame.size.height);
    
    if (!self.scrollView.contentOffset.x) {
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
    }else{
        [self scrollToPageWithIndex:self.pageControl.currentPage + 1];
    }
    
}


- (void)updateConstraints {
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.dotHeight);
        make.centerX.equalTo(self.scrollView);
        make.bottom.equalTo(self.scrollView.mas_bottom);
        make.width.equalTo(self.scrollView);
    }];
    
    [super updateConstraints];
}

#pragma mark - set

- (void)setDotImage:(UIImage *)dotImage{
    _pageControl.dotImage = dotImage;
}

- (void)setCurrentDotImage:(UIImage *)currentDotImage{
    _pageControl.currentDotImage = currentDotImage;
}

- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    _pageControl.numberOfPages = dataSource.count;
    _pageControl.alpha = (dataSource.count == 1) ? 0:1;
    [self addContentView:dataSource];
}

- (void)setDotHeight:(CGFloat)dotHeight{
    _dotHeight = dotHeight;
    [self setNeedsUpdateConstraints];
}

- (void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    
    [self invalidateTimer];
    
    if (_autoScroll) {
        [self setupTimer];
    }
    
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval
{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    [self setAutoScroll:self.autoScroll];
}

#pragma mark - action

- (void)addContentView:(NSArray *)dataSource{
    UIView *lastView;
    
    for (int i = 0; i < [dataSource count] + 2; i++) {
        FLADAnimatedImageView *imageView = [[FLADAnimatedImageView alloc]init];
        
        if (i == 0) {
            [self setAnimationCircleColorWithImageView:imageView index:([dataSource count] - 1)];
        }else if (i == [dataSource count] + 1) {
            [self setAnimationCircleColorWithImageView:imageView index:0];
        }else{
            [self setAnimationCircleColorWithImageView:imageView index:(i-1)];
        }
        
        [self.scrollView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.scrollView.mas_height);
            make.width.equalTo(self.scrollView.mas_width);
            make.top.equalTo(self.scrollView.mas_top);
            make.left.equalTo(lastView ? lastView.mas_right : self.scrollView.mas_left);
        }];
        
        lastView = imageView;
    }

}

- (void)setAnimationCircleColorWithImageView:(FLADAnimatedImageView *)imageView index:(NSInteger)index{
    if ([self.circleColor count] == [self.dataSource count]) {
        [imageView setCircleWithColor:self.circleColor[index]];
    }
    [self loadImageView:imageView UrlString:self.dataSource[index]];
}

- (void)loadImageView:(DFImageView *)imageView UrlString:(NSString *)urlString{
    
    [imageView prepareForReuse];
    
    [imageView setImageWithResource:[NSURL  URLWithString:urlString] targetSize:DFImageMaximumSize contentMode:DFImageContentModeAspectFill options:nil];
}

- (void)didTapView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapPageViewAtIndex:)]) {
        [self.delegate didTapPageViewAtIndex:self.pageControl.currentPage];
    }
}

- (void)setupTimer
{
    NSTimeInterval timeInterval = (self.autoScrollTimeInterval)?self.autoScrollTimeInterval:DefaultAutoScrollTimeInterval;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)automaticScroll {
    if (![self.dataSource count] || _isTouch) {
        return;
    }
    
    NSInteger nextIndex = self.pageControl.currentPage + 2;
    [self scrollToPageWithIndex:nextIndex];
 
}

- (void)scrollToPageWithIndex:(NSInteger)index {

    [self.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.scrollView.frame) * index, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame)) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_isAdjustContentSize) {
        _isAdjustContentSize = NO;
        return;
    }
    
    NSInteger pageIndex = (scrollView.contentOffset.x - CGRectGetWidth(scrollView.frame)) / CGRectGetWidth(scrollView.frame);
    if ([self.dataSource count] == pageIndex) {
        self.pageControl.currentPage = 0;
        [self.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.scrollView.frame) * (self.pageControl.currentPage + 1), 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame)) animated:NO];
    }else if(pageIndex == -1){
        self.pageControl.currentPage = [self.dataSource count] - 1;
        [self.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.scrollView.frame) * (self.pageControl.currentPage + 1), 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame)) animated:NO];
    }else{
        self.pageControl.currentPage = pageIndex;
    }
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _isTouch = YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _isTouch = NO;
}

#pragma mark - TAPageControl delegate
- (void)TAPageControl:(TAPageControl *)pageControl didSelectPageAtIndex:(NSInteger)index{
    
    [self scrollToPageWithIndex:index + 1];
}


@end
