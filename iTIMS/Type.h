//
//  Type.h
//  iTIMS
//
//  Created by John Laxson on 5/31/11.
//  Copyright (c) 2011 SOS Technologies, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item, Type;

@interface Type : NSObject {
@private
    NSArray *_cachedAccessories;
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * requiresName;
@property (nonatomic, retain) NSNumber * isCase;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * rawAccessories;
@property (nonatomic, retain) Type *caseType;
@property (nonatomic, retain) Item *items;
@property (nonatomic, readonly) NSArray *accessories;

@end
