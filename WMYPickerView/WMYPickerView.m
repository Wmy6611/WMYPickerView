//
//  WMYPickerView.m
//  Workspace
//
//  Created by Wmy on 16/3/3.
//  Copyright © 2016年 Wmy. All rights reserved.
//

#import "WMYPickerView.h"

static CGFloat const kDuration = 0.26;
static CGFloat const kContentViewH = 216;
static CGFloat const kToolBarH = 44;

@interface WMYPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSLayoutConstraint *contentViewBottomConstraint;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
@property (nonatomic, strong) UIPickerView *pickerView;

@end

@implementation WMYPickerView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self)
    {
        [self configureUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = [UIScreen mainScreen].bounds;
}

#pragma mark - show / dismiss

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:kDuration
                         animations:^{
                             self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
                             _contentViewBottomConstraint.constant = 0;
                             [self layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             
                         }];
    });
}

- (void)dismiss {
    
    [UIView animateWithDuration:kDuration
                     animations:^{
                         self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.01];
                         _contentViewBottomConstraint.constant = kToolBarH + kContentViewH;
                         [self layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
    
}

#pragma mark - confirm

- (void)confirm:(id)sender {
    
    if (self.delegate && [_delegate respondsToSelector:@selector(confirmSelectedInPickerView:)]) {
        [_delegate confirmSelectedInPickerView:self];
    }
    [self dismiss];
}


#pragma mark - reset

- (void)reloadAllComponents {
    [_pickerView reloadAllComponents];
    for (NSInteger i = 0; i < _pickerView.numberOfComponents; i++) {
        [_pickerView selectRow:0 inComponent:i animated:YES];
    }
}

- (void)reloadComponent:(NSInteger)component {
    [_pickerView reloadComponent:component];
    [_pickerView selectRow:0 inComponent:component animated:YES];
}


#pragma mark -

- (NSInteger)numberOfComponents {
    return _pickerView.numberOfComponents;
}

- (NSInteger)numberOfRowsInComponent:(NSInteger)component {
    return [_pickerView numberOfRowsInComponent:component];
}

#pragma mark -

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_pickerView selectRow:row inComponent:component animated:animated];
        [self pickerView:_pickerView didSelectRow:row inComponent:component];
    });
}

- (NSInteger)selectedRowInComponent:(NSInteger)component {
    return [_pickerView selectedRowInComponent:component];
}

#pragma mark - dataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfComponentsInPickerView:)]) {
        return [_dataSource numberOfComponentsInPickerView:self];
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)]) {
        return [_dataSource pickerView:self numberOfRowsInComponent:component];
    }
    return 0;
}

#pragma mark - delegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)]) {
        return [_delegate pickerView:self titleForRow:row forComponent:component];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    for (NSInteger i = component + 1; i < _pickerView.numberOfComponents; i++) {
        [self reloadComponent:i];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [_delegate pickerView:self didSelectRow:row inComponent:component];
    }
}

#pragma mark - configureUI

- (void)configureUI {
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.01];
    [self addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.contentView];
    [_contentView addSubview:self.visualEffectView];
    [_contentView addSubview:self.pickerView];
    [self addSubview:self.toolBar];

    [self addVFL];
}

#pragma mark - getter and setter

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
            view.translatesAutoresizingMaskIntoConstraints = NO;
            view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.68];
            view;
        });
    }
    return _contentView;
}

- (UIToolbar *)toolBar {
    if (_toolBar == nil) {
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确认  "
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(confirm:)];
        NSArray *items = @[leftItem,rightItem];
        
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectZero];
        _toolBar.translatesAutoresizingMaskIntoConstraints = NO;
        _toolBar.tintColor = [UIColor grayColor];
        [_toolBar setItems:items];
    }
    return _toolBar;
}

- (UIPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = ({
            UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
            pickerView.translatesAutoresizingMaskIntoConstraints = NO;
            pickerView.delegate = self;
            pickerView.dataSource = self;
            pickerView;
        });
    }
    return _pickerView;
}

- (UIVisualEffectView *)visualEffectView {
    if (_visualEffectView == nil) {
        
        _visualEffectView = ({
            UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
            visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
            visualEffectView.alpha = 1.0;
            visualEffectView;
        });
    }
    return _visualEffectView;
}

#pragma mark - vfl

- (void)addVFL {

    NSDictionary *metrics = @{@"contentViewH" : [NSNumber numberWithFloat:kContentViewH],
                              @"toolBarH" : [NSNumber numberWithFloat:kToolBarH]};
    NSString *vfl1 = @"H:|-0-[contentView]-0-|";
    NSString *vfl2 = @"V:[contentView(contentViewH)]";
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl1
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:@{@"contentView":_contentView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl2
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:metrics
                                                                   views:@{@"contentView":_contentView}]];
    
    _contentViewBottomConstraint = [NSLayoutConstraint constraintWithItem:_contentView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:kContentViewH + kToolBarH];
    [NSLayoutConstraint activateConstraints:@[_contentViewBottomConstraint]];
    _contentViewBottomConstraint.active = YES;


    NSString *vfl3 = @"H:|-0-[visualEffectView]-0-|";
    NSString *vfl4 = @"V:|-0-[visualEffectView]-0-|";
    [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl3
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:@{@"visualEffectView":_visualEffectView}]];
    [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl4
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:@{@"visualEffectView":_visualEffectView}]];
    
    NSString *vfl5 = @"H:|-0-[pickerView]-0-|";
    NSString *vfl6 = @"V:|-0-[pickerView]-0-|";
    [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl5
                                                                         options:NSLayoutFormatDirectionLeadingToTrailing
                                                                         metrics:nil
                                                                           views:@{@"pickerView":_pickerView}]];
    [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl6
                                                                         options:NSLayoutFormatDirectionLeadingToTrailing
                                                                         metrics:nil
                                                                           views:@{@"pickerView":_pickerView}]];
    NSString *vfl7 = @"H:|-0-[toolBar]-0-|";
    NSString *vfl8 = @"V:[toolBar(toolBarH)]-0-[contentView]";
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl7
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:@{@"toolBar":_toolBar,
                                                                           @"contentView":_contentView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl8
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:metrics
                                                                   views:@{@"toolBar":_toolBar,
                                                                           @"contentView":_contentView}]];

}

@end
