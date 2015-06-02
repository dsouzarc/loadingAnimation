//
//  RDTwoImageLoadingAnimation.h
//  RDLoadingAnimation
//
//  Created by Ryan D'souza on 6/1/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum ANIMATION_TYPE{LINE, PARABOLA}ANIMATION_TYPE;

@interface RDTwoImageLoadingAnimation : NSObject

- (instancetype) initOnView:(UIView*)view;
- (instancetype) initOnView:(UIView *)view leftImage:(UIImage*)leftImage rightImage:(UIImage*)rightImage;
- (instancetype) initOnView:(UIView *)view leftImage:(UIImage *)leftImage rightImage:(UIImage *)rightImage ballColor:(UIColor*)ballColor animationType:(ANIMATION_TYPE)animationType;

- (void) show;
- (void) hide;
+ (UIImage*)resizeImage:(UIImage*)originalImage newSize:(CGSize)newSize;
+ (UIImage*)makeBlankImage:(UIColor*)color size:(CGSize)size;

@property ANIMATION_TYPE loadingAnimationType;

@property BOOL showLoaderFunction;
@property (strong, nonatomic) UIColor *loaderFunctionColor;
@property CGFloat loaderFunctionThickness;

@property NSInteger numBalls;
@property CGFloat ballRadius;
@property (strong, nonatomic) UIColor *ballColor;
@property BOOL ballRadiusChangesSize;
@property CGFloat maxBallRadius;

@end
