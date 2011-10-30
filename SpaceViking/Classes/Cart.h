#import "Box2DSprite.h"

@interface Cart : Box2DSprite {
    b2World *world;
    
    Box2DSprite *wheelL;
    Box2DSprite *wheelR;
    b2Body *wheelLBody;
    b2Body *wheelRBody;
    b2RevoluteJoint *wheelLJoint;
    b2RevoluteJoint *wheelRJoint;
}
@property (readonly) b2Body * wheelLBody;
@property (readonly) b2Body * wheelRBody;
@property (readonly) Box2DSprite * wheelL;
@property (readonly) Box2DSprite * wheelR;

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location;

@end