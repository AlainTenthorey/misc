#import "CPSprite.h"

@interface CPViking : CPSprite {
}

- (id)initWithLocation:(CGPoint)location space:(cpSpace *)space
            groundBody:(cpBody *)groundBody;
@end