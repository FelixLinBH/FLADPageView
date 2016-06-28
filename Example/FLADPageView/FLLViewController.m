//
//  FLLViewController.m
//  FLADPageView
//
//  Created by TWFeilx on 2016/6/28.
//  Copyright © 2016年 Felix. All rights reserved.
//

#import "FLLViewController.h"
#import "FLADPageView.h"
#import "Masonry.h"
@interface FLLViewController ()<FLADPageViewDelegate>

@end

@implementation FLLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    FLADPageView *adView = [[FLADPageView alloc]init];
    adView.delegate = self;
    adView.backgroundColor = [UIColor clearColor];
    adView.dotImage = [UIImage imageNamed:@"dotInactive"];
    adView.currentDotImage = [UIImage imageNamed:@"dotActive"];
    adView.dataSource = @[@"image1.jpg", @"image2.jpg", @"image3.jpg", @"image4.jpg", @"image5.jpg", @"image6.jpg"];
//    adView.dotHeight = 50.0;
    adView.autoScroll = YES;
    [self.view addSubview:adView];
    
    [adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.mas_equalTo(200);
    }];
}

-(void)didTapPageViewAtIndex: (NSInteger)index{
    NSLog(@"%ld",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
