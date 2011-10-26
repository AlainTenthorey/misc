#import "TestPuzzleLayer.h"
#import "SimpleQueryCallback.h"

@implementation TestPuzzleLayer

+ (id)scene {
    CCScene *scene = [CCScene node];
    TestPuzzleLayer *layer = [self node];
    [scene addChild:layer];
    return scene;
}

- (void)setupWorld {
    b2Vec2 gravity = b2Vec2(0.0f, -10.0f);
    bool doSleep = true;
    world = new b2World(gravity, doSleep);
}

- (void)createBoxAtLocation:(CGPoint)location    withSize:(CGSize)size 
                   friction:(float32)friction restitution:(float32)restitution 
                    density:(float32)density {
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    bodyDef.allowSleep = false;
    b2Body *body = world->CreateBody(&bodyDef);
    
    b2PolygonShape shape;
    shape.SetAsBox(size.width/2/PTM_RATIO, size.height/2/PTM_RATIO);
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;
    fixtureDef.density = density; 
    fixtureDef.friction = friction; 
    fixtureDef.restitution = restitution;
    
    body->CreateFixture(&fixtureDef);
}

- (void)setupDebugDraw {
    debugDraw = new GLESDebugDraw(PTM_RATIO *[[CCDirector sharedDirector]
                                              contentScaleFactor]);
    world->SetDebugDraw(debugDraw);
    debugDraw->SetFlags(b2DebugDraw::e_shapeBit);
}

-(void) draw {
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    world->DrawDebugData();
    
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}

- (void)createGround {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    float32 margin = 10.0f;
    b2Vec2 lowerLeft = b2Vec2(margin/PTM_RATIO, margin/PTM_RATIO);
    b2Vec2 lowerRight = b2Vec2((winSize.width-margin)/PTM_RATIO,
                               margin/PTM_RATIO);
    b2Vec2 upperRight = b2Vec2((winSize.width-margin)/PTM_RATIO,
                               (winSize.height-margin)/PTM_RATIO);
    b2Vec2 upperLeft = b2Vec2(margin/PTM_RATIO,
                              (winSize.height-margin)/PTM_RATIO);
    
    b2BodyDef groundBodyDef;
    groundBodyDef.type = b2_staticBody;
    groundBodyDef.position.Set(0, 0);
    groundBody = world->CreateBody(&groundBodyDef);
    
    b2PolygonShape groundShape;
    b2FixtureDef groundFixtureDef;
    groundFixtureDef.shape = &groundShape;
    groundFixtureDef.density = 0.0;
    
    groundShape.SetAsEdge(lowerLeft, lowerRight);
    groundBody->CreateFixture(&groundFixtureDef);
    groundShape.SetAsEdge(lowerRight, upperRight);
    groundBody->CreateFixture(&groundFixtureDef);
    groundShape.SetAsEdge(upperRight, upperLeft);
    groundBody->CreateFixture(&groundFixtureDef);
    groundShape.SetAsEdge(upperLeft, lowerLeft);
    groundBody->CreateFixture(&groundFixtureDef);
}

- (id)init {
    if ((self = [super init])) {
        [self setupWorld];
        [self setupDebugDraw];
        [self createGround];
        
        [self scheduleUpdate];
        self.isTouchEnabled = YES;
        self.isAccelerometerEnabled = TRUE;
        
        CGPoint location1, location2, location3;
        CGSize smallSize, medSize, largeSize;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            location1 = ccp(200, 400);
            location2 = ccp(500, 400);
            location3 = ccp(800, 400);
            smallSize = CGSizeMake(50, 50);
            medSize   = CGSizeMake(100, 100);
            largeSize = CGSizeMake(200, 200);
        } else {
            location1 = ccp(100, 200);
            location2 = ccp(250, 200);
            location3 = ccp(400, 200);
            smallSize = CGSizeMake(25, 25);
            medSize   = CGSizeMake(50, 50);
            largeSize = CGSizeMake(100, 100);
        }
        [self createBoxAtLocation:location1 withSize:medSize
                         friction:1.0 restitution:0.0 density:1.0];
        [self createBoxAtLocation:location2 withSize:medSize
                         friction:1.0 restitution:0.5 density:1.0];
        [self createBoxAtLocation:location3 withSize:medSize
                         friction:1.0 restitution:1.0 density:1.0];
    }
    return self;
}

#pragma mark -
#pragma mark event handlers
- (void)registerWithTouchDispatcher {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                     priority:0 swallowsTouches:YES];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer
        didAccelerate:(UIAcceleration *)acceleration {
    b2Vec2 gravity(-acceleration.y * 15, acceleration.x *15);
    world->SetGravity(gravity);
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector]
                     convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    b2Vec2 locationWorld = b2Vec2(touchLocation.x/PTM_RATIO, touchLocation.y/PTM_RATIO);
    
    b2AABB aabb;
    b2Vec2 delta = b2Vec2(1.0/PTM_RATIO, 1.0/PTM_RATIO);
    
    aabb.lowerBound = locationWorld - delta;
    aabb.upperBound = locationWorld + delta;
    SimpleQueryCallback callback(locationWorld);
    world->QueryAABB(&callback, aabb);
    
    if (callback.fixtureFound) {
        b2Body *body = callback.fixtureFound->GetBody();
        b2MouseJointDef mouseJointDef;
        mouseJointDef.bodyA = groundBody;
        mouseJointDef.bodyB = body;
        mouseJointDef.target = locationWorld;
        mouseJointDef.maxForce = 100 * body->GetMass();
        mouseJointDef.collideConnected = true;
        mouseJoint = (b2MouseJoint *) world->CreateJoint(&mouseJointDef);
        body->SetAwake(true);
        return YES;
    } else {
        //[self createBoxAtLocation:touchLocation
        //                 withSize:CGSizeMake(50, 50)];
    }
    
    return TRUE;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    b2Vec2 locationWorld = b2Vec2(touchLocation.x/PTM_RATIO, touchLocation.y/PTM_RATIO);
    
    if (mouseJoint) {
        mouseJoint->SetTarget(locationWorld);
    }
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if (mouseJoint) {
        world->DestroyJoint(mouseJoint);
        mouseJoint = NULL;
    }
}

-(void)update:(ccTime)dt {
    int32 velocityIterations = 3;
    int32 positionIterations = 2;
    world->Step(dt, velocityIterations, positionIterations);
}

#pragma mark -
- (void)dealloc {
    if (world) {
        delete world;
        world = NULL;
    }
    if (debugDraw) {
        delete debugDraw;
        debugDraw = nil;
    }
    [super dealloc];
}

@end