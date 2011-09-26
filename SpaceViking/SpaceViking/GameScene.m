//
//  GameScene.m
//  SpaceViking
//
//  Created by Muhammad Naveed Siddiqui on 26/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

- (id)init
{
    self = [super init];
    if (self) {
        // Background Layer
        BackgroundLayer *backgroundLayer = [BackgroundLayer node];
        [self addChild:backgroundLayer z:0];
        
        // Gameplay Layer
        GameplayLayer *gameplayLayer = [GameplayLayer node];
        [self addChild:gameplayLayer z:5];
    }
    return self;
}

@end
