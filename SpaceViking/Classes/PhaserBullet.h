//  PhaserBullet.h
//  SpaceViking

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
