//
//  FLViewController.m
//  FLADPageView
//
//  Created by Felix on 06/28/2016.
//  Copyright (c) 2016 Felix. All rights reserved.
//

#import "FLViewController.h"
#import "TAPageControl.h"
#import "Masonry.h"


@interface FLViewController ()<UIScrollViewDelegate,TAPageControlDelegate>
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) TAPageControl *pageControl;
@property (nonatomic,strong) NSArray *imageData;
@end

@implementation FLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self setData];
    
    self.pageControl = [[TAPageControl alloc]init];
    self.pageControl.delegate = self;
    
    self.pageControl.numberOfPages = self.imageData.count;
    self.pageControl.dotImage        = [UIImage imageNamed:@"dotInactive"];
    self.pageControl.currentDotImage = [UIImage imageNamed:@"dotActive"];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    [self setConstraints];
    
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.imageData.count, self.scrollView.frame.size.height);
    
    [self.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.scrollView.frame) * self.pageControl.currentPage, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame)) animated:YES];
    
}

- (void)setData{
    self.imageData = @[@"image1.jpg", @"image2.jpg", @"image3.jpg", @"image4.jpg", @"image5.jpg", @"image6.jpg"];
    
    UIView *lastView;
    
    for (int i = 0; i < [self.imageData count]; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:self.imageData[i]];
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
- (void)setConstraints{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.mas_equalTo(160);
    }];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.centerX.equalTo(self.scrollView);
        make.bottom.equalTo(self.scrollView.mas_bottom).with.offset(0);
        make.width.equalTo(self.scrollView);
    }];
}

#pragma mark - ScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger pageIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    self.pageControl.currentPage = pageIndex;
    
    if ( [scrollView viewWithTag:(pageIndex +1)] ) {
        return;
    }
    else {
        // view is missing, create it and set its tag to currentPage+1
    }
    
    for ( int i = 0; i < pageIndex; i++ ) {
        if ( (i < (pageIndex-1) || i > (pageIndex+1)) && [scrollView viewWithTag:(i+1)] ) {
            [[scrollView viewWithTag:(i+1)] removeFromSuperview];
        }
    }
    
}

#pragma mark - TAPageControl delegate
- (void)TAPageControl:(TAPageControl *)pageControl didSelectPageAtIndex:(NSInteger)index{
    [self.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.scrollView.frame) * index, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame)) animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
