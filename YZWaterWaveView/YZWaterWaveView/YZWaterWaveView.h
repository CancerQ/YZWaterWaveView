//
//  YZWaterWaveView.h
//  YZWaterWaveView
//
//  Created by 叶志强 on 2017/7/7.
//  Copyright © 2017年 CancerQ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBAlpha_255(r, g, b, a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]
/**
 *  暂时只有这几个配置 后面再进行添加 如果看懂源码的自修改
 */
@interface YZWaterWave : NSObject

/**
 *  波纹颜色
 */
@property (nonatomic, strong) UIColor *color;

/**
 *  旋转角度
 */
@property (nonatomic, assign) CGFloat rotation;

/**
 *  所在位置比例 0~1 默认0.5
 */
@property (nonatomic, assign) CGFloat positionPercent;
@end


typedef void (^YZConfigHandle)(YZWaterWave *config);
@interface YZWaterWaveView : UIView

- (void)yz_configHandle:(YZConfigHandle)handle;

@end
