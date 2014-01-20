//
//  GameScene.h
//  ByoHazard
//

//  Copyright (c) 2013年 goodsmile. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum {
    square = 0,
    vRect,
    hRect,
    germ,
    ball
} ObjectType;

@interface GameScene : SKScene <SKPhysicsContactDelegate> {
    NSMutableArray *germTextures;
}

@property BOOL gameStarted;
@property BOOL hasGravity;
@property BOOL shouldSave;
@property ObjectType objectType;
@property NSMutableArray *sceneObjects;
@property NSMutableArray *undoStack;


- (NSMutableArray *)saveScene;
- (UIImage *)screenShot;
- (void)undo;


@end
