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

- (void)dealloc
{
    NSLog(@"Clock dealloc 释放了");
}

@end
