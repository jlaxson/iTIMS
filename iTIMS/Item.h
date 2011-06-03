//
//  Item.h
//  iTIMS
//
//  Created by John Laxson on 5/27/11.
//  Copyright (c) 2011 SOS Technologies, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Case, Assignment, Type;

@interface Item : NSObject {
@private
    NSArray *_sortedCache;
}
@property (nonatomic, retain) NSString * referenceNumber;
@property (nonatomic, retain) NSNumber * rowNumber;
@property (nonatomic, retain) NSString * assetTag;
@property (nonatomic, retain) Type * type;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSSet *assignments;
@property (nonatomic, retain) Item *commBox;
@property (nonatomic, readonly) Assignment *currentAssignment;
@property (nonatomic, retain) NSNumber *showOnReport;
@property (nonatomic, readonly) NSArray *sortedAssignments;
@end

@interface Item (CoreDataGeneratedAccessors)
- (void)addAssignmentsObject:(Assignment *)value;
- (void)removeAssignmentsObject:(Assignment *)value;
- (void)addAssignments:(NSSet *)value;
- (void)removeAssignments:(NSSet *)value;

@end
