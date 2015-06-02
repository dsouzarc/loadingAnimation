//
//  RDTwoImageLoadingAnimation.m
//  RDLoadingAnimation
//
//  Created by Ryan D'souza on 6/1/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "RDTwoImageLoadingAnimation.h"

@interface RDTwoImageLoadingAnimation ()

@property (strong, nonatomic) UIView *view;

@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UIImageView *rightImageView;

@property (strong, nonatomic) UIImage *leftImage;
@property (strong, nonatomic) UIImage *rightImage;

@property (strong, nonatomic) UIBezierPath *parabolaPath;
@property (strong, nonatomic) NSMutableArray *bezierPathPoints;
@property (strong, nonatomic) NSMutableArray *animationPathPoints;

@property CGFloat viewCenterY;
@property CGFloat viewWidth;

@property CGPoint leftImageCenter;
@property CGPoint rightImageCenter;

@property CGFloat imageSpaceFromEnd;


@end

@implementation RDTwoImageLoadingAnimation

- (instancetype) initOnView:(UIView *)view
{
    CGSize size = CGSizeMake(50, 50);
    UIImage *leftImage = [RDTwoImageLoadingAnimation makeBlankImage:[UIColor blackColor] size:size];
    UIImage *rightImage = [RDTwoImageLoadingAnimation makeBlankImage:[UIColor brownColor] size:size];
    
    self = [self initOnView:view leftImage:leftImage rightImage:rightImage];
    return self;
}

- (instancetype) initOnView:(UIView *)view leftImage:(UIImage *)leftImage rightImage:(UIImage *)rightImage
{
    self = [self initOnView:view leftImage:leftImage rightImage:rightImage ballColor:[UIColor blueColor] animationType:PARABOLA];
    return self;
}

- (instancetype) initOnView:(UIView *)view leftImage:(UIImage *)leftImage rightImage:(UIImage *)rightImage ballColor:(UIColor *)ballColor animationType:(ANIMATION_TYPE)animationType
{
    self = [super init];
    
    if(self) {
        
        self.view = view;
        self.leftImage = leftImage;
        self.rightImage = rightImage;
        self.ballColor = ballColor;
        self.loadingAnimationType = animationType;
        
        self.showLoaderFunction = NO;
        self.loaderFunctionColor = [UIColor blackColor];
        self.loaderFunctionThickness = 5.0;
        
        self.numBalls = 5;
        self.ballRadius = 5;
        self.ballRadiusChangesSize = YES;
        self.maxBallRadius = self.ballRadius * 2;
    }
    
    return self;
}
- (void) show
{
    //If the view hasn't been shown before, initialize the ImageViews
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
    
    //Draw them on the screen
    [self.view addSubview:self.leftImageView];
    [self.view addSubview:self.rightImageView];
}

- (CGFloat) parabolaY:(CGFloat)x
{
    //y = a(x - h)^2 + k
    CGFloat a = 0.015;
    CGFloat h = self.view.center.x;
    CGFloat k = self.view.frame.size.height * 1/14;
    
    CGFloat y = a * pow(x - h, 2) + k;
    
    return y;
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

//For the UIBezierPath
/*if(!self.parabolaPath) {
 self.parabolaPath = [UIBezierPath bezierPath];
 
 [self.parabolaPath moveToPoint:CGPointMake(self.leftImageView.center.x, self.leftImageView.frame.origin.y)];
 [self.parabolaPath addArcWithCenter:CGPointMake(self.view.center.x, self.view.bounds.size.height * 2.5/12) radius:self.view.center.x - self.leftImageView.center.x startAngle:START_ANGLE endAngle:END_ANGLE clockwise:YES];
 [self.parabolaPath addLineToPoint:CGPointMake(self.rightImageView.center.x, self.rightImageView.frame.origin.y)];
 [self.parabolaPath addArcWithCenter:CGPointMake(self.view.center.x, self.view.bounds.size.height * 4/12) radius:self.view.center.x - self.leftImageView.center.x startAngle:START_ANGLE endAngle:END_ANGLE clockwise:YES];
 [self.parabolaPath addLineToPoint:CGPointMake(self.rightImageView.center.x, self.rightImageView.frame.origin.y)];
 
 CGPoint theCenter = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height * 1/4);
 CGFloat innerRadius = (self.rightImageView.center.x - self.leftImageView.center.x)/2;
 CGFloat outerRadius = innerRadius + BEZIER_DISTANCE;
 
 [self.parabolaPath addArcWithCenter:theCenter radius:innerRadius
 startAngle:START_ANGLE endAngle:END_ANGLE clockwise:YES];
 
 [self.parabolaPath addLineToPoint:CGPointMake(self.rightImageView.center.x,
 self.rightImageView.frame.origin.y)];
 [self.parabolaPath addLineToPoint:CGPointMake(self.rightImageView.center.x + BEZIER_DISTANCE,
 self.rightImageView.frame.origin.y)];
 
 [self.parabolaPath addArcWithCenter:theCenter radius:outerRadius
 startAngle:END_ANGLE endAngle:START_ANGLE clockwise:NO];
 
 [self.parabolaPath addLineToPoint:CGPointMake(self.leftImageView.center.x,
 self.leftImageView.frame.origin.y)];
 [self.parabolaPath addLineToPoint:CGPointMake(self.leftImageView.center.x + BEZIER_DISTANCE,
 self.leftImageView.frame.origin.y)];
 
 [self.parabolaPath closePath];
 }
 
 if(self.showTossingParabola) {
 CAShapeLayer *shapeForPath = [[CAShapeLayer alloc] init];
 
 [shapeForPath setPath:self.parabolaPath.CGPath];
 [shapeForPath setFillColor:[self.tossingParabolaLineColor CGColor]];
 
 [[self.view layer] addSublayer:shapeForPath];
 
 UIBezierPath *yourPath = self.parabolaPath;
 CGPathRef yourCGPath = yourPath.CGPath;
 self.bezierPathPoints = [NSMutableArray array];
 CGPathApply(yourCGPath, (__bridge void *)(self.bezierPathPoints), MyCGPathApplierFunc); */
