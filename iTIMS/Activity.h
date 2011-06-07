//
//  Activity.h
//  iTIMS
//
//  Created by John Laxson on 6/4/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Activity : NSObject {
    
}

@property (retain) NSString *code;
@property (retain) NSString *name;
@property (retain) Activity *group;
@property (retain) NSArray *activities;
@property (retain) NSNumber *index;

@end
