//
//  User.m
//  KVC&KVO
//
//  Created by muhlenXi on 2020/11/12.
//

#import "User.h"

static User *user = nil;

@implementation User

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        user = [[super allocWithZone: NULL] init];
    });
    return user;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [User sharedInstance];
}

@end
