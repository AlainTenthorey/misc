//
//  GameplayLayer.m
//  SpaceViking
//
//  Created by Muhammad Naveed Siddiqui on 26/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameplayLayer.h"

@implementation GameplayLayer

- (void) dealloc {
    [leftJoystick release];
    [jumpButton release];
    [attackButton release];
    [super dealloc];
}

-(void)initJoystickAndButtons {
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CGRect joystickBaseDimensions   = CGRectMake(0, 0, 128.0f, 128.0f);
    CGRect jumpButtonDimensions     = CGRectMake(0, 0, 64.0f, 64.0f);
    CGRect attackButtonDimensions   = CGRectMake(0, 0, 64.0f, 64.0f);
    
    CGPoint joystickBasePosition;
    CGPoint jumpButtonPosition;
    CGPoint attackButtonPosition;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // The device is an iPad running iPhone 3.2 or later.
        CCLOG(@"Positioning Joystick and Buttons for iPad");
        joystickBasePosition    = ccp(screenSize.width*0.0625f, screenSize.height*0.052f);
        jumpButtonPosition      = ccp(screenSize.width*0.946f, screenSize.height*0.052f);
        attackButtonPosition    = ccp(screenSize.width*0.947f, screenSize.height*0.169f);
    } else {
        // The device is an iPhone or iPod touch.
        CCLOG(@"Positioning Joystick and Buttons for iPhone");
        joystickBasePosition    = ccp(screenSize.width*0.07f, screenSize.height*0.11f);
        jumpButtonPosition      = ccp(screenSize.width*0.93f, screenSize.height*0.11f);
        attackButtonPosition    = ccp(screenSize.width*0.93f, screenSize.height*0.35f);
    }
    
    SneakyJoystickSkinnedBase *joystickBase = [[[SneakyJoystickSkinnedBase alloc] init] autorelease];
    joystickBase.position   = joystickBasePosition;
    joystickBase.backgroundSprite = [CCSprite spriteWithFile:@"dpadDown.png"];
    joystickBase.thumbSprite = [CCSprite spriteWithFile:@"joystickDown.png"];
    joystickBase.joystick   = [[SneakyJoystick alloc] initWithRect:joystickBaseDimensions];
    leftJoystick = [joystickBase.joystick retain];
    [self addChild:joystickBase];
    
    SneakyButtonSkinnedBase *jumpButtonBase = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
    jumpButtonBase.position = jumpButtonPosition;
    jumpButtonBase.defaultSprite    = [CCSprite spriteWithFile:@"jumpUp.png"];
    jumpButtonBase.activatedSprite  = [CCSprite spriteWithFile:@"jumpDown.png"];
    jumpButtonBase.pressSprite      = [CCSprite spriteWithFile:@"jumpDown.png"];
    jumpButtonBase.button = [[SneakyButton alloc] initWithRect:jumpButtonDimensions];
    jumpButton = [jumpButtonBase.button retain];
    jumpButton.isToggleable = NO;
    [self addChild:jumpButtonBase];
    
    SneakyButtonSkinnedBase *attackButtonBase = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
    attackButtonBase.position   = attackButtonPosition;
    attackButtonBase.defaultSprite  = [CCSprite spriteWithFile:@"handUp.png"];
    attackButtonBase.activatedSprite = [CCSprite spriteWithFile:@"handDown.png"];
    attackButtonBase.pressSprite    = [CCSprite spriteWithFile:@"handDown.png"];
    attackButtonBase.button     = [[SneakyButton alloc] initWithRect:attackButtonDimensions];
    attackButton = [attackButtonBase.button retain];
    attackButton.isToggleable = NO;
    [self addChild:attackButtonBase];
}

#pragma mark -
#pragma mark Update Method
-(void) update:(ccTime)deltaTime
{
    CCArray *listOfGameObjects = [sceneSpriteBatchNode children];
    for (GameCharacter *tempChar in listOfGameObjects) {
        [tempChar updateStateWithDeltaTime:deltaTime 
                      andListOfGameObjects: listOfGameObjects];
    }
}

#pragma mark -
-(void)createObjectOfType:(GameObjectType)objectType
               withHealth:(int)initialHealth
               atLocation:(CGPoint)spawnLocation
               withZValue:(int)ZValue 
{
    if (kEnemyTypeRadarDish == objectType) {
        CCLOG(@"Creating the Radar Enemy");
        RadarDish *radarDish = [[RadarDish alloc] initWithSpriteFrameName:@"radar_1.png"];
        [radarDish setCharacterHealth:initialHealth];
        [radarDish setPosition:spawnLocation];
        [sceneSpriteBatchNode addChild:radarDish z:ZValue
                                   tag:kRadarDishTagValue];
        [radarDish release];
    }
    else if (kEnemyTypeAlienRobot == objectType) {
        CCLOG(@"Creating the Alien Robot");
        EnemyRobot *enemyRobot = [[EnemyRobot alloc] initWithSpriteFrameName:@"an1_anim1.png"];
        [enemyRobot setCharacterHealth:initialHealth];
        [enemyRobot setPosition:spawnLocation];
        [enemyRobot changeState:kStateSpawning];
        [sceneSpriteBatchNode addChild:enemyRobot z:ZValue];
        [enemyRobot setDelegate:self.self];
        
        //Creating the debug label
        CCLabelBMFont *debugLabel = [CCLabelBMFont
                                     labelWithString:@"NoneNone"
                                     fntFile:@"SpaceVikingFont.fnt"];
        [self addChild:debugLabel];
        [enemyRobot setMyDebugLabel:debugLabel];
        
        [enemyRobot release];
    } 
    else if (kEnemyTypeSpaceCargoShip == objectType) {
        CCLOG(@"Creating the Cargo Ship Enemy");
        SpaceCargoShip *spaceCargoShip = [[SpaceCargoShip alloc] initWithSpriteFrameName:@"ship_2.png"];
        [spaceCargoShip setDelegate:self.self];
        [spaceCargoShip setPosition:spawnLocation];
        [sceneSpriteBatchNode addChild:spaceCargoShip z:ZValue];
        [spaceCargoShip release];
    } 
    else if (kPowerUpTypeMallet == objectType) {
        CCLOG(@"GameplayLayer -> Creating mallet powerup");
        Mallet *mallet = [[Mallet alloc] initWithSpriteFrameName:@"mallet_1.png"];
        [mallet setPosition:spawnLocation];
        [sceneSpriteBatchNode addChild:mallet];
        [mallet release];
    } 
    else if (kPowerUpTypeHealth == objectType) {
        CCLOG(@"GameplayLayer -> Creating Health Powerup");
        Health *health = [[Health alloc] initWithSpriteFrameName:@"sandwich_1.png"];
        [health setPosition:spawnLocation];
        [sceneSpriteBatchNode addChild:health];
        [health release];
    } 
}

-(void)addEnemy {
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    RadarDish *radarDish = (RadarDish*)
    [sceneSpriteBatchNode getChildByTag:kRadarDishTagValue];
    if (radarDish != nil) {
        if ([radarDish characterState] != kStateDead) {
            [self createObjectOfType:kEnemyTypeAlienRobot
                          withHealth:100
                          atLocation:ccp(screenSize.width * 0.195f,
                                         screenSize.height * 0.1432f)
                          withZValue:2];
        } else {
            [self unschedule:@selector(addEnemy)];
        } 
    }
}

-(void)createPhaserWithDirection:(PhaserDirection)phaserDirection
                     andPosition:(CGPoint)spawnPosition {
    PhaserBullet *phaserBullet = [[PhaserBullet alloc] initWithSpriteFrameName:@"beam_1.png"];
    [phaserBullet setPosition:spawnPosition];
    [phaserBullet setMyDirection:phaserDirection];
    [phaserBullet setCharacterState:kStateSpawning];
    [sceneSpriteBatchNode addChild:phaserBullet];
    [phaserBullet release];
}

-(id)init {
    self = [super init];
    if (self != nil) {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        // enable touches
        self.isTouchEnabled = YES;
        srandom(time(NULL)); // Seeds the random number generator
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [[CCSpriteFrameCache sharedSpriteFrameCache]
             addSpriteFramesWithFile:@"scene1atlas.plist"];
            sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"scene1atlas.png"];
        } else {
            [[CCSpriteFrameCache sharedSpriteFrameCache]
             addSpriteFramesWithFile:@"scene1atlasiPhone.plist"];
            sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"scene1atlasiPhone.png"];
        }
        
        [self addChild:sceneSpriteBatchNode z:0];
        [self initJoystickAndButtons];
        Viking *viking = [[Viking alloc]
                          initWithSpriteFrame:[[CCSpriteFrameCache
                                                sharedSpriteFrameCache]
                                               spriteFrameByName:@"sv_anim_1.png"]];
        [viking setJoystick:leftJoystick];
        [viking setJumpButton:jumpButton];
        [viking setAttackButton:attackButton];
        [viking setPosition:ccp(screenSize.width * 0.35f,
                                screenSize.height * 0.14f)];
        [viking setCharacterHealth:100];
        [sceneSpriteBatchNode addChild:viking
                                     z:kVikingSpriteZValue
         tag:kVikingSpriteTagValue];
        [self createObjectOfType:kEnemyTypeRadarDish
                      withHealth:100
                      atLocation:ccp(screenSize.width * 0.878f,
                                     screenSize.height * 0.13f)
                      withZValue:10];
        
        //Printing out list of available fonts
        /*NSMutableArray *fontNames = [[NSMutableArray alloc] init];
        NSArray *fontFamilyNames = [UIFont familyNames];
        for (NSString *familyName in fontFamilyNames) {
            NSLog(@"Font Family Name = %@", familyName);
            NSArray *names = [UIFont fontNamesForFamilyName:familyName];
            rrNSLog(@"Font Names = %@", fontNames);
            [fontNames addObjectsFromArray:names];
        }
        [fontNames release];*/
        
        //Text Label
        /*CCLabelTTF *gameBeginLabel = [CCLabelTTF labelWithString:@"Game Start" fontName:@"Helvetica"
                                                        fontSize:64];*/
        CCLabelBMFont *gameBeginLabel = [CCLabelBMFont labelWithString:@"Game Start"
                                                               fntFile:@"SpaceVikingFont.fnt"];
        [gameBeginLabel setPosition:ccp(screenSize.width/2,screenSize.height/2)];
        [self addChild:gameBeginLabel];
        id labelAction = [CCSpawn actions:
                          [CCScaleBy actionWithDuration:2.0f scale:4],
                          [CCFadeOut actionWithDuration:2.0f],
                          nil];
        [gameBeginLabel runAction:labelAction];
        
        [self scheduleUpdate];
        
        /* Wave Action on sprite batch node
        id wavesAction = [CCWaves actionWithWaves:5 amplitude:20 horizontal:NO
                                         vertical:YES grid:ccg(15,10) duration:20];
        [sceneSpriteBatchNode runAction: [CCRepeatForever
                                          actionWithAction:wavesAction]];*/
        
        [self schedule:@selector(addEnemy) interval:10.0f];
        [self createObjectOfType:kEnemyTypeSpaceCargoShip
                      withHealth:0
                      atLocation:ccp(screenSize.width * -0.5f,
                                     screenSize.height * 0.74f)
                      withZValue:50];
    }
    return self;
}
@end
