//
//  ViewController.m
//  KVC&KVO
//
//  Created by muhlenXi on 2020/10/28.
//

#import "ViewController.h"
#import "KVCViewController.h"
#import "KVOViewController.h"
#import <objc/runtime.h>
#import "BaseClock.h"
#import "Clock.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *kvc = [[UIButton alloc] init];
    [kvc setTitle:@"key value coding" forState:UIControlStateNormal];
    [kvc setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [kvc addTarget:self action:@selector(kvcButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:kvc];
    kvc.frame = CGRectMake(0, 0, 200, 50);
    kvc.center = CGPointMake(self.view.center.x, self.view.center.y-50);
    
    
    UIButton *kvo = [[UIButton alloc] init];
    [kvo setTitle:@"key value observing" forState:UIControlStateNormal];
    [kvo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [kvo addTarget:self action:@selector(kvoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    kvo.frame = CGRectMake(0, 0, 200, 50);
    kvo.center = CGPointMake(self.view.center.x, self.view.center.y+50);
    [self.view addSubview:kvo];
}


- (void)kvcButtonAction:(UIButton *)sender {
    KVCViewController *kvc = [[KVCViewController alloc] init];
    [self.navigationController pushViewController:kvc animated:YES];
}

- (void)kvoButtonAction:(id)sender {
    KVOViewController *kvo = [[KVOViewController alloc] init];
    [self.navigationController pushViewController:kvo animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self printClasses:[Clock class]];
}

- (void)printClasses:(Class)cls {
    /// 获取已注册的 class 数量
    int count = objc_getClassList(NULL, 0);
    /// 第一个元素为 cls
    NSMutableArray *array = [NSMutableArray arrayWithObject:cls];
    Class *classes = (Class *)malloc(sizeof(Class)*count);
    /// 获取已注册的 class
    objc_getClassList(classes, count);
    
    /// 获取 cls 的子类
    for (int i = 0; i < count; i++) {
        if (class_getSuperclass(classes[i]) == cls) {
            [array addObject:classes[i]];
        }
    }
    free(classes);
    
    NSLog(@"classes -> %@", array);
}



@end
