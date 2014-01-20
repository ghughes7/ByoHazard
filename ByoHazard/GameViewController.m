//
//  GameViewController.m
//  ByoHazard
//
//  Created by goodsmile on 2013/12/02.
//  Copyright (c) 2013年 goodsmile. All rights reserved.
//

#import "GameViewController.h"
#import "MasterViewController.h"


@implementation GameViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //Configure the view.
    SKView *skView = (SKView *)self.view;
    skView.showsDrawCount = NO;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    //Create and configure the scene.
    SKScene *gameScreen = [GameScene sceneWithSize:skView.bounds.size];
    gameScreen.scaleMode = SKSceneScaleModeAspectFill;
    
    
    //Present the scene.
    [skView presentScene:gameScreen];
}



- (void)blockButtonHit:(id)sender
{
    SKView *skView = (SKView *)self.view;
    GameScene *scene = (GameScene *)skView.scene;
    scene.objectType = square;
}

- (void)vRectButtonHit:(id)sender
{
    SKView *skView = (SKView *)self.view;
    GameScene *scene = (GameScene *)skView.scene;
    scene.objectType = vRect;
}

- (void)hRectButtonHit:(id)sender
{
    SKView *skView = (SKView *)self.view;
    GameScene *scene = (GameScene *)skView.scene;
    scene.objectType = hRect;
}

- (void)germButtonHit:(id)sender
{
    SKView *skView = (SKView *)self.view;
    GameScene *scene = (GameScene *)skView.scene;
    scene.objectType = germ;
}

- (void)launchBallButtonHit:(id)sender
{
    SKView *skView = (SKView *)self.view;
    GameScene *scene = (GameScene *)skView.scene;
    scene.objectType = ball;
    
    scene.gameStarted = YES;
    
}

- (void)resetButtonHit:(id)sender
{
    SKView *skView = (SKView *)self.view;
//    GameScene *scene = (GameScene *)skView.scene;
    
    SKScene *gameScreen = [GameScene sceneWithSize:skView.bounds.size];
    gameScreen.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:gameScreen];
    
    

}

- (void)undoButtonHit:(id)sender
{
    SKView *skView = (SKView *)self.view;
    GameScene *scene = (GameScene *)skView.scene;
    [scene undo];
}

- (void)toggleGravityButtonHit:(id)sender {
    SKView *skView = (SKView *)self.view;
    GameScene *scene = (GameScene *)skView.scene;
    
    if (scene.hasGravity) {
        scene.hasGravity = NO;
    }
    else if (!scene.hasGravity) {
        scene.hasGravity = YES;
    }

}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    MasterViewController *mvc = [MasterViewController sharedMasterViewController];
    
    if (buttonIndex == 0){
//        NSLog(@"At saving");
        UITextField *textField = [alertView textFieldAtIndex:0];
        
        //This would be the place to check for bad input
        if ([textField.text  isEqual: @""]) {
            UIAlertView *badInput = [[UIAlertView alloc] initWithTitle:@"なんとか入力して下さい。"
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [badInput show];
            return;
        }
        
        [mvc saveOption:textField.text];
    }
    else {
//        NSLog(@"At not saving cancelling and moving on with the scene");
    }
}

- (void)saveSceneButtonHit:(id)sender
{
    MasterViewController *mvc = [MasterViewController sharedMasterViewController];
    
    SKView *skView = (SKView *)self.view;
    GameScene *scene = (GameScene *)skView.scene;
//    [scene saveScene];
    

    UIAlertView *saveAsBox = [[UIAlertView alloc] initWithTitle:@"レベルを別名で保存"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
    
    [saveAsBox addButtonWithTitle:@"保存"];
    [saveAsBox addButtonWithTitle:@"キャンセル"];
    
    saveAsBox.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *saveAsBoxTextField = [saveAsBox textFieldAtIndex:0];
    saveAsBoxTextField.placeholder = @"タイトル";
    
//    UIImage *temp = [scene screenShot];
    mvc.savedImage = [scene screenShot];
                      
    [saveAsBox show];
    
}


- (void)cancelButtonHit:(id)sender
{
//    NSLog(@"unwinding¥¥");
}

@end
