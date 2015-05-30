//
//  RDTossingLoadingAnimation.m
//  RDLoadingAnimation
//
//  Created by Ryan D'souza on 5/30/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "RDTossingLoadingAnimation.h"

@implementation RDTossingLoadingAnimation


/****************************/
//    CONSTRUCTORS
/****************************/

- (instancetype) initOnView:(UIView *)view leftImage:(UIImage *)leftImage rightImage:(UIImage *)rightImage tossingColor:(UIColor *)tossingColor
{
    self = [super init];
    
    if(self) {
        self.view = view;
        self.leftImage = leftImage;
        self.rightImage = rightImage;
        self.tossingColor = tossingColor;
        
        self.numBalls = 8;
        self.showTossingParabola = YES;
    }
    
    return self;
}

- (instancetype) initOnView:(UIView *)view leftImage:(UIImage *)leftImage rightImage:(UIImage *)rightImage
{
    self = [self initOnView:view leftImage:leftImage rightImage:rightImage tossingColor:[UIColor blueColor]];
    return self;
}

- (instancetype) initOnView:(UIView *)view
{
    CGSize blankSize = CGSizeMake(50, 50);
    UIColor *fillColor = [UIColor blackColor];
    UIGraphicsBeginImageContextWithOptions(blankSize, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [fillColor setFill];
    CGRect rect = (CGRect){CGPointZero, blankSize};
    CGContextFillRect(context, rect);
    UIImage *leftImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *rightImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self = [self initOnView:view leftImage:leftImage rightImage:rightImage];
    return self;
}

@end
