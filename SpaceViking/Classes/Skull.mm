#import "Skull.h"
#import "SimpleAudioEngine.h"

@implementation Skull

-(id) init {
    if( (self=[super init]) ) {
        gameObjectType = kSkullType;
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
                               spriteFrameByName:@"skull.png"]];
    }
    return self;
}

- (void)shrinkDone:(id)sender {
    [self removeFromParentAndCleanup:YES];
}

-(void)changeState:(CharacterStates)newState {
    [self setCharacterState:newState];
    switch (newState) {
        case kStateDead:
        {
            CCLOG(@"Skull->Changing State to Dead");
            PLAYSOUNDEFFECT(PUZZLE_SKULL);
            body->GetWorld()->DestroyBody(body);
            body = NULL;
            CCScaleTo *growAction = [CCScaleTo actionWithDuration:0.1 scale:1.2];
            CCScaleTo *shrinkAction = [CCScaleTo actionWithDuration:0.1 scale:0.1];
            CCCallFuncN *doneAction = [CCCallFuncN actionWithTarget:self
                                                           selector:@selector(shrinkDone:)];
            CCSequence *sequence = [CCSequence actions:
                                    growAction, shrinkAction, doneAction, nil];
            [self runAction:sequence];
            break;
        } default:
            CCLOG(@"Unhandled state %d in Skull", newState);
        break; }
}

- (BOOL)mouseJointBegan {
    if (self.characterState == kStateDead) return FALSE;
    [self changeState:kStateDead];
    return FALSE;
}

@end
