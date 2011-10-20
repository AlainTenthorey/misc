//
//  GameManager.h
//  SpaceViking
//
//  Created by Muhammad Naveed Siddiqui on 15/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "SimpleAudioEngine.h"

@interface GameManager : NSObject {
    BOOL isMusicON;
    BOOL isSoundEffectsON;
    BOOL hasPlayerDied;
    SceneTypes currentScene;
    
    // Added for audio
    BOOL hasAudioBeenInitialized;
    GameManagerSoundState managerSoundState;
    SimpleAudioEngine *soundEngine;
    NSMutableDictionary *listOfSoundEffectFiles;
    NSMutableDictionary *soundEffectsState;
}

@property (readwrite) BOOL isMusicON;
@property (readwrite) BOOL isSoundEffectsON;
@property (readwrite) BOOL hasPlayerDied;
@property (readwrite) GameManagerSoundState managerSoundState; 
@property (nonatomic, retain) NSMutableDictionary *listOfSoundEffectFiles;
@property (nonatomic, retain) NSMutableDictionary *soundEffectsState;

+(GameManager*)sharedGameManager;
-(void)runSceneWithID:(SceneTypes)sceneID;
-(void)openSiteWithLinkType:(LinkTypes)linkTypeToOpen ;
-(void)setupAudioEngine; 
-(ALuint)playSoundEffect:(NSString*)soundEffectKey; 
-(void)stopSoundEffect:(ALuint)soundEffectID; 
-(void)playBackgroundTrack:(NSString*)trackFileName;

@end
