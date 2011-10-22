//
//  GameScene.m
//  SpaceViking
//
//  Created by Rod on 3/2/11.
//  Copyright 2011 Prop Group LLC. All rights reserved.
//

#import "GameScene.h"


@implementation GameScene
-(id)init {
    self = [super init];
    if (self != nil) {
        // Background Layer
        BackgroundLayer *backgroundLayer = [BackgroundLayer node]; // 1
        [self addChild:backgroundLayer z:0];                       // 2
        // Gameplay Layer
        GameplayLayer *gameplayLayer = [GameplayLayer node];       // 3
        [self addChild:gameplayLayer z:5];                         // 4
    }
    return self;
}
@end
