#import "IceBlock.h"

@implementation IceBlock

-(id) init {
    if((self = [super init])) {
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
                               spriteFrameByName:@"ice_block.png"]];
        gameObjectType = kIceType;
    }
    return self;
}

@end