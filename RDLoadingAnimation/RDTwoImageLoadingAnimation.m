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

@property (strong, nonatomic) NSMutableArray *allPathPoints;

@property CGFloat ONE_TWELFTH;

@property CGFloat screenWidth;
@property CGFloat screenHeight;

@property CGFloat leftImageWidth;
@property CGFloat leftImageHeight;
@property CGPoint leftImageCenter;

@property CGFloat rightImageWidth;
@property CGFloat rightImageHeight;
@property CGPoint rightImageCenter;

@property CGFloat spaceFromEnd;
@property CGFloat spaceBetweenImages;

@property CGFloat viewCenterY;
@property CGFloat viewWidth;

@property CGFloat imageSpaceFromEnd;

@property CGFloat parabolaH;
@property CGFloat parabolaA;
@property CGFloat parabolaK;

@property CGFloat loadingStartX;
@property CGFloat loadingEndX;
@property CGFloat loadingIncrement;


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
    self = [self initOnView:view leftImage:leftImage rightImage:rightImage ballColor:[UIColor blueColor] animationType:LOADING_ANIMATION_PARABOLA];
    return self;
}

- (instancetype) initOnView:(UIView *)view leftImage:(UIImage *)leftImage rightImage:(UIImage *)rightImage ballColor:(UIColor *)ballColor animationType:(ANIMATION_TYPE)animationType
{
    self = [super init];
    
    if(self) {
        self.allPathPoints = [[NSMutableArray alloc] init];
        
        self.view = view;
        self.leftImage = leftImage;
        self.rightImage = rightImage;
        self.ballColor = ballColor;
        self.loadingAnimationType = animationType;
        
        self.showLoaderFunction = NO;
        self.loaderFunctionColor = [UIColor blackColor];
        self.loaderFunctionThickness = 3;
        
        self.numBalls = 5;
        self.ballRadius = 5;
        self.ballRadiusChangesSize = YES;
        self.maxBallRadius = self.ballRadius * 2;
    }
    
    return self;
}

- (void) show
{
    self.screenWidth = self.view.frame.size.width;
    self.screenHeight = self.view.frame.size.height;
    
    self.ONE_TWELFTH = self.screenWidth * 1/12;
    
    NSLog(@"1/12: %f", self.ONE_TWELFTH);
    self.spaceFromEnd = self.ONE_TWELFTH;
    self.spaceBetweenImages = self.ONE_TWELFTH * 4;
    
    self.leftImageWidth = self.leftImage.size.width < self.ONE_TWELFTH * 3 ? self.leftImage.size.width : self.ONE_TWELFTH * 3;
    self.leftImageHeight = self.leftImage.size.height / (self.leftImage.size.width / self.leftImageWidth);
    self.leftImageCenter = CGPointMake(self.spaceFromEnd + self.leftImageWidth / 2, self.screenHeight / 2);
    
    self.rightImageWidth = self.rightImage.size.width < self.ONE_TWELFTH * 3 ? self.rightImage.size.width : self.ONE_TWELFTH * 3;
    self.rightImageHeight = self.leftImage.size.height / (self.rightImage.size.width / self.rightImageWidth);
    self.rightImageCenter = CGPointMake(self.screenWidth - self.spaceFromEnd - (self.rightImageWidth / 2), self.screenHeight/ 2);
    
    //If the view hasn't been shown before, initialize the ImageViews
    if(!self.leftImageView) {
        CGRect imageDimensions = CGRectMake(self.leftImageCenter.x, self.leftImageCenter.y, self.leftImageWidth, self.leftImageHeight);
        
        self.leftImageView = [[UIImageView alloc] initWithFrame:imageDimensions];
        [self.leftImageView setImage:self.leftImage];
        self.leftImageView.center = self.leftImageCenter;
    }

    if(!self.rightImageView) {
        CGRect imageDimensions = CGRectMake(self.rightImageCenter.x, self.rightImageCenter.y, self.leftImageWidth, self.rightImageHeight);
        self.rightImageView = [[UIImageView alloc] initWithFrame:imageDimensions];
        [self.rightImageView setImage:self.rightImage];
        self.rightImageView.center = self.rightImageCenter;
    }
    
    //Draw them on the screen
    [self.view addSubview:self.leftImageView];
    [self.view addSubview:self.rightImageView];
    
    self.parabolaH = (((self.rightImageView.frame.origin.x + self.rightImageView.frame.size.width) - self.leftImageView.frame.origin.x) / 2) + self.leftImageView.frame.origin.x;
    self.parabolaA = 0.015;
    self.parabolaK = self.view.frame.size.height * 1/16;
    
    
    switch (self.loadingAnimationType) {
        case LOADING_ANIMATION_LINE:
            for(float i = self.leftImageView.frame.origin.x + self.leftImageView.frame.size.width; i < self.rightImageView.frame.origin.x; i += 1) {
                CGPoint point = CGPointMake(i, self.screenHeight / 2);
                [self.allPathPoints addObject:[NSValue valueWithCGPoint:point]];
            }
            
            break;
        case LOADING_ANIMATION_PARABOLA:
            for(float i = self.leftImageView.frame.origin.x; i < self.rightImageView.frame.origin.x + self.rightImageView.frame.size.width; i+= 0.1) {
                CGPoint point = CGPointMake(i, [self parabolaY:i]);
                
                //If the point is above the left image view, add it
                if((i <= self.screenWidth/2 && point.y <= self.leftImageView.frame.origin.y) || (i > self.screenWidth/2 && point.y < self.rightImageView.frame.origin.y)) {
                    [self.allPathPoints addObject:[NSValue valueWithCGPoint:point]];
                }
            }
            break;
    }
    self.showLoaderFunction = YES;
    if(self.showLoaderFunction) {
        for(int i = 0; i < self.allPathPoints.count; i++) {
            CGPoint point = [self.allPathPoints[i] CGPointValue];
            UIView *circleView = [self circleViewAtPoint:point radius:self.loaderFunctionThickness color:self.loaderFunctionColor];
            [self.view addSubview:circleView];
        }
    }
    
    __block UIView *circleView;
    __block NSInteger index = 0;
    id addCircle = ^{
        [circleView removeFromSuperview];
        circleView = [self circleViewAtPoint:[self.allPathPoints[index] CGPointValue] radius:self.ballRadius color:self.ballColor];
        [self.view addSubview:circleView];
        index+= 10;
        
        if(index >= self.allPathPoints.count) {
            index = 0;
        }
    };
    
    NSTimer* timer = [NSTimer timerWithTimeInterval:0.2f target:addCircle selector:@selector(invoke) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //load your data here.
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *circleView = [self circleViewAtPoint:[self.allPathPoints[0] CGPointValue] radius:self.ballRadius color:self.ballColor];
            [self.view addSubview:circleView];
            
            for(int i = 0; i < self.allPathPoints.count; i+= self.ballRadius) {
                //[NSThread sleepForTimeInterval:1.0f];
                //[circleView removeFromSuperview];
                NSLog(@"Here");
                circleView = [self circleViewAtPoint:[self.allPathPoints[i] CGPointValue] radius:8 color:self.ballColor];
                //[self.view addSubview:circleView];
            }
        });
    });
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{

        
    }];
}

- (UIView*) circleViewAtPoint:(CGPoint)point radius:(CGFloat)radius color:(UIColor*)color
{
    UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, radius, radius)];
    circleView.layer.cornerRadius = radius / 2;
    circleView.backgroundColor = color;
    return circleView;
}

- (CGFloat) parabolaY:(CGFloat)x
{
    //y = a(x - h)^2 + k
    CGFloat y = self.parabolaA * pow(x - self.parabolaH, 2) + self.parabolaK;
    
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
