//
//  SignatureCaptureView.m
//  iTIMS
//
//  Created by John Laxson on 6/3/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import "SignatureCaptureView.h"


@implementation SignatureCaptureView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGColorSpaceRef space = CGColorSpaceCreateDeviceGray();
        _drawCtx = CGBitmapContextCreate(NULL, 480, 320, 8, 480, space, kCGBitmapAlphaInfoMask);
        CGColorSpaceRelease(space);
        
        [self clear];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    [self clear];
    
    CGRect bounds = self.layer.bounds;
    CGColorRef gray = [[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.8] CGColor];
    
    float insetX = 50, insetY = 50;
    CALayer *l = [[CALayer alloc] init];
    l.backgroundColor = gray;
    l.frame = CGRectMake(0, 0, bounds.size.width, insetY);
    [self.layer addSublayer:l];
    
    l = [[CALayer alloc] init];
    l.backgroundColor = gray;
    l.frame = CGRectMake(0, bounds.size.height-insetY, bounds.size.width, insetY+50);
    [self.layer addSublayer:l];
    
    l = [[CALayer alloc] init];
    l.backgroundColor = gray;
    l.frame = CGRectMake(0, insetY, insetX, bounds.size.height-(2*insetY));
    [self.layer addSublayer:l];
    
    l = [[CALayer alloc] init];
    l.backgroundColor = gray;
    l.frame = CGRectMake(bounds.size.width-insetX, insetY, insetX, bounds.size.height-(2*insetY));
    [self.layer addSublayer:l];
    
    self.layer.geometryFlipped = YES;
    
    return self;
}

- (void)clear
{
    if (_drawCtx) {
        CGContextRelease(_drawCtx);
    }
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceGray();
    _drawCtx = CGBitmapContextCreate(NULL, 480, 320, 8, 480, space, 0);
    CGColorSpaceRelease(space);

    CGFloat wcolor[4] = {1, 1, 1, 1};
    CGContextSetFillColor(_drawCtx, wcolor);
    CGContextFillRect(_drawCtx, CGRectMake(0, 0, 480, 320));
    CGContextStrokePath(_drawCtx);
    
    CGFloat bcolor[4] = {0, 1, 0, 0};
    CGContextSetStrokeColor(_drawCtx, bcolor);
    CGContextSetLineWidth(_drawCtx, 2);
    CGContextSetFillColor(_drawCtx, bcolor);
    
    [self setNeedsDisplay];
}

- (UIImage *)image {
    CGImageRef cgImage = CGBitmapContextCreateImage(_drawCtx);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return image;
}

/*
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    return;
    if (layer == self.layer) {
        
    } else {
        float insetX = 50, insetY = 50;
        CGFloat color[4] = {.3, .3, .3, .8};
        CGContextSetFillColor(ctx, color);
        CGContextFillRect(ctx, CGRectMake(0, 0, self.bounds.size.width, insetY));
    }
}*/

- (void)drawRect:(CGRect)rect {
    /*
    [[UIColor whiteColor] set];
    UIRectFill(self.bounds);
    
    CGImageRef img = CGBitmapContextCreateImage(_drawCtx);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), self.bounds, img);
    CGImageRelease(img);
    
    [[UIColor colorWithRed:1 green:0 blue:0 alpha:0] set];
    
    UIRectFill(CGRectMake(0, 0, self.bounds.size.width, insetY));
    UIRectFill(CGRectMake(0, self.bounds.size.height-insetY, self.bounds.size.width, insetY));
    UIRectFill(CGRectMake(0, insetY, insetX, self.bounds.size.height-(2*insetY)));
    UIRectFill(CGRectMake(self.bounds.size.width-insetX, insetY, insetX, self.bounds.size.height-(2*insetY)));*/
}

- (void)dealloc
{
    [super dealloc];
}

- (CGPoint) mapPoint:(CGPoint)p {
    CGPoint ret;
    ret.x = (p.x/self.bounds.size.width) * 480;
    ret.y = (p.y/self.bounds.size.height) * 320;
    return ret;
}

- (void)updateToTouch:(CGPoint)p
{
    p = [self mapPoint:p];
    
    CGContextMoveToPoint(_drawCtx, lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(_drawCtx, p.x, p.y);
    CGContextStrokePath(_drawCtx);
    
    //NSLog(@"Line from %f,%f to %f,%f", lastPoint.x, lastPoint.y, p.x, p.y);
    
    lastPoint = p;
    
    [self setNeedsDisplay];
    
    
    self.layer.contents = (id)CGBitmapContextCreateImage(_drawCtx);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    lastPoint = [self mapPoint:[(UITouch *)[touches anyObject] locationInView:self]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [(UITouch *)[touches anyObject] locationInView:self];
    [self updateToTouch:p];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [(UITouch *)[touches anyObject] locationInView:self];
    [self updateToTouch:p];
}

@end
