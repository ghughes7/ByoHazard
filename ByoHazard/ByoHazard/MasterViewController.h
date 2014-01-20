//
//  MasterViewController.h
//  ByoHazard
//
//  Created by goodsmile on 2013/12/11.
//  Copyright (c) 2013年 goodsmile. All rights reserved.
//
//Singleton for saving and loading


#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CreatedScene.h"


@class DetailViewController;
@class GameViewController;
@class LevelViewController;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) GameViewController *gameViewController;

@property (nonatomic, strong) NSMutableArray *sceneInfos;
@property (nonatomic, strong) UIImage *savedImage;


+ (MasterViewController *)sharedMasterViewController;
- (void)preLoadData;
- (void)saveOption:(NSString *)title;
//- (IBAction)cancelButtonTapped:(UIButton *)button;
- (IBAction)unwindToMaster:(UIStoryboardSegue *)unwindSeque;

@end
