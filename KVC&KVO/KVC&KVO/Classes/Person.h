//
//  Person.h
//  KVC&KVO
//
//  Created by muhlenXi on 2020/10/28.
//

#import <Foundation/Foundation.h>
#import "Pet.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject {
    @public
    NSString *isName;
//    NSString *name;
//    NSString *_isName;
//    NSString *_name;
    
    NSInteger  _age;
}


@property (nonatomic,assign) double  weight;
@property (nonatomic,strong) Pet *pet;
@property (nonatomic,strong) NSArray * hobbies;

@end

NS_ASSUME_NONNULL_END
