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

- (NSString *)escapeText:(NSString *)text {
    if (text == nil) return @"";
    
    return [text stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
}

- (id)init
{
    self = [super init];
    if (self) {
        typeCache = [[NSMutableDictionary alloc] init];
        
        _connection = [[PGSQLConnection alloc] init];
        [_connection setServer:@"jlaxson.local"];
        [_connection setDatabaseName:@"tims"];
        [_connection setUserName:@"tims"];
        [_connection setPassword:@"tims"];
        [_connection connect];
        
        if (![_connection isConnected]) {
            [[NSException exceptionWithName:@"Datasource Error" reason:[_connection lastError] userInfo:nil] raise];
        }
    }
    
    return self;
}

- (id)initWithConnection:(PGSQLConnection *)conn
{
    self = [super init];
    if (self) {
        _connection = [conn retain];
    }
    return self;
}

- (void)dealloc
{
    [_connection release]; _connection = nil;
    [super dealloc];
}

- (BOOL)resetConnection
{
    return [_connection reset];
}

- (DROInfo *)loadDROInfo {
    PGSQLRecordset *results;
    PGSQLRecord *record;
    
    @try {
        results = [_connection open:@"SELECT * from \"DR Information\""];
    }
    @catch (NSException *e) {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Error" message:[e description] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [view show];
        [view release];
        return nil;
    }

    record = [results moveFirst];
    
    DROInfo *info = [[DROInfo alloc] init];
    info.drNumber = [[record fieldByName:@"DR Number"] asString];
    info.drName = [[record fieldByName:@"DR Name"] asString];
    
    [results close];
    
    NSMutableArray *positions = [NSMutableArray array];
    
    results = [_connection open:@"SELECT * FROM \"Position\" ORDER BY \"Postion Number\" asc"];
    if (!results) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Database Problem" message:[NSString stringWithFormat:@"An error occurred accessing the database: %@", [_connection lastError]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        return nil;
    }
    
    record = [results moveFirst];
    
    while (![results isEOF]) {
        Position *pos = [[Position alloc] init];
        
        pos.code = [[record fieldByName:@"Position"] asString];
        pos.name = [[record fieldByName:@"Position Name"] asString];    
        
        [positions addObject:pos];
        
        record = [results moveNext];
    }
    
    [results close];
    
    info.positions = [NSArray arrayWithArray:positions];
    
    NSMutableDictionary *groups = [NSMutableDictionary dictionary];
    
    results = [_connection open:@"SELECT * from \"Function\" ORDER BY \"Group Order\" asc, \"Function Order\" asc"];
    
    record = [results moveFirst];
    
    while (![results isEOF]) {
        NSString *function = [[record fieldByName:@"Function"] asString];
        NSString *group = [[record fieldByName:@"Group"] asString];
        
        Activity *act = [[Activity alloc] init];
        act.name = [[record fieldByName:@"Function Name"] asString];
        act.code = function;
        act.index = [[record fieldByName:@"Group Order"] asNumber];
        
        if ([group isEqualToString:function]) {
            act.activities = [NSMutableArray arrayWithObject:act];
            [groups setObject:act forKey:group];
        } else {
            Activity *g = [groups objectForKey:group];
            NSMutableArray *actList = [NSMutableArray arrayWithArray:g.activities];
            [actList addObject:act];
            act.group = g;
            g.activities = actList;
        }
        
        record = [results moveNext];
    }
    
    info.groups = groups;
    
    [results close];
    
    // load locations
    NSMutableArray *locations = [NSMutableArray array];
    
    results = [_connection open:@"SELECT * FROM \"Location\" WHERE \"State\" is not null order by \"ID\" asc"];
    if (!results) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Database Problem" message:[NSString stringWithFormat:@"An error occurred accessing the database: %@", [_connection lastError]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        return nil;
    }
    
    record = [results moveFirst];
    
    while (![results isEOF]) {
        Location *loc = [[Location alloc] init];
        
        loc.code = [[results fieldByName:@"Location"] asString];
        loc.name = [[results fieldByName:@"Location Long Name"] asString];
        
        [locations addObject:loc];
        
        record = [results moveNext];
    }
    
    [results close];
    
    info.locations = [NSArray arrayWithArray:locations];
    
    return [info autorelease];
}

- (NSSet *)findAssignmentsForItem:(Item *)item
{
    NSMutableSet *assignments = [NSMutableSet set];
    PGSQLRecordset *results;
    PGSQLRecord *record;
    
    results = [_connection open:@"SELECT * FROM \"History\" WHERE \"Record Number\"=$1" numberOfArguments:1 withParameters:item.rowNumber];
    if (!results) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Database Problem" message:[NSString stringWithFormat:@"An error occurred accessing the database: %@", [_connection lastError]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        return nil;
    }
    
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

        NSData *imageData = [[record fieldByName:@"Signature"] asData];
        if (imageData) {
            ass.signatureImage = [UIImage imageWithData:imageData];
            NSLog(@"got data for %@", ass.rowNumber);
            [imageData writeToFile:@"/tmp/sig.png" atomically:YES];
        }
        
        ass.item = item;
        
        [assignments addObject:ass];
        [ass release];
        
        record = [results moveNext];
    }
    
    [results close];
    
    return assignments;
}

- (Type *)findTypeByName:(NSString *)name
{
    Type *t = [typeCache objectForKey:name];
    if (t) return t;
    
    PGSQLRecordset *results;
    PGSQLRecord *record;
    
    results = [_connection open:@"SELECT * from \"Type\" WHERE \"Type\"=$1" numberOfArguments:1 withParameters:name];
    if (!results) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Database Problem" message:[NSString stringWithFormat:@"An error occurred accessing the database: %@", [_connection lastError]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        return nil;
    }
    
    if ([results isEOF])
        return nil;
    
    record = [results moveFirst];
    
    t = [[Type alloc] init];
    t.name = [[record fieldByName:@"Type"] asString];
    t.desc = [[record fieldByName:@"Long Title"] asString];
    t.requiresName = [[record fieldByName:@"NameReq"] asNumber];
    t.isCase = [[record fieldByName:@"Case"] asNumber];
    t.rawAccessories = [[record fieldByName:@"Accessories"] asString];
    
    [typeCache setObject:t forKey:t.name];
    
    return t;
}

- (Item *)findItemByReference:(NSString *)reference
{
    PGSQLRecordset *results;
    PGSQLRecord *record;
    
    results = [_connection open:@"SELECT * from \"Inventory\" WHERE \"Reference Number\" LIKE $1 OR \"ESN/CAP #\" LIKE $1"
               numberOfArguments:1 withParameters:reference];
    if (!results) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Database Problem" message:[NSString stringWithFormat:@"An error occurred accessing the database: %@", [_connection lastError]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        return nil;
    }
    
    if ([results isEOF])
        return nil;
    
    record = [results moveFirst];
    
    Item *item = [[Item alloc] init];
    item.rowNumber = [[record fieldByName:@"ID"] asNumber];
    item.referenceNumber = [[record fieldByName:@"Reference Number"] asString];
    item.assetTag = [[record fieldByName:@"ESN/CAP #"] asString];
    item.desc = [[record fieldByName:@"Description"] asString];
    
    item.assignments = [self findAssignmentsForItem:item];
    
    NSString *boxName = [[record fieldByName:@"Comm Box"] asString];
    if (![boxName isEqualToString:@"UNASSIGNED"] && ![boxName isEqualToString:item.referenceNumber])
    {
        Item *commBox = [self findItemByReference:boxName];
        item.commBox = commBox;
    }
    
    item.type = [self findTypeByName:[[record fieldByName:@"Type"] asString]];
    
    [results close];
    
    return item;
}

- (NSString *)formatDateForSQL:(NSDate *)d {
    if (d == nil) return @"NULL";
    
    return [NSString stringWithFormat:@"'%@'", d];
}

- (void)saveAssignment:(Assignment *)assignment
{
    if (assignment.rowNumber == nil) {
        [_connection execCommand:@"INSERT INTO \"History\" (\"Record Number\", \"Function\", \"Responsible Individual\", \"Location\", \"Position\", \"Date of Issue\", \"Initials Issued\", \"Date Returned\", \"Initials Returned\", \"Comments\", \"Signature\") VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)"
               numberOfArguments:11
                  withParameters:assignment.item.rowNumber,
                                 assignment.activity, 
                                 assignment.name, 
                                 assignment.location, 
                                 assignment.position, 
                                 assignment.checkoutTime, 
                                 assignment.checkoutBy, 
                                 assignment.returnTime, 
                                 assignment.returnBy, 
                                 assignment.comment, 
                                 UIImagePNGRepresentation(assignment.signatureImage), 
                                nil];
        
        PGSQLRecordset *results = [_connection open:@"SELECT currval('seq_history_historyid')"];
        [results moveFirst];
        assignment.rowNumber = [[results fieldByIndex:0] asNumber];
        [results close];
    } else {
        [_connection execCommand:@"UPDATE \"History\" SET \"Function\"=$1,  \"Responsible Individual\"=$2, \"Location\"=$3,  \"Position\"=$4, \"Date of Issue\"=$5, \"Initials Issued\"=$6, \"Date Returned\"=$7, \"Initials Returned\"=$8, \"Comments\"=$9 WHERE \"History ID\"=$10 "
               numberOfArguments:10 
                  withParameters:assignment.activity,
                                 assignment.name,
                                 assignment.location,
                                 assignment.position,
                                 assignment.checkoutTime,
                                 assignment.checkoutBy,
                                 assignment.returnTime,
                                 assignment.returnBy,
                                 assignment.comment,
                                 assignment.rowNumber ];
    }
}

- (Assignment *)createAssignment
{
    return [[[Assignment alloc] init] autorelease];
}

- (void)saveItem:(Item *)item {
    
}

@end
