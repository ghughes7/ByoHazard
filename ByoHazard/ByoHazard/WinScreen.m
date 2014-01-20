//
//  WinScreen.m
//  ByoHazard
//
//  Created by goodsmile on 2014/01/10.
//  Copyright (c) 2014年 goodsmile. All rights reserved.
//

#import "WinScreen.h"
@interface WinScreen ()
@property BOOL contentCreated;
@end

@implementation WinScreen


- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blueColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    [self addChild: [self newHelloNode]];
    
}

- (SKLabelNode *)newHelloNode
{
    
    SKLabelNode *helloNode = [SKLabelNode labelNodeWithFontNamed:@"Osaka"];
    helloNode.text = @"よく出来た!全員の菌を殺してしまった！";
    helloNode.fontSize = 42;
    helloNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    helloNode.name = @"helloNode";
    
    return helloNode;
}


@end
