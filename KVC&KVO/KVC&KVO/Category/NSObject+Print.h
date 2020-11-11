//
//  NSObject+Print.h
//  KVC&KVO
//
//  Created by muhlenXi on 2020/10/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Print)

- (void)printFunctionDescription: (SEL) sel;

@end

NS_ASSUME_NONNULL_END
