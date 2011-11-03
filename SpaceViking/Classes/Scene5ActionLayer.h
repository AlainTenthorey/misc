#import "cocos2d.h"

@class Scene5UILayer;

@interface Scene5ActionLayer : CCLayer {
    Scene5UILayer * uiLayer;
    double startTime;
}

- (id)initWithScene5UILayer:(Scene5UILayer *)scene5UILayer;

@end