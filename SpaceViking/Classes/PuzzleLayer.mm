#import "PuzzleLayer.h"
#import "SimpleQueryCallback.h"
#import "Box2DSprite.h"

@implementation PuzzleLayer

+ (id)scene {
    CCScene *scene = [CCScene node];
    PuzzleLayer *layer = [self node];
    [scene addChild:layer];
    return scene;
}

- (void)setupWorld {
    b2Vec2 gravity = b2Vec2(0.0f, -10.0f);
    bool doSleep = true;
    world = new b2World(gravity, doSleep);
}

#pragma mark -
#pragma mark Box2D object creation code
- (void)createBodyAtLocation:(CGPoint)location   forSprite:(Box2DSprite *)sprite 
                   friction:(float32)friction restitution:(float32)restitution 
                    density:(float32)density        isBox:(BOOL)isBox {
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    bodyDef.allowSleep = false;
    b2Body *body = world->CreateBody(&bodyDef);
    body->SetUserData(sprite);
    sprite.body = body;
        
    b2FixtureDef fixtureDef;
    
    if (isBox) {
        b2PolygonShape shape;
        shape.SetAsBox(sprite.contentSize.width/2/PTM_RATIO,
                       sprite.contentSize.height/2/PTM_RATIO);
        fixtureDef.shape = &shape;
    } else {
        b2CircleShape shape;
        shape.m_radius = sprite.contentSize.width/2/PTM_RATIO;
        fixtureDef.shape = &shape;
    }
    
    fixtureDef.density = density; 
    fixtureDef.friction = friction; 
    fixtureDef.restitution = restitution;
    
    body->CreateFixture(&fixtureDef);
}

- (void)createMeteorAtLocation:(CGPoint)location {
    Box2DSprite *sprite = [Box2DSprite spriteWithSpriteFrameName:@"meteor.png"];
    sprite.gameObjectType = kMeteorType;
    [self createBodyAtLocation:location forSprite:sprite friction:0.1
                   restitution:0.3 density:1.0 isBox:FALSE];
    [sceneSpriteBatchNode addChild:sprite];
}

- (void)createSkullAtLocation:(CGPoint)location {
    Box2DSprite *sprite = [Box2DSprite spriteWithSpriteFrameName:@"skull.png"];
    sprite.gameObjectType = kSkullType;
    [self createBodyAtLocation:location forSprite:sprite friction:0.5
                   restitution:0.5 density:0.25 isBox:FALSE];
    [sceneSpriteBatchNode addChild:sprite];
}

- (void)createLongBlockAtLocation:(CGPoint)location {
    Box2DSprite *sprite = [Box2DSprite spriteWithSpriteFrameName:@"long_block.png"];
    sprite.gameObjectType = kLongBlockType;
    [self createBodyAtLocation:location forSprite:sprite friction:0.2
                   restitution:0.0 density:1.0 isBox:TRUE];
    [sceneSpriteBatchNode addChild:sprite];
}

- (void)createIceBlockAtLocation:(CGPoint)location {
    Box2DSprite *sprite = [Box2DSprite spriteWithSpriteFrameName:@"ice_block.png"];
    sprite.gameObjectType = kIceType;
    [self createBodyAtLocation:location forSprite:sprite friction:0.2
                   restitution:0.2 density:1.0 isBox:TRUE];
    [sceneSpriteBatchNode addChild:sprite];
}

- (void)createFrozenOleAtLocation:(CGPoint)location {
    Box2DSprite *sprite = [Box2DSprite spriteWithSpriteFrameName:@"frozen_ole.png"];
    sprite.gameObjectType = kFrozenVikingType;
    [self createBodyAtLocation:location forSprite:sprite friction:0.1
                   restitution:0.2 density:1.0 isBox:TRUE];
    [sceneSpriteBatchNode addChild:sprite];
    frozenVikingBody = sprite.body;
}

- (void)createRockAtLocation:(CGPoint)location {
    Box2DSprite *sprite = [Box2DSprite spriteWithSpriteFrameName:@"rock.png"];
    sprite.gameObjectType = kRockType;
    [self createBodyAtLocation:location forSprite:sprite friction:3.0
                   restitution:0.0 density:1.0 isBox:TRUE];
    [sceneSpriteBatchNode addChild:sprite];
}

#pragma mark -
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
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [[CCSpriteFrameCache sharedSpriteFrameCache]
             addSpriteFramesWithFile:@"scene3atlas-hd.plist"];
            sceneSpriteBatchNode = [CCSpriteBatchNode
                                    batchNodeWithFile:@"scene3atlas-hd.png"];
            
            [self addChild:sceneSpriteBatchNode z:0];
            [self createMeteorAtLocation:ccp(200, 600)];
            [self createSkullAtLocation:ccp(200, 500)];
            [self createRockAtLocation:ccp(400, 100)];
            [self createIceBlockAtLocation:ccp(400, 400)];
            [self createLongBlockAtLocation:ccp(400, 300)];
            [self createFrozenOleAtLocation:ccp(100, 400)];
            [self createRockAtLocation:ccp(300, 400)];
            
            [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
            
            CCSprite *background = [CCSprite spriteWithFile:@"puzzle_level_bkgrnd-ipad.png"];
            background.anchorPoint = ccp(0,0);
            [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_Default];
            [self addChild:background z:-1];
        } else {
            [[CCSpriteFrameCache sharedSpriteFrameCache]
             addSpriteFramesWithFile:@"scene3atlas.plist"];
            sceneSpriteBatchNode = [CCSpriteBatchNode
                                    batchNodeWithFile:@"scene3atlas.png"];
            [self addChild:sceneSpriteBatchNode z:0];
            
            [self createMeteorAtLocation:ccp(100, 300)];
            [self createSkullAtLocation:ccp(100, 250)];
            [self createRockAtLocation:ccp(200, 50)];
            [self createIceBlockAtLocation:ccp(200, 200)];
            [self createLongBlockAtLocation:ccp(200, 150)];
            [self createFrozenOleAtLocation:ccp(40, 200)];
            [self createRockAtLocation:ccp(150, 200)];
            
            [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
            
            CCSprite *background = [CCSprite spriteWithFile:@"puzzle_level_bkgrnd.png"];
            background.anchorPoint = ccp(0,0);
            [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_Default];
            [self addChild:background z:-1];
        }
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
    for(b2Body *b = world->GetBodyList(); b != NULL; b = b->GetNext()) {
        if (b->GetUserData() != NULL) {
            Box2DSprite *sprite = (Box2DSprite *) b->GetUserData();
            sprite.position = ccp(b->GetPosition().x * PTM_RATIO,
                                  b->GetPosition().y * PTM_RATIO);
            sprite.rotation = CC_RADIANS_TO_DEGREES(b->GetAngle() * -1);
        } 
    }
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