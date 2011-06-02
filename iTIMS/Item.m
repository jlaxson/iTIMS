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

//@synthesize currentAssignment;
/*
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
}*/

- (Assignment *)currentAssignment {
    for (Assignment *ass in self.assignments) {
        if (ass.returnTime == nil && ass.checkoutTime != nil)
            return ass;
    }
    return nil;
}

- (NSArray *)sortedAssignments {
    if (_sortedCache)
        return _sortedCache;
    
    _sortedCache = [[self.assignments allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"checkoutTime" ascending:YES]]];
    [_sortedCache retain];
    
    NSLog(@"%@", _sortedCache);
    
    return _sortedCache;
}

- (void)addAssignmentsObject:(Assignment *)value {
    NSMutableSet *s = [NSMutableSet setWithSet:self.assignments];
    [s addObject:value];
    self.assignments = [NSSet setWithSet:s];
    
    [_sortedCache release];
    _sortedCache = nil;
}
@end
