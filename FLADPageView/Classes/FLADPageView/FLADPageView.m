//
//  FLADPageView.m
//  Pods
//
//  Created by TWFeilx on 2016/6/28.
//
//

#import "FLADPageView.h"
#import "TAPageControl.h"
#import "Masonry.h"
#define DefaultDotHeight 15
#define DefaultAutoScrollTimeInterval 3
@interface FLADPageView()
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) TAPageControl *pageControl;
@property (nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) BOOL isTouch;
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
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.dataSource.count, self.scrollView.frame.size.height);
    
    [self scrollToPageWithIndex:self.pageControl.currentPage];
    
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
    
    for (int i = 0; i < [dataSource count]; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        
        imageView.image = [UIImage imageNamed:dataSource[i]];
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
    
    NSInteger nextIndex = self.pageControl.currentPage + 1;
    if (nextIndex <= [self.dataSource count]) {
        [self scrollToPageWithIndex:nextIndex];
    }
    
}

- (void)scrollToPageWithIndex:(NSInteger)index {
    [self.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.scrollView.frame) * index, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame)) animated:YES];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    _isTouch = YES;
    return [super hitTest:point withEvent:event];
    
}
#pragma mark - ScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger pageIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    self.pageControl.currentPage = pageIndex;
    
}

#pragma mark - TAPageControl delegate
- (void)TAPageControl:(TAPageControl *)pageControl didSelectPageAtIndex:(NSInteger)index{
    
    [self scrollToPageWithIndex:index];
}


@end
