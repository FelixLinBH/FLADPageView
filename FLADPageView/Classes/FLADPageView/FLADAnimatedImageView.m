//
//  FLADAnimatedImageView.m
//  Pods
//
//  Created by TWFeilx on 2016/6/29.
//
//

#import "FLADAnimatedImageView.h"
#import "Masonry.h"

@interface FLADAnimatedImageView()
@property (nonatomic, readonly) UIProgressView *progressView;
@property (nonatomic) NSProgress *currentProgress;

@end

@implementation FLADAnimatedImageView

- (void)dealloc {
    self.currentProgress = nil;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _progressView = [[UIProgressView alloc]init];

        [self addSubview:_progressView];
    }
    return self;
}

- (void)updateConstraints{
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.and.with.mas_equalTo(40);
    }];
    
    [super updateConstraints];
}

- (void)setImageWithResource:(id)resource targetSize:(CGSize)targetSize contentMode:(DFImageContentMode)contentMode options:(DFImageRequestOptions *)options{
    [super setImageWithResource:resource targetSize:targetSize contentMode:contentMode options:options];
    self.currentProgress = self.imageTask.progress;
    if (self.imageTask.state == DFImageTaskStateCompleted) {
        self.progressView.alpha = 0;
    }

}

- (void)setCurrentProgress:(NSProgress *)currentProgress {
    if (_currentProgress != currentProgress) {
        [_currentProgress removeObserver:self forKeyPath:@"fractionCompleted" context:nil];
        _currentProgress = currentProgress;
        [self.progressView setProgress:currentProgress.fractionCompleted];
        [currentProgress addObserver:self forKeyPath:@"fractionCompleted" options:kNilOptions context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == _currentProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressView setProgress:_currentProgress.fractionCompleted animated:YES];
            NSLog(@"%f",_currentProgress.fractionCompleted);
            if (_currentProgress.fractionCompleted == 1) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.progressView.alpha = 0;
                }];
            }
        });
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
