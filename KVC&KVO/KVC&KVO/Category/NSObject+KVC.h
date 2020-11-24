//
//  NSObject+KVC.h
//  KVC&KVO
//
//  Created by muhlenXi on 2020/10/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KVC)

- (void)mx_setValue:(id)value forKey:(NSString *)key;
- (id)mx_valueForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
