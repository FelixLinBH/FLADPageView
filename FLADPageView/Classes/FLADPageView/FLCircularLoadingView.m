//
//  FLCircularLoadingView.m
//  Pods
//
//  Created by Feilx on 2016/6/30.
//
//

#import "FLCircularLoadingView.h"

@interface FLCircularLoadingView()
@property (nonatomic) CAShapeLayer *circleShapeLayer;
@property (nonatomic) CGFloat circleRadius;

@end


@implementation FLCircularLoadingView
- (CGFloat)progress{
    return _circleShapeLayer.strokeEnd;
}
- (void)setProgress:(CGFloat)progress{
    if (progress > 1) {
        _circleShapeLayer.strokeEnd = 1;
    }else if (progress < 0) {
        _circleShapeLayer.strokeEnd = 0;
    }else{
        _circleShapeLayer.strokeEnd = progress;
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure{
    _circleRadius = 20.0;
    _circleShapeLayer = [[CAShapeLayer alloc]init];
    _circleShapeLayer.frame = self.bounds;
    _circleShapeLayer.lineWidth = 2.0;
    _circleShapeLayer.fillColor = [UIColor clearColor].CGColor;
    _circleShapeLayer.strokeColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:_circleShapeLayer];
    self.backgroundColor = [UIColor clearColor];
    self.progress = 0;
}

- (CGRect)getCircleFrame{
    CGRect circleFrame = CGRectMake(0, 0, 2 * _circleRadius, 2 * _circleRadius);
    circleFrame.origin.x = CGRectGetMidX(_circleShapeLayer.bounds) - CGRectGetMidX(circleFrame);
    circleFrame.origin.y = CGRectGetMidY(_circleShapeLayer.bounds) - CGRectGetMidY(circleFrame);
    return circleFrame;
}

- (CGRect)getCircleFrameWithBounds:(CGRect)bounds{
    CGRect circleFrame = CGRectMake(0, 0, 2 * _circleRadius, 2 * _circleRadius);
    circleFrame.origin.x = CGRectGetMidX(bounds) - CGRectGetMidX(circleFrame);
    circleFrame.origin.y = CGRectGetMidY(bounds) - CGRectGetMidY(circleFrame);
    return circleFrame;

}

- (UIBezierPath *)circlePathWithView:(UIView *)view{
    return [UIBezierPath bezierPathWithOvalInRect:[self getCircleFrameWithBounds:view.bounds]];
}

- (UIBezierPath *)circlePath{
    return [UIBezierPath bezierPathWithOvalInRect:[self getCircleFrame]];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _circleShapeLayer.frame = self.bounds;
    _circleShapeLayer.path = [self circlePath].CGPath;
}

- (void)reveal{
    self.backgroundColor = [UIColor clearColor];
    self.progress = 1;
    [_circleShapeLayer removeAnimationForKey:@"strokeEnd"];
    [_circleShapeLayer removeFromSuperlayer];
    _circleShapeLayer.frame = self.bounds;
    self.superview.layer.mask = _circleShapeLayer;
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds));
    
    CGFloat finalRadius = sqrt((center.x*center.x) + (center.y*center.y));
    CGFloat radiusInset = finalRadius - _circleRadius;
    
    CGRect outerRect = CGRectInset([self getCircleFrameWithBounds:self.superview.bounds], -radiusInset, -radiusInset);
    
    CGPathRef toPath = [UIBezierPath bezierPathWithOvalInRect:outerRect].CGPath;

    
    CGPathRef fromPath = [self circlePathWithView:self.superview].CGPath;
    CGFloat fromLineWidth = _circleShapeLayer.lineWidth;
    
    [CATransaction begin];
    [CATransaction setValue:kCFBooleanTrue forKey:kCATransactionDisableActions];
    _circleShapeLayer.lineWidth = 2*finalRadius;
    _circleShapeLayer.path = toPath;
    [CATransaction commit];
    
    CABasicAnimation *lineWithAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    lineWithAnimation.fromValue = [NSNumber numberWithFloat:fromLineWidth];
    lineWithAnimation.toValue = [NSNumber numberWithFloat:2 * finalRadius];

    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (__bridge id)fromPath;
    pathAnimation.toValue = (__bridge id)toPath;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 2.0;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.animations = @[pathAnimation,lineWithAnimation];
    animationGroup.delegate = self;
    [_circleShapeLayer addAnimation:animationGroup forKey:@"strokeWith"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    self.superview.layer.mask = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
