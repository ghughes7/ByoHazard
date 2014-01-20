//
//  GSAppDelegate.h
//  ByoHazard
//
//  Created by goodsmile on 2013/11/25.
//  Copyright (c) 2013年 goodsmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSAppDelegate : UIResponder <UIApplicationDelegate> {
    
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property BOOL initialized;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
