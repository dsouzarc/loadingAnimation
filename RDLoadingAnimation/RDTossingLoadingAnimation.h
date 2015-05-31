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

- (void) show;
- (void) hide;
+ (UIImage*)resizeImage:(UIImage*)originalImage newSize:(CGSize)newSize;

@property (strong, nonatomic) UIImage *leftImage;
@property (strong, nonatomic) UIImage *rightImage;
@property (strong, nonatomic) UIColor *tossingColor;
@property (strong, nonatomic) UIColor *tossingParabolaLineColor;

@property NSInteger numBalls;
@property BOOL showTossingParabola;

@end
