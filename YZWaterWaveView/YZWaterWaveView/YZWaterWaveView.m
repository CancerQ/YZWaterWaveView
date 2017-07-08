//
//  YZWaterWaveView.m
//  YZWaterWaveView
//
//  Created by 叶志强 on 2017/7/7.
//  Copyright © 2017年 CancerQ. All rights reserved.
//

#import "YZWaterWaveView.h"
#import "YYWeakProxy.h"


@interface YZWaterWave ()

@property (nonatomic, copy) void(^configHandle)(YZWaterWave *config);

@end

@interface YZWaterWaveView (){
    
    /**
     *  可以设置 多种不同的属性 需求自行修改
     */
    CGFloat waveAmplitudeF;  // 波纹振幅1
    CGFloat waveAmplitudeS;  // 波纹振幅2
    CGFloat waveCycle;      // 波纹周期
    CGFloat waveSpeed;      // 波纹速度
    
    CGFloat waterWaveWidth; //
    CGFloat offsetXF;
    CGFloat offsetXS;
    CGFloat currentWavePointY; // 当前波浪上市高度Y（高度从大到小 坐标系向下增长）
}
@property (nonatomic, strong) YZWaterWave   *config;
@property (nonatomic, strong) CADisplayLink *waveDisplaylink;
@property (nonatomic, strong) CAShapeLayer  *firstWaveLayer;
@property (nonatomic, strong) CAShapeLayer  *secondWaveLayer;
@property (nonatomic, strong) UIColor       *waveColor;
@end
@implementation YZWaterWaveView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    waterWaveWidth  = self.frame.size.width;
    waveCycle =  2 * M_PI / waterWaveWidth;
    currentWavePointY = self.frame.size.height/2;
}

- (void)setWaveColor:(UIColor *)waveColor{
    _waveColor = waveColor;
    self.firstWaveLayer.fillColor = waveColor.CGColor;
    self.secondWaveLayer.fillColor = waveColor.CGColor;
}

- (void)yz_configHandle:(YZConfigHandle)handle{
    __weak typeof(self)weakSelf = self;
    self.config.configHandle = ^(YZWaterWave *config) {
        weakSelf.transform = CGAffineTransformMakeRotation(config.rotation*M_PI/180);
        weakSelf.waveColor = config.color?:weakSelf.waveColor;
    };
    handle(self.config);
    self.config.configHandle(self.config);
}

- (void)commonInit{
    self.userInteractionEnabled = NO;
    self.config = [YZWaterWave new];
    
    waveAmplitudeF = 10.f;
    waveAmplitudeS = 1.5 * waveAmplitudeF;
    waveSpeed = 0.08/M_PI;
    self.waveColor = RGBAlpha_255(255, 255, 255, 0.1);
    
    if (_firstWaveLayer == nil) {
        // 创建第一个波浪Layer
        _firstWaveLayer = [CAShapeLayer layer];

        _firstWaveLayer.fillColor = self.waveColor.CGColor;
        [self.layer addSublayer:_firstWaveLayer];
    }
    
    if (_secondWaveLayer == nil) {
        // 创建第二个波浪Layer
        _secondWaveLayer = [CAShapeLayer layer];
        _secondWaveLayer.fillColor =  self.waveColor.CGColor;
        [self.layer addSublayer:_secondWaveLayer];
    }
    self.waveDisplaylink = [CADisplayLink displayLinkWithTarget:[YYWeakProxy proxyWithTarget:self] selector:@selector(getCurrentWave)];
    [self.waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)getCurrentWave{
    // 波浪位移
    offsetXF += waveSpeed;
    offsetXS += 2*waveSpeed;
    [self waveLayerDraw];
}

- (void)waveLayerDraw{
    
    
    CGMutablePathRef firstPath = CGPathCreateMutable();
    CGFloat y = currentWavePointY;
    CGPathMoveToPoint(firstPath, nil, 0, y);
    for (float x = 0.0f; x <=  waterWaveWidth ; x++) {
        // 正弦波浪公式
        y = waveAmplitudeF * sinf(waveCycle * x - offsetXF) + currentWavePointY;
        CGPathAddLineToPoint(firstPath, nil, x, y);
    }
    
    CGPathAddLineToPoint(firstPath, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(firstPath, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(firstPath);
    
    self.firstWaveLayer.path = firstPath;
    CGPathRelease(firstPath);
    
     CGMutablePathRef secondPath = CGPathCreateMutable();
    
    CGPathMoveToPoint(secondPath, nil, 0, y);
    for (float x = 0.0f; x <=  waterWaveWidth ; x++) {
        // 余弦波浪公式
        y = waveAmplitudeS * cosf(waveCycle * x - offsetXS) + currentWavePointY ;
        CGPathAddLineToPoint(secondPath, nil, x, y);
    }
    
    CGPathAddLineToPoint(secondPath, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(secondPath, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(secondPath);
    
    self.secondWaveLayer.path = secondPath;
    CGPathRelease(secondPath);
}

@end

@implementation YZWaterWave

@end
