//
//  iTIMSAppDelegate.h
//  iTIMS
//
//  Created by John Laxson on 5/24/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;

@interface iTIMSAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (Item *)itemByReference:(NSString *)ref;

@end
