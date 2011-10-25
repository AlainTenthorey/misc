//  GameplayScrollingLayer.m
//  SpaceViking
//
#import "GameplayScrollingLayer.h"
@implementation GameplayScrollingLayer

-(void)connectControlsWithJoystick:(SneakyJoystick*)leftJoystick
                     andJumpButton:(SneakyButton*)jumpButton
                   andAttackButton:(SneakyButton*)attackButton {
    Viking *viking = (Viking*)[sceneSpriteBatchNode
                              getChildByTag:kVikingSpriteTagValue];
    [viking setJoystick:leftJoystick];
    [viking setJumpButton:jumpButton];
    [viking setAttackButton:attackButton];
}

// Scrolling with just a large width *2 background
-(void)addScrollingBackground {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGSize levelSize = [[GameManager sharedGameManager] getDimensionsOfCurrentScene];
    CCSprite *scrollingBackground;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Indicates game is running on iPad
        scrollingBackground = [CCSprite spriteWithFile:@"FlatScrollingLayer.png"];
    } else {
        scrollingBackground = [CCSprite spriteWithFile:@"FlatScrollingLayeriPhone.png"];
    }
    [scrollingBackground setPosition:ccp(levelSize.width/2.0f,screenSize.height/2.0f)];
    [self addChild:scrollingBackground];
}

// Scrolling with 3 Parallax backgrounds
-(void)addScrollingBackgroundWithParallax {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGSize levelSize = [[GameManager sharedGameManager]
                        getDimensionsOfCurrentScene];
    CCSprite *BGLayer1;
    CCSprite *BGLayer2;
    CCSprite *BGLayer3;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Indicates game is running on iPad
        BGLayer1 = [CCSprite spriteWithFile:@"chap9_scrolling4.png"];
        BGLayer2 = [CCSprite spriteWithFile:@"chap9_scrolling2.png"];
        BGLayer3 = [CCSprite spriteWithFile:@"chap9_scrolling3.png"];
    } else {
        BGLayer1 = [CCSprite spriteWithFile:@"chap9_scrolling4iPhone.png"];
        BGLayer2 = [CCSprite spriteWithFile:@"chap9_scrolling2iPhone.png"];
        BGLayer3 = [CCSprite spriteWithFile:@"chap9_scrolling3iPhone.png"];
    }
    // chap9_scrolling4 is the ground
    // chap9_scrolling2 are the large mountains
    // chap9_scrolling3 are the small rocks
    
    parallaxNode = [CCParallaxNode node];
    [parallaxNode setPosition:ccp(levelSize.width/2.0f,screenSize.height/2.0f)];
    float xOffset = 0;
    // Ground moves at ratio 1,1
    [parallaxNode addChild:BGLayer1 z:40 parallaxRatio:ccp(1.0f,1.0f)
            positionOffset:ccp(0.0f,0.0f)];
    xOffset = (levelSize.width/2) * 0.3f;
    [parallaxNode addChild:BGLayer2 z:20 parallaxRatio:ccp(0.2f,1.0f)
            positionOffset:ccp(xOffset, 0)];
    xOffset = (levelSize.width/2) * 0.8f;
    [parallaxNode addChild:BGLayer3 z:30 parallaxRatio:ccp(0.7f,1.0f)
            positionOffset:ccp(xOffset, 0)];
    [self addChild:parallaxNode z:10];
}

// Scrolling with TileMap Layers inside of a Parallax Node
-(void)addScrollingBackgroundWithTileMapInsideParallax {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGSize levelSize = [[GameManager sharedGameManager]
                        getDimensionsOfCurrentScene];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        tileMapNode = [CCTMXTiledMap tiledMapWithTMXFile:@"Level2TileMap.tmx"];
    } else {
        tileMapNode = [CCTMXTiledMap tiledMapWithTMXFile:@"Level2TileMapiPhone.tmx"];
    }
    
    CCTMXLayer *groundLayer = [tileMapNode layerNamed:@"GroundLayer"];
    CCTMXLayer *rockColumnsLayer = [tileMapNode layerNamed:@"RockColumnsLayer"];
    CCTMXLayer *rockBoulderLayer = [tileMapNode layerNamed:@"RockBoulderLayer"];
    
    parallaxNode = [CCParallaxNode node];
    [parallaxNode setPosition:ccp(levelSize.width/2,screenSize.height/2)];
    float xOffset = 0.0f;
    
    xOffset = (levelSize.width/2);
    [groundLayer retain];
    [groundLayer removeFromParentAndCleanup:NO];
    [groundLayer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
    [parallaxNode addChild:groundLayer z:30 parallaxRatio:ccp(1,1)
            positionOffset:ccp(0,0)];
    [groundLayer release];
    
    xOffset = (levelSize.width/2) * 0.8f;
    [rockColumnsLayer retain];
    [rockColumnsLayer removeFromParentAndCleanup:NO];
    [rockColumnsLayer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
    [parallaxNode addChild:rockColumnsLayer z:20
             parallaxRatio:ccp(0.2,1)
            positionOffset:ccp(xOffset, 0.0f)];
    [rockColumnsLayer release];
    
    xOffset = (levelSize.width/2) * 0.3f;
    [rockBoulderLayer retain];
    [rockBoulderLayer removeFromParentAndCleanup:NO];
    [rockBoulderLayer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
    [parallaxNode addChild:rockBoulderLayer z:30
             parallaxRatio:ccp(0.7,1)
            positionOffset:ccp(xOffset, 0.0f)];
    [rockBoulderLayer release];
    
    [self addChild:parallaxNode z:1];
}

// Scrolling with all TileMap Layers together
-(void)addScrollingBackgroundWithTileMap {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        tileMapNode = [CCTMXTiledMap tiledMapWithTMXFile:@"Level2TileMap.tmx"];
    } else {
        tileMapNode = [CCTMXTiledMap tiledMapWithTMXFile:@"Level2TileMapiPhone.tmx"];
    }
    [self addChild:tileMapNode];
}

-(id)init {
    if (( self = [super init] )) {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [[CCSpriteFrameCache sharedSpriteFrameCache]
             addSpriteFramesWithFile:@"scene1atlas.plist"];
            sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"scene1atlas.png"];
        } else {
            [[CCSpriteFrameCache sharedSpriteFrameCache]
             addSpriteFramesWithFile:@"scene1atlasiPhone.plist"];
            sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"scene1atlasiPhone.png"];
        }
        [self addChild:sceneSpriteBatchNode z:20];
        Viking *viking = [[Viking alloc]
                          initWithSpriteFrame:
                          [[CCSpriteFrameCache sharedSpriteFrameCache]
                           spriteFrameByName:@"sv_anim_1.png"]];
        [viking setJoystick:nil];
        [viking setJumpButton:nil];
        [viking setAttackButton:nil];
        [viking setPosition:ccp(screenSize.width * 0.35f,
                                screenSize.height * 0.14f)];
        [viking setCharacterHealth:100];
        [sceneSpriteBatchNode addChild:viking
                                     z:1000 tag:kVikingSpriteTagValue];
        
        //[self addScrollingBackground];
        //[self addScrollingBackgroundWithParallax];
        //[self addScrollingBackgroundWithTileMap];
        [self addScrollingBackgroundWithTileMapInsideParallax];
        
        [self scheduleUpdate];
    }
    return self;
}

#pragma mark SCROLLING_CALCULATION
-(void)adjustLayer {
    Viking *viking = (Viking*)[sceneSpriteBatchNode
                               getChildByTag:kVikingSpriteTagValue];
    float vikingXPosition = viking.position.x;
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    float halfOfTheScreen = screenSize.width/2.0f;
    CGSize levelSize = [[GameManager sharedGameManager] getDimensionsOfCurrentScene];
    
    if ((vikingXPosition > halfOfTheScreen) &&
        (vikingXPosition < (levelSize.width - halfOfTheScreen))) {
        // Background should scroll
        float newXPosition = halfOfTheScreen - vikingXPosition;    
        [self setPosition:ccp(newXPosition,self.position.y)];      
    } 
}

#pragma mark -
-(void) update:(ccTime)deltaTime
{
    CCArray *listOfGameObjects =
    [sceneSpriteBatchNode children];
    for (GameCharacter *tempChar in listOfGameObjects) {
        [tempChar updateStateWithDeltaTime:deltaTime
                      andListOfGameObjects:listOfGameObjects];
    }
    [self adjustLayer];
    
    // Check to see if the Viking is dead
    GameCharacter *tempChar =
    (GameCharacter*)[sceneSpriteBatchNode
                     getChildByTag:kVikingSpriteTagValue];
    if (([tempChar characterState] == kStateDead) &&
        ([tempChar numberOfRunningActions] == 0)) {
        [[GameManager sharedGameManager] setHasPlayerDied:YES];
        [[GameManager sharedGameManager]
         runSceneWithID:kLevelCompleteScene];
    }
    
    // Check to see if the RadarDish is dead
    tempChar = (GameCharacter*)[sceneSpriteBatchNode
                                getChildByTag:kRadarDishTagValue];
    if (([tempChar characterState] == kStateDead) &&
        ([tempChar numberOfRunningActions] == 0)) {
        [[GameManager sharedGameManager]
         runSceneWithID:kLevelCompleteScene];
    }
}

@end
