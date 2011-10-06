//
//  RadarDish.h
//  SpaceViking
//
//  Created by Muhammad Naveed Siddiqui on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameCharacter.h"
#import <Foundation/Foundation.h>

@interface RadarDish : GameCharacter {
    CCAnimation *tiltingAnim;
    CCAnimation *transmittingAnim;
    CCAnimation *takingAHitAnim;
    CCAnimation *blowingUpAnim;
    GameCharacter *vikingCharacter;
}

@property (nonatomic, retain) CCAnimation *tiltingAnim;
@property (nonatomic, retain) CCAnimation *transmittingAnim;
@property (nonatomic, retain) CCAnimation *takingAHitAnim;
@property (nonatomic, retain) CCAnimation *blowingUpAnim;

@end
