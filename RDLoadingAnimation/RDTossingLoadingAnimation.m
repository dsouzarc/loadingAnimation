//
//  RDTossingLoadingAnimation.m
//  RDLoadingAnimation
//
//  Created by Ryan D'souza on 5/30/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "RDTossingLoadingAnimation.h"

@interface RDTossingLoadingAnimation ()

@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UIImageView *rightImageView;

@property CGFloat viewCenterY;
@property CGFloat viewWidth;

@property CGPoint leftImageCenter;
@property CGPoint rightImageCenter;

@property CGFloat imageSpaceFromEnd;

@end

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
        
        self.viewCenterY = self.view.frame.size.height / 2;
        self.viewWidth = self.view.frame.size.width;
        
        CGFloat availableSpaceX = self.viewWidth - (self.leftImage.size.width + self.rightImage.size.width);
        self.imageSpaceFromEnd = availableSpaceX * 1/6;
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
    CGSize size = CGSizeMake(50, 50);
    UIImage *leftImage = [RDTossingLoadingAnimation makeBlankImage:[UIColor blackColor] size:size];
    UIImage *rightImage = [RDTossingLoadingAnimation makeBlankImage:[UIColor brownColor] size:size];
    
    self = [self initOnView:view leftImage:leftImage rightImage:rightImage];
    return self;
}

- (void) show
{
    if(!self.leftImageView) {
        CGFloat imageCenterX = self.imageSpaceFromEnd + (self.leftImage.size.width / 2);
        CGRect imageDimensions = CGRectMake(imageCenterX, self.viewCenterY, self.leftImage.size.width, self.leftImage.size.height);
        
        self.leftImageView = [[UIImageView alloc] initWithFrame:imageDimensions];
        [self.leftImageView setImage:self.leftImage];
        self.leftImageView.center = CGPointMake(imageCenterX, CGRectGetMidY(self.view.bounds));
    }
    
    if(!self.rightImageView) {
        CGFloat imageCenterX = self.viewWidth - (self.imageSpaceFromEnd + self.rightImage.size.width / 2);
        CGRect imageDimensions = CGRectMake(imageCenterX, self.viewCenterY, self.rightImage.size.width, self.rightImage.size.height);
        
        self.rightImageView = [[UIImageView alloc] initWithFrame:imageDimensions];
        [self.rightImageView setImage:self.rightImage];
        self.rightImageView.center = CGPointMake(imageCenterX, CGRectGetMidY(self.view.bounds));
    }
    
    [self.view addSubview:self.leftImageView];
    [self.view addSubview:self.rightImageView];
}

- (void) hide
{
    
}

+ (UIImage*) makeBlankImage:(UIColor*)color size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGRect rect = (CGRect){CGPointZero, size};
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage*) resizeImage:(UIImage *)originalImage newSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [originalImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
