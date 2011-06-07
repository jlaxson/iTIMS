//
//  SignatureCaptureView.h
//  iTIMS
//
//  Created by John Laxson on 6/3/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SignatureCaptureView : UIView {
    CGPoint lastPoint;
    CGContextRef _drawCtx;
    
    CALayer *_imageLayer;
}

- (void)clear;
- (UIImage *)image;

@end
