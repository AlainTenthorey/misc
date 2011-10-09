//
//  Health.h
//  SpaceViking
//
//  Created by Muhammad Naveed Siddiqui on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"
#import <Foundation/Foundation.h>

@interface Health : GameObject {
    CCAnimation *healthAnim;
}

@property (nonatomic, retain) CCAnimation *healthAnim;
@end
