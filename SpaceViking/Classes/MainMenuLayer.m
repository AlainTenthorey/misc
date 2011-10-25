//  MainMenuLayer.m
//  SpaceViking
//
#import "MainMenuLayer.h"
@interface MainMenuLayer() 
-(void)displayMainMenu;
-(void)displaySceneSelection;
@end

@implementation MainMenuLayer
-(void)buyBook {
    [[GameManager sharedGameManager]
     openSiteWithLinkType:kLinkTypeBookSite];
}

-(void)showOptions {
    CCLOG(@"Show the Options screen");
    [[GameManager sharedGameManager] runSceneWithID:kOptionsScene];
}

-(void)playScene:(CCMenuItemFont*)itemPassedIn {
    if ([itemPassedIn tag] == 1) {
        CCLOG(@"Tag 1 found, Scene 1");
        [[GameManager sharedGameManager] runSceneWithID:kIntroScene];
    } else if ([itemPassedIn tag] == 2) {
        [[GameManager sharedGameManager] runSceneWithID:kCutSceneForLevel2];
        //[[GameManager sharedGameManager] runSceneWithID:kGameLevel2];
    } else if ([itemPassedIn tag] == 3) {
        [[GameManager sharedGameManager] runSceneWithID:kGameLevel3];
    } else if ([itemPassedIn tag] == 4) {
        [[GameManager sharedGameManager] runSceneWithID:kGameLevel4];
    } else if ([itemPassedIn tag] == 5) {
        [[GameManager sharedGameManager] runSceneWithID:kGameLevel5];
    } else {
        CCLOG(@"Unexpected item.  Tag was: %d", [itemPassedIn tag]);
    }
}

-(void)playChorus {
    int soundToPlay = random() % 2;
    if (soundToPlay == 0) {
        PLAYSOUNDEFFECT(CHORUS1);
    } else {
        PLAYSOUNDEFFECT(CHORUS2);
    }
}

-(void)displayMainMenu {
    CGSize screenSize = [CCDirector sharedDirector].winSize; 
    if (sceneSelectMenu != nil) {
        [sceneSelectMenu removeFromParentAndCleanup:YES];
    }
    // Main Menu
    CCMenuItemImage *playGameButton = [CCMenuItemImage 
                                       itemFromNormalImage:@"PlayGameButtonNormal.png" 
                                       selectedImage:@"PlayGameButtonSelected.png" 
                                       disabledImage:nil 
                                       target:self 
                                       selector:@selector(displaySceneSelection)];
    
    CCMenuItemImage *buyBookButton = [CCMenuItemImage 
                                      itemFromNormalImage:@"BuyBookButtonNormal.png" 
                                      selectedImage:@"BuyBookButtonSelected.png" 
                                      disabledImage:nil 
                                      target:self 
                                      selector:@selector(buyBook)];
    
    CCMenuItemImage *optionsButton = [CCMenuItemImage 
                                      itemFromNormalImage:@"OptionsButtonNormal.png" 
                                      selectedImage:@"OptionsButtonSelected.png" 
                                      disabledImage:nil 
                                      target:self 
                                      selector:@selector(showOptions)];
    
    mainMenu = [CCMenu 
                menuWithItems:playGameButton,buyBookButton,optionsButton,nil];
    [mainMenu alignItemsVerticallyWithPadding:screenSize.height * 0.059f];
    [mainMenu setPosition:
     ccp(screenSize.width * 2.0f,
         screenSize.height / 2.0f)];
    id moveAction = 
    [CCMoveTo actionWithDuration:1.2f 
                        position:ccp(screenSize.width * 0.85f,
                                     screenSize.height/2.0f)];
    id moveEffect = [CCEaseIn actionWithAction:moveAction rate:1.0f];
    id playChorus = [CCCallFunc actionWithTarget:
                     self selector:@selector(playChorus)];
    id sequenceAction = [CCSequence actions:moveEffect,playChorus,nil];
    [mainMenu runAction:sequenceAction];
    [self addChild:mainMenu z:0 tag:kMainMenuTagValue];
}

-(void)displaySceneSelection {
    CGSize screenSize = [CCDirector sharedDirector].winSize; 
    if (mainMenu != nil) {
        [mainMenu removeFromParentAndCleanup:YES];
    }
    
    CCLabelBMFont *playScene1Label = 
    [CCLabelBMFont labelWithString:@"Oli Awakes!" 
                           fntFile:@"VikingSpeechFont64.fnt"];
    CCMenuItemLabel *playScene1 = 
    [CCMenuItemLabel itemWithLabel:playScene1Label target:self 
                          selector:@selector(playScene:)];
    [playScene1 setTag:1];
    
    CCLabelBMFont *playScene2Label = 
    [CCLabelBMFont labelWithString:@"Dogs of Loki!" 
                           fntFile:@"VikingSpeechFont64.fnt"];
    CCMenuItemLabel *playScene2 = 
    [CCMenuItemLabel itemWithLabel:playScene2Label target:self 
                          selector:@selector(playScene:)];
    [playScene2 setTag:2];
    
    CCLabelBMFont *playScene3Label = 
    [CCLabelBMFont labelWithString:@"Mad Dreams of the Dead!" 
                           fntFile:@"VikingSpeechFont64.fnt"];
    CCMenuItemLabel *playScene3 = [CCMenuItemLabel itemWithLabel:playScene3Label target:self 
                                                        selector:@selector(playScene:)];
    [playScene3 setTag:3];
    
    CCLabelBMFont *playScene4Label = 
    [CCLabelBMFont labelWithString:@"Descent Into Hades!" 
                                     fntFile:@"VikingSpeechFont64.fnt"];
	CCMenuItemLabel *playScene4 = [CCMenuItemLabel itemWithLabel:playScene4Label target:self 
														selector:@selector(playScene:)];
	[playScene4 setTag:4];
    
    CCLabelBMFont *playScene5Label = 
    [CCLabelBMFont labelWithString:@"Escape!" 
                                     fntFile:@"VikingSpeechFont64.fnt"];
	CCMenuItemLabel *playScene5 = [CCMenuItemLabel itemWithLabel:playScene5Label target:self 
														selector:@selector(playScene:)];
	[playScene5 setTag:5];
    
    CCLabelBMFont *backButtonLabel = 
    [CCLabelBMFont labelWithString:@"Back" 
                           fntFile:@"VikingSpeechFont64.fnt"];
    CCMenuItemLabel *backButton = 
    [CCMenuItemLabel itemWithLabel:backButtonLabel target:self 
                          selector:@selector(displayMainMenu)];
    
    sceneSelectMenu = [CCMenu menuWithItems:playScene1,
                       playScene2,playScene3,playScene4,playScene5,backButton,nil];
    [sceneSelectMenu alignItemsVerticallyWithPadding:screenSize.height * 0.059f];
    [sceneSelectMenu setPosition:ccp(screenSize.width * 2, 
                                     screenSize.height / 2)];
    
    id moveAction = [CCMoveTo actionWithDuration:0.5f 
                                        position:ccp(screenSize.width * 0.75f, 
                                                     screenSize.height/2)];
    id moveEffect = [CCEaseIn actionWithAction:moveAction rate:1.0f];
    [sceneSelectMenu runAction:moveEffect];
    [self addChild:sceneSelectMenu z:1 tag:kSceneMenuTagValue];
}
-(id)init {
    self = [super init];
    if (self != nil) {
        CGSize screenSize = [CCDirector sharedDirector].winSize; 
        
        CCSprite *background = 
        [CCSprite spriteWithFile:@"MainMenuBackground.png"];
        [background setPosition:ccp(screenSize.width/2, 
                                    screenSize.height/2)];
        [self addChild:background];
        [self displayMainMenu];
        
        CCSprite *viking = 
        [CCSprite spriteWithFile:@"VikingFloating.png"];
        [viking setPosition:ccp(screenSize.width * 0.35f, 
                                screenSize.height * 0.45f)];
        [self addChild:viking];
        
        id rotateAction = [CCEaseElasticInOut actionWithAction:
                           [CCRotateBy actionWithDuration:8.0f 
                                                    angle:360]];
        
        id scaleUp = [CCScaleTo actionWithDuration:4.0f scale:1.5f];
        id scaleDown = [CCScaleTo actionWithDuration:4.0f scale:0.5f];

        [viking runAction:[CCRepeatForever actionWithAction:
                           [CCSequence 
                            actions:scaleUp,scaleDown,nil]]];
        
        [viking runAction:
         [CCRepeatForever actionWithAction:rotateAction]];
        
        [[GameManager sharedGameManager] playBackgroundTrack:BACKGROUND_TRACK_MAIN_MENU];
        
    }
    return self;
}


@end
