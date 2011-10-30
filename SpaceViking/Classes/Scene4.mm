#import "Scene4.h"
#import "Scene4UILayer.h"
#import "Scene4ActionLayer.h"

@implementation Scene4

-(id)init {
    if ((self = [super init])) {
        Scene4UILayer * uiLayer = [Scene4UILayer node];
        [self addChild:uiLayer z:1];
        
        Scene4ActionLayer * actionLayer = [[[Scene4ActionLayer alloc] 
                                            initWithScene4UILayer:uiLayer] autorelease];
        [self addChild:actionLayer z:0];
    }
    return self;
}

@end