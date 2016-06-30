//
//  FLADPageView.h
//  Pods
//
//  Created by Felix.lin on 2016/6/28.
//
//

#import <UIKit/UIKit.h>

@protocol FLADPageViewDelegate <NSObject>
@optional
-(void)didTapPageViewAtIndex: (NSInteger)index;
@end

@interface FLADPageView : UIView
@property (nonatomic, weak) id<FLADPageViewDelegate> delegate;
@property (nonatomic) UIImage *dotImage;
@property (nonatomic) UIImage *currentDotImage;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *circleColor;
@property (nonatomic) CGFloat dotHeight;
@property (nonatomic, assign) BOOL autoScroll;
@property (nonatomic) CGFloat autoScrollTimeInterval;
@end
