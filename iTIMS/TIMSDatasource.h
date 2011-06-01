//
//  TIMSDatasource.h
//  iTIMS
//
//  Created by John Laxson on 5/31/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TIMSDatasource

- (DROInfo *)loadDROInfo;
- (Item *)findItemByReference:(NSString *)reference;
//- (NSArray *)findAssignmentsForItem:(Item *)item;

- (void)saveItem:(Item *)item;
- (void)saveAssignment:(Assignment *)assignment;

@end