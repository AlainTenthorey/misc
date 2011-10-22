//  Health.h
//  SpaceViking
//
#import <Foundation/Foundation.h>
#import "GameObject.h"

@interface Health : GameObject {
    CCAnimation *healthAnim;
}
@property (nonatomic, retain) CCAnimation *healthAnim;
@end
