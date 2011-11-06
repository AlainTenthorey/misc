#import "CPSprite.h"

@interface CPViking : CPSprite {
    cpArray *groundShapes;
    
    double jumpStartTime;
    float accelerationFraction;
}
@property (readonly) cpArray *groundShapes;

- (id)initWithLocation:(CGPoint)location space:(cpSpace *)space
            groundBody:(cpBody *)groundBody;
- (void)accelerometer:(UIAccelerometer*)accelerometer
        didAccelerate:(UIAcceleration*)acceleration;
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;

@end