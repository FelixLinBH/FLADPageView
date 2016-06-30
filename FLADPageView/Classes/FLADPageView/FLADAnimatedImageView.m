//
//  FLADAnimatedImageView.m
//  Pods
//
//  Created by Feilx on 2016/6/29.
//
//

#import "FLADAnimatedImageView.h"
#import "FLCircularLoadingView.h"
#import "Masonry.h"

@interface FLADAnimatedImageView()
@property (nonatomic) NSProgress *currentProgress;
@property (nonatomic) FLCircularLoadingView *loadingView;

@end

@implementation FLADAnimatedImageView

- (void)dealloc {
    self.currentProgress = nil;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _loadingView = [[FLCircularLoadingView alloc]init];
        [self addSubview:_loadingView];
    }
    return self;
}

- (void)updateConstraints{
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.and.width.mas_equalTo(20);
    }];
    
    [super updateConstraints];
}

- (void)setImageWithResource:(id)resource targetSize:(CGSize)targetSize contentMode:(DFImageContentMode)contentMode options:(DFImageRequestOptions *)options{
    [super setImageWithResource:resource targetSize:targetSize contentMode:contentMode options:options];
    self.currentProgress = self.imageTask.progress;
    
    if (self.imageTask.state == DFImageTaskStateCompleted) {
        self.loadingView.alpha = 0;
    }

}

- (void)setCurrentProgress:(NSProgress *)currentProgress {
    if (_currentProgress != currentProgress) {
        [_currentProgress removeObserver:self forKeyPath:@"fractionCompleted" context:nil];
        _currentProgress = currentProgress;
        [self.loadingView setProgress:_currentProgress.fractionCompleted];
        [currentProgress addObserver:self forKeyPath:@"fractionCompleted" options:kNilOptions context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == _currentProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingView setProgress:_currentProgress.fractionCompleted];
            if (_currentProgress.fractionCompleted == 1) {
                [self.loadingView reveal];
            }
        });
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


@end
