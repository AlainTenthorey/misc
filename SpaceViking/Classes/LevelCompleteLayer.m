//
//  LevelCompleteLayer.m
//  SpaceViking
//
//  Created by Rod on 10/7/10.
//  Copyright 2010 Prop Group LLC - www.prop-group.com. All rights reserved.
//

#import "LevelCompleteLayer.h"
#import "GameState.h"
#import "GCHelper.h"
#import "SpaceVikingAppDelegate.h"

@implementation LevelCompleteLayer


-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	CCLOG(@"Touches received, returning to the Main Menu");
    if ([GameManager sharedGameManager].lastLevel == kGameLevel5) {
/*        GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
        if (leaderboardController != NULL)
        {
            leaderboardController.category = kLeaderboardEscape;
            leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
            leaderboardController.leaderboardDelegate = self;
            SpaceVikingAppDelegate *delegate = [UIApplication sharedApplication].delegate;
            [delegate.viewController presentModalViewController:leaderboardController
                                                       animated:YES];
        }*/
    } else {
        [[GameManager sharedGameManager] setHasPlayerDied:NO]; // Reset this for the next level
        [[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    SpaceVikingAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate.viewController dismissModalViewControllerAnimated: YES];
    [viewController release];
    
    [[GameManager sharedGameManager] setHasPlayerDied:NO];
    [[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

-(id)init {
	self = [super init];
	if (self != nil) {
		// Accept touch input
		self.isTouchEnabled = YES;
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
	
		// If Viking is dead, reset him and show the tombstone,
		// Any touch gets you back to the main menu
		BOOL didPlayerDie = [[GameManager sharedGameManager] hasPlayerDied];
		CCSprite *background = nil;
		if (didPlayerDie) {
			background = [CCSprite spriteWithFile:@"LevelCompleteDead.png"];
		} else {
			background = [CCSprite spriteWithFile:@"LevelCompleteAlive.png"];
		}
		
		[background setPosition:ccp(screenSize.width/2, screenSize.height/2)];
		[self addChild:background];
		
		
		// Add the text for level complete.
		CCLabelBMFont *levelLabelText = [CCLabelBMFont labelWithString:@"Level Complete" fntFile:@"VikingSpeechFont64.fnt"];
		[levelLabelText setPosition:ccp(screenSize.width/2, screenSize.height * 0.9f)];
		[self addChild:levelLabelText];
		
		// Add achievement tracking
        /*
        CCLabelBMFont *achievementLabelText = [CCLabelBMFont
                                               bitmapFontAtlasWithString:@"" 
                                               fntFile:@"VikingSpeechFont64.fnt"];
        [achievementLabelText setPosition:
         ccp(screenSize.width/2, screenSize.height * 0.7f)];
        [self addChild:achievementLabelText];
        if ([GameManager sharedGameManager].lastLevel == kGameLevel1 &&
            ![GameManager sharedGameManager].hasPlayerDied) {
            CCLOG(@"Finished level 1");
            if (![GameState sharedInstance].completedLevel1) {
                [GameState sharedInstance].completedLevel1 = true;
                [[GameState sharedInstance] save];
                [[GCHelper sharedInstance] reportAchievement:kAchievementLevel1
                                             percentComplete:100.0];
                achievementLabelText.string = @"Achievement Unlocked: Simple Gamer!";
            }
        } else if ([GameManager sharedGameManager].lastLevel == kGameLevel2 &&
                   ![GameManager sharedGameManager].hasPlayerDied) {
            CCLOG(@"Finished level 2");
            if (![GameState sharedInstance].completedLevel2) {
                [GameState sharedInstance].completedLevel2 = true;
                [[GameState sharedInstance] save];
                [[GCHelper sharedInstance] reportAchievement:kAchievementLevel2
                                             percentComplete:100.0];
                achievementLabelText.string = @"Achievement Unlocked: Side Scroller!";
            }
        } else if ([GameManager sharedGameManager].lastLevel == kGameLevel3 &&
                   ![GameManager sharedGameManager].hasPlayerDied) {
            CCLOG(@"Finished level 3");
            if (![GameState sharedInstance].completedLevel3) {
                [GameState sharedInstance].completedLevel3 = true;
                [[GameState sharedInstance] save];
                [[GCHelper sharedInstance] reportAchievement:kAchievementLevel3
                                             percentComplete:100.0];
                achievementLabelText.string = @"Achievement Unlocked: Physics Puzzler!";
            }
        } else if ([GameManager sharedGameManager].lastLevel == kGameLevel4 &&
                   ![GameManager sharedGameManager].hasPlayerDied) {
            CCLOG(@"Finished level 4");
            if (![GameState sharedInstance].completedLevel4) {
                [GameState sharedInstance].completedLevel4 = true;
                [[GameState sharedInstance] save];
                [[GCHelper sharedInstance] reportAchievement:kAchievementLevel4
                                             percentComplete:100.0];
                achievementLabelText.string = @"Achievement Unlocked: Box2D Master!";
            }
        } else if ([GameManager sharedGameManager].lastLevel == kGameLevel5 &&
                   ![GameManager sharedGameManager].hasPlayerDied) {
            CCLOG(@"Finished level 5");
            if (![GameState sharedInstance].completedLevel5) {
                [GameState sharedInstance].completedLevel5 = true;
                [[GameState sharedInstance] save];
                [[GCHelper sharedInstance] reportAchievement:kAchievementLevel5
                                             percentComplete:100.0];
                achievementLabelText.string =  @"Achievement Unlocked: Chipmunk Master!";
            }
        } else if ([GameManager sharedGameManager].lastLevel == kGameLevel4 &&
                   [GameManager sharedGameManager].hasPlayerDied) {
            CCLOG(@"Died on level 4. Fell %d times...", [GameState
                                                         sharedInstance].timesFell);
            int maxTimesToFall = 3;
            if ([GameState sharedInstance].timesFell < maxTimesToFall) {
                [GameState sharedInstance].timesFell++;
                [[GameState sharedInstance] save];
                double pctComplete = ((double)
                                      [GameState sharedInstance].timesFell /
                                      (int)maxTimesToFall) * 100.0;
                [[GCHelper sharedInstance] reportAchievement:kAchievementBadDream
                                             percentComplete:pctComplete];
                if ([GameState sharedInstance].timesFell >= maxTimesToFall) {
                    achievementLabelText.string = @"Achievement Unlocked: Bad Dream!";
                }
            }
        }*/
	}
	return self;
}
@end
