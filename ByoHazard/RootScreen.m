//
//  RootScreen.m
//  ByoHazard
//
//  Created by goodsmile on 2013/11/25.
//  Copyright (c) 2013年 goodsmile. All rights reserved.
//

#import "RootScreen.h"
#import "GameScene.h"

@implementation RootScreen

- (void)didMoveToView:(SKView *)view
{
        
     [self createSceneContents];
}

- (void)createSceneContents
{
    

}

- (void) startSegue
{
    /*
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionDown duration:1.0];
    GameScene *test = [[GameScene alloc] initWithSize:CGSizeMake(1024, 768)];
    [self.scene.view presentScene: test transition: reveal];
    
    NSLog(@"Was supposed to transition");
     */
}

/*
+ (id)buttonWithType:(UIButtonType)buttonType
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    button.
    
    return self;
}
*/

@end
