#import "Cart.h"

#define HD_PTM_RATIO 100.0

@implementation Cart

@synthesize wheelL;
@synthesize wheelR;
@synthesize wheelLBody;
@synthesize wheelRBody;

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
    
    body->CreateFixture(&fixtureDef);
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
    }
    return self;
}

@end