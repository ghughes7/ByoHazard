//
//  LevelController.h
//  ByoHazard
//
//  Created by goodsmile on 2013/12/16.
//  Copyright (c) 2013年 goodsmile. All rights reserved.
//

#import "RootViewController.h"
#import "LevelScene.h"

@interface LevelViewController : RootViewController {
    
}

@property (nonatomic, retain) LevelScene *levelScreen;
@property (strong, nonatomic) NSArray *nodesToLoad;

@end
