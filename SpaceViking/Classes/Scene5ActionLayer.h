#import "cocos2d.h"
#import "chipmunk.h"
#import "cpMouse.h"

@class Scene5UILayer;
@class CPViking;

@interface Scene5ActionLayer : CCLayer {
    Scene5UILayer * uiLayer;
    double startTime;
    
    cpSpace *space;
    cpBody *groundBody;
    cpMouse *mouse;
    
    CPViking *viking;
    CCSpriteBatchNode *sceneSpriteBatchNode;
}

- (id)initWithScene5UILayer:(Scene5UILayer *)scene5UILayer;

@end