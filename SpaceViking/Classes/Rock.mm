#import "Rock.h"
#import "SimpleAudioEngine.h"

@implementation Rock

-(id) init {
    if( (self=[super init]) ) {
        gameObjectType = kRockType;
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
                               spriteFrameByName:@"rock.png"]];
    }
    return self;
}

- (BOOL)mouseJointBegan {
    PLAYSOUNDEFFECT(PUZZLE_ROCK1);
    return TRUE;
}

@end