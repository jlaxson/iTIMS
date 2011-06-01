//
//  ItemLayer.m
//  iTIMS
//
//  Created by John Laxson on 5/30/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import "ItemLayer.h"


@implementation ItemLayer

@synthesize title, subtitle;

- (id)init
{
    self = [super init];
    if (self) {
        self.cornerRadius = 10;
        self.backgroundColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:.5] CGColor];
        self.contentsScale = [UIScreen mainScreen].scale;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)setTitle:(NSString *)t
{
    [title release];
    title = [t retain];
    
    [self setNeedsDisplay];
}

- (void)setSubtitle:(NSString *)t
{
    [subtitle release];
    subtitle = [t retain];
    
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx
{
    UIGraphicsPushContext(ctx);
    [[UIColor whiteColor] set];
    CGRect r = CGRectInset(self.bounds, 10, 10);
    UIFont *f = [UIFont systemFontOfSize:30];
    [title drawInRect:r withFont:f lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
    r.origin.y += 36;
    r.size.height -= 36;
    
    [subtitle drawInRect:r withFont:[UIFont systemFontOfSize:20] lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
    UIGraphicsPopContext();
}

@end
