#import "Scene5ActionLayer.h"
#import "Scene5UILayer.h"

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
    float boxSize = 60.0;
    float mass = 1.0;
    cpBody *body = cpBodyNew(mass, cpMomentForBox(mass, boxSize, boxSize));                   // 1
    body->p = location;
    
    cpSpaceAddBody(space, body);
    cpShape *shape =
    cpBoxShapeNew(body, boxSize, boxSize);
    shape->e = 0.0;
    shape->u = 0.5;
    cpSpaceAddShape(space, shape);
}

- (void)createLevel {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    [self createBoxAtLocation:ccp(winSize.width * 0.5, winSize.height *
                                  0.15)];
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
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    cpMouseGrab(mouse, touchLocation, false);
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    cpMouseMove(mouse, touchLocation);
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    cpMouseRelease(mouse);
}

@end