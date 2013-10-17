
//  BUAppDelegate.h
//  BrockUs
//  Created by HUB 3C 2 on 25/09/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
#import <UIKit/UIKit.h>
#import "BULoginViewController.h"
#import "BURegistroViewController.h"
@interface BUAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;



- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
