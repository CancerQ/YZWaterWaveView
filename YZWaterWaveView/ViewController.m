//
//  ViewController.m
//  YZWaterWaveView
//
//  Created by 叶志强 on 2017/7/7.
//  Copyright © 2017年 CancerQ. All rights reserved.
//

#import "ViewController.h"
#import "YZWaterWaveView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = RGBAlpha_255(46, 159, 255, 1);
    YZWaterWaveView *wateView = [[YZWaterWaveView alloc]initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, self.view.frame.size.height - 40)];
    [wateView yz_configHandle:^(YZWaterWave *config) {
        config.rotation = 3.f;
        
        //这里不会有循环引用 可以放心试用
        NSLog(@"%@",self.view);
    }];
    
    //可以添加在任意的视图上
    [self.view addSubview:wateView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
