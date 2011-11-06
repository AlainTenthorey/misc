#import "Scene5ActionLayer.h"
#import "Scene5UILayer.h"
#import "CPViking.h"
#import "CPRevolvePlatform.h"
#import "CPPivotPlatform.h"
#import "CPSpringPlatform.h"
#import "CPNormalPlatform.h"

@implementation Scene5ActionLayer

- (void)createSpace {
    space = cpSpaceNew();
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        space->gravity = ccp(0, -1500);
    } else {
        space->gravity = ccp(0, -750);
    }
    
    cpSpaceResizeStaticHash(space, 400, 200);
    cpSpaceResizeActiveHash(space, 200, 200);
}

- (void)createBoxAtLocation:(CGPoint)location {
    cpFloat hw, hh;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        hw = 100.0/2.0f;
        hh = 10.0/2.0f;
    } else {
        hw = 50.0/2.0f;
        hh = 5.0/2.0f;
    }
    
    cpVect verts[] = {
        cpv(-hw,-hh),
        cpv(-hw, hh),
        cpv( hw, hh),
        cpv( hw,-hh),
    };
    
    cpShape *shape = cpPolyShapeNew(groundBody, 4, verts, location);
    shape->e = 1.0;
    shape->u = 1.0;
    shape->collision_type = kCollisionTypeGround;
    cpSpaceAddShape(space, shape);
}

#pragma mark -
#pragma mark Create Platforms
- (void)createRevolvePlatformAtLocation:(CGPoint)location {
    CPRevolvePlatform *revolvePlatform =
    [[[CPRevolvePlatform alloc] initWithLocation:location
                                           space:space groundBody:groundBody] autorelease];
    [sceneSpriteBatchNode addChild:revolvePlatform];
}

- (void)createPivotPlatformAtLocation:(CGPoint)location {
    CPPivotPlatform *pivotPlatform = [[[CPPivotPlatform alloc]
                                       initWithLocation:location space:space groundBody:groundBody]
                                      autorelease];
    [sceneSpriteBatchNode addChild:pivotPlatform];
}

- (void)createSpringPlatformAtLocation:(CGPoint)location {
    CPSpringPlatform *springPlatform = [[[CPSpringPlatform alloc]
                                         initWithLocation:location space:space groundBody:groundBody]
                                        autorelease];
    [sceneSpriteBatchNode addChild:springPlatform];
}

- (void)createNormalPlatformAtLocation:(CGPoint)location {
    CPNormalPlatform *normPlatform = [[[CPNormalPlatform alloc]
                                       initWithLocation:location space:space groundBody:groundBody]
                                      autorelease];
    [sceneSpriteBatchNode addChild:normPlatform];
}

#pragma mark -
- (void)createLevel {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    [self createNormalPlatformAtLocation:ccp(200, 100)];
    [self createNormalPlatformAtLocation:
     ccp(winSize.width * 0.2, winSize.height * 0.15)];
    [self createNormalPlatformAtLocation:
     ccp(winSize.width * 0.4, winSize.height * 0.30)];
    [self createNormalPlatformAtLocation:
     ccp(winSize.width * 0.6, winSize.height * 0.45)];
    [self createNormalPlatformAtLocation:
     ccp(winSize.width * 0.8, winSize.height * 0.75)];
    [self createNormalPlatformAtLocation:
     ccp(winSize.width * 0.6, winSize.height * 0.90)];
    [self createNormalPlatformAtLocation:
     ccp(winSize.width * 0.4, winSize.height * 1.15)];
    [self createNormalPlatformAtLocation:
     ccp(winSize.width * 0.2, winSize.height * 1.30)];
    [self createPivotPlatformAtLocation:
     ccp(winSize.width * 0.4, winSize.height * 1.60)];
    [self createNormalPlatformAtLocation:
     ccp(winSize.width * 0.7, winSize.height * 1.90)];
    [self createNormalPlatformAtLocation:
     ccp(winSize.width * 0.4, winSize.height * 2.15)];
    [self createSpringPlatformAtLocation:
     ccp(winSize.width * 0.45, winSize.height * 2.60)];
    [self createSpringPlatformAtLocation:
     ccp(winSize.width * 0.75, winSize.height * 2.80)];
    [self createSpringPlatformAtLocation:
     ccp(winSize.width * 0.55, winSize.height * 3.05)];
    [self createNormalPlatformAtLocation:
     ccp(winSize.width * 0.4, winSize.height * 3.15)];
    [self createNormalPlatformAtLocation:
     ccp(winSize.width * 0.2, winSize.height * 3.35)];
    [self createRevolvePlatformAtLocation:
     ccp(winSize.width * 0.5, winSize.height * 3.50)];
    [self createNormalPlatformAtLocation:
     ccp(winSize.width * 0.8, winSize.height * 3.65)];
}
    
- (void)createGround {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGPoint lowerLeft = ccp(0, 0);
    CGPoint lowerRight = ccp(winSize.width, 0);
    groundBody = cpBodyNewStatic();
    
    float radius = 10.0f;
    cpShape * shape = cpSegmentShapeNew(groundBody,
                                        lowerLeft, lowerRight, radius);
    shape->e = 1.0f;
    shape->u = 1.0f;
    shape->layers ^= GRABABLE_MASK_BIT;
    shape->collision_type = kCollisionTypeGround;
    cpSpaceAddShape(space, shape);
}

- (void)createBackground 
{
    CCParallaxNode * parallax = [CCParallaxNode node];
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
    
    CCSprite *background;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        background = [CCSprite spriteWithFile:@"chipmunk_background-ipad.png"];
    } else {
        background = [CCSprite spriteWithFile:@"chipmunk_background.png"];
    }
    background.anchorPoint = ccp(0,0);
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_Default];
    [parallax addChild:background z:-10 parallaxRatio:ccp(0.1f, 0.1f)
        positionOffset:ccp(0,0)];
    [self addChild:parallax z:-10];
    
    //Adding ground sprite at bottom
    CCSprite *groundSprite;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        groundSprite = [CCSprite spriteWithFile:@"chipmunk_ground-hd.png"];
    } else {
        groundSprite = [CCSprite spriteWithFile:@"chipmunk_ground.png"];
    }
    groundSprite.anchorPoint = ccp(0,0);
    groundSprite.position = ccp(0,0);
    [self addChild:groundSprite z:-10];
    
    //pulse glow effect on background
    [background runAction:
     [CCRepeatForever actionWithAction:
      [CCSequence actions:
       [CCTintTo actionWithDuration:0.5 red:200 green:0 blue:0],
       [CCTintTo actionWithDuration:0.5 red:255 green:255 blue:255],
       nil]]];
}

- (id)initWithScene5UILayer:(Scene5UILayer *)scene5UILayer {
    if ((self = [super init])) {
        uiLayer = scene5UILayer;
        startTime = CACurrentMediaTime();
        [self scheduleUpdate];
        
        [self createSpace];
        [self createGround];
        mouse = cpMouseNew(space);
        self.isTouchEnabled = YES;
        self.isAccelerometerEnabled = YES;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [[CCSpriteFrameCache sharedSpriteFrameCache]
             addSpriteFramesWithFile:@"scene5atlas-hd.plist"];
            sceneSpriteBatchNode = [CCSpriteBatchNode
                                    batchNodeWithFile:@"scene5atlas-hd.png"];
            
            viking = [[[CPViking alloc] initWithLocation:ccp(200,200)
                                                   space:space groundBody:groundBody] autorelease];
        } else {
            [[CCSpriteFrameCache sharedSpriteFrameCache]
             addSpriteFramesWithFile:@"scene5atlas.plist"];
            sceneSpriteBatchNode = [CCSpriteBatchNode
                                    batchNodeWithFile:@"scene5atlas.png"];
            viking = [[[CPViking alloc] initWithLocation:ccp(100,100)
                                                   space:space groundBody:groundBody] autorelease];
        }
        [self addChild:sceneSpriteBatchNode z:0];
        [sceneSpriteBatchNode addChild:viking z:2];
        
        [self createLevel];
        
        [[GameManager sharedGameManager] playBackgroundTrack:BACKGROUND_TRACK_ESCAPE];
        [self createBackground];
    }
    return self;
}

- (void)followPlayer:(ccTime)dt 
{   
    static double totalTime = 0;
    totalTime += dt;
    
    double shakesPerSecond = 5;
    double shakeOffset = 3;
    double shakeX = sin(totalTime*M_PI*2*shakesPerSecond) * shakeOffset;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    float fixedPosition = winSize.height/4;
    float newY = fixedPosition - viking.position.y;
    float groundMaxY = 2048;
    newY = MIN(newY, 50);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        groundMaxY = 900;
        newY = MIN(newY, 25);
    }
    
    newY = MAX(newY, -groundMaxY-fixedPosition);
    CGPoint newPos = ccp(shakeX, newY);
    [self setPosition:newPos];
}

- (void)update:(ccTime)dt {
    static double MAX_TIME = 60;
    double timeSoFar = CACurrentMediaTime() - startTime;
    double remainingTime = MAX_TIME - timeSoFar;
    [uiLayer displaySecs:remainingTime];
    
    static double UPDATE_INTERVAL = 1.0f/60.0f;
    static double MAX_CYCLES_PER_FRAME = 5;
    static double timeAccumulator = 0;
    timeAccumulator += dt;
    if (timeAccumulator > (MAX_CYCLES_PER_FRAME * UPDATE_INTERVAL)) {
        timeAccumulator = UPDATE_INTERVAL;
    }
    while (timeAccumulator >= UPDATE_INTERVAL) {
        timeAccumulator -= UPDATE_INTERVAL;
        cpSpaceStep(space, UPDATE_INTERVAL);
    }
    
    CCArray *listOfGameObjects = [sceneSpriteBatchNode children];
    for (GameCharacter *tempChar in listOfGameObjects) {
        [tempChar updateStateWithDeltaTime:dt
                      andListOfGameObjects:listOfGameObjects];
    }
    
    [self followPlayer:dt];
}

- (void)registerWithTouchDispatcher {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                     priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [viking ccTouchBegan:touch withEvent:event];
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    [viking ccTouchEnded:touch withEvent:event];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer
        didAccelerate:(UIAcceleration *)acceleration {
    [viking accelerometer:accelerometer didAccelerate:acceleration];
}

@end