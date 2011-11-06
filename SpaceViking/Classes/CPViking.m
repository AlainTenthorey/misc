#import "CPViking.h"

@implementation CPViking

- (id)initWithLocation:(CGPoint)location space:(cpSpace *)theSpace
            groundBody:(cpBody *)groundBody {
    if ((self = [super initWithSpriteFrameName:@"sv_anim_1.png"])) {
        CGSize size;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            size = CGSizeMake(60, 60);
            self.anchorPoint = ccp(0.5, 30/self.contentSize.height);
        } else {
            size = CGSizeMake(30, 30);
            self.anchorPoint = ccp(0.5, 15/self.contentSize.height);
        }
        
        [self addBoxBodyAndShapeWithLocation:location
                                        size:size space:theSpace mass:1.0 e:0.0 u:0.5
                               collisionType:0 canRotate:TRUE];
    }
    return self;
}
@end