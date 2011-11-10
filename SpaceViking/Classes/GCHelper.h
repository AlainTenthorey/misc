#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

#define kAchievementLevel1 @"com.prop-group.spaceviking.achievement.level1"
#define kAchievementLevel2 @"com.prop-group.spaceviking.achievement.level2"
#define kAchievementLevel3 @"com.prop-group.spaceviking.achievement.level3"
#define kAchievementLevel4 @"com.prop-group.spaceviking.achievement.level4"
#define kAchievementLevel5 @"com.prop-group.spaceviking.achievement.level5"
#define kAchievementBadDream @"com.prop-group.spaceviking.achievement.baddream"
#define kLeaderboardEscape @"com.prop-group.spaceviking.leaderboard.escape"

@interface GCHelper : NSObject <NSCoding> {
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    
    NSMutableArray *scoresToReport; 
    NSMutableArray *achievementsToReport;
}

@property (retain) NSMutableArray *scoresToReport;
@property (retain) NSMutableArray *achievementsToReport;

+ (GCHelper *) sharedInstance;
- (void)authenticationChanged;
- (void)authenticateLocalUser;

- (void)save;
- (id)initWithScoresToReport:(NSMutableArray *)scoresToReport
        achievementsToReport:(NSMutableArray *)achievementsToReport;
- (void)reportAchievement:(NSString *)identifier
          percentComplete:(double)percentComplete;
- (void)reportScore:(NSString *)identifier score:(int)score;

@end