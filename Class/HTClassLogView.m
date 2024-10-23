

#import "HTClassLogView.h"

@interface HTClassLogView() <UITextFieldDelegate>

@property (nonatomic, strong) UITextView *logTextView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UIButton *cleanButton;

@property (nonatomic, assign) NSInteger segmentIndex;
@property (nonatomic, copy) NSString *filterText;
@property (nonatomic, copy) NSString *currentLogText;

@end

@implementation HTClassLogView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    self.logTextView = [[UITextView alloc] init];
    self.logTextView.backgroundColor = [UIColor colorWithRed:39/255.0 green:40/255.0 blue:34/255.0 alpha:1.0];
    self.logTextView.textColor = [UIColor whiteColor];
    self.logTextView.font = [UIFont systemFontOfSize:14.0];
    self.logTextView.editable = NO;
    self.logTextView.layoutManager.allowsNonContiguousLayout = NO;
    [self addSubview:self.logTextView];
    
    NSArray *segmentArray = @[@"Normal",@"Crash"];
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:segmentArray];
    self.segmentControl.selectedSegmentIndex = 0;
    self.segmentIndex = 0;
    [self.segmentControl addTarget:self action:@selector(didClickSegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.segmentControl];
    
    self.cleanButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cleanButton.layer.cornerRadius = 5.0f;
    self.cleanButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.cleanButton setTitle:@"Clean" forState:UIControlStateNormal];
    [self.cleanButton addTarget:self action:@selector(cleanButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.cleanButton.layer.borderWidth = 1.0f;
    self.cleanButton.layer.borderColor = [UIColor colorWithRed:12/255.0 green:95/255.0 blue:250/255.0 alpha:1.0].CGColor;
    [self addSubview:self.cleanButton];
    
    self.textField = [[UITextField alloc] init];
    self.textField.placeholder = @"Filter";
    self.textField.backgroundColor = [UIColor clearColor];
    self.textField.textColor = [UIColor blackColor];
    self.textField.textAlignment = NSTextAlignmentLeft;
    self.textField.delegate = self;
    self.textField.layer.cornerRadius = 4;
    self.textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textField.layer.borderWidth = 0.5;
    [self addSubview:self.textField];
}

- (void)updateLog:(NSString *)logText {

    if ([self.currentLogText isEqualToString:logText] && self.filterText.length == 0) {
        return;
    }
    self.currentLogText = logText;
    if (self.filterText && self.filterText.length > 0) {
        logText = [logText stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        logText = [logText stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        NSArray *stringsArray = [logText componentsSeparatedByString:@"\n"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", self.filterText];
        NSArray *filteredArray = [stringsArray filteredArrayUsingPredicate:predicate];
        logText = [filteredArray componentsJoinedByString:@"\n"];
    }
    if (self.logTextView.contentSize.height <= (self.logTextView.contentOffset.y + CGRectGetHeight(self.bounds))) {
        self.logTextView.text = logText;
        [self.logTextView scrollRangeToVisible:NSMakeRange(self.logTextView.text.length, 1)];
    } else {
        self.logTextView.text = logText;
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height ?: 44;
    self.logTextView.frame = CGRectMake(0, height + 44, self.bounds.size.width, self.bounds.size.height - height - 44);
    
    self.segmentControl.frame = CGRectMake(16.0, 0, 150.0, 30.0);
    self.segmentControl.center = CGPointMake(self.segmentControl.center.x, height + 22);
    
    self.cleanButton.frame = CGRectMake(self.bounds.size.width-16-50, 0, 50.0, 30.0);
    self.cleanButton.center = CGPointMake(self.cleanButton.center.x, height + 22);
    
    self.textField.frame = CGRectMake(CGRectGetMaxX(self.segmentControl.frame) + 5, CGRectGetMinY(self.segmentControl.frame), CGRectGetMinX(self.cleanButton.frame) - CGRectGetMaxX(self.segmentControl.frame) - 10, 30);

}

- (void)cleanButtonClick {
    self.filterText = nil;
    self.textField.text = nil;
    [self.textField resignFirstResponder];
    if (_CleanButtonIndexBlock) {
        _CleanButtonIndexBlock(self.segmentIndex);
    }
}

- (void)didClickSegmentedControlAction:(UISegmentedControl *)control {
    [self.textField resignFirstResponder];
    if (_indexBlock) {
        _indexBlock(control.selectedSegmentIndex);
    }
    self.segmentIndex = control.selectedSegmentIndex;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self.textField resignFirstResponder];
        [self updateLog:self.currentLogText];
        return NO;
    }
    self.filterText = [[textField.text stringByReplacingCharactersInRange:range withString:string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return YES;
}

@end
