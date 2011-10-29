#import "Meteor.h"
#import "SimpleAudioEngine.h"

@implementation Meteor

-(id) init {
    if( (self=[super init]) ) {
        gameObjectType = kMeteorType;
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
                               spriteFrameByName:@"meteor.png"]];
    }
    return self;
}

- (BOOL)mouseJointBegan {
    PLAYSOUNDEFFECT(PUZZLE_METEOR);
    return TRUE;
}

@end