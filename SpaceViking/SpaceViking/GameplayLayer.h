//
//  GameplayLayer.h
//  SpaceViking
//
//  Created by Muhammad Naveed Siddiqui on 26/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "SneakyJoystick.h" 
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyJoystickSkinnedBase.h"

@interface GameplayLayer : CCLayer {
    CCSprite *vikingSprite;
    SneakyJoystick *leftJoystick; 
    SneakyButton *jumpButton; 
    SneakyButton *attackButton;
}

@end
