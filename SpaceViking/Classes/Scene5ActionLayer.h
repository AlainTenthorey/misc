#import "cocos2d.h"
#import "chipmunk.h"
#import "cpMouse.h"
#import "drawSpace.h"

@class Scene5UILayer;

@interface Scene5ActionLayer : CCLayer {
    Scene5UILayer * uiLayer;
    double startTime;
    
    cpSpace *space;
    cpBody *groundBody;
    cpMouse *mouse;
}

- (id)initWithScene5UILayer:(Scene5UILayer *)scene5UILayer;

@end