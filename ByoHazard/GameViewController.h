//
//  GameViewController.h
//  ByoHazard
//
//  Created by goodsmile on 2013/12/02.
//  Copyright (c) 2013年 goodsmile. All rights reserved.
//

#import "RootViewController.h"
#import "RadioButtonSetController.h"
#import "GameScene.h"

@interface GameViewController : RootViewController <UIAlertViewDelegate> {
    
}

@property (nonatomic, strong) IBOutlet RadioButtonSetController *radioButtonSetController;
@property (nonatomic, weak) IBOutlet UILabel *selectedIndexLabel;


-(IBAction)launchBallButtonHit:(id)sender;
-(IBAction)blockButtonHit:(id)sender;
-(IBAction)vRectButtonHit:(id)sender;
-(IBAction)hRectButtonHit:(id)sender;
-(IBAction)germButtonHit:(id)sender;

-(IBAction)undoButtonHit:(id)sender;
-(IBAction)resetButtonHit:(id)sender;

-(IBAction)toggleGravityButtonHit:(id)sender;
-(IBAction)saveSceneButtonHit:(id)sender;
-(IBAction)cancelButtonHit:(id)sender;

//remove later
- (IBAction)printButtonHit:(id)sender;

@end
