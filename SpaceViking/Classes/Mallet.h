//  Mallet.h
//  SpaceViking
//
#import <Foundation/Foundation.h>
#import "GameObject.h"

@interface Mallet : GameObject {
    CCAnimation *malletAnim;
}
@property (nonatomic, retain) CCAnimation *malletAnim;
@end
