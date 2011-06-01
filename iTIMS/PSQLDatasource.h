//
//  PSQLDatasource.h
//  iTIMS
//
//  Created by John Laxson on 6/1/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TIMSDatasource.h"

@interface PSQLDatasource : NSObject <TIMSDatasource> {
    PGSQLConnection *_connection;
}

@end
