#import "Box2DSprite.h"

@interface Cart : Box2DSprite {
    b2World *world;
    
    Box2DSprite *wheelL;
    Box2DSprite *wheelR;
    b2Body *wheelLBody;
    b2Body *wheelRBody;
    b2RevoluteJoint *wheelLJoint;
    b2RevoluteJoint *wheelRJoint;
    
    Box2DSprite * legs;
    Box2DSprite * trunk;
    Box2DSprite * head;
    Box2DSprite * helm;
    Box2DSprite * arm;
    b2Body * legsBody;
    b2Body * trunkBody;
    b2Body * headBody;
    b2Body * helmBody;
    b2Body * armBody;
}
@property (readonly) b2Body * wheelLBody;
@property (readonly) b2Body * wheelRBody;
@property (readonly) Box2DSprite * wheelL;
@property (readonly) Box2DSprite * wheelR;
@property (readonly) Box2DSprite * legs;
@property (readonly) Box2DSprite * trunk;
@property (readonly) Box2DSprite * head;
@property (readonly) Box2DSprite * helm;
@property (readonly) Box2DSprite * arm;

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location;
- (void)setMotorSpeed:(float32)motorSpeed;
- (void)jump;
- (float32)fullMass;

@end