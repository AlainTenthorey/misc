//
//  Digger.mm
//  SpaceViking
//
//  Created by Muhammad Naveed Siddiqui on 3/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Digger.h"

@implementation Digger

@synthesize wheelLSprite;
@synthesize wheelRSprite;

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
    
    wheelLSprite = [Box2DSprite
                    spriteWithSpriteFrameName:@"digger_wheel.png"];
    wheelLSprite.body = wheelLBody;
    wheelLBody->SetUserData(wheelLSprite);
    
    wheelRSprite = [Box2DSprite
                    spriteWithSpriteFrameName:@"digger_wheel.png"];
    wheelRSprite.body = wheelRBody;
    wheelRBody->SetUserData(wheelRSprite);
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
    }
    return self;
}

@end