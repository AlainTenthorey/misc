#import "Scene4ActionLayer.h"
#import "Box2DSprite.h"
#import "Scene4UILayer.h"
#import "Cart.h"
#import "SimpleQueryCallback.h"
#import "Box2DHelpers.h"

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

- (void)createLevel {
    [self createBackground];
    [self createGround3];
    [self createGround1];
    [self createGround3];
    [self createGround2];
    [self createGround3];
}

- (void)followCart {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    float fixedPosition = winSize.width/4;
    float newX = fixedPosition - cart.position.x;
    
    newX = MIN(newX, fixedPosition);
    newX = MAX(newX, -groundMaxX-fixedPosition);
    
    CGPoint newPos = ccp(newX, self.position.y);
    [self setPosition:newPos];
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

#pragma mark -
#pragma mark Event Handlers
-(void)update:(ccTime)dt {
    int32 velocityIterations = 3;
    int32 positionIterations = 2;
    world->Step(dt, velocityIterations, positionIterations);
    
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
        didAccelerate:(UIAcceleration *)acceleration {
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
