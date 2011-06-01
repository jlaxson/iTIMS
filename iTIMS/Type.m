//
//  Type.m
//  iTIMS
//
//  Created by John Laxson on 5/31/11.
//  Copyright (c) 2011 SOS Technologies, Inc. All rights reserved.
//

#import "Type.h"
#import "Item.h"
#import "Type.h"


@implementation Type
@dynamic name;
@dynamic requiresName;
@dynamic desc;
@dynamic rawAccessories;
@dynamic caseType;
@dynamic items;
@dynamic isCase;

-  (NSArray *)accessories {
    if (_cachedAccessories == nil) {
        _cachedAccessories = [[self.rawAccessories componentsSeparatedByString:@"|"] retain];
    }
    
    return _cachedAccessories;
}

@end
