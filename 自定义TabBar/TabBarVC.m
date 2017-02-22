//
//  TabBarVC.m
//  自定义TabBar
//
//  Created by SunGuoYan on 17/2/22.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "TabBarVC.h"
#import "ViewController1.h"
#import "ViewController2.h"
#import "ViewController3.h"
#import "ViewController.h"
#import "Extension.h"
//重复点击tabBar上按钮，刷新当前界面
NSString * const repeateClickTabBarButtonNote = @"repeateClickTabBarButton";
@interface TabBarVC ()<UITabBarControllerDelegate>
//记录当前选中的视图控制器
@property (nonatomic,weak) UIViewController *lastViewController;
@end

@implementation TabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加所有的子控制器
    [self setUpChildVC];
    
    // 设置tabBar上按钮的内容
    [self setupAllTabBarButton];
    
    //设置中心按钮
    [self setCenterButton];
    
    //设置tabBar背景图片（系统自己的图片，这里必须得设置）
    [self setupTabBarBackgroundImage];
    
    // 设置代理 监听tabBar上按钮点击
    self.delegate = self;
    //默认选中第一个
    _lastViewController = self.childViewControllers.firstObject;
    
}
-(void)setupAllTabBarButton{
    //设置TabBar按钮的内容
    //1.
    ViewController1 *vc1 = self.childViewControllers[0];
    vc1.tabBarItem.image = [UIImage imageNamed:@"tab_live"];
    vc1.tabBarItem.selectedImage = [UIImage imageWithOriginalRenderingMode:@"tab_live_p"];
    
    //2.注：这里并没有设置图片内容
    ViewController2 *vc2 = self.childViewControllers[1];
    //关闭之前的响应事件(添加到self之前写的enabled设置无效) 给btn写添加事件
    vc2.tabBarItem.enabled = NO;
    
    //3.
    ViewController3 *vc3 = self.childViewControllers[2];
    vc3.tabBarItem.image = [UIImage imageNamed:@"tab_me"];
    vc3.tabBarItem.selectedImage = [UIImage imageWithOriginalRenderingMode:@"tab_me_p"];
    
    // 调整TabBarItem位置
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 0, -10, 0);
    UIEdgeInsets cameraInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    vc1.tabBarItem.imageInsets = insets;
    vc3.tabBarItem.imageInsets = insets;
    
    vc2.tabBarItem.imageInsets = cameraInsets;
    
    //隐藏阴影线
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
}

-(void)setCenterButton{
    //给btn添加响应事件
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setImage:[UIImage imageNamed:@"tab_room"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"tab_room_p"] forState:UIControlStateHighlighted];
    
    // 自适应,自动根据按钮图片和文字计算按钮尺寸
    [btn sizeToFit];
    
    btn.center = CGPointMake(self.tabBar.width * 0.5, self.tabBar.height * 0.5 + 5);
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tabBar addSubview:btn];
}
-(void)clickBtn{
    ViewController *vc=[[ViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
    //以下两种方式都不能push过去，这里只能present
    //ViewController2 *vc2=self.childViewControllers[1];
    //[vc2.navigationController pushViewController:vc animated:YES];
    //[self.navigationController pushViewController:vc animated:YES];
}
-(void)setUpChildVC{
    //1.
    ViewController1 *vc1=[[ViewController1 alloc]init];
    UINavigationController *nvc1=[[UINavigationController alloc] initWithRootViewController:vc1];
    [self addChildViewController:nvc1];
    
    //2.注：这里并没有设置图片内容
    ViewController2 *vc2=[[ViewController2 alloc]init];
    UINavigationController *nvc2=[[UINavigationController alloc] initWithRootViewController:vc2];
    [self addChildViewController:nvc2];
    
    //3.
    ViewController3 *vc3=[[ViewController3 alloc]init];
    UINavigationController *nvc3=[[UINavigationController alloc] initWithRootViewController:vc3];
    [self addChildViewController:nvc3];
    
}

#pragma mark ---- <UITabBarControllerDelegate>
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    ViewController1 *vc1 = self.childViewControllers[0];
    ViewController2 *vc2 = self.childViewControllers[1];
    ViewController3 *vc3 = self.childViewControllers[2];
    
    NSLog(@"%@ %@ %@",vc1,vc2,vc3);
    
    //tabBaritem 如果连续点击两次，第二次就是刷新
    if (_lastViewController == viewController) {
        //        NSLog(@"重复点击");
        
        // 发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:repeateClickTabBarButtonNote object:nil];
        // 通知对应的子控制器去刷新界面 ??
        NSLog(@"%@",_lastViewController);
    
    }
    _lastViewController = viewController;
}


- (void)setupTabBarBackgroundImage {
    UIImage *image = [UIImage imageNamed:@"tab_bg"];
    
    CGFloat top = 40; // 顶端盖高度
    CGFloat bottom = 40 ; // 底端盖高度
    CGFloat left = 100; // 左端盖宽度
    CGFloat right = 100; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    UIImage *TabBgImage = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.tabBar.backgroundImage = TabBgImage;
    
    //2.2隐藏阴影线 下面的代码为什么要写两次？
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
}
//自定义TabBar高度
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 60;
    tabFrame.origin.y = self.view.frame.size.height - 60;
    self.tabBar.frame = tabFrame;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
