#import "Digger.h"
#import "Cart.h"
#import "Box2DHelpers.h"

@implementation Digger

- (void)createBodyWithWorld:(b2World *)world
                 atLocation:(CGPoint)location {
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    b2Body *cartBody = world->CreateBody(&bodyDef);
    cartBody->SetUserData(self);
    self.body = cartBody;
    
    b2PolygonShape shape;
    int num = 4;
    b2Vec2 verts[] = {
        b2Vec2(87.0f / 100.0, -32.0f / 100.0),
        b2Vec2(81.0f / 100.0, 110.0f / 100.0),
        b2Vec2(-87.0f / 100.0, 112.0f / 100.0),
        b2Vec2(-84.0f / 100.0, -33.0f / 100.0)
    };
    shape.Set(verts, num);
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;
    fixtureDef.density = 0.5;
    fixtureDef.friction = 0.5;
    fixtureDef.restitution = 0.5;
    cartBody->CreateFixture(&fixtureDef);
    cartBody->SetAngularDamping(1000);
}

- (void)createWheelsWithWorld:(b2World *)world {
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;    
    
    bodyDef.position = body->GetWorldPoint(b2Vec2(-50.0/100.0, -80.0/100.0));
    wheelLBody = world->CreateBody(&bodyDef);
    
    bodyDef.position = body->GetWorldPoint(b2Vec2(50.0/100.0, -80.0/100.0));
    wheelRBody = world->CreateBody(&bodyDef);
    
    b2CircleShape circleShape;    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &circleShape;
    fixtureDef.friction = 0.2;
    fixtureDef.restitution = 0.5;
    fixtureDef.density = 5.0;
    
    circleShape.m_radius = 25.0/100.0;
    wheelLBody->CreateFixture(&fixtureDef);  
    circleShape.m_radius = 25.0/100.0;
    wheelRBody->CreateFixture(&fixtureDef);
    
    b2RevoluteJointDef revJointDef;
    revJointDef.Initialize(body, wheelLBody, 
                           wheelLBody->GetWorldCenter());
    revJointDef.enableMotor = true;
    revJointDef.motorSpeed = 0;
    revJointDef.maxMotorTorque = 1000;
    wheelLJoint = (b2RevoluteJoint *) world->CreateJoint(&revJointDef);
    revJointDef.Initialize(body, wheelRBody, 
                           wheelRBody->GetWorldCenter());
    wheelRJoint = (b2RevoluteJoint *) world->CreateJoint(&revJointDef);
}

- (void)createDrillWithWorld:(b2World *)world {
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = body->GetPosition();
    drillLBody = world->CreateBody(&bodyDef);
    drillRBody = world->CreateBody(&bodyDef);
    
    b2PolygonShape shape;
    int num = 3;
    b2Vec2 verts[] = {
        b2Vec2(-65.0f / 100.0, 31.0f / 100.0),
        b2Vec2(-189.0f / 100.0, -2.0f / 100.0),
        b2Vec2(-85.0f / 100.0, -72.0f / 100.0)
    };
    shape.Set(verts, num);
    
    b2FixtureDef fixtureDef;
    fixtureDef.density = 0.25;
    fixtureDef.shape = &shape;
    fixtureDef.isSensor = true;
    drillLFixture = drillLBody->CreateFixture(&fixtureDef);
    
    int num2 = 3;
    b2Vec2 verts2[] = {
        b2Vec2(85.0f / 100.0, -72.0f / 100.0),
        b2Vec2(189.0f / 100.0, -2.0f / 100.0),
        b2Vec2(65.0f / 100.0, 31.0f / 100.0),
    };
    shape.Set(verts2, num2);
    drillRFixture = drillRBody->CreateFixture(&fixtureDef);
    
    b2WeldJointDef weldJointDef;
    weldJointDef.Initialize(body, drillLBody, body->GetWorldCenter());
    world->CreateJoint(&weldJointDef);
    
    weldJointDef.Initialize(body, drillRBody, body->GetWorldCenter());
    world->CreateJoint(&weldJointDef);
}

-(void)initAnimations {
    rotateAnim = [self loadPlistForAnimationWithName:@"rotateAnim"
                                        andClassName:NSStringFromClass([self class])];
    [[CCAnimationCache sharedAnimationCache] addAnimation:rotateAnim
                                                     name:@"rotateAnim"];
    drillAnim = [self loadPlistForAnimationWithName:@"drillAnim"
                                       andClassName:NSStringFromClass([self class])];
    [[CCAnimationCache sharedAnimationCache] addAnimation:drillAnim
                                                     name:@"drillAnim"];
}

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location {
    if ((self = [super init])) {
        [self setDisplayFrame:
         [[CCSpriteFrameCache sharedSpriteFrameCache]
          spriteFrameByName:@"digger_anim5.png"]];
        gameObjectType = kDiggerType;
        characterHealth = 100.0f;
        [self createBodyWithWorld:world atLocation:location];
        [self createWheelsWithWorld:world];
        [self createDrillWithWorld:world];
        [self initAnimations];
    }
    return self;
}

- (void) updateStateWithDeltaTime:(ccTime)deltaTime
             andListOfGameObjects:(CCArray *)listOfGameObjects {
    if ((characterState == kStateTakingDamage) &&
        ([self numberOfRunningActions] > 0)) {
        return;
    }
    
    if (characterState == kStateDrilling &&
        [self numberOfRunningActions] == 0) {
        [self changeState:kStateRotating];
    }
    
    if (characterState == kStateTakingDamage &&
        [self numberOfRunningActions] == 0) {
        wheelLJoint->SetMotorSpeed(0);
        wheelRJoint->SetMotorSpeed(0);
        [self changeState:kStateRotating];
    }
    
    if (characterState != kStateWalking &&
        [self numberOfRunningActions] == 0) {
        [self changeState:kStateWalking];
    }
    
    if (characterState == kStateWalking) {
        Cart *cart = (Cart *)[[self parent] getChildByTag:kVikingSpriteTagValue];
        b2Body *cartBody = cart.body;
        
        double curTime = CACurrentMediaTime();
        double timeMoving = curTime - movingStartTime;
        static double TIME_TO_MOVE = 2.0f;
        
        b2Body * drill = drillLBody;
        float direction = -1.0;
        if ([self flipX]) {
            drill = drillRBody;
            direction = -1 * direction;
        }
        
        if (isBodyCollidingWithObjectType(drill, kCartType)) 
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"drill.caf"];
            [cart changeState:kStateTakingDamage];
            [self changeState:kStateDrilling];
            wheelLJoint->SetMotorSpeed(0);
            wheelRJoint->SetMotorSpeed(0);
            cartBody->ApplyLinearImpulse(b2Vec2(direction * cart.fullMass * 8, -1.0 * cart.fullMass),
                                         cartBody->GetWorldPoint(b2Vec2(0, -15.0/100.0)));
        }
        else if (isBodyCollidingWithObjectType(cartBody, kDiggerType)) 
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"collision.caf"];
            [self changeState:kStateTakingDamage];
            cartBody->ApplyLinearImpulse(b2Vec2(-direction * cart.fullMass * 8, -1.0 * cart.fullMass),
                                         cartBody->GetWorldPoint(b2Vec2(0, -15.0/100.0)));
            body->ApplyLinearImpulse(
                                     b2Vec2(direction * body->GetMass() * 10, 0),
                                     body->GetWorldPoint(b2Vec2(0, -5.0/100.0)));
        }
        else if (timeMoving > TIME_TO_MOVE) {
            wheelLJoint->SetMotorSpeed(0);
            wheelRJoint->SetMotorSpeed(0);
            [self changeState:kStateRotating];
        }
        else {
            wheelLJoint->SetMotorSpeed(-1 * direction * M_PI * 3);
            wheelRJoint->SetMotorSpeed(-1 * direction * M_PI * 3);
        }
    }
}

-(void)disableDrills {
    drillLFixture->SetSensor(true);
    drillRFixture->SetSensor(true);
}

-(void)enableDrills {
    if ([self flipX]) {
        drillRFixture->SetSensor(false);
    } else {
        drillLFixture->SetSensor(false);
    }
}

-(void)changeState:(CharacterStates)newState {
    if (characterState == newState) return;
    
    [self stopAllActions];
    id action = nil;
    [self setCharacterState:newState];
    
    switch (newState) {
        case kStateTakingDamage:
            action = [CCBlink actionWithDuration:1.0 blinks:3.0];
            break;
        case kStateDrilling:
            action = [CCRepeat actionWithAction:
                      [CCAnimate actionWithAnimation:drillAnim
                                restoreOriginalFrame:YES] times:3];
            break;
        case kStateWalking:
            movingStartTime = CACurrentMediaTime();
            break;
        case kStateRotating:
        {
            CCCallFunc *disableDrills =
            [CCCallFunc actionWithTarget:self
                                selector:@selector(disableDrills)];
            CCAnimate *rotToCenter =
            [CCAnimate actionWithAnimation:rotateAnim
                      restoreOriginalFrame:NO];
            CCFlipX *flip = [CCFlipX actionWithFlipX:!self.flipX];
            CCAnimate *rotToSide = (CCAnimate *) [rotToCenter reverse];
            CCCallFunc *enableDrills =
            [CCCallFunc actionWithTarget:self
                                selector:@selector(enableDrills)];
            
            action = [CCSequence actions:disableDrills, rotToCenter,
                      flip, rotToSide, enableDrills, nil];
            break; 
        }
        default:
            break;
    }
    
    if (action != nil) {
        [self runAction:action];
    } 
}
            
@end