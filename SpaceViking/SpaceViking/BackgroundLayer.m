//
//  BackgroundLayer.m
//  SpaceViking
//
//  Created by Muhammad Naveed Siddiqui on 26/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer

- (id)init
{
    self = [super init];
    if (self != nil) {
        CCSprite *backgroundImage;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // Indicates game is running on iPad
            backgroundImage = [CCSprite spriteWithFile:@"background.png"];
        } else {
            backgroundImage = [CCSprite spriteWithFile:@"backgroundiPhone.png"];
        }
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        [backgroundImage setPosition: CGPointMake(screenSize.width/2, screenSize.height/2)];
        
        /* Wave Action on background image
         id wavesAction = [CCWaves actionWithWaves:5 amplitude:20
                                       horizontal:NO vertical:YES
                                             grid:ccg(15,10) duration:20];
        [backgroundImage runAction: [CCRepeatForever actionWithAction:wavesAction]]; */
        
        [self addChild:backgroundImage z:0 tag:0];
    }
    return self;
}

@end
