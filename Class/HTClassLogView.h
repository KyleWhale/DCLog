
#import <UIKit/UIKit.h>

@interface HTClassLogView : UIView

- (void)updateLog:(NSString *)logText;

@property (nonatomic, strong) void(^indexBlock)(NSInteger index);

@property (nonatomic, strong) void(^CleanButtonIndexBlock)(NSInteger index);

@end
