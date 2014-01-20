//
//  LevelController.m
//  ByoHazard
//
//  Created by goodsmile on 2013/12/16.
//  Copyright (c) 2013年 goodsmile. All rights reserved.
//

#import "LevelViewController.h"

@implementation LevelViewController

@synthesize levelScreen, nodesToLoad;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //Configure the view.
    SKView *skView = (SKView *)self.view;
    skView.showsDrawCount = NO;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    //Create and configure the scene.
    levelScreen = [LevelScene sceneWithSize:skView.bounds.size];
    levelScreen.scaleMode = SKSceneScaleModeAspectFill;
    
    /*
     for (SKSpriteNode *ball in shotsLeft) {
     [gameScreen addChild:ball];
     }
     */
    
    //    [gameScreen addChild:byoBall];
    
//    NSLog(@"Nodes to Load did the make it?%@", self.nodesToLoad);
   
//    levelScreen.sceneObjects = theNodes;

    /*for (SKSpriteNode *node in nodesToLoad) {
        NSLog(@"Node is a %@", node);
        NSLog(@"Found and altered a germ!");
        [levelScreen addChild:node];
    }*/
    
    [levelScreen loadScene:nodesToLoad];
    //Present the scene.
    [skView presentScene:levelScreen];
   
}

@end
