#import "cocos2d.h"

@interface Scene4UILayer : CCLayer {
    CCLabelTTF *label;
}

- (BOOL)displayText:(NSString *)text andOnCompleteCallTarget:(id)target 
           selector:(SEL)selector;

@end