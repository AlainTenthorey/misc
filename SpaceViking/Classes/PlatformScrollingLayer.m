//  PlatformScrollingLayer.m
//  SpaceViking
//
#import "PlatformScrollingLayer.h"
#import "GameManager.h"

@interface PlatformScrollingLayer (PrivateMethods)
-(void)resetCloudWithNode:(id)node;
-(void)createCloud;
-(void)createVikingAndPlatform;
-(void)createStaticBackground;
@end

@implementation PlatformScrollingLayer

-(id)init {
    self = [super init];
    if (self != nil) {
        srandom(time(NULL));
        self.isTouchEnabled = YES;
        [self createStaticBackground];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // Indicates game is running on iPad
            [[CCSpriteFrameCache sharedSpriteFrameCache]
             addSpriteFramesWithFile: @"ScrollingCloudsTextureAtlas.plist"];
            scrollingBatchNode = [CCSpriteBatchNode
                                  batchNodeWithFile:@"ScrollingCloudsTextureAtlas.png"];
        } else {
            [[CCSpriteFrameCache sharedSpriteFrameCache]
             addSpriteFramesWithFile: @"ScrollingCloudsTextureAtlasiPhone.plist"];
            scrollingBatchNode = [CCSpriteBatchNode
                                  batchNodeWithFile:@"ScrollingCloudsTextureAtlasiPhone.png"];
        }
        
        [self addChild:scrollingBatchNode];
        for (int x=0; x < 25; x++) {
            [self createCloud];
        }
        [self createVikingAndPlatform];
    }
    return self;
}

-(void)createStaticBackground {
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CCSprite *background;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Indicates game is running on iPad
        background = [CCSprite spriteWithFile:@"tiles_grad_bkgrnd.png"];
    } else {
        background = [CCSprite spriteWithFile:@"tiles_grad_bkgrndiPhone.png"];
    }
    [background setPosition:ccp(screenSize.width/2.0f, screenSize.height/2.0f)];
    [self addChild:background];
}

-(void)createCloud {
    int cloudToDraw = random() % 6; 
    NSString *cloudFileName = [NSString
                               stringWithFormat:@"tiles_cloud%d.png",cloudToDraw];
    CCSprite *cloudSprite = [CCSprite
                             spriteWithSpriteFrameName:cloudFileName];
    [scrollingBatchNode addChild:cloudSprite];
    [self resetCloudWithNode:cloudSprite];
}

-(void)resetCloudWithNode:(id)node {
    CGSize screenSize = [CCDirector sharedDirector].winSize; 
    CCNode *cloud = (CCNode*)node; 
    
    float xOffSet = [cloud boundingBox].size.width /2;
    int xPosition = screenSize.width + 1 + xOffSet;
    int yPosition = random() % (int)screenSize.height;
    [cloud setPosition:ccp(xPosition,yPosition)];
    
    int moveDuration = random() % kMaxCloudMoveDuration;
    if (moveDuration < kMinCloudMoveDuration) {
        moveDuration = kMinCloudMoveDuration;
    }
    
    float offScreenXPosition = (xOffSet * -1) - 1;
    
    id moveAction = [CCMoveTo actionWithDuration:moveDuration
                                        position:
                     ccp(offScreenXPosition,[cloud position].y)];
    id resetAction = [CCCallFuncN
                      actionWithTarget:self
                      selector:@selector(resetCloudWithNode:)];
    id sequenceAction = [CCSequence
                         actions:moveAction,resetAction,nil];
    [cloud runAction:sequenceAction];
    
    int newZOrder = kMaxCloudMoveDuration - moveDuration;
    [scrollingBatchNode reorderChild:cloud z:newZOrder];
}

-(void)createVikingAndPlatform {
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    int nextZValue = [scrollingBatchNode children].count + 1;
    
    CCSprite *platform = [CCSprite
                          spriteWithSpriteFrameName:@"platform.png"];
    [platform setPosition:
     ccp(screenSize.width/2,
         screenSize.height * 0.09f)];
    [scrollingBatchNode addChild:platform z:nextZValue];
    nextZValue = nextZValue + 1;
    
    CCSprite *viking = [CCSprite
                        spriteWithSpriteFrameName:@"sv_anim_1.png"];
    [viking setPosition:
     ccp(screenSize.width/2,
         screenSize.height * 0.23f)];
    [scrollingBatchNode addChild:viking z:nextZValue];
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[GameManager sharedGameManager] runSceneWithID:kGameLevel2];
}
@end
