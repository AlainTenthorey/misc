#import "CPViking.h"

@implementation CPViking
@synthesize groundShapes;

#pragma mark Chipmunk Collision Handlers
static cpBool begin(cpArbiter *arb, cpSpace *space, void *ignore) {
    CP_ARBITER_GET_SHAPES(arb, vikingShape, groundShape);
    CPViking *viking = (CPViking *)vikingShape->data;
    cpVect n = cpArbiterGetNormal(arb, 0);
    
    if (n.y < 0.0f) {
        cpArray *groundShapes = viking.groundShapes;
        cpArrayPush(groundShapes, groundShape);
    }
    
    return cpTrue;
}

static cpBool preSolve(cpArbiter *arb, cpSpace *space, void *ignore) {
    if(cpvdot(cpArbiterGetNormal(arb, 0), ccp(0,-1)) < 0){
        return cpFalse;
    }
    return cpTrue;
}

static void separate(cpArbiter *arb, cpSpace *space, void *ignore) {
    CP_ARBITER_GET_SHAPES(arb, vikingShape, groundShape);
    CPViking *viking = (CPViking *)vikingShape->data;
    cpArrayDeleteObj(viking.groundShapes, groundShape);
}

#pragma mark -
#pragma mark Update and Init
-(void)updateStateWithDeltaTime:(ccTime)dt
           andListOfGameObjects:(CCArray*)listOfGameObjects {
    [super updateStateWithDeltaTime:dt
               andListOfGameObjects:listOfGameObjects];
    
    //making ole jump
    float jumpFactor;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        jumpFactor = 300.0;
    } else {
        jumpFactor = 150.0;
    }
    
    CGPoint newVel = body->v;
    if (groundShapes->num == 0) {
        newVel = ccp(jumpFactor*accelerationFraction,body->v.y);
    }
    double timeJumping = CACurrentMediaTime()-jumpStartTime;
    if (jumpStartTime != 0 && timeJumping < 0.25) {
        newVel.y = jumpFactor*2;
    }
    cpBodySetVel(body, newVel);
    
    //moving ole on ground
    if (groundShapes->num > 0) {
        if (ABS(accelerationFraction) < 0.05) {
            accelerationFraction = 0;
            shape->surface_v = ccp(0, 0);
        } else {
            float maxSpeed = 200.0f;
            shape->surface_v = ccp(-maxSpeed*accelerationFraction, 0);
            cpBodyActivate(body);
        }
    } else {
        shape->surface_v = cpvzero;
    }
    
    //clamping ole position within device bounds
    float margin = 70;
    CGSize winSize = [CCDirector sharedDirector].winSize;
    if (body->p.x < margin) {
        cpBodySetPos(body, ccp(margin, body->p.y));
    }
    if (body->p.x > winSize.width - margin) {
        cpBodySetPos(body, ccp(winSize.width - margin, body->p.y));
    }
}

- (id)initWithLocation:(CGPoint)location space:(cpSpace *)theSpace
            groundBody:(cpBody *)groundBody {
    if ((self = [super initWithSpriteFrameName:@"sv_anim_1.png"])) {
        CGSize size;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            size = CGSizeMake(60, 60);
            self.anchorPoint = ccp(0.5, 30/self.contentSize.height);
        } else {
            size = CGSizeMake(30, 30);
            self.anchorPoint = ccp(0.5, 15/self.contentSize.height);
        }
        
        [self addBoxBodyAndShapeWithLocation:location
                                        size:size space:theSpace mass:1.0 e:0.0 u:1.0
                               collisionType:kCollisionTypeViking canRotate:TRUE];
        
        groundShapes = cpArrayNew(0);
        cpSpaceAddCollisionHandler(space, kCollisionTypeViking,
                                   kCollisionTypeGround, begin, preSolve, NULL, separate, NULL);
        
        cpConstraint *constraint = cpRotaryLimitJointNew(groundBody, body,
                                                         CC_DEGREES_TO_RADIANS(-30),  CC_DEGREES_TO_RADIANS(30));
        cpSpaceAddConstraint(space, constraint);
    }
    return self;
}

#pragma mark -
#pragma mark Event Handlers
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if (groundShapes->num > 0) {
        jumpStartTime = CACurrentMediaTime();
    }
    return TRUE;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    jumpStartTime = 0;
}

- (void)accelerometer:(UIAccelerometer*)accelerometer
        didAccelerate:(UIAcceleration*)acceleration {
    accelerationFraction = acceleration.y*2;
    
    if (accelerationFraction < -1) {
        accelerationFraction = -1;
    } else if (accelerationFraction > 1) {
        accelerationFraction = 1;
    }
    
    if ([[CCDirector sharedDirector] deviceOrientation] == UIDeviceOrientationLandscapeLeft) {
        accelerationFraction *= -1;
    } 
}
@end