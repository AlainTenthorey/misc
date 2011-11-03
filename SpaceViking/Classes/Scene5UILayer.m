#import "Scene5UILayer.h"

@implementation Scene5UILayer

- (void)displaySecs:(double)secs {
    secs = MAX(0, secs);
    
    double intPart = 0;
    double fractPart = modf(secs, &intPart);
    int isecs = (int)intPart;
    int min = isecs / 60;
    int sec = isecs % 60;
    int hund = (int) (fractPart * 100);
    [label setString:[NSString stringWithFormat:@"%02d:%02d:%02d",
                      min, sec, hund]];
}

- (id)init {
    if ((self = [super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        float fontSize = 40.0;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            fontSize *= 2;
        }
        
        label = [CCLabelTTF labelWithString:@""
                                   fontName:@"AmericanTypewriter-Bold" fontSize:fontSize];
        label.anchorPoint = ccp(1, 1);
        label.position = ccp(winSize.width - 20, winSize.height - 20);
        [self addChild:label];
    }
    return self;
}
@end