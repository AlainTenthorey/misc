//  PlatformScene.m
//  SpaceViking
//
#import "PlatformScene.h"

@implementation PlatformScene

-(id)init {
    self = [super init];
    if (self != nil) {
        // Platform Cloud Scrolling
        PlatformScrollingLayer *scrollingLayer = [PlatformScrollingLayer node];
        [self addChild:scrollingLayer];
    }
    return self;
}
@end