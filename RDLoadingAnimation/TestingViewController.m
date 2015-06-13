//
//  TestingViewController.m
//  RDLoadingAnimation
//
//  Created by Ryan D'souza on 5/30/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "TestingViewController.h"
#import "RDTwoImageLoadingAnimation.h"

@interface TestingViewController ()

@property (strong, nonatomic) RDTwoImageLoadingAnimation *tossingLoadingAnimation;

@end

@implementation TestingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *leftImage = [UIImage imageNamed:@"facebook_f_icon.png"];
    //leftImage = [RDTwoImageLoadingAnimation resizeImage:leftImage newSize:CGSizeMake(100, 100)];
    
    UIImage *rightImage = [UIImage imageNamed:@"white_iphone.png"];
    //rightImage = [RDTwoImageLoadingAnimation resizeImage:rightImage newSize:CGSizeMake(100, 210)];
    
    self.tossingLoadingAnimation = [[RDTwoImageLoadingAnimation alloc] initOnView:self.view leftImage:leftImage rightImage:rightImage ballColor:[UIColor blueColor] animationType:LOADING_ANIMATION_PARABOLA];
    self.tossingLoadingAnimation.ballRadius = 8;
    self.tossingLoadingAnimation.loaderFunctionThickness = 2;
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
