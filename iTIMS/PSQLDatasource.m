//
//  PSQLDatasource.m
//  iTIMS
//
//  Created by John Laxson on 6/1/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import "PSQLDatasource.h"
#import "PGSQLConnection.h"

@implementation PSQLDatasource

- (id)init
{
    self = [super init];
    if (self) {
        _connection = [[PGSQLConnection alloc] init];
        [_connection setServer:@"jlaxson.local"];
        [_connection setDatabaseName:@"tims"];
        [_connection setUserName:@"tims"];
        [_connection setPassword:@"tims"];
        [_connection connect];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (DROInfo *)loadDROInfo {
    PGSQLRecordset *results;
    PGSQLRecord *record;
    
    results = [_connection open:@"SELECT * from \"DR Information\""];
    
    record = [results moveFirst];
    
    DROInfo *info = [[DROInfo alloc] init];
    info.drName = [[record fieldByName:@"DR Number"] asString];
    info.drNumber = [[record fieldByName:@"DR Name"] asString];
    
    [results close];
    
    return [info autorelease];
}

- (NSSet *)findAssignmentsForItem:(Item *)item
{
    NSMutableSet *assignments = [NSMutableSet set];
    PGSQLRecordset *results;
    PGSQLRecord *record;
    
    results = [_connection open:[NSString stringWithFormat:@"SELECT * FROM \"History\" WHERE \"Record Number\"=%@", item.rowNumber]];
    
    while (![results isEOF]) {
        record = [results moveNext];
    }
    
    [results close];
    
    return assignments;
}

- (Item *)findItemByReference:(NSString *)reference
{
    PGSQLRecordset *results;
    PGSQLRecord *record;
    
    results = [_connection open:[NSString stringWithFormat:@"SELECT * from \"Inventory\" WHERE \"Reference Number\" LIKE '%@' OR \"ESN/CAP #\" LIKE '%@'", reference, reference]];
    
    if ([results isEOF])
        return nil;
    
    record = [results moveFirst];
    
    Item *item = [[Item alloc] init];
    item.rowNumber = [[record fieldByName:@"ID"] asNumber];
    item.referenceNumber = [[record fieldByName:@"Reference Number"] asString];
    item.assetTag = [[record fieldByName:@"ESN/CAP #"] asString];
    item.desc = [[record fieldByName:@"Description"] asString];
    
    item.assignments = [self findAssignmentsForItem:item];
    
    [results close];
    
    return item;
}


@end
