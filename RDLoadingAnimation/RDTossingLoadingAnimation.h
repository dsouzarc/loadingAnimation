//
//  RDTossingLoadingAnimation.h
//  RDLoadingAnimation
//
//  Created by Ryan D'souza on 5/30/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface RDTossingLoadingAnimation : NSObject

- (instancetype) initOnView:(UIView*)view;
- (instancetype) initOnView:(UIView *)view leftImage:(UIImage*)leftImage rightImage:(UIImage*)rightImage;
- (instancetype) initOnView:(UIView *)view leftImage:(UIImage *)leftImage rightImage:(UIImage *)rightImage tossingColor:(UIColor*)tossingColor;

@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UIImage *leftImage;
@property (strong, nonatomic) UIImage *rightImage;
@property (strong, nonatomic) UIColor *tossingColor;

@property NSInteger numBalls;
@property BOOL showTossingParabola;

@end
