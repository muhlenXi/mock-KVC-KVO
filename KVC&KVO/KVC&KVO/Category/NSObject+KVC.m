//
//  NSObject+KVC.m
//  KVC&KVO
//
//  Created by muhlenXi on 2020/10/28.
//

#import "NSObject+KVC.h"
#import <objc/runtime.h>

@implementation NSObject (KVC)

- (void)mx_setValue:(id)value forKey:(NSString *)key {
    // 1 - 安全校验
    if (key == nil || key.length == 0) {
        return;
    }
    
    // 2 - setter 方法检查和调用
    NSString *setKey = [NSString stringWithFormat:@"set%@:", key.capitalizedString];
    NSString *_setKey = [NSString stringWithFormat:@"_set%@:", key.capitalizedString];
    
    if ([self mx_performSelector:setKey withObject:value]) {
        return;
    } else if ([self mx_performSelector:_setKey withObject:value]) {
        return;
    }
    // 3 - 检查 accessInstanceVariablesDirectly
    if (![self.class accessInstanceVariablesDirectly]) {
        @throw [NSException exceptionWithName:@"MXUnknownKeyException" reason:[NSString stringWithFormat:@"[%@ valueForUndefinedKey:]: this class is not key value coding-compliant for the key name.", self] userInfo:nil];
    }
    
    // 4 - 查找成员变量并赋值
    NSArray *ivarNames = [self getIvarListName];
    NSString *_key = [NSString stringWithFormat:@"_%@", key];
    NSString *_isKey = [NSString stringWithFormat:@"_is%@", key.capitalizedString];
    NSString *isKey = [NSString stringWithFormat:@"is%@", key.capitalizedString];
    
    NSArray *keys = @[_key, _isKey, key, isKey];
    for(NSString *key in keys) {
        if ([ivarNames containsObject:key]) {
            Ivar ivar = class_getInstanceVariable([self class], key.UTF8String);
            object_setIvar(self, ivar, value);
            return;
        }
    }
    
    // 异常提醒
    @throw  [NSException exceptionWithName:@"MXUnknownKeyException" reason:[NSString stringWithFormat:@"[%@ %@]: this class is not key value coding-compliant for the key name.", self, NSStringFromSelector(_cmd)] userInfo:nil];
}

- (id)mx_valueForKey:(NSString *)key {
    // 1 - 安全校验
    if (key == nil || key.length == 0) {
        return nil;
    }
    
    // 2 - getter 方法检查和调用
    NSString *getKeyM = [NSString stringWithFormat:@"get%@", key.capitalizedString];
    NSString *isKeyM = [NSString stringWithFormat:@"is%@", key.capitalizedString];
    NSString *_keyM = [NSString stringWithFormat:@"_%@", key];
    NSString *countOfKey = [NSString stringWithFormat:@"countOf%@", key.capitalizedString];
    NSString *objectInKeyAtIndex = [NSString stringWithFormat:@"ObjectIn%@AtIndex:", key.capitalizedString];
    
    
    NSArray *methodNames = @[getKeyM, isKeyM, key, _keyM];
    
    for(NSString *name in methodNames) {
        id value = [self checkPerformSelector: name];
        if (value != nil) {
            return value;
        }
    }
    if ([self respondsToSelector:NSSelectorFromString(countOfKey)]) {
        if ([self respondsToSelector:NSSelectorFromString(objectInKeyAtIndex)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            int num = (int)[self performSelector:NSSelectorFromString(countOfKey)];
            NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:1];
            for(int i = 0; i < num; i++) {
                id object = [self performSelector:NSSelectorFromString(objectInKeyAtIndex) withObject:@(i)];
#pragma clang diagnostic pop
                [mArray addObject:object];
            }
        }
    }
    
    // 3 - 检查 accessInstanceVariablesDirectly
    if (![self.class accessInstanceVariablesDirectly]) {
        @throw [NSException exceptionWithName:@"MXUnknownKeyException" reason:[NSString stringWithFormat:@"[%@ valueForUndefinedKey:]: this class is not key value coding-compliant for the key name.", self] userInfo:nil];
    }
    
    // 4 - 成员变量查找
    
    NSString *_key = [NSString stringWithFormat:@"_%@", key];
    NSString *_isKey = [NSString stringWithFormat:@"_is%@", key.capitalizedString];
    NSString *isKey = [NSString stringWithFormat:@"is%@", key.capitalizedString];
    
    NSArray *keys = @[_key, _isKey, key, isKey];
    NSArray *names = [self getIvarListName];
    for(NSString *key in keys) {
        if ([names containsObject:key]) {
            Ivar ivar = class_getInstanceVariable([self class], key.UTF8String);
            return object_getIvar(self, ivar);
        }
    }
    
    return nil;
}

- (id) checkPerformSelector:(NSString *) methodName {
    SEL sel = NSSelectorFromString(methodName);
    if([self respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [self performSelector:sel];
#pragma clang diagnostic pop
    }
    
    return nil;
}

- (BOOL) mx_performSelector:(NSString *) methodName withObject:(id) object {
    SEL sel = NSSelectorFromString(methodName);
    if ([self respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:sel withObject:object];
#pragma clang diagnostic pop
        return YES;
    }
    
    return NO;
}

- (NSMutableArray *)getIvarListName {
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:1];
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *ivarNameChar = ivar_getName(ivar);
        NSString *ivarName = [NSString stringWithUTF8String:ivarNameChar];
        [mArray addObject:ivarName];
    }
    
    free(ivars);
    return mArray;
}

@end
