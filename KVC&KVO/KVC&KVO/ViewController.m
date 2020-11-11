//
//  ViewController.m
//  KVC&KVO
//
//  Created by muhlenXi on 2020/10/28.
//

#import "ViewController.h"
#import "Person.h"
#import "NSObject+KVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Person *person = [Person alloc];
    Pet *dog = [Pet alloc];
    dog -> _name = @"wang wang";
    
//    [person setValue: @"muhlenxi" forKey:@"name"];
    [person mx_setValue:@"mx" forKey:@"name"];
    [person mx_setValue:@[@"fish", @"cook"] forKey:@"hobbies"];
//    [person setValue:@18 forKey:@"age"];
//    [person setValue:@50.66 forKey:@"weight"];
//     [person setValue:@185 forKey:@"height"];             // will crash
//    [person setValue:dog forKey:@"pet"];

//    [person setValue:@"wang cai" forKey:@"pet.name"];    // will crash
//    [person setValue:@"wang cai" forKeyPath:@"pet.name"];
    
    //NSLog(@"\n_name == %@ \n_isName == %@ \nname ==  %@ \nisName ==  %@", person -> _name, person -> _isName, person -> name, person -> isName);
    //NSLog(@"\n_isName == %@ \nname ==  %@ \nisName ==  %@", person -> _isName, person -> name, person -> isName);
    //NSLog(@"\nname ==  %@ \nisName ==  %@", person -> name, person -> isName);
//    NSLog(@"isName ==  %@",person -> isName);
    
    NSString *readName = [person mx_valueForKey:@"name"];
    NSArray *hobbies = [person mx_valueForKey:@"hobbies"];
    NSLog(@"readName = %@", readName);
    NSLog(@"hobbies = %@", hobbies);
//    NSString *petName = [person valueForKeyPath:@"pet.name"];
//    NSLog(@"petName = %@", petName);
    
//    NSLog(@"%@", person -> _name);
//    NSLog(@"%ld", person -> _age);
//    NSLog(@"%.2f", person.weight);
//    NSLog(@"%@", person.pet.name);
}


@end
