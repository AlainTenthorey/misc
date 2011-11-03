#import "Spikes.h"

@implementation Spikes

- (void)createBodyAtLocation:(CGPoint)location {
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = b2Vec2(location.x/PTM_RATIO,
                              location.y/PTM_RATIO);
    
    self.body = world->CreateBody(&bodyDef);
    body->SetUserData(self);
    
    b2PolygonShape shape;
    shape.SetAsBox(self.contentSize.width/2/PTM_RATIO,
                   self.contentSize.height/2/PTM_RATIO,
                   b2Vec2(0, +5.0/100.0), 0);
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;
    fixtureDef.density = 1000.0;
    
    body->CreateFixture(&fixtureDef);
}

- (id)initWithWorld:(b2World *)theWorld atLocation:(CGPoint)location {
    if ((self = [super init])) {
        world = theWorld;
        [self setDisplayFrame:[[CCSpriteFrameCache
                                sharedSpriteFrameCache] spriteFrameByName:@"spikes.png"]];
        gameObjectType = kSpikesType;
        [self createBodyAtLocation:location];
    }
    return self;
}

@end