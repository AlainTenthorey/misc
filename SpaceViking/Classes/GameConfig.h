//
//  GameConfig.h
//  SpaceViking
//
//  Created by Rod on 3/2/11.
//  Copyright Prop Group LLC - www.prop-group.com 2011. All rights reserved.
//

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

//
// Define here the type of autorotation that you want for your game
//
// For iPhone 3GS and newer
//#define GAME_AUTOROTATION kGameAutorotationUIViewController

// For iPhone 3G and older (runs better)
#define GAME_AUTOROTATION kGameAutorotationCCDirector



#endif // __GAME_CONFIG_H