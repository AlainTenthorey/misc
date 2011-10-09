//
//  Mallet.h
//  SpaceViking
//
//  Created by Muhammad Naveed Siddiqui on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"
#import <Foundation/Foundation.h>

@interface Mallet : GameObject {
    CCAnimation *malletAnim;
}

@property (nonatomic, retain) CCAnimation *malletAnim;

@end
