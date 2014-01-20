//
//  LevelScene.m
//  ByoHazard
//
//  Created by goodsmile on 2013/11/25.
//  Copyright (c) 2013年 goodsmile. All rights reserved.
//

#import "LevelScene.h"
#import <AudioToolbox/AudioToolbox.h>
#import "WinScreen.h"
#import "LoseScreen.h"

#define PI              3.14159265359


#define BALL_CATEGORY   (0x00000001)
#define GERM_CATEGORY   ((0x00000001)<<1)
#define BLOCK_CATEGORY  ((0x00000001)<<2)

#define SCALE           2.0


@implementation LevelScene {
    NSMutableDictionary *particles;
}
@synthesize objectType, gameStarted, hasGravity, shotsLeft,
sceneObjects, shotCount, ballsToRemove, wonGame, finishedGame,
gameOn, germCount, ballOnScreen, timer, transitioned;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        particles = [[NSMutableDictionary alloc] init];
        self.backgroundColor = [SKColor colorWithRed:233.0/255 green:233.0/255 blue:233.0/255 alpha:1.0];
        
        SKSpriteNode *bgSprite = [SKSpriteNode spriteNodeWithImageNamed:@"office_v1"];
        bgSprite.position = CGPointMake(CGRectGetMidX(self.frame), (CGRectGetMidY(self.frame) - bgSprite.size.height/6));
        bgSprite.name = @"officeBG";
        bgSprite.zPosition = -100;
        
        
        int xOff = 0;
        shotsLeft = [[NSMutableArray array] init];
        ballsToRemove = [[NSMutableArray alloc] init];
        timer = [[NSTimer alloc] init];
        
        for (int i = 0; i < 6; i++) {
            
            SKSpriteNode *byoBall = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
            byoBall.position = CGPointMake(CGRectGetMinX(self.frame) + 50 +xOff,
                                           CGRectGetHeight(self.frame) - 50);
            xOff += 50;
            byoBall.zPosition = -99;
            
            NSString *name = [NSString stringWithFormat:@"byoBall%u", i];
            byoBall.name = name;
            [shotsLeft addObject:byoBall];
            
            [self addChild:byoBall];
            
        }
        
        shotCount = [shotsLeft count];
       
//        NSLog(@"Final destination: %@", sceneObjects);
        
        
        germTextures = [[NSMutableArray alloc] init];
        for(int i=1; i<3; i++)
            [germTextures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"germ%d",i]]];
        
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsWorld.contactDelegate = self;
        hasGravity = YES;
        
        [self addChild:bgSprite];
        
        //        NSLog(@"\nBall %d\nGerm %d\nBlock %d\n\n", BALL_CATEGORY, GERM_CATEGORY, BLOCK_CATEGORY);
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];

        switch (objectType) {
            case ball2:      [self launchBall:location];                 break;
            case vRect2:     [self addRectangle:location Vertical:YES];  break;
            case hRect2:     [self addRectangle:location Vertical:NO];   break;
            case germ2:      [self addGerm:location];                    break;
            case square2:    [self addBlock:location];                   break;

        }
    }
}

-(void)launchBall:(CGPoint)position {
    gameStarted = YES;
    
    if (shotsLeft != nil && shotCount != 0 && !ballOnScreen) {
        ballOnScreen = YES;
        SKEmitterNode *fire = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"BallFlame" ofType:@"sks"]];
    
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
        sprite.name = @"ByoBall";
    
        sprite.size = CGSizeMake(sprite.size.width/SCALE, sprite.size.height/SCALE);
        sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width/2];
    
        sprite.position = CGPointMake(sprite.size.width/SCALE, sprite.size.height/SCALE);
        fire.position = sprite.position;
        [self addChild:fire];
    
        sprite.name = [NSString stringWithFormat:@"ByoBall%d", shotCount];
        [particles setObject:fire forKey:sprite.name];
    
        [self addChild:sprite];
        ballOnScreen = YES;
        
        [sprite.physicsBody applyForce:CGVectorMake(position.x*4, position.y*4)];
        sprite.physicsBody.categoryBitMask = BALL_CATEGORY;
    
        SKAction *remove = [SKAction removeFromParent];

        [[shotsLeft objectAtIndex:shotCount-1 ] runAction:remove];
        shotCount -= 1 ;

        
        [self performSelector:@selector(removeBallsFromScene:) withObject:fire afterDelay:3.0];
        [self performSelector:@selector(removeBallsFromScene:) withObject:sprite afterDelay:3.0];
;
//        [self sequeToResultScreen:YES];
        
    }

}

-(void)addBlock:(CGPoint)position {
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"square"];
    sprite.position = position;
    sprite.name = @"block";
    
    sprite.size = CGSizeMake(sprite.size.width/SCALE, sprite.size.height/SCALE);
    sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:sprite.size];
    sprite.physicsBody.categoryBitMask = BLOCK_CATEGORY;
    sprite.physicsBody.density = 1000.0;
    
    [self addChild:sprite];
}

-(void)addRectangle:(CGPoint)position Vertical:(BOOL)vertical {
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"rectangle"];
    sprite.position = position;
    sprite.name = @"rect";
    
    sprite.size = CGSizeMake(sprite.size.width/SCALE, sprite.size.height/SCALE);
    if(vertical) {
        sprite.zRotation = PI/2.0;
    }
    
    sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:sprite.size];
    sprite.physicsBody.categoryBitMask = BLOCK_CATEGORY;
    sprite.physicsBody.density = 10.0;
    
    [self addChild:sprite];
}

-(void)addGerm:(CGPoint)position {
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"germ0"];
    sprite.position = position;
    sprite.name = @"germ";
    
    SKAction *animAction = [SKAction animateWithTextures:germTextures timePerFrame:0.5 resize:NO restore:YES];
    [sprite runAction:[SKAction repeatActionForever:animAction]];
    sprite.size = CGSizeMake(sprite.size.width/SCALE, sprite.size.height/SCALE);
    
    
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width/2];
    sprite.physicsBody.categoryBitMask = GERM_CATEGORY;
    sprite.physicsBody.contactTestBitMask = GERM_CATEGORY | BLOCK_CATEGORY | BALL_CATEGORY;
    
    [self addChild:sprite];
    germCount += 1;
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    if (gameStarted == NO)
        return;
    if(contact.bodyB == self.physicsBody || contact.bodyA == self.physicsBody)
        return;
    int test = BLOCK_CATEGORY | BALL_CATEGORY;
    
    SystemSoundID soundID;
    NSString *soundPath =  [[NSBundle mainBundle] pathForResource:@"killSound" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    //    AudioServicesPlaySystemSound (soundID);
    
    
    if(contact.bodyA.categoryBitMask == GERM_CATEGORY && (contact.bodyB.categoryBitMask & test) > 0) {
        [contact.bodyA.node removeFromParent];
        SKEmitterNode *emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"spark" ofType:@"sks"]];
        emitter.position = contact.contactPoint;
        AudioServicesPlaySystemSound (soundID);
        [self addChild:emitter];
        if (germCount == 0){
            germCount = 0;
        }
        else {
            germCount -=1;
            NSLog(@"germ count:%u", germCount);
        }

    }
    else if(contact.bodyB.categoryBitMask == GERM_CATEGORY && (contact.bodyA.categoryBitMask & test)>0) {
        [contact.bodyB.node removeFromParent];
        SKEmitterNode *emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"spark" ofType:@"sks"]];
        emitter.position = contact.contactPoint;
        AudioServicesPlaySystemSound (soundID);
        [self addChild:emitter];
        if (germCount == 0){
            germCount = 0;
        }
        else {
            germCount -=1;
            NSLog(@"germ count:%u", germCount);
        }

    }
    
    
}

-(void)didSimulatePhysics {
    for(SKNode *node in self.children) {
        if(node.physicsBody.categoryBitMask == BALL_CATEGORY) {
            SKEmitterNode *flame = [particles objectForKey:node.name];
            flame.position = node.position;
        }
    }
}

- (void)loadScene:(NSArray *)nodesToLoad2
{
    sceneObjects = nodesToLoad2;
    
    for (SKSpriteNode *node in sceneObjects) {
        int nodeInt = 0;
//        NSLog(@"node info: %@", node);
        if ([node.name isEqualToString:@"rect"]){
            if (fabsf(node.zRotation) <= PI/4.0 && fabsf(node.zRotation) >= 0.00){
                nodeInt = 2;
            }
            else if (fabsf(node.zRotation) <= (3.0*PI)/4.0 && fabsf(node.zRotation) > PI/4.0){
                nodeInt = 1;
            }
            else {
                nodeInt = 2;
            }
        }
        else if ([node.name isEqualToString:@"germ"]){
            nodeInt = 3;
        }
        else {
            //else square
            nodeInt = 4;
        }
        
        switch (nodeInt) {
            case vRect2:     [self addRectangle:node.position Vertical:YES];  break;
            case hRect2:     [self addRectangle:node.position Vertical:NO];   break;
            case germ2:      [self addGerm:node.position];
                              gameOn = YES;                                   break;
            case square2:    [self addBlock:node.position];                   break;

        }

    }
    
    NSLog(@"Germs on screen:%u ", germCount);
    
}


- (void)removeBallsFromScene:(SKNode *)sprite
{
    NSLog(@"spriteNames: %@", sprite.name);

    SKAction *remove = [SKAction removeFromParent];
    [sprite runAction:remove];
    ballOnScreen = NO;
    
    if ([sprite.name isEqualToString:@"ByoBall1"]) {
        finishedGame = YES;
        wonGame = NO;
        [self segueToResultScreen:wonGame isGame:gameOn isOver:finishedGame];
    }
    if (gameOn && germCount == 0) {
        finishedGame = YES;
        wonGame = YES;
        [self segueToResultScreen:wonGame isGame:gameOn isOver:finishedGame];
    }
    if (!transitioned) {
        [self performSelector:@selector(winCheck:) withObject:sprite afterDelay:5.0];
    }
    
    
    NSLog(@"Won Game:%hhd\nIs a Game:%hhd\nFinishedGame:%hhd\n\n", wonGame, gameOn, finishedGame);
//    [ballsToRemove removeObjectAtIndex:[ballsToRemove count]-1];

//    SKSpriteNode *stillBody = [[SKSpriteNode alloc] initWithColor:[SKColor blueColor] size:CGSizeMake(0, 0)];
//    stillBody.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:stillBody.size];
    
/*
    int ballCount = [ballsToRemove count];
    NSLog(@"removeList: %@", ballsToRemove);
    
    while (ballsToRemove != nil && ballCount != 0) {
     
        SKAction *remove = [SKAction removeFromParent];
        SKSpriteNode *node = [ballsToRemove objectAtIndex:ballCount-1];
        
        
        if (node.physicsBody.velocity.dx == 0.00 && node.physicsBody.velocity.dy == 0.00){
        
            [node runAction:remove]; NSLog(@"was suppose to remove from screen");
            [ballsToRemove removeObjectAtIndex:ballCount-1];
            ballCount = [ballsToRemove count];
        
        }

     /*
         SKAction *remove = [SKAction removeFromParent];
         if(_undoStack != nil && [_undoStack count] != 0){
         
         NSLog(@"undoStack: %@", _undoStack);
         [[_undoStack objectAtIndex:[_undoStack count]- 1] runAction:remove];
         [_undoStack removeLastObject];
         }
         
 
        
    }
*/
}

- (void)segueToResultScreen:(BOOL)won isGame:(BOOL)game isOver:(BOOL)over
{
    [timer invalidate];
    transitioned = YES;
    
    self.wonGame = won;
    self.gameOn = game;
    self.finishedGame = over;
    
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionDown duration:1.0];
    
    if (gameOn && finishedGame) {
        if (wonGame) {
            WinScreen *winner = [[WinScreen alloc] initWithSize:CGSizeMake(1024, 768)];
            [self.scene.view presentScene: winner transition: reveal];
        }
        else {
            LoseScreen *loser = [[LoseScreen alloc] initWithSize:CGSizeMake(1024, 768)];
            [self.scene.view presentScene: loser transition: reveal];
        }
    }
    
    else if (!gameOn && finishedGame) {
        //alert you have no germs to kill
    }
    
    else {
        return;
    }

     
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (hasGravity) {
        for (SKNode *node in self.children) {
            node.physicsBody.affectedByGravity = YES;
        }
    }
    else if (!hasGravity){
        for (SKNode *node in self.children) {
            node.physicsBody.affectedByGravity = NO;
        }
    }
//    NSLog(@"germCount: %u", germCount);
    
//Try a timer instead
//    if (objectType != 3) {
//        finishedGame = YES;
//        wonGame = YES;
//        [self segueToResultScreen:wonGame isGame:gameOn isOver:finishedGame];
//    }
//        if ((objectType == 3) && finishedGame) {
//            wonGame = NO;
//            [self segueToResultScreen:wonGame isGame:gameOn isOver:finishedGame];
//        }
    
     
    //    NSLog(@"Shot Count is currently %u", shotCount);
}


-(void)winCheck:(SKSpriteNode *) sprite {
    
//    NSLog(@"germCount: %u", germCount);
    if ([sprite.name isEqualToString:@"ByoBall1"]) {
        finishedGame = YES;
        wonGame = NO;
        [self segueToResultScreen:wonGame isGame:gameOn isOver:finishedGame];
    }

    if (gameOn && germCount == 0) {
        finishedGame = YES;
        wonGame = YES;
//        [self segueToResultScreen:wonGame isGame:gameOn isOver:finishedGame];
    }
//    NSLog(@"Ran win Check");
}

@end
