//
//  User.h
//  KVC&KVO
//
//  Created by muhlenXi on 2020/11/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic,strong) NSString *nickname;

+ (instancetype) sharedInstance;

@end

NS_ASSUME_NONNULL_END
