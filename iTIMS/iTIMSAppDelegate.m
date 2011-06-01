//
//  iTIMSAppDelegate.m
//  iTIMS
//
//  Created by John Laxson on 5/24/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import "iTIMSAppDelegate.h"
#import "CSVParser.h"

#import "PSQLDatasource.h"

#define RESET_CD 0

@implementation iTIMSAppDelegate


@synthesize window=_window;

@synthesize navigationController=_navigationController;

@synthesize managedObjectContext=__managedObjectContext;
@synthesize managedObjectModel=__managedObjectModel;
@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    PSQLDatasource *ds = [[PSQLDatasource alloc] init];
    DROInfo *info = [ds loadDROInfo];
    Item *item = [ds findItemByReference:@"571-205-3330"];
    NSLog(@"%@", info);
    
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
#if RESET_CD
    [self loadData];
#endif
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Inventory Model" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"iTIMS.sqlite"];
    
#if RESET_CD
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
#endif
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
/*
- (NSDate *)parseAccessDateString:(NSString *)str {
    if (str == nil || [str length] == 0) return nil;
    
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@" /:"]];
    int month, day, year, hour, minute, second;
    
    BOOL worked = YES;
    
    worked = worked && [scanner scanInt:&month];
    worked = worked && [scanner scanInt:&day];
    worked = worked && [scanner scanInt:&year];
    worked = worked && [scanner scanInt:&hour];
    worked = worked && [scanner scanInt:&minute];
    worked = worked && [scanner scanInt:&second];
    
    if (!worked) {
        NSLog(@"Couldn't parse date %@", str);
        return nil;
    }
    
    NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
    [c setMonth:month];
    [c setDay:day];
    [c setYear:year];
    [c setHour:hour];
    [c setMinute:minute];
    [c setSecond:second];
    [c setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *d = [[NSCalendar currentCalendar] dateFromComponents:c];
    return d;
}*/

- (NSDate *)parseAccessDateString:(NSString *)str
{
    static NSDateFormatter *formatter = nil;
    
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MM'/'d'/'yyyy hh:mm:ss" options:0 locale:[NSLocale currentLocale]]];
    }
         
    NSDate *d = [formatter dateFromString:str];
    NSLog(@"parsed %@ as %@", str, d);
    
    return d;
}

- (void)loadData
{
    NSError *e;
    CSVParser *parser = [[CSVParser alloc] init];
    
    NSMutableDictionary *types = [NSMutableDictionary dictionary];
    [parser openFile:[[[NSBundle mainBundle] URLForResource:@"RawTypes" withExtension:@"csv"] path]];
    
    NSArray *rows = [parser parseFile];
    for (NSArray *row in rows) {
        Type *type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:self.managedObjectContext];
        
        type.name = [row objectAtIndex:1];
        type.desc = [row objectAtIndex:2];
        type.isCase = [NSNumber numberWithBool:[[row objectAtIndex:5] isEqualToString:@"-1"]];
        type.requiresName = [NSNumber numberWithBool:[[row objectAtIndex:6] isEqualToString:@"-1"]];
        if (row.count >= 13) {
            type.rawAccessories = [row objectAtIndex:12];
            NSLog(@"accessories %@", type.accessories);
        }
        
        [types setObject:type forKey:type.name];
    }
    
    [parser closeFile];
    
    [parser openFile:[[[NSBundle mainBundle] URLForResource:@"RawInventory" withExtension:@"txt"] path]];
    
    rows = [parser parseFile];
    
    NSMutableDictionary *items = [NSMutableDictionary dictionaryWithCapacity:rows.count];
    
    for (NSArray *row in rows) {
        //NSLog(@"%@", [row objectAtIndex:1]);
        Item *mo;
        NSString *type = [row objectAtIndex:4];
        if ([type hasPrefix:@"CASE"]) {
            mo = [NSEntityDescription insertNewObjectForEntityForName:@"Case" inManagedObjectContext:self.managedObjectContext];
        } else {
            mo = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
        }
        [mo setValue:[NSNumber numberWithInteger:[[row objectAtIndex:0] intValue]]  forKey:@"rowNumber"];
        [mo setValue:[row objectAtIndex:1] forKey:@"referenceNumber"];
        [mo setValue:[row objectAtIndex:2] forKey:@"assetTag"];
        [mo setValue:[row objectAtIndex:3] forKey:@"desc"];
        [mo setValue:[types objectForKey:[row objectAtIndex:4]] forKey:@"type"];
        
        if (mo.type == nil) {
            //NSLog(@"Couldn't find type %@ for item %@", type, mo.referenceNumber);
        }
        
        [items setObject:mo forKey:mo.referenceNumber];
    }
    
    // loop through and set comm box data
   
    for (NSArray *row in rows) {
        NSString *caseRef = [row objectAtIndex:13];
        
        if ([caseRef length] < 3) continue;
        
        Item *obj = [items objectForKey:[row objectAtIndex:1]];
        
        Case *commBox = [items objectForKey:caseRef];
        if (commBox && [commBox.entity.name isEqualToString:@"Case"]) {
            obj.commBox = commBox;
            
            //NSLog(@"assigned %@ to %@", obj.referenceNumber, caseRef);
        } else {
            //NSLog(@"couldn't find comm box %@", caseRef);
        }
        
    }
    
    [parser closeFile];
    
    [self saveContext];
    return;
    
    [parser openFile:[[[NSBundle mainBundle] URLForResource:@"RawHistory" withExtension:@"txt"] path]];
    rows = [parser parseFile];
    for (NSArray *row in rows) {
        NSFetchRequest *req = [self.managedObjectModel fetchRequestFromTemplateWithName:@"ItemByRowNumber" substitutionVariables:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:[[row objectAtIndex:1] intValue]] forKey:@"rowNumber"]];
        NSArray *results = [self.managedObjectContext executeFetchRequest:req error:&e];
        if ([results count]) {
            NSManagedObject *item = [results lastObject];
            NSManagedObject *record = [NSEntityDescription insertNewObjectForEntityForName:@"Assignment" inManagedObjectContext:self.managedObjectContext];
            
            [record setValue:item forKey:@"item"];
            [record setValue:[row objectAtIndex:2] forKey:@"activity"];
            [record setValue:[row objectAtIndex:3] forKey:@"name"];
            [record setValue:[row objectAtIndex:4] forKey:@"location"];
            [record setValue:[row objectAtIndex:5] forKey:@"position"];
            [record setValue:[self parseAccessDateString:[row objectAtIndex:6]] forKey:@"checkoutTime"];
            [record setValue:[row objectAtIndex:7] forKey:@"checkoutBy"];
            [record setValue:[self parseAccessDateString:[row objectAtIndex:8]] forKey:@"returnTime"];
            [record setValue:[row objectAtIndex:9] forKey:@"returnBy"];
            [record setValue:[row objectAtIndex:10] forKey:@"comment"];
        }
    }
    [parser closeFile];
                

    [self saveContext];
}

- (id)itemByReference:(NSString *)ref {
    NSFetchRequest *fetch = [self.managedObjectModel fetchRequestFromTemplateWithName:@"ItemByReference" substitutionVariables:[NSDictionary dictionaryWithObject:ref forKey:@"refNumber"]];
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    if ([results count]) {
        return [results lastObject];
    }
    
    return nil;
}

@end
