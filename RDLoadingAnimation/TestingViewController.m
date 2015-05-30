//
//  TestingViewController.m
//  RDLoadingAnimation
//
//  Created by Ryan D'souza on 5/30/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "TestingViewController.h"
#import "RDTossingLoadingAnimation.h"

@interface TestingViewController ()

@property (strong, nonatomic) RDTossingLoadingAnimation *tossingLoadingAnimation;

@end

@implementation TestingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *leftImage = [UIImage imageNamed:@"facebook_f_icon.png"];
    leftImage = [RDTossingLoadingAnimation resizeImage:leftImage newSize:CGSizeMake(100, 100)];
    
    UIImage *rightImage = [UIImage imageNamed:@"white_iphone.png"];
    rightImage = [RDTossingLoadingAnimation resizeImage:rightImage newSize:CGSizeMake(100, 210)];
    
    self.tossingLoadingAnimation = [[RDTossingLoadingAnimation alloc] initOnView:self.view leftImage:leftImage rightImage:rightImage tossingColor:[UIColor blueColor]];
     [self.tossingLoadingAnimation show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
