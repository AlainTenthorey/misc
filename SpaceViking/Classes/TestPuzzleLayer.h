#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "Constants.h"

@interface TestPuzzleLayer : CCLayer {
    b2World * world;
    b2Body *groundBody;
    GLESDebugDraw * debugDraw;
    b2MouseJoint *mouseJoint;
}

+ (id)scene;

@end