//
//  GameScene.m
//  ByoHazard
//
//  Created by goodsmile on 2013/11/25.
//  Copyright (c) 2013年 goodsmile. All rights reserved.
//

#import "GameScene.h"
#import <AudioToolbox/AudioToolbox.h>

#define PI              3.14159265359


#define BALL_CATEGORY   (0x00000001)
#define GERM_CATEGORY   ((0x00000001)<<1)
#define BLOCK_CATEGORY  ((0x00000001)<<2)

#define SCALE           2.0

@implementation GameScene {
    NSMutableDictionary *particles;
}
@synthesize objectType = _objectType;
@synthesize gameStarted = _gameStarted;
@synthesize hasGravity =_hasGravity;
@synthesize sceneObjects = _sceneObjects;
@synthesize undoStack = _undoStack;

//Defined at top of implementation file
CGImageRef UIGetScreenImage(void);

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        particles = [[NSMutableDictionary alloc] init];
        self.backgroundColor = [SKColor colorWithRed:233.0/255 green:233.0/255 blue:233.0/255 alpha:1.0];
        
        SKSpriteNode *bgSprite = [SKSpriteNode spriteNodeWithImageNamed:@"office"];
        bgSprite.position = CGPointMake(CGRectGetMidX(self.frame), (CGRectGetMidY(self.frame) - bgSprite.size.height/6));
        bgSprite.name = @"officeBG";
        bgSprite.zPosition = -100;
        
        germTextures = [[NSMutableArray alloc] init];
        for(int i=0; i<3; i++)
            [germTextures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"germ%d",i]]];
        
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsWorld.contactDelegate = self;
        _hasGravity = YES;
        
        _undoStack = [[NSMutableArray alloc] init];
        [self addChild:bgSprite];
        
//        NSLog(@"\nBall %d\nGerm %d\nBlock %d\n\n", BALL_CATEGORY, GERM_CATEGORY, BLOCK_CATEGORY);
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        switch (_objectType) {
            case square:    [self addBlock:location];                   break;
            case vRect:     [self addRectangle:location Vertical:YES];  break;
            case hRect:     [self addRectangle:location Vertical:NO];   break;
            case germ:      [self addGerm:location];                    break;
            case ball:      [self launchBall:location];                 break;
        }
    }
}

-(void)launchBall:(CGPoint)position {
    static int count = 0;
    SKEmitterNode *fire = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"BallFlame" ofType:@"sks"]];
    
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    sprite.name = @"ball";
    
    sprite.size = CGSizeMake(sprite.size.width/SCALE, sprite.size.height/SCALE);
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width/2];
    
    sprite.position = CGPointMake(sprite.size.width/SCALE, sprite.size.height/SCALE);
    fire.position = sprite.position;
    [self addChild:fire];
    
    sprite.name = [NSString stringWithFormat:@"%d", count++];
    [particles setObject:fire forKey:sprite.name];
    
    [self addChild:sprite];
    
    [sprite.physicsBody applyForce:CGVectorMake(position.x*4, position.y*4)];
    sprite.physicsBody.categoryBitMask = BALL_CATEGORY;
    
    [_undoStack addObject:sprite];
    [_undoStack addObject:fire];
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
    [_undoStack addObject:sprite];
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
    [_undoStack addObject:sprite];
}

-(void)addGerm:(CGPoint)position {
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"germ0"];
    sprite.position = position;
    sprite.name = @"germ";
    
    SKAction *animAction = [SKAction animateWithTextures:germTextures timePerFrame:0.5 resize:NO restore:YES];
    [sprite runAction:[SKAction repeatActionForever:animAction]];
    sprite.size = CGSizeMake(sprite.size.width/SCALE, sprite.size.height/SCALE);
//    there is this really weird bug here that breaks the game when you try to add a germ
    
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width/2];
    sprite.physicsBody.categoryBitMask = GERM_CATEGORY;
    sprite.physicsBody.contactTestBitMask = GERM_CATEGORY | BLOCK_CATEGORY | BALL_CATEGORY;
    
    [self addChild:sprite];
    [_undoStack addObject:sprite];
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    if (_gameStarted == NO)
        return;
    if(contact.bodyB == self.physicsBody || contact.bodyA == self.physicsBody)
        return;
    int test = /*GERM_CATEGORY | */BLOCK_CATEGORY | BALL_CATEGORY;
    
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
    }
    else if(contact.bodyB.categoryBitMask == GERM_CATEGORY && (contact.bodyA.categoryBitMask & test)>0) {
        [contact.bodyB.node removeFromParent];
        SKEmitterNode *emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"spark" ofType:@"sks"]];
        emitter.position = contact.contactPoint;
        AudioServicesPlaySystemSound (soundID);
        [self addChild:emitter];
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

- (NSMutableArray *)saveScene {
    
    _sceneObjects = [[NSMutableArray alloc] init];
    
    for (SKSpriteNode *skNode in self.children) {
//        NSLog(@"Node is a %@\nNode position: (%f, %f)", skNode.name ,skNode.position.x, skNode.position.y);
        if ([skNode.name isEqualToString:@"officeBG"] || [skNode.name isEqualToString:@"ball"]) {
//            NSLog(@"Dont save"); do nothing
        }
        else {
            [_sceneObjects addObject:skNode];
        }
    }

//    NSLog(@"contents of sceneObjects:\n%@", _sceneObjects);
    
    return _sceneObjects;
    
}

- (void)undo
{
    SKAction *remove = [SKAction removeFromParent];
    if(_undoStack != nil && [_undoStack count] != 0){
   
//        NSLog(@"undoStack: %@", _undoStack);
        [[_undoStack objectAtIndex:[_undoStack count]- 1] runAction:remove];
        [_undoStack removeLastObject];
    }
}

-(UIImage *) screenShot
{
    
    //Capture screen here
    
    /// somewhere else we are called for the image
    CGImageRef screen = UIGetScreenImage();
    UIImage *img = [UIImage imageWithCGImage:screen];
    
    UIGraphicsBeginImageContext(CGSizeMake(1024.0f, 768.0f));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeRight) {

//        NSLog(@"visited shot Right");
        CGContextRotateCTM (context, -M_PI/2.0f);
        [img drawAtPoint:CGPointMake(-768.0f, 0.0f)];
//        [img drawAtPoint:CGPointMake(0.0f, -1024.0f)];
    }
    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeLeft) {

//        NSLog(@"visited shot Left");
        CGContextRotateCTM (context, M_PI/2.0f);
//        [img drawAtPoint:CGPointMake(-768.0f, 0.0f)];
        [img drawAtPoint:CGPointMake(0.0f, -1024.0f)];
    }
    
  
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ret;
    
}

- (void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (_hasGravity) {
        for (SKNode *node in self.children) {
            node.physicsBody.affectedByGravity = YES;
        }
    }
    else if (!_hasGravity){
        for (SKNode *node in self.children) {
            node.physicsBody.affectedByGravity = NO;
        }
    }
    
}


@end
