//
//  Person.m
//  KVC&KVO
//
//  Created by muhlenXi on 2020/10/28.
//

#import "Person.h"
#import "NSObject+Print.h"

@implementation Person

- (void) hello {
    [self printFunctionDescription:_cmd];
}

//- (void)setName:(NSString *)name {
//    isName = name;
//    [self printFunctionDescription:_cmd];
//}

//- (void)_setName:(NSString *)name {
//    isName = name;
//    [self printFunctionDescription:_cmd];
//}

//+ (BOOL)accessInstanceVariablesDirectly {
//    [self printFunctionDescription:_cmd];
//    return YES;
//}

//- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    [self printFunctionDescription:_cmd];
//}



//- (NSString *) getName {
//    [self printFunctionDescription:_cmd];
//    return isName;
//}

//- (NSString *) name {
//    [self printFunctionDescription:_cmd];
//    return isName;
//}

//- (NSString *) isName {
//    [self printFunctionDescription:_cmd];
//    return isName;
//}

//- (NSString *) _name {
//    [self printFunctionDescription:_cmd];
//    return isName;
//}

@end
