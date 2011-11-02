#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "Constants.h"

@class Scene4UILayer;
@class Cart;

@interface Scene4ActionLayer : CCLayer {
    b2World * world;
    GLESDebugDraw * debugDraw;
    
    CCSpriteBatchNode * sceneSpriteBatchNode;
    b2Body * groundBody;
    b2MouseJoint * mouseJoint;
    Cart * cart;
    Scene4UILayer * uiLayer;
    
    CCSpriteBatchNode * groundSpriteBatchNode;
    float32 groundMaxX;
}

- (id)initWithScene4UILayer:(Scene4UILayer *)scene4UILayer;

@end