//
//  SFCircleProgress.m
//  LunchAd
//
//  Created by Lurich on 2018/5/21.
//  Copyright © 2018年 . All rights reserved.
//

#import "SFCircleProgress.h"

@interface SFCircleProgress ()
{
    /** 原点 */
    CGPoint _origin;
    /** 半径 */
    CGFloat _radius;
    /** 起始 */
    CGFloat _startAngle;
    /** 结束 */
    CGFloat _endAngle;
}

/** 底层显示层 */
@property (nonatomic, strong) CAShapeLayer *bottomLayer;
/** 顶层显示层 */
@property (nonatomic, strong) CAShapeLayer *topLayer;

@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, assign) SFProgressType type;

@end

@implementation SFCircleProgress

- (instancetype)initWithFrame:(CGRect)frame Type:(SFProgressType)type{
    if (self) {
        self = [super initWithFrame:frame];
        self.backgroundColor = [UIColor clearColor];
        [self.layer addSublayer:self.bottomLayer];
        [self.layer addSublayer:self.topLayer];
        self.type = type;
        if (type == SFProgressTypeCircle) {
            _origin = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
            _radius = MIN(self.bounds.size.width, self.bounds.size.height) / 2;
            
            UIBezierPath *bottomPath = [UIBezierPath bezierPathWithArcCenter:_origin radius:_radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
            _bottomLayer.path = bottomPath.CGPath;
        } else {
            UIBezierPath *bottomPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
            _bottomLayer.path = bottomPath.CGPath;
        }
        self.progress = 0.0;
    }
    return self;
}
- (void)startProgressWithTime:(CGFloat)time completion:(void(^)(void))block{
    self.progress = 0.0;
    // 队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    // 创建定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 设置时间
    dispatch_source_set_timer(timer,
                              dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC),
                              time/100.0 * NSEC_PER_SEC, 0);
    
    // 设置回调
    dispatch_source_set_event_handler(timer, ^{
        self.progress += 0.01;
        if (self.progress >= 1.0) { // 不重复的任务
            dispatch_source_cancel(timer);
            [self removeFromSuperview];
            if (block) {
                block();
            }
        }
    });
    // 启动定时器
    dispatch_resume(timer);
    self.timer = timer;
}
- (void)stopProgress{
    dispatch_source_cancel(self.timer);
}

#pragma mark - 懒加载
- (CAShapeLayer *)bottomLayer {
    if (!_bottomLayer) {
        _bottomLayer = [CAShapeLayer layer];
        _bottomLayer.lineCap = kCALineCapRound;
        _bottomLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _bottomLayer;
}

- (CAShapeLayer *)topLayer {
    if (!_topLayer) {
        _topLayer = [CAShapeLayer layer];
        _topLayer.lineCap = kCALineCapRound;
        _topLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _topLayer;
}

#pragma mark - setMethod
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    if (self.type == SFProgressTypeCircle) {
        _startAngle = - M_PI_2;
        _endAngle = _startAngle + _progress * M_PI * 2;
        
        UIBezierPath *topPath = [UIBezierPath bezierPathWithArcCenter:_origin radius:_radius startAngle:_startAngle endAngle:_endAngle clockwise:YES];
        _topLayer.path = topPath.CGPath;
    } else {
        UIBezierPath *topPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.bounds.size.width * progress, self.bounds.size.height)];
        _topLayer.path = topPath.CGPath;
    }
}

- (void)setBottomColor:(UIColor *)bottomColor {
    _bottomColor = bottomColor;
    if (self.type == SFProgressTypeCircle) {
        _bottomLayer.strokeColor = _bottomColor.CGColor;
    } else {
        _bottomLayer.fillColor = _bottomColor.CGColor;
    }
}

- (void)setTopColor:(UIColor *)topColor {
    _topColor = topColor;
    if (self.type == SFProgressTypeCircle) {
        _topLayer.strokeColor = _topColor.CGColor;
    } else {
        _topLayer.fillColor = _topColor.CGColor;
    }
}

- (void)setProgressWidth:(CGFloat)progressWidth {
    _progressWidth = progressWidth;
    if (self.type == SFProgressTypeCircle) {
        _topLayer.lineWidth = progressWidth;
        _bottomLayer.lineWidth = progressWidth;
    }
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end
