//
//  Clock.h
//  KVC&KVO
//
//  Created by muhlenXi on 2020/11/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Clock : NSObject

@property (nonatomic,assign) NSInteger  hour;
@property (nonatomic,assign) NSInteger  minute;
@property (nonatomic,assign) NSInteger  second;
@property (nonatomic,strong) NSString *clockName;

@end

NS_ASSUME_NONNULL_END
