//
//  NSObject+Print.m
//  KVC&KVO
//
//  Created by muhlenXi on 2020/10/28.
//

#import "NSObject+Print.h"

@implementation NSObject (Print)

- (void)printFunctionDescription: (SEL) sel {
    NSLog(@"%@ ==> %@", NSStringFromClass([self class]),NSStringFromSelector(sel));
}

@end
