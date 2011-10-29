#import "LongBlock.h"

@implementation LongBlock

-(id) init {
    if((self = [super init])) {
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
                               spriteFrameByName:@"long_block.png"]];
        gameObjectType = kLongBlockType;
    }
    return self;
}

- (BOOL)mouseJointBegan {
    return FALSE;
}

@end