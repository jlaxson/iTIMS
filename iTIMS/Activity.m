//
//  Activity.m
//  iTIMS
//
//  Created by John Laxson on 6/4/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import "Activity.h"


@implementation Activity

@synthesize code, name, group, activities, index;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
