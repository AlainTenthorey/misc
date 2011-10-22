//  SpaceCargoShip.h
//  SpaceViking
//
#import <Foundation/Foundation.h>
#import "GameObject.h"

@interface SpaceCargoShip : GameObject {
    BOOL hasDroppedMallet;
    id <GameplayLayerDelegate> delegate;
    int soundNumberToPlay;
}
@property (nonatomic,assign) id <GameplayLayerDelegate> delegate;
@end
