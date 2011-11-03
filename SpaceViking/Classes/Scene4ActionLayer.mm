#import "Scene4ActionLayer.h"
#import "Box2DSprite.h"
#import "Scene4UILayer.h"
#import "Cart.h"
#import "SimpleQueryCallback.h"
#import "Box2DHelpers.h"
#import "Spikes.h"
#import "Digger.h"
#import "GameManager.h"

#ifndef HD_PTM_RATIO
    #define HD_PTM_RATIO 100.0
#endif

@implementation Scene4ActionLayer

- (void)setupWorld {
    b2Vec2 gravity = b2Vec2(0.0f, -10.0f);
    bool doSleep = true;
    world = new b2World(gravity, doSleep);
}

- (void)createCartAtLocation:(CGPoint)location {
    cart = [[[Cart alloc]
             initWithWorld:world atLocation:location] autorelease];
    [sceneSpriteBatchNode addChild:cart z:1 tag:kVikingSpriteTagValue];
    [sceneSpriteBatchNode addChild:cart.wheelL];
    [sceneSpriteBatchNode addChild:cart.wheelR];
    [sceneSpriteBatchNode addChild:cart.legs];
    [sceneSpriteBatchNode addChild:cart.trunk];
    [sceneSpriteBatchNode addChild:cart.head];
    [sceneSpriteBatchNode addChild:cart.helm];
    [sceneSpriteBatchNode addChild:cart.arm z:2];
}

- (void)createBackground {
    CCParallaxNode * parallax = [CCParallaxNode node];
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
    
    CCSprite *background;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        background = [CCSprite spriteWithFile:@"scene_4_background-ipad.png"];
    } else {
        background = [CCSprite spriteWithFile:@"scene_4_background.png"];
    }
    
    background.anchorPoint = ccp(0,0);
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_Default];
    
    [parallax addChild:background z:-10 parallaxRatio:ccp(0.05f, 0.05f)
        positionOffset:ccp(0,0)];
    [self addChild:parallax z:-10];
}

- (void)createDigger {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    digger = [[[Digger alloc] initWithWorld:world
                                 atLocation:ccp(groundMaxX - winSize.width * 0.8,
                                                winSize.height/2)] autorelease];
    [sceneSpriteBatchNode addChild:digger];
}

- (void)createOffscreenSensorBody {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    float32 sensorWidth = groundMaxX + winSize.width*4;
    float32 sensorHeight = winSize.height * 0.25;
    float32 sensorOffsetX = -winSize.width*2;
    float32 sensorOffsetY = -winSize.height/2;
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    bodyDef.position.Set(sensorOffsetX/PTM_RATIO + sensorWidth/2/PTM_RATIO,
                         sensorOffsetY/PTM_RATIO + sensorHeight/2/PTM_RATIO);
    offscreenSensorBody = world->CreateBody(&bodyDef);
    
    b2PolygonShape shape;
    shape.SetAsBox(sensorWidth/2/PTM_RATIO, sensorHeight/2/PTM_RATIO);
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;
    fixtureDef.isSensor = true;
    fixtureDef.density = 0.0;
    offscreenSensorBody->CreateFixture(&fixtureDef);
}

- (void)createFinalBattleSensor {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    float32 sensorWidth = winSize.width * 0.03;
    float32 sensorHeight = winSize.height;
    float32 sensorOffset = winSize.width * 0.15;
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    bodyDef.position.Set(
                         groundMaxX/PTM_RATIO + sensorOffset/PTM_RATIO + sensorWidth/2/PTM_RATIO,
                         sensorHeight/2/PTM_RATIO);
    finalBattleSensorBody = world->CreateBody(&bodyDef);
    
    b2PolygonShape shape;
    shape.SetAsBox(sensorWidth/2/PTM_RATIO, sensorHeight/2/PTM_RATIO);
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;
    fixtureDef.isSensor = true;
    fixtureDef.density = 0.0;
    finalBattleSensorBody->CreateFixture(&fixtureDef);
}

- (void)createParticleSystem {
    fireOnBridge = [CCParticleSystemQuad
                    particleWithFile:@"fire.plist"];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        fireOnBridge.position = ccp(groundMaxX - 400.0, 80);
    } else {
        fireOnBridge.position = ccp(groundMaxX - 200, 40);
    }
    [fireOnBridge stopSystem];
    [self addChild:fireOnBridge z:10];
}

#pragma mark -
#pragma mark Create Scrollable Ground
- (void)createGround {
    b2BodyDef groundBodyDef;
    groundBodyDef.type = b2_staticBody;
    groundBodyDef.position.Set(0, 0);
    groundBody = world->CreateBody(&groundBodyDef);
}

- (void)createGroundEdgesWithVerts:(b2Vec2 *)verts numVerts:(int)num
                   spriteFrameName:(NSString *)spriteFrameName 
{
    CCSprite *ground = [CCSprite spriteWithSpriteFrameName:spriteFrameName];
    ground.position = ccp(groundMaxX+ground.contentSize.width/2,
                          ground.contentSize.height/2);
    [groundSpriteBatchNode addChild:ground];
    
    b2PolygonShape groundShape;
    b2FixtureDef groundFixtureDef;
    groundFixtureDef.shape = &groundShape;
    groundFixtureDef.density = 0.0;
    for(int i = 0; i < num - 1; ++i) {
        b2Vec2 offset = b2Vec2(groundMaxX/PTM_RATIO +
                               ground.contentSize.width/2/PTM_RATIO,
                               ground.contentSize.height/2/PTM_RATIO);
        b2Vec2 left = verts[i] + offset;
        b2Vec2 right = verts[i+1] + offset;
        groundShape.SetAsEdge(left, right);
        groundBody->CreateFixture(&groundFixtureDef);
    }
    groundMaxX += ground.contentSize.width;
}

- (void)createGround1 {
    // Replace with your values from Vertex Helper, but replace all
    // instances of PTM_RATIO with 100.0
    int num = 23;
    b2Vec2 verts[] = {
        b2Vec2(-1022.5f / 100.0, -20.2f / HD_PTM_RATIO),
        b2Vec2(-966.6f / 100.0, -18.0f / HD_PTM_RATIO),
        b2Vec2(-893.8f / 100.0, -10.3f / HD_PTM_RATIO),
        b2Vec2(-888.8f / 100.0, 1.1f / HD_PTM_RATIO),
        b2Vec2(-804.0f / 100.0, 10.3f / HD_PTM_RATIO),
        b2Vec2(-799.7f / 100.0, 5.3f / HD_PTM_RATIO),
        b2Vec2(-795.5f / 100.0, 8.1f / HD_PTM_RATIO),
        b2Vec2(-755.2f / 100.0, -1.8f / HD_PTM_RATIO),
        b2Vec2(-755.2f / 100.0, -9.5f / HD_PTM_RATIO),
        b2Vec2(-632.2f / 100.0, 5.3f / HD_PTM_RATIO),
        b2Vec2(-603.9f / 100.0, 17.3f / HD_PTM_RATIO),
        b2Vec2(-536.0f / 100.0, 18.0f / HD_PTM_RATIO),
        b2Vec2(-518.3f / 100.0, 28.6f / HD_PTM_RATIO),
        b2Vec2(-282.1f / 100.0, 13.1f / HD_PTM_RATIO),
        b2Vec2(-258.1f / 100.0, 27.2f / HD_PTM_RATIO),
        b2Vec2(-135.1f / 100.0, 18.7f / HD_PTM_RATIO),
        b2Vec2(9.2f / 100.0, -19.4f / HD_PTM_RATIO),
        b2Vec2(483.0f / 100.0, -18.7f / HD_PTM_RATIO),
        b2Vec2(578.4f / 100.0, 11.0f / HD_PTM_RATIO),
        b2Vec2(733.3f / 100.0, -7.4f / HD_PTM_RATIO),
        b2Vec2(827.3f / 100.0, -1.1f / HD_PTM_RATIO),
        b2Vec2(1006.9f / 100.0, -20.2f / HD_PTM_RATIO),
        b2Vec2(1023.2f / 100.0, -20.2f / HD_PTM_RATIO)
    };
    [self createGroundEdgesWithVerts:verts
                            numVerts:num spriteFrameName:@"ground1.png"];
}

- (void)createGround2 {
    // Replace with your values from Vertex Helper, but replace all
    // instances of PTM_RATIO with 100.0
    int num = 24;
    b2Vec2 verts[] = {
        b2Vec2(-1022.0f / 100.0, -20.0f / HD_PTM_RATIO),
        b2Vec2(-963.0f / 100.0, -23.0f / HD_PTM_RATIO),
        b2Vec2(-902.0f / 100.0, -4.0f / HD_PTM_RATIO),
        b2Vec2(-762.0f / 100.0, -7.0f / HD_PTM_RATIO),
        b2Vec2(-674.0f / 100.0, 26.0f / HD_PTM_RATIO),
        b2Vec2(-435.0f / 100.0, 22.0f / HD_PTM_RATIO),
        b2Vec2(-258.0f / 100.0, -1.0f / HD_PTM_RATIO),
        b2Vec2(-242.0f / 100.0, 19.0f / HD_PTM_RATIO),
        b2Vec2(-170.0f / 100.0, 43.0f / HD_PTM_RATIO),
        b2Vec2(-58.0f / 100.0, 45.0f / HD_PTM_RATIO),
        b2Vec2(98.0f / 100.0, -20.0f / HD_PTM_RATIO),
        b2Vec2(472.0f / 100.0, -20.0f / HD_PTM_RATIO),
        b2Vec2(471.0f / 100.0, -7.0f / HD_PTM_RATIO),
        b2Vec2(503.0f / 100.0, 4.0f / HD_PTM_RATIO),
        b2Vec2(614.0f / 100.0, 66.0f / HD_PTM_RATIO),
        b2Vec2(679.0f / 100.0, 59.0f / HD_PTM_RATIO),
        b2Vec2(681.0f / 100.0, 46.0f / HD_PTM_RATIO),
        b2Vec2(735.0f / 100.0, 31.0f / HD_PTM_RATIO),
        b2Vec2(822.0f / 100.0, 24.0f / HD_PTM_RATIO),
        b2Vec2(827.0f / 100.0, 12.0f / HD_PTM_RATIO),
        b2Vec2(934.0f / 100.0, 14.0f / HD_PTM_RATIO),
        b2Vec2(975.0f / 100.0, 1.0f / HD_PTM_RATIO),
        b2Vec2(982.0f / 100.0, -19.0f / HD_PTM_RATIO),
        b2Vec2(1023.0f / 100.0, -20.0f / HD_PTM_RATIO)
    };
    [self createGroundEdgesWithVerts:verts numVerts:num
                     spriteFrameName:@"ground2.png"];
}

- (void)createGround3 {
    // Replace with your values from Vertex Helper, but replace all
    // instances of PTM_RATIO with 100.0
    int num = 2;
    b2Vec2 verts[] = {
        b2Vec2(-1021.0f / 100.0, -22.0f / HD_PTM_RATIO),
        b2Vec2(1021.0f / 100.0, -20.0f / HD_PTM_RATIO)
    };
    [self createGroundEdgesWithVerts:verts numVerts:num
                     spriteFrameName:@"ground3.png"];
}

- (void)createBridge {
    Box2DSprite *lastObject;
    b2Body *lastBody = groundBody;
    for(int i = 0; i < 15; i++) {
        Box2DSprite *plank =
        [Box2DSprite spriteWithSpriteFrameName:@"plank.png"];
        plank.gameObjectType = kGroundType;
        
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        bodyDef.position = b2Vec2(groundMaxX/PTM_RATIO + plank.contentSize.width/2/PTM_RATIO,
                                  80.0/100.0 - (plank.contentSize.height/2/PTM_RATIO));
        b2Body *plankBody = world->CreateBody(&bodyDef);
        plankBody->SetUserData(plank);
        plank.body = plankBody;
        [groundSpriteBatchNode addChild:plank];
        
        b2PolygonShape shape;
        float32 diff;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            diff = 40.0-plank.contentSize.height;
        } else {
            diff = 20.0-plank.contentSize.height;
        }
        
        shape.SetAsBox(plank.contentSize.width/2/PTM_RATIO, 40.0/100.0,
                       b2Vec2(0, -plank.contentSize.height/2/
                              PTM_RATIO-diff/PTM_RATIO), 0);
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &shape;
        fixtureDef.density = 2.0;
        plankBody->CreateFixture(&fixtureDef);
        
        b2RevoluteJointDef jd;
        jd.Initialize(lastBody, plankBody,
                      plankBody->GetWorldPoint(b2Vec2(-plank.contentSize.width/2/PTM_RATIO, 0)));
        jd.lowerAngle = CC_DEGREES_TO_RADIANS(-0.25);
        jd.upperAngle = CC_DEGREES_TO_RADIANS(0.25);
        jd.enableLimit = true;
        b2Joint *joint = world->CreateJoint(&jd);
        if (i == 0) { lastBridgeStartJoint = joint; }
        
        groundMaxX += (plank.contentSize.width * 0.8);
        lastBody = plankBody;
        lastObject = plank;
    }
    
    b2RevoluteJointDef jd;
    jd.Initialize(lastBody, groundBody,
                  lastBody->GetWorldPoint(
                                          b2Vec2(lastObject.contentSize.width/2/PTM_RATIO, 0)));
    lastBridgeEndJoint = world->CreateJoint(&jd);
}

- (void)createSpikesWithOffset:(int)offset {
    Spikes * spikes;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        spikes = [[[Spikes alloc] initWithWorld:world
                                     atLocation:ccp(groundMaxX + offset, 100)] autorelease];
    } else {
        spikes = [[[Spikes alloc] initWithWorld:world
                                     atLocation:ccp(groundMaxX + offset/2, 100/2)] autorelease];
    }
    [sceneSpriteBatchNode addChild:spikes];
}
    
- (void)createLevel {
    [self createBackground];
    [self createGround3];
    [self createSpikesWithOffset:-1200];
    [self createSpikesWithOffset:-400];
    [self createBridge];
    [self createGround1];
    [self createSpikesWithOffset:-1050];
    [self createSpikesWithOffset:-100];
    [self createBridge];
    [self createGround3];
    [self createSpikesWithOffset:-1700];
    [self createSpikesWithOffset:-900];
    [self createBridge];
    [self createGround2];
    [self createSpikesWithOffset:-1300];
    [self createSpikesWithOffset:-900];
    [self createGround3];
    [self createSpikesWithOffset:-1200];
    [self createSpikesWithOffset:-400];
    [self createBridge];
    [self createParticleSystem];
    [self createFinalBattleSensor];
    [self createGround3];
    [self createDigger];
    [self createGround3];
    [self createGround3];
    [self createOffscreenSensorBody];
}

- (void)followCart {
    if (actionStopped) return;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    float fixedPosition = winSize.width/4;
    float newX = fixedPosition - cart.position.x;
    
    newX = MIN(newX, fixedPosition);
    newX = MAX(newX, -groundMaxX-fixedPosition);
    
    CGPoint newPos = ccp(newX, self.position.y);
    [self setPosition:newPos];
}

-(void)gameOver:(id)sender {
    [[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

#pragma mark -
#pragma mark Debug drawing code

-(void) draw {
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    if (world) {
        world->DrawDebugData();
    }
    
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}

- (void)setupDebugDraw {
    debugDraw = new GLESDebugDraw(PTM_RATIO*
                                  [[CCDirector sharedDirector] contentScaleFactor]);
    world->SetDebugDraw(debugDraw);
    debugDraw->SetFlags(b2DebugDraw::e_shapeBit);
}

#pragma mark -
- (id)initWithScene4UILayer:(Scene4UILayer *)scene4UILayer {
    if ((self = [super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        uiLayer = scene4UILayer;
        
        [self setupWorld];
        [self setupDebugDraw];
        [[GameManager sharedGameManager]
         playBackgroundTrack:BACKGROUND_TRACK_MINECART];
        [self scheduleUpdate];
        [self createGround];
        
        self.isTouchEnabled = YES;
        self.isAccelerometerEnabled = YES;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [[CCSpriteFrameCache sharedSpriteFrameCache]
             addSpriteFramesWithFile:@"scene4atlas-hd.plist"];
            sceneSpriteBatchNode = [CCSpriteBatchNode
                                    batchNodeWithFile:@"scene4atlas-hd.png"];
            [self addChild:sceneSpriteBatchNode z:-1];
        } else {
            [[CCSpriteFrameCache sharedSpriteFrameCache]
             addSpriteFramesWithFile:@"scene4atlas.plist"];
            sceneSpriteBatchNode = [CCSpriteBatchNode
                                    batchNodeWithFile:@"scene4atlas.png"];
            [self addChild:sceneSpriteBatchNode z:-1];
        }
        
        [self createCartAtLocation:
         ccp(winSize.width/4, winSize.width*0.3)];
        [uiLayer displayText:@"Go!" andOnCompleteCallTarget:nil
                    selector:nil];
        
        //Create level background
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB5A1];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [[CCSpriteFrameCache sharedSpriteFrameCache]
             addSpriteFramesWithFile:@"groundAtlas-hd.plist"];
            groundSpriteBatchNode = [CCSpriteBatchNode
                                     batchNodeWithFile:@"groundAtlas-hd.png"];
        } else {
            [[CCSpriteFrameCache sharedSpriteFrameCache]
             addSpriteFramesWithFile:@"groundAtlas.plist"];
            groundSpriteBatchNode = [CCSpriteBatchNode
                                     batchNodeWithFile:@"groundAtlas.png"];
        }
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_Default];
        [self addChild:groundSpriteBatchNode z:-2];
        [self createLevel];
        
    }
    return self;
}

- (void)startFire {
    PLAYSOUNDEFFECT(FLAME_SOUND);
    [fireOnBridge resetSystem];
}

- (void)destroyBridge {
    [fireOnBridge stopSystem];
    world->DestroyJoint(lastBridgeStartJoint);
    lastBridgeStartJoint = NULL;
    world->DestroyJoint(lastBridgeEndJoint);
    lastBridgeEndJoint = NULL;
}

- (void)playRoar {
    PLAYSOUNDEFFECT(ENEMYDRILL_ROAR1);
}

- (void)backToAction {
    actionStopped = false;
    [self followCart];
}

#pragma mark -
#pragma mark Event Handlers
-(void)update:(ccTime)dt {
    static double UPDATE_INTERVAL = 1.0f/60.0f;
    static double MAX_CYCLES_PER_FRAME = 5;
    static double timeAccumulator = 0;
    
    timeAccumulator += dt;
    if (timeAccumulator > (MAX_CYCLES_PER_FRAME * UPDATE_INTERVAL)) {
        timeAccumulator = UPDATE_INTERVAL;
    }
    
    int32 velocityIterations = 3;
    int32 positionIterations = 2;
    while (timeAccumulator >= UPDATE_INTERVAL) {
        timeAccumulator -= UPDATE_INTERVAL;
        world->Step(UPDATE_INTERVAL,
                    velocityIterations, positionIterations);
    }
    
    for(b2Body *b=world->GetBodyList(); b!=NULL; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            Box2DSprite *sprite = (Box2DSprite *) b->GetUserData();
            sprite.position = ccp(b->GetPosition().x * PTM_RATIO,
                                  b->GetPosition().y * PTM_RATIO);
            sprite.rotation = CC_RADIANS_TO_DEGREES(b->GetAngle() * -1);
        }
    }
    
    CCArray *listOfGameObjects = [sceneSpriteBatchNode children];
    
    for (GameCharacter *tempChar in listOfGameObjects) {
        [tempChar updateStateWithDeltaTime:dt
                      andListOfGameObjects:listOfGameObjects];
    } 
    
    [self followCart];
    
    if (!gameOver) {
        if (isBodyCollidingWithObjectType(offscreenSensorBody, kCartType)) {
            gameOver = true;
            [uiLayer displayText:@"You Lose" andOnCompleteCallTarget:self 
                        selector:@selector(gameOver:)];
        } else if (isBodyCollidingWithObjectType(offscreenSensorBody, kDiggerType)) {
            gameOver = true;
            [uiLayer displayText:@"You Win!" andOnCompleteCallTarget:self 
                        selector:@selector(gameOver:)];
        }
    }
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    if (!inFinalBattle &&
        isBodyCollidingWithObjectType(finalBattleSensorBody, kCartType)) 
    {
        inFinalBattle = true;
        actionStopped = true;
        [cart setMotorSpeed:0];
        cart.body->SetLinearVelocity(b2Vec2(0, 0));
        [self runAction:
         [CCSequence actions:
          [CCDelayTime actionWithDuration:1.0],
          [CCMoveBy actionWithDuration:0.5
                              position:ccp(winSize.width * 0.6, 0)],
          [CCCallFunc actionWithTarget:self
                              selector:@selector(startFire)],
          [CCDelayTime actionWithDuration:2.0],
          [CCCallFunc actionWithTarget:self
                              selector:@selector(destroyBridge)],
          [CCDelayTime actionWithDuration:1.0],
          [CCMoveBy actionWithDuration:2.0
                              position:ccp(-1 * winSize.width * 1.3, 0)],
          [CCDelayTime actionWithDuration:1.0],
          [CCCallFunc actionWithTarget:self
                              selector:@selector(playRoar)],
          [CCDelayTime actionWithDuration:1.0],
          [CCMoveBy actionWithDuration:2.0
                              position:ccp(-1 * (winSize.width*6-winSize.width*0.7), 0)],
          [CCDelayTime actionWithDuration:1.0],
          [CCMoveBy actionWithDuration:2.0
                              position:ccp(winSize.width*6, 0)],
          [CCCallFunc actionWithTarget:self
                              selector:@selector(backToAction)],
          nil]]; 
    }
}

- (void)registerWithTouchDispatcher {
    [[CCTouchDispatcher sharedDispatcher]
     addTargetedDelegate:self priority:0 swallowsTouches:YES];
}


-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if (isBodyCollidingWithObjectType(cart.body, kGroundType) ||
        isBodyCollidingWithObjectType(groundBody, kCartType)) {
        [cart jump];
    }
    return TRUE;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer
        didAccelerate:(UIAcceleration *)acceleration 
{
    if (actionStopped) return;
    
    float32 maxRevsPerSecond = 7.0;
    float32 accelerationFraction = acceleration.y*6;
    
    if (accelerationFraction < -1) {
        accelerationFraction = -1;
    } else if (accelerationFraction > 1) {
        accelerationFraction = 1;
    }
    
    float32 motorSpeed = (M_PI*2) * maxRevsPerSecond * accelerationFraction;
    [cart setMotorSpeed:motorSpeed];
    
    if (abs(cart.body->GetLinearVelocity().x) < 5.0) {
        b2Vec2 impulse = b2Vec2(-1 * acceleration.y * cart.fullMass * 2, 0);
        cart.body->ApplyLinearImpulse(impulse,
                                      cart.body->GetWorldCenter());
    }
}

@end
