//
//  FLLViewController.m
//  FLADPageView
//
//  Created by Feilx on 2016/6/28.
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
    adView.backgroundColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:199/255.0 alpha:1];
    adView.dotImage = [UIImage imageNamed:@"dotInactive"];
    adView.currentDotImage = [UIImage imageNamed:@"dotActive"];
//    adView.dataSource = @[@"image1.jpg", @"image2.jpg", @"image3.jpg", @"image4.jpg", @"image5.jpg", @"image6.jpg"];
//    adView.dataSource = @[@"https://github.com/TanguyAladenise/TAPageControl/blob/master/Example/Resources/image1.jpg?raw=true"];
    
    adView.circleColor = @[[UIColor blueColor],[UIColor redColor],[UIColor greenColor],[UIColor purpleColor],[UIColor grayColor],[UIColor darkGrayColor],[UIColor yellowColor]];
    
    adView.dataSource = @[@"https://github.com/TanguyAladenise/TAPageControl/blob/master/Example/Resources/image1.jpg?raw=true",@"https://github.com/TanguyAladenise/TAPageControl/blob/master/Example/Resources/image2.jpg?raw=true",@"https://github.com/TanguyAladenise/TAPageControl/blob/master/Example/Resources/image3.jpg?raw=true",@"https://github.com/TanguyAladenise/TAPageControl/blob/master/Example/Resources/image4.jpg?raw=true",@"https://github.com/TanguyAladenise/TAPageControl/blob/master/Example/Resources/image5.jpg?raw=true",@"https://github.com/TanguyAladenise/TAPageControl/blob/master/Example/Resources/image6.jpg?raw=true",@"https://cloud.githubusercontent.com/assets/1567433/6505557/77ff05ac-c2e7-11e4-9a09-ce5b7995cad0.gif"];
    
//    adView.dataSource = @[@"http://m.08lc.net/static/B01M/_default/__static/__images/index/banner_14.jpg",@"http://m.08lc.net/static/B01M/_default/__static/__images/index/banner_13.jpg",@"http://m.08lc.net/static/B01M/_default/__static/__images/index/banner_03.jpg",@"http://m.08lc.net/static/B01M/_default/__static/__images/index/banner_05.jpg",@"http://m.08lc.net/static/B01M/_default/__static/__images/index/banner_11.jpg"];
//    adView.dotHeight = 50.0;
//    adView.autoScroll = YES;
    adView.autoScrollTimeInterval = 1.0;
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
