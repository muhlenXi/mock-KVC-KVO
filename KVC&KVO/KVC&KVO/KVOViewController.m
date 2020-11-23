//
//  KVOViewController.m
//  KVC&KVO
//
//  Created by muhlenXi on 2020/11/11.
//

#import "KVOViewController.h"
#import "Clock.h"
#import "User.h"
#import <objc/runtime.h>

@interface KVOViewController ()

@property (nonatomic, strong) Clock *clock;
@property (nonatomic, strong) User * user;


@end

@implementation KVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"KVO";
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.user = [User sharedInstance];
    
    self.clock = [[Clock alloc] init];
    
    NSLog(@"Before: class -> %@, className -> %s",NSStringFromClass([self.clock class]), object_getClassName(self.clock));
    [self.clock addObserver:self forKeyPath:@"second" options:NSKeyValueObservingOptionNew context: NULL];
    NSLog(@"After: class -> %@, className -> %s",NSStringFromClass([self.clock class]), object_getClassName(self.clock));
    [self.clock removeObserver:self forKeyPath:@"second"];
    NSLog(@"Removed: class -> %@, className -> %s",NSStringFromClass([self.clock class]), object_getClassName(self.clock));
//
//    [self printClasses:[self.clock class]];
//    [self.clock addObserver:self forKeyPath:@"clockName" options:NSKeyValueObservingOptionNew context: NULL];
//    [self printClasses:[self.clock class]];
//    [self.clock removeObserver:self forKeyPath:@"clockName"];
//    [self printClasses:[self.clock class]];
    
//    [self printAllMethodInClass:NSClassFromString(@"Clock")];
//    NSLog(@"-----------------");
//    [self printAllMethodInClass:NSClassFromString(@"NSKVONotifying_Clock")];
//    [self printClasses:[self.clock class]];
//
//    [self.clock addObserver:self forKeyPath:@"openedClocks" options:NSKeyValueObservingOptionNew context:NULL];
//    
//    [self.clock addObserver:self forKeyPath:@"openDate" options:NSKeyValueObservingOptionNew context:NULL];
    
//    self.clock.clockName = @"hello";
//    
//    NSLog(@"%s", object_getClassName(self.clock));
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%@", change);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    self.clock.second = self.clock.second + 1;
//    self.clock.clockName = @"morning call";
//
//    self.user.nickname = @"muhlenXi";
    
//    [self.clock.openedClocks addObject:@"morning call"];
//
//    [[self.clock mutableArrayValueForKey:@"openedClocks"] addObject:@"morning call"];
//    [[self.clock mutableArrayValueForKey:@"openedClocks"] removeObject:@"morning call"];
//    [[self.clock mutableArrayValueForKey:@"openedClocks"] replaceObjectAtIndex:0 withObject:@"evening call"];
    
    self.clock->openDate = @"2020-12-20";
    self.clock.clockName = @"hello";
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

- (void)printAllMethodInClass:(Class)cls {
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(cls, &count);
    
    for (int i = 0; i < count; i++) {
        Method method = methodList[i];
        SEL sel = method_getName(method);
        IMP imp = method_getImplementation(method);
        
        NSLog(@" %@ -> %p", NSStringFromSelector(sel), imp);
    }
    free(methodList);
}

- (void)dealloc
{
    NSLog(@"KVOViewController dealloc");
}

@end
