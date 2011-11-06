#import "Scene5ActionLayer.h"
#import "Scene5UILayer.h"
#import "CPViking.h"
#import "CPRevolvePlatform.h"

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

- (void)createRevolvePlatformAtLocation:(CGPoint)location {
    CPRevolvePlatform *revolvePlatform =
    [[[CPRevolvePlatform alloc] initWithLocation:location
                                           space:space groundBody:groundBody] autorelease];
    [sceneSpriteBatchNode addChild:revolvePlatform];
}

- (void)createLevel {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    [self createRevolvePlatformAtLocation:
     ccp(winSize.width * 0.5, winSize.height * 0.25)];
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
    }
    return self;
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
}

- (void)draw {
    drawSpaceOptions options = {
        0,      // drawHash
        0,      // drawBBs
        1,      // drawShapes
        4.0f,   // collisionPointSize
        0.0f,   // bodyPointSize
        1.5f,   // lineThickness
    };
    drawSpace(space, &options);
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