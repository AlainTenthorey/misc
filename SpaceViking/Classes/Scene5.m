#import "Scene5.h"
#import "Scene5UILayer.h"
#import "Scene5ActionLayer.h"

@implementation Scene5

-(id)init {
    if ((self = [super init])) {
        Scene5UILayer * uiLayer = [Scene5UILayer node];
        [self addChild:uiLayer z:1];
        
        Scene5ActionLayer * actionLayer = [[[Scene5ActionLayer alloc]
                                            initWithScene5UILayer:uiLayer] autorelease];
        [self addChild:actionLayer z:0];
    }
    return self;
}

@end