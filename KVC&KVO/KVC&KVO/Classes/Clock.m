//
//  Clock.m
//  KVC&KVO
//
//  Created by muhlenXi on 2020/11/11.
//

#import "Clock.h"

@implementation Clock

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.openedClocks = [NSMutableArray array];
    }
    return self;
}

//- (void)setSecond:(NSInteger)second {
//    [self willChangeValueForKey:@"second"];
//    _second = second;
//    [self didChangeValueForKey:@"second"];
//}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
//    if ([key isEqualToString:@"second"]) {
//        return NO;
//    }
    return YES;
}

+ (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    if ([key isEqualToString:@"clockTime"]) {
        NSArray *affectingKeys = @[@"hour", @"minute", @"second"];
        keyPaths = [keyPaths setByAddingObjectsFromArray:affectingKeys];
    }
    return keyPaths;
}

- (NSString *)clockTime {
    return [NSString stringWithFormat:@"%ld:%ld:%ld", (long)_hour, (long)_minute, (long)_second];
}

- (void)dealloc
{
    NSLog(@"Clock dealloc 释放了");
}

@end
