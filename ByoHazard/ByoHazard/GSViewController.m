//
//  GSViewController.m
//  ByoHazard
//
//  Created by goodsmile on 2013/11/25.
//  Copyright (c) 2013年 goodsmile. All rights reserved.
//

#import "GSViewController.h"
#import "GSMyScene.h"
#import "StartScreen.h"

@implementation GSViewController


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Configure the view.
    SKView *skView = (SKView *)self.view;
    skView.showsDrawCount = YES;
    skView.showsFPS = YES;
    skView.showsNodeCount =YES;
    
    //Create and configure the scene.
    SKScene *start_scene = [StartScreen sceneWithSize:skView.bounds.size];
    start_scene.scaleMode = SKSceneScaleModeAspectFill;
    
    //Present the scene.
    [skView presentScene:start_scene];
}


- (IBAction)startButtonHit:(id)sender {
    SKView *skView = (SKView *)self.view;
    SKScene *test_scene = (GSMyScene *)skView;
    NSLog(@"startButtonHit");
    
    [skView presentScene:test_scene];

    
    
    
    /*
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
   //Remove View-1 from the main view
//        
        [skView removeFromSuperView];
        
        //Add the new view to your current view
        
        [skView addSubView:test_scene];
    
    } completion:^(BOOL finished) {
        //Once animation is complete
    }];
    
    /*
    [someNode runAction:moveSequence completion:^ {
        SKScene *spaceshipScene = [[SpaceshipScene alloc] initWithSize:self.size];
        SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
        [self.view presentScene:spaceshipScene transition:doors];
    }];
     */
    
}

//write removeFromSuperView and addSubView as they are methods of UIView and SKView inherits from UIView [super ぶら」






/*
- (void)viewDidLoad
{
    [super viewDidLoad];
    SKView *skView = (SKView *) self.view;
    skView.showsDrawCount = YES;
    skView.showsNodeCount = YES;
    skView.showsFPS = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    SKScene *menu = [[StartScreen alloc] initWithSize:CGSizeMake(1024, 768)];
    SKView *spriteView = (SKView *)self.view;
    [spriteView presentScene:menu];
    
}
*/

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
