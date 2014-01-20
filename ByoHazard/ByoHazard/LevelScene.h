//
//  LevelScene.h
//  ByoHazard
//
//  Created by goodsmile on 2013/12/20.
//  Copyright (c) 2013年 goodsmile. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface NSMutableArray (QueueAdditions)
- (id) deque;
- (void) enqueu:(id)obj;
@end


typedef enum {
    ball2 = 0,
    vRect2,
    hRect2,
    germ2,
    square2
} ObjectType2;

@interface LevelScene : SKScene <SKPhysicsContactDelegate> {
    NSMutableArray *germTextures;
}

@property BOOL gameStarted;
@property BOOL hasGravity;

//To determine end game
@property BOOL wonGame;
@property BOOL gameOn;
@property BOOL finishedGame;
@property BOOL ballOnScreen;
@property NSTimer *timer;
@property BOOL transitioned;

@property ObjectType2 objectType;
@property NSArray *sceneObjects;
@property NSMutableArray *shotsLeft;
@property int germCount;
@property int shotCount;
@property NSMutableArray *ballsToRemove;

- (void)loadScene:(NSArray *)nodesToLoad2;

@end
