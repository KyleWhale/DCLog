

#import <Foundation/Foundation.h>

#if DEBUG
#define HTLog(FORMAT, ...)  { \
    NSString *logMessage = [NSString stringWithFormat:@"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(FORMAT), ##__VA_ARGS__]]; \
    [HTClassLog writeLog:logMessage]; \
}
#else
#define HTLog(FORMAT, ...) nil
#endif

@interface HTClassLog : NSObject

+ (void)writeLog:(NSString *)logMessage;

+ (void)changeVisible;

@end
