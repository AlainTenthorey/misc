//  BackgroundLayer.m
//  SpaceViking
#import "BackgroundLayer.h"

@implementation BackgroundLayer
-(id)init { 
    self = [super init];                                           // 1
    if (self != nil) {                                             // 2
        CCSprite *backgroundImage;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) { // 3
            // Indicates game is running on iPad
            backgroundImage = [CCSprite spriteWithFile:@"background.png"];
        } else {
            backgroundImage = [CCSprite spriteWithFile:@"backgroundiPhone.png"];
        }
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize]; // 4
        [backgroundImage setPosition:
         CGPointMake(screenSize.width/2, screenSize.height/2)]; // 5
        
        [self addChild:backgroundImage z:0 tag:0];                 // 6
        
    }
    return self;                                                   // 7
    
}
@end
