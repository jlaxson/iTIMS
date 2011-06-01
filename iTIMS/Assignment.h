//
//  Assignment.h
//  iTIMS
//
//  Created by John Laxson on 5/27/11.
//  Copyright (c) 2011 SOS Technologies, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface Assignment : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * returnTime;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSDate * checkoutTime;
@property (nonatomic, retain) NSString * activity;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * checkoutBy;
@property (nonatomic, retain) NSString * returnBy;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) Item *item;

@end
