//
//  SFCircleProgress.h
//  LunchAd
//
//  Created by Lurich on 2018/5/21.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SFProgressTypeCircle,
    SFProgressTypeLong,
} SFProgressType;

@interface SFCircleProgress : UIView

/** 进度 */
@property (nonatomic, assign) CGFloat progress;
/** 底层颜色 */
@property (nonatomic, strong) UIColor *bottomColor;
/** 顶层颜色 */
@property (nonatomic, strong) UIColor *topColor;
/** 宽度 */
@property (nonatomic, assign) CGFloat progressWidth;

/** 初始化 */
- (instancetype)initWithFrame:(CGRect)frame Type:(SFProgressType)type;

//指定时间
- (void)startProgressWithTime:(CGFloat)time completion:(void(^)(void))block;
- (void)stopProgress;

@end
