//
//  GameCharacter.h
//  SpaceViking
//
//  Created by Muhammad Naveed Siddiqui on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"
#import <Foundation/Foundation.h>

@interface GameCharacter : GameObject {
    int characterHealth;
    CharacterStates characterState;
}

@property (readwrite) int characterHealth;
@property (readwrite) CharacterStates characterState;

-(void)checkAndClampSpritePosition;
-(int)getWeaponDamage;

@end
