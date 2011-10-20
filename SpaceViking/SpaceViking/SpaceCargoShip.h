//
//  SpaceCargoShip.h
//  SpaceViking
//
//  Created by Muhammad Naveed Siddiqui on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"
#import <Foundation/Foundation.h>

@interface SpaceCargoShip : GameObject {
    BOOL hasDroppedMallet;
    id <GameplayLayerDelegate> delegate;
    int soundNumberToPlay;
}

@property (nonatomic,assign) id <GameplayLayerDelegate> delegate;

@end
