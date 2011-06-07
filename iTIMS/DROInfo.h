//
//  DROInfo.h
//  iTIMS
//
//  Created by John Laxson on 5/31/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DROInfo : NSObject {
    
}

@property (nonatomic, retain) NSString *drName;
@property (nonatomic, retain) NSString *drNumber;
@property (nonatomic, retain) NSArray *positions;
@property (nonatomic, retain) NSDictionary *groups;
@property (nonatomic, retain) NSArray *locations;

@end
