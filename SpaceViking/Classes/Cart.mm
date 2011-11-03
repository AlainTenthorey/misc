#import "Cart.h"
#import "Box2DHelpers.h"

#define HD_PTM_RATIO 100.0

@implementation Cart

@synthesize wheelL;
@synthesize wheelR;
@synthesize wheelLBody;
@synthesize wheelRBody;
@synthesize legs;
@synthesize trunk;
@synthesize head;
@synthesize helm;
@synthesize arm;

- (b2Body *)createWheelWithSprite:(Box2DSprite*)sprite
                           offset:(b2Vec2)offset {
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = body->GetWorldPoint(offset);
    b2Body * wheelBody = world->CreateBody(&bodyDef);
    wheelBody->SetUserData(sprite);
    sprite.body = wheelBody;
    
    b2CircleShape circleShape;
    circleShape.m_radius = sprite.contentSize.width/2/PTM_RATIO;
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &circleShape;
    fixtureDef.friction = 1.0;
    fixtureDef.restitution = 0.2;
    fixtureDef.density = 10.0;
    fixtureDef.filter.categoryBits = 0x2;
    fixtureDef.filter.maskBits = 0xFFFF;
    fixtureDef.filter.groupIndex = -1;
    wheelBody->CreateFixture(&fixtureDef);
    
    return wheelBody;
}

- (void)createWheels {
    wheelL = [Box2DSprite spriteWithSpriteFrameName:@"Wheel.png"];
    wheelL.gameObjectType = kCartType;
    wheelLBody = [self createWheelWithSprite:wheelL
                                      offset:b2Vec2(-63.0/HD_PTM_RATIO, -48.0/HD_PTM_RATIO)];
    
    wheelR = [Box2DSprite spriteWithSpriteFrameName:@"Wheel.png"];
    wheelR.gameObjectType = kCartType;
    wheelRBody = [self createWheelWithSprite:wheelR
                                      offset:b2Vec2(63.0/HD_PTM_RATIO, -48.0/HD_PTM_RATIO)];
    
    b2RevoluteJointDef revJointDef;
    revJointDef.Initialize(body, wheelLBody, wheelLBody->GetWorldCenter());
    revJointDef.enableMotor = true;
    revJointDef.maxMotorTorque = 1000;
    revJointDef.motorSpeed = 0;
    wheelLJoint = (b2RevoluteJoint *) world->CreateJoint(&revJointDef);
    
    revJointDef.Initialize(body, wheelRBody, wheelRBody->GetWorldCenter());
    wheelRJoint = (b2RevoluteJoint *) world->CreateJoint(&revJointDef);
}

- (void)setMotorSpeed:(float32)motorSpeed {
    if (characterState != kStateTakingDamage) {
        wheelLJoint->SetMotorSpeed(motorSpeed);
        wheelRJoint->SetMotorSpeed(motorSpeed);
    } else {
        wheelLJoint->SetMotorSpeed(0.2 * motorSpeed);
        wheelRJoint->SetMotorSpeed(0.2 * motorSpeed);
    } 
}

- (void)createBodyAtLocation:(CGPoint)location {
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    body = world->CreateBody(&bodyDef);
    body->SetUserData(self);
    
    b2FixtureDef fixtureDef;
    b2PolygonShape shape;
    //shape.SetAsBox(self.contentSize.width/2/PTM_RATIO,
    //               self.contentSize.height/2/PTM_RATIO);
    int num = 4;
    b2Vec2 verts[] = {
        b2Vec2(77.5f / HD_PTM_RATIO, 37.0f / HD_PTM_RATIO),
        b2Vec2(-78.5f / HD_PTM_RATIO, 38.0f / HD_PTM_RATIO),
        b2Vec2(-60.5f / HD_PTM_RATIO, -37.0f / HD_PTM_RATIO),
        b2Vec2(56.5f / HD_PTM_RATIO, -38.0f / HD_PTM_RATIO)
    };
    shape.Set(verts, num);
    
    fixtureDef.shape = &shape;
    fixtureDef.density = 1.0;
    fixtureDef.friction = 0.5;
    fixtureDef.restitution = 0.5;
    fixtureDef.filter.categoryBits = 0x2;
    fixtureDef.filter.maskBits = 0xFFFF;
    fixtureDef.filter.groupIndex = -1;
    body->CreateFixture(&fixtureDef);
    
    //Add sensor to bottom of cart
    b2PolygonShape sensorShape;
    sensorShape.SetAsBox(self.contentSize.width/2/PTM_RATIO, self.contentSize.
                         height/2/PTM_RATIO,
                         b2Vec2(0, -self.contentSize.height/PTM_RATIO), 0);
    fixtureDef.shape = &sensorShape;
    fixtureDef.density = 0.0;
    fixtureDef.isSensor = true;
    body->CreateFixture(&fixtureDef);
}

-(b2Body *)createPartAtLocation:(b2Vec2)location
                     withSprite:(Box2DSprite *)sprite {
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = location;
    bodyDef.angle = body->GetAngle();
    
    b2Body *retval = world->CreateBody(&bodyDef);
    retval->SetUserData(sprite);
    sprite.body = retval;
    
    b2PolygonShape shape;
    shape.SetAsBox(sprite.contentSize.width/2/PTM_RATIO,
                   sprite.contentSize.height/2/PTM_RATIO);
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;
    fixtureDef.density = 0.05;
    fixtureDef.filter.categoryBits = 0x2;
    fixtureDef.filter.maskBits = 0xFFFF;
    fixtureDef.filter.groupIndex = -1;
    
    retval->CreateFixture(&fixtureDef);
    return retval;
}

-(void)createOle {
    //Creating the parts
    legs = [Box2DSprite spriteWithSpriteFrameName:@"OleCartLegs.png"];
    legs.gameObjectType = kCartType;
    legsBody = [self createPartAtLocation:
                body->GetWorldPoint(b2Vec2(-10.0/HD_PTM_RATIO, 6.0/HD_PTM_RATIO))
                               withSprite:legs];
    
    trunk = [Box2DSprite spriteWithSpriteFrameName:@"OleCartBody.png"];
    trunk.gameObjectType = kCartType;
    trunkBody = [self createPartAtLocation:
                 legsBody->GetWorldPoint(b2Vec2(0, 45.0/HD_PTM_RATIO))
                                withSprite:trunk];
    
    head = [Box2DSprite spriteWithSpriteFrameName:@"OleCartHead.png"];
    head.gameObjectType = kCartType;
    headBody = [self createPartAtLocation:
                trunkBody->GetWorldPoint(b2Vec2(18.0/HD_PTM_RATIO, 24.0/HD_PTM_RATIO)) 
                               withSprite:head];
    
    helm = [Box2DSprite
            spriteWithSpriteFrameName:@"OleCartHelmet.png"];
    helm.gameObjectType = kCartType;
    helmBody = [self createPartAtLocation:
                headBody->GetWorldPoint(b2Vec2(15.0/HD_PTM_RATIO, 25.0/HD_PTM_RATIO))
                               withSprite:helm];
    
    arm = [Box2DSprite spriteWithSpriteFrameName:@"OleCartArm.png"];
    arm.gameObjectType = kCartType;
    armBody = [self createPartAtLocation:
               trunkBody->GetWorldPoint(b2Vec2(5.0/HD_PTM_RATIO, -15.0/HD_PTM_RATIO)) 
                              withSprite:arm];
    
    //Creating the joints
    b2Transform axisTransform;
    axisTransform.Set(b2Vec2(0, 0), body->GetAngle());
    b2Vec2 axis = b2Mul(axisTransform.R, b2Vec2(0,1));
    
    b2PrismaticJointDef prisJointDef;
    prisJointDef.Initialize(body, legsBody,
                            legsBody->GetWorldCenter(), axis);
    prisJointDef.enableLimit = true;
    prisJointDef.lowerTranslation = 0.0;
    prisJointDef.upperTranslation = 43.0/HD_PTM_RATIO;
    world->CreateJoint(&prisJointDef);
    
    b2RevoluteJointDef revJointDef;
    revJointDef.Initialize(legsBody, trunkBody,
                           legsBody->GetWorldPoint(b2Vec2(0, 20.0/HD_PTM_RATIO)));
    revJointDef.lowerAngle = CC_DEGREES_TO_RADIANS(-15);
    revJointDef.upperAngle = CC_DEGREES_TO_RADIANS(15);
    revJointDef.enableLimit = true;
    revJointDef.enableMotor = true;
    revJointDef.motorSpeed = 0.5;
    revJointDef.maxMotorTorque = 50.0;
    world->CreateJoint(&revJointDef);
    revJointDef.enableMotor = false;
    
    revJointDef.Initialize(trunkBody, armBody,
                           armBody->GetWorldPoint(b2Vec2(-9.0/HD_PTM_RATIO, 29.0/HD_PTM_RATIO)));
    revJointDef.lowerAngle = CC_DEGREES_TO_RADIANS(-30);
    revJointDef.upperAngle = CC_DEGREES_TO_RADIANS(60);
    revJointDef.enableLimit = true;
    world->CreateJoint(&revJointDef);
    
    revJointDef.Initialize(trunkBody, headBody,
                           headBody->GetWorldPoint(b2Vec2(-12.0/HD_PTM_RATIO, -9.0/HD_PTM_RATIO)));
    revJointDef.lowerAngle = CC_DEGREES_TO_RADIANS(-5);
    revJointDef.upperAngle = CC_DEGREES_TO_RADIANS(5);
    revJointDef.enableLimit = true;
    world->CreateJoint(&revJointDef);
    
    prisJointDef.Initialize(headBody, helmBody,
                            helmBody->GetWorldCenter(), axis);
    prisJointDef.enableLimit = true;
    prisJointDef.lowerTranslation = 0.0/HD_PTM_RATIO;
    prisJointDef.upperTranslation = 5.0/HD_PTM_RATIO;
    world->CreateJoint(&prisJointDef);
}

- (id)initWithWorld:(b2World *)theWorld atLocation:(CGPoint)location {
    if ((self = [super init])) {
        world = theWorld;
        [self setDisplayFrame:[[CCSpriteFrameCache
                                sharedSpriteFrameCache] spriteFrameByName:@"Cart.png"]];
        gameObjectType = kCartType;
        characterHealth = 100.0f;
        [self createBodyAtLocation:location];
        [self createWheels];
        [self createOle];
    }
    return self;
}

- (void)playJumpEffect {
    int soundToPlay = random() % 4;
    if (soundToPlay == 0) {
        PLAYSOUNDEFFECT(VIKING_JUMPING_1);
    } else if (soundToPlay == 1) {
        PLAYSOUNDEFFECT(VIKING_JUMPING_2);
    } else if (soundToPlay == 2) {
        PLAYSOUNDEFFECT(VIKING_JUMPING_3);
    } else {
        PLAYSOUNDEFFECT(VIKING_JUMPING_4);
    }
}

- (void)playHitEffect {
    int soundToPlay = random() % 5;
    if (soundToPlay == 0) {
        PLAYSOUNDEFFECT(VIKING_HIT_1);
    } else if (soundToPlay == 1) {
        PLAYSOUNDEFFECT(VIKING_HIT_2);
    } else if (soundToPlay == 2) {
        PLAYSOUNDEFFECT(VIKING_HIT_3);
    } else if (soundToPlay == 3) {
        PLAYSOUNDEFFECT(VIKING_HIT_4);
    } else {
        PLAYSOUNDEFFECT(VIKING_HIT_5);
    } 
}

-(void)changeState:(CharacterStates)newState {
    if (characterState == newState) return;
    [self stopAllActions];
    [self setCharacterState:newState];
    switch (newState) {
        case kStateTakingDamage: {
            [self playHitEffect];
            characterHealth = characterHealth - 10;
            CCAction *blink = [CCBlink actionWithDuration:1.0
                                                   blinks:3.0];
            [self runAction:blink];
            [wheelL runAction:[blink copy]];
            [wheelR runAction:[blink copy]];
            [legs runAction:[blink copy]];
            [trunk runAction:[blink copy]];
            [head runAction:[blink copy]];
            [helm runAction:[blink copy]];
            [arm runAction:[blink copy]];
            break;
        } default:
            break; 
    }
}

- (void) updateStateWithDeltaTime:(ccTime)deltaTime
             andListOfGameObjects:(CCArray *)listOfGameObjects {
    float32 minAngle = CC_DEGREES_TO_RADIANS(-20);
    float32 maxAngle = CC_DEGREES_TO_RADIANS(20);
    double desiredAngle = self.body->GetAngle();
    
    if (self.body->GetAngle() > maxAngle) {
        desiredAngle = maxAngle;
    } else if (self.body->GetAngle() < minAngle) {
        desiredAngle = minAngle;
    }
    
    float32 diff = desiredAngle - self.body->GetAngle();
    if (diff != 0) {
        body->SetAngularVelocity(0);
        float32 diff = desiredAngle - self.body->GetAngle();
        float angimp = self.body->GetInertia() * diff;
        self.body->ApplyAngularImpulse(angimp * 2);
    } 
    
    if (characterState == kStateDead)
        return; // Nothing to do if the Viking is dead
    
    if ((characterState == kStateTakingDamage) &&
        ([self numberOfRunningActions] > 0))
        return; // Currently playing the taking damage animation
    
    if ([self numberOfRunningActions] == 0) {
        // Not playing an animation
        if (characterHealth <= 0) {
            [self changeState:kStateDead];
        } else {
            [self changeState:kStateIdle];
        }
    }
    
    if (isBodyCollidingWithObjectType(wheelLBody, kSpikesType)) {
        [self changeState:kStateTakingDamage];
    } else if (isBodyCollidingWithObjectType(wheelRBody, kSpikesType)) {
        [self changeState:kStateTakingDamage];
    }
}

- (float32)fullMass {
    return body->GetMass() + wheelLBody->GetMass() + wheelRBody->GetMass();
}

- (void)jump {
    [self playJumpEffect];
    b2Vec2 impulse = b2Vec2([self fullMass]*1.0, [self fullMass]*5.0);
    b2Vec2 impulsePoint = body->GetWorldPoint(b2Vec2(5.0/HD_PTM_RATIO, -15.0/HD_PTM_RATIO));
    body->ApplyLinearImpulse(impulse, impulsePoint);
}

@end