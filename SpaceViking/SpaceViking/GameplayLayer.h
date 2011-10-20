//
//  GameplayLayer.h
//  SpaceViking
//
//  Created by Muhammad Naveed Siddiqui on 26/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLayer.h"
#import "cocos2d.h"
#import "SneakyJoystick.h" 
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyJoystickSkinnedBase.h"
#import "Constants.h"
#import "CommonProtocols.h"
#import "RadarDish.h"
#import "Viking.h"
#import "SpaceCargoShip.h"
#import "EnemyRobot.h"
#import "PhaserBullet.h"
#import "Mallet.h"
#import "Health.h"
#import "GameManager.h"
#import "SimpleAudioEngine.h"

@interface GameplayLayer : CCLayer {
    CCSprite *vikingSprite;
    SneakyJoystick *leftJoystick; 
    SneakyButton *jumpButton; 
    SneakyButton *attackButton;
    CCSpriteBatchNode *sceneSpriteBatchNode;
    SimpleAudioEngine *soundEngine;
}

@end
