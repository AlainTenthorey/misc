#import "FrozenOle.h"

@implementation FrozenOle

-(id) init {
    if((self = [super init])) {
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
                               spriteFrameByName:@"frozen_ole.png"]];
        gameObjectType = kFrozenVikingType;
    }
    return self;
}

- (BOOL)mouseJointBegan {
    return FALSE;
}

@end