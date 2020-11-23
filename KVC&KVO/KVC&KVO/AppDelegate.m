//
//  AppDelegate.m
//  KVC&KVO
//
//  Created by muhlenXi on 2020/10/28.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self test];
    [self question];
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

- (void) test {
    //主队列 - Main Dispatch Queue
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //串行队列 - Serial Dispatch Queue
    dispatch_queue_t serialQueue = dispatch_queue_create("com.muhlenXi", NULL);
    //全局并发队列 - Global Dispatch Queue
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    //并发队列 - Concurrent Dispatch Queue
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.muhlenXi", DISPATCH_QUEUE_CONCURRENT);
}

- (void) question {
    return;
    //并行队列
    dispatch_queue_t queue = dispatch_queue_create("com.muhlenXi", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{ // 耗时
        NSLog(@"1");
    });
    dispatch_async(queue, ^{
        NSLog(@"2");
    });
    
    // 同步
    dispatch_sync(queue, ^{
        NSLog(@"3 -> %@", NSThread.currentThread);
    });
    
    NSLog(@"0 -> %@", NSThread.currentThread);

    dispatch_async(queue, ^{
        NSLog(@"7");
    });
    dispatch_async(queue, ^{
        NSLog(@"8");
    });
    dispatch_async(queue, ^{
        NSLog(@"9");
    });
}

@end
