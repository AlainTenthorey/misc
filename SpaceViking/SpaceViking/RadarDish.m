//
//  RadarDish.m
//  SpaceViking
//
//  Created by Muhammad Naveed Siddiqui on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RadarDish.h"

@implementation RadarDish
@synthesize tiltingAnim;
@synthesize transmittingAnim;
@synthesize takingAHitAnim;
@synthesize blowingUpAnim;

- (void) dealloc{
    [tiltingAnim release];
    [transmittingAnim release];
    [takingAHitAnim release];
    [blowingUpAnim release];
    [super dealloc];
}

-(void)changeState:(CharacterStates)newState {
    [self stopAllActions];
    id action = nil;
    [self setCharacterState:newState];
    
    switch (newState) {
        case kStateSpawning:
            CCLOG(@"RadarDish->Starting the Spawning Animation");
            action = [CCAnimate actionWithAnimation:tiltingAnim
                      restoreOriginalFrame:NO];
            break;
        case kStateIdle:
            CCLOG(@"RadarDish->Changing State to Idle");
            action = [CCAnimate actionWithAnimation:transmittingAnim
                               restoreOriginalFrame:NO];
            break;
        case kStateTakingDamage:
            CCLOG(@"RadarDish->Changing State to TakingDamage");
            characterHealth -= [vikingCharacter getWeaponDamage];
            if (characterHealth <= 0.0f) {
                [self changeState:kStateDead];
            } else {
                PLAYSOUNDEFFECT(VIKING_HAMMERHIT1);
                action = [CCAnimate actionWithAnimation:takingAHitAnim
                                   restoreOriginalFrame:NO];
            } 
            break;
        case kStateDead:
            CCLOG(@"RadarDish->Changing State to Dead");
            action = [CCAnimate actionWithAnimation:blowingUpAnim
                               restoreOriginalFrame:NO];
            break;
        default:
            CCLOG(@"Unhandled state %d in RadarDish", newState);
            break;
    }
    
    if (action != nil) {
        [self runAction:action];
    }
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime
           andListOfGameObjects:(CCArray*)listOfGameObjects {
    if (characterState == kStateDead) return;
    
    vikingCharacter = (GameCharacter*)[[self parent]
                                       getChildByTag:kVikingSpriteTagValue];
    CGRect vikingBoudingBox = [vikingCharacter adjustedBoundingBox];
    CharacterStates vikingState = [vikingCharacter characterState];
    
    // Calculate if the Viking is attacking and nearby
    if ((vikingState == kStateAttacking) &&
        (CGRectIntersectsRect([self adjustedBoundingBox],vikingBoudingBox))) {
        
        if (characterState != kStateTakingDamage) {
            // If RadarDish is NOT already taking Damage
            [self changeState:kStateTakingDamage];
            return; 
        }
    }
    
    if (([self numberOfRunningActions] == 0) && (characterState != kStateDead)) {
        CCLOG(@"Going to Idle");
        [self changeState:kStateIdle];
        return; 
    }
}

-(void)initAnimations {
    [self setTiltingAnim: [self loadPlistForAnimationWithName:@"tiltingAnim"
                                                 andClassName:NSStringFromClass([self class])]];
    [self setTransmittingAnim: [self loadPlistForAnimationWithName:@"transmittingAnim"
                                                      andClassName:NSStringFromClass([self class])]];
    [self setTakingAHitAnim: [self loadPlistForAnimationWithName:@"takingAHitAnim"
                                                    andClassName:NSStringFromClass([self class])]];
    [self setBlowingUpAnim: [self loadPlistForAnimationWithName:@"blowingUpAnim"
                                                   andClassName:NSStringFromClass([self class])]];
}

-(id) init {
    if( (self=[super init]) ) {
        CCLOG(@"### RadarDish initialized");
        [self initAnimations];
        characterHealth = 100.0f;
        gameObjectType = kEnemyTypeRadarDish;
        [self changeState:kStateSpawning];
    }
    return self;
}

@end
