//
//  ViewController.m
//  KVC&KVO
//
//  Created by muhlenXi on 2020/10/28.
//

#import "ViewController.h"
#import "KVCViewController.h"
#import "KVOViewController.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
}



- (IBAction)kvcButtonAction:(UIButton *)sender {
    KVCViewController *kvc = [KVCViewController new];
    [self.navigationController pushViewController:kvc animated:YES];
}

- (IBAction)kvoButtonAction:(id)sender {
    KVOViewController *kvo = [KVOViewController new];
    [self.navigationController pushViewController:kvo animated:YES];
}



@end
