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
    
    record = [results moveFirst];
    
    while (![results isEOF]) {
        
        Assignment *ass = [[Assignment alloc] init];
        
        ass.rowNumber = [[record fieldByName:@"History ID"] asNumber];
        ass.name = [[record fieldByName:@"Responsible Individual"] asString];
        ass.position = [[record fieldByName:@"Position"] asString];
        ass.activity = [[record fieldByName:@"Function"] asString];
        ass.location = [[record fieldByName:@"Location"] asString];
        ass.checkoutTime = [[record fieldByName:@"Date of Issue"] asDate];
        ass.checkoutBy = [[record fieldByName:@"Initials Issued"] asString];
        ass.returnTime = [[record fieldByName:@"Date Returned"] asDate];
        ass.returnBy = [[record fieldByName:@"Initials Returned"] asString];
        ass.comment = [[record fieldByName:@"Comments"] asString];

        ass.item = item;
        
        [assignments addObject:ass];
        [ass release];
        
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

- (NSString *)escapeText:(NSString *)text {
    if (text == nil) return @"";
    
    return [text stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
}

- (NSString *)formatDateForSQL:(NSDate *)d {
    if (d == nil) return @"NULL";
    
    return [NSString stringWithFormat:@"'%@'", d];
}

- (void)saveAssignment:(Assignment *)assignment
{
    NSString *query;
    if (assignment.rowNumber == nil) {
        query = [NSString stringWithFormat:
                 @"INSERT INTO \"History\" (\"Record Number\", \"Function\", \"Responsible Individual\", \"Location\", \"Position\", \"Date of Issue\", \"Initials Issued\", \"Date Returned\", \"Initials Returned\", \"Comments\") VALUES (%@, '%@', '%@', '%@', '%@', %@, '%@', %@, '%@', '%@')",
                 assignment.item.rowNumber, 
                 [self escapeText:assignment.activity], 
                 [self escapeText:assignment.name], 
                 [self escapeText:assignment.location], 
                 [self escapeText:assignment.position], 
                 [self formatDateForSQL:assignment.checkoutTime], 
                 [self escapeText:assignment.checkoutBy], 
                 [self formatDateForSQL:assignment.returnTime], 
                 [self escapeText:assignment.returnBy], 
                 [self escapeText:assignment.comment]];
        NSLog(@"%@", query);
        [_connection execCommand:query];
        
        PGSQLRecordset *results = [_connection open:@"SELECT currval('seq_history_historyid')"];
        [results moveFirst];
        assignment.rowNumber = [[results fieldByIndex:0] asNumber];
    } else {
        query = [NSString stringWithFormat:@"UPDATE \"History\" SET \"Function\"='%@',  \"Responsible Individual\"='%@', \"Location\"='%@',  \"Position\"='%@', \"Date of Issue\"=%@, \"Initials Issued\"='%@', \"Date Returned\"=%@, \"Initials Returned\"='%@', \"Comments\"='%@' WHERE \"History ID\"=%@ ",
                 [self escapeText:assignment.activity],
                 [self escapeText:assignment.name],
                 [self escapeText:assignment.location],
                 [self escapeText:assignment.position],
                 [self formatDateForSQL:assignment.checkoutTime],
                 [self escapeText:assignment.checkoutBy],
                 [self formatDateForSQL:assignment.returnTime],
                 [self escapeText:assignment.returnBy],
                 [self escapeText:assignment.comment],
                 assignment.rowNumber];
        
        [_connection execCommand:query];
    }
}

- (Assignment *)createAssignment
{
    return [[[Assignment alloc] init] autorelease];
}

- (void)saveItem:(Item *)item {
    
}

@end
