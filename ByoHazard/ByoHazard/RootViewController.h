//
//  GSViewController.h
//  ByoHazard
//

//  Copyright (c) 2013年 goodsmile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface RootViewController : UIViewController {
    
}

@property IBOutlet UIButton *startButton;
@property BOOL buttonPressed;

- (IBAction)startButtonHit:(id)sender;

@end
