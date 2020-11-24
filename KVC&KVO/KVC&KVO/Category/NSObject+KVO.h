//
//  NSObject+KVO.h
//  KVC&KVO
//
//  Created by muhlenXi on 2020/11/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MXBlock)(id newValue);

@interface NSObject (KVO)

- (void)mx_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath handleBlock:(MXBlock)block;
- (void)mx_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
