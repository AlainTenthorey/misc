#import "Box2DSprite.h"

@interface Digger : Box2DSprite {
    b2Body *wheelLBody;
    b2Body *wheelRBody;
    b2RevoluteJoint *wheelLJoint;
    b2RevoluteJoint *wheelRJoint;
    
    b2Body *drillLBody;
    b2Body *drillRBody;
    b2Fixture *drillLFixture;
    b2Fixture *drillRFixture;
    
    //Box2DSprite *wheelLSprite;
    //Box2DSprite *wheelRSprite;
    
    double movingStartTime;
    CCAnimation *rotateAnim;
    CCAnimation *drillAnim;
}

//@property (assign) Box2DSprite *wheelLSprite;
//@property (assign) Box2DSprite *wheelRSprite;
- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location;

@end
