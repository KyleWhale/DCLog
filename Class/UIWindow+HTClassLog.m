

#import "UIWindow+HTClassLog.h"
#import "HTClassLog.h"

@implementation UIWindow (HTClassLog)

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    if (event.type == UIEventSubtypeMotionShake) {
        [HTClassLog changeVisible];
    }
}


@end
