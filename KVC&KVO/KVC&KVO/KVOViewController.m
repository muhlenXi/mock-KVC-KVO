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
    NSLog(@"%@", self.user);
    NSLog(@"%@", [User alloc]);
    
    self.clock = [[Clock alloc] init];
    NSLog(@"%s", object_getClassName(self.clock));
    
    [self.clock addObserver:self forKeyPath:@"second" options:NSKeyValueObservingOptionNew context: NULL];
    [self.clock addObserver:self forKeyPath:@"clockName" options:NSKeyValueObservingOptionNew context: NULL];
    
    [self.user addObserver:self forKeyPath:@"nickname" options:NSKeyValueObservingOptionNew context:NULL];
    
    self.clock.clockName = @"hello";
    
    NSLog(@"%s", object_getClassName(self.clock));
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%@", change);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.clock.second = self.clock.second + 1;
    self.clock.clockName = @"morning call";
    
    self.user.nickname = @"muhlenXi";
}

- (void)dealloc
{
    NSLog(@"KVOViewController dealloc");
    
    [self.user removeObserver:self forKeyPath:@"nickname"];
}

@end
