//
//  PhaserBullet.h
//  SpaceViking
//
//  Created by Muhammad Naveed Siddiqui on 9/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameCharacter.h"

@interface PhaserBullet : GameCharacter {
    CCAnimation *firingAnim;
    CCAnimation *travelingAnim;
    PhaserDirection myDirection;
}

@property PhaserDirection myDirection;
@property (nonatomic,retain) CCAnimation *firingAnim;
@property (nonatomic,retain) CCAnimation *travelingAnim;

@end
