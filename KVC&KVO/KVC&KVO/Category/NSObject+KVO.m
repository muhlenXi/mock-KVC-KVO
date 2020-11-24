//
//  NSObject+KVO.m
//  KVC&KVO
//
//  Created by muhlenXi on 2020/11/24.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

static NSString *const kMXBlockOAssiociateKey = @"kMXBlockOAssiociateKey";

@implementation NSObject (KVO)

- (void)mx_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath handleBlock:(MXBlock)block {
    // 1、检查 setter
    [self checkSetterForKeyPath:keyPath];
    // 2、动态添加子类
    Class newClass = [self createChildClassWithKeyPath:keyPath];
    // 3、修改 isa
    object_setClass(self, newClass);
    // 4、保存观察者
    [self as_saveObserver:observer block:block keyPath:keyPath];
}

- (void)mx_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    NSInteger remain = [self as_removeObserver:observer keyPath:keyPath];
    if (remain <= 0) {
        Class class = [self class];
        object_setClass(self, class);
    }
}

// 检查是否实现 setter 方法
- (void)checkSetterForKeyPath:(NSString *)keyPath {
    Class class = object_getClass(self);
    SEL setter = NSSelectorFromString([self setterForKeyPath:keyPath]);
    Method setterMethod = class_getInstanceMethod(class, setter);
    if (!setterMethod) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@" %@ 没有 %@ setter 方法", NSStringFromClass(class), keyPath] userInfo:nil];
    }
}

- (Class)createChildClassWithKeyPath:(NSString *)keyPath {
    NSString *oldClassName = NSStringFromClass([self class]);
    NSString *newClassName = [NSString stringWithFormat:@"MXKVONotifying_%@", oldClassName];
    
    Class newClass = NSClassFromString(newClassName);
    if (!newClass) {
        // 1、注册 new class
        newClass = objc_allocateClassPair([self class], newClassName.UTF8String, 0);
        objc_registerClassPair(newClass);
        
        // 2、添加 class 方法
        SEL classSEL = NSSelectorFromString(@"class");
        Method classMethod = class_getInstanceMethod([self class], classSEL);
        const char *classType = method_getTypeEncoding(classMethod);
        class_addMethod(newClass, classSEL, (IMP) mxClass, classType);
        
        // 3、添加 dealloc 方法
        SEL deallocSEL = NSSelectorFromString(@"dealloc");
        Method deallocMethod = class_getInstanceMethod([self class], deallocSEL);
        const char *deallocType = method_getTypeEncoding(deallocMethod);
        class_addMethod(newClass, deallocSEL, (IMP) mxDealloc, deallocType);
    }
    
    // 0、添加 setter
    SEL setterSEL = NSSelectorFromString([self setterForKeyPath:keyPath]);
    Method setterMethod = class_getInstanceMethod([self class], setterSEL);
    const char *setterType = method_getTypeEncoding(setterMethod);
    class_addMethod(newClass, setterSEL, (IMP) mxSetter, setterType);
    
    return newClass;
}

static void mxDealloc(id self, SEL _cmd) {
    Class class = [self class];
    object_setClass(self, class);
    
    objc_removeAssociatedObjects(self);
    
    NSLog(@"%@", [NSString stringWithFormat:@"%@ 释放了", NSStringFromClass([self class])]);
}

static Class mxClass(id self, SEL _cmd) {
    return class_getSuperclass(object_getClass(self));
}

static void mxSetter(id self, SEL _cmd, id newValue) {
    // 转发消息给父类，赋值
    Class superClass = class_getSuperclass(object_getClass(self));
    void (*mx_msgSendSuper)(void *, SEL, id) = (void *)objc_msgSendSuper;
    struct objc_super father;
    father.receiver = self;
    father.super_class = superClass;
    mx_msgSendSuper(&father, _cmd, newValue);
    
    NSDictionary *info = objc_getAssociatedObject(self,  (__bridge const void * _Nonnull)(kMXBlockOAssiociateKey));
    NSString *setterName = [self keyPathFromSelector:_cmd];
    
    // block 回调
    for (NSString *key in info) {
        if ([key containsString:setterName]) {
            MXBlock block = (MXBlock) info[key];
            block(newValue);
        }
    }
}

- (NSString *)setterForKeyPath:(NSString *)keyPath {
    if (keyPath.length <= 0) {
        return nil;
    }
    
    NSString *firstString = [[keyPath substringToIndex:1] uppercaseString];
    NSString *leaveString = [keyPath substringFromIndex:1];
    
    return [NSString stringWithFormat:@"set%@%@:",firstString,leaveString];
}

- (NSString *)keyPathFromSelector:(SEL) selector {
    NSString *setterName = NSStringFromSelector(selector);
    if (setterName.length > 0 && [setterName hasPrefix:@"set"] && [setterName hasSuffix:@":"]) {
        NSRange range = NSMakeRange(3, setterName.length-4);
        NSString *name = [setterName substringWithRange:range];
        NSString *first = [[name substringToIndex:1] lowercaseString];
        NSString *leaveString = [name substringFromIndex:1];
        return [first stringByAppendingString:leaveString];
    } else {
        return nil;
    }
}

- (void)as_saveObserver:(NSObject *) observer block:(MXBlock) block keyPath:(NSString *) keyPath {
    NSMutableDictionary *info = objc_getAssociatedObject(self,  (__bridge const void * _Nonnull)(kMXBlockOAssiociateKey));
    if(!info) {
        info = [NSMutableDictionary dictionary];
    }
    
    NSString *blockKey = [NSString stringWithFormat:@"%@-%@", NSStringFromClass([observer class]), keyPath];
    info[blockKey] = block;
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kMXBlockOAssiociateKey), info, OBJC_ASSOCIATION_RETAIN);
}

- (NSInteger)as_removeObserver:(NSObject *) observer keyPath:(NSString *) keyPath {
    NSMutableDictionary *info = objc_getAssociatedObject(self,  (__bridge const void * _Nonnull)(kMXBlockOAssiociateKey));
    if(!info) {
        info = [NSMutableDictionary dictionary];
    }
    NSString *blockKey = [NSString stringWithFormat:@"%@-%@", NSStringFromClass([observer class]), keyPath];
    [info removeObjectForKey:blockKey];
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kMXBlockOAssiociateKey), info, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (info.count == 0) {
        objc_removeAssociatedObjects(self);
    }
    return info.count;
}

@end
