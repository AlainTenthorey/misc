#import "Box2DSprite.h"

@interface Spikes : Box2DSprite {
    b2World *world;
}

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location;

@end