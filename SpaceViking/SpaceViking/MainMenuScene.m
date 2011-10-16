//
//  MainMenuScene.m
//  SpaceViking
//
//  Created by Muhammad Naveed Siddiqui on 16/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.h"

@implementation MainMenuScene

-(id)init {
    if ((self = [super init])) {
        mainMenuLayer = [MainMenuLayer node];
        [self addChild:mainMenuLayer];
    }
    return self;
}

@end
