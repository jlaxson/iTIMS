//
//  Item.m
//  iTIMS
//
//  Created by John Laxson on 5/27/11.
//  Copyright (c) 2011 SOS Technologies, Inc. All rights reserved.
//

#import "Item.h"

@interface Item (CoreDataPrivate) 

- (NSArray *)primitiveCurrentAssignment;
    
@end

@implementation Item

@synthesize referenceNumber, rowNumber, assetTag, type, desc, assignments, commBox, showOnReport;

/*
@dynamic referenceNumber;
@dynamic rowNumber;
@dynamic assetTag;
@dynamic type;
@dynamic desc;
@dynamic assignments;
@dynamic commBox;
@dynamic showOnReport;*/

- (Assignment *)currentAssignment
{
    NSArray *ret = [self primitiveCurrentAssignment];
    int count = [ret count];
    if (count == 0) {
        return nil;
    }
    
    if (count > 1) {
        NSLog(@"item %@ has more than one current assignment", self);
    }
    
    return [ret lastObject];
}

- (NSArray *)sortedAssignments {
    if (_sortedCache)
        return _sortedCache;
    
    _sortedCache = [[self.assignments allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"checkoutTime" ascending:YES]]];
    [_sortedCache retain];
    
    NSLog(@"%@", _sortedCache);
    
    return _sortedCache;
}

@end
