//
//  Case.h
//  iTIMS
//
//  Created by John Laxson on 5/27/11.
//  Copyright (c) 2011 SOS Technologies, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Item.h"

@interface Case : Item {
@private
}
@property (nonatomic, retain) NSSet *items;
@end

@interface Case (CoreDataGeneratedAccessors)
- (void)addItemsObject:(NSManagedObject *)value;
- (void)removeItemsObject:(NSManagedObject *)value;
- (void)addItems:(NSSet *)value;
- (void)removeItems:(NSSet *)value;

@end
