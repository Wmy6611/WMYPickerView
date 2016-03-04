//
//  WMYPickerView.h
//  Workspace
//
//  Created by Wmy on 16/3/3.
//  Copyright © 2016年 Wmy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WMYPickerViewDelegate, WMYPickerViewDataSource;

@interface WMYPickerView : UIControl

@property (nonatomic, strong) UITableView *talbeview;
@property (nonatomic, strong) UIPickerView *pickV;
@property (nonatomic, weak) id<WMYPickerViewDelegate> delegate;
@property (nonatomic, weak) id<WMYPickerViewDataSource> dataSource;

- (void)show;

- (void)reloadAllComponents;
- (void)reloadComponent:(NSInteger)component;

- (NSInteger)numberOfComponents;
- (NSInteger)numberOfRowsInComponent:(NSInteger)component;

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
- (NSInteger)selectedRowInComponent:(NSInteger)component;   // returns selected row. -1 if nothing selected

@end

#pragma mark - WMYPickerViewDataSource

@protocol WMYPickerViewDataSource <NSObject>
@required
- (NSInteger)numberOfComponentsInPickerView:(WMYPickerView *)pickerView;
- (NSInteger)pickerView:(WMYPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
@end

#pragma mark - WMYPickerViewDelegate

@protocol WMYPickerViewDelegate <NSObject>
@optional
- (void)confirmSelectedInPickerView:(WMYPickerView *)pickerView;
- (NSString *)pickerView:(WMYPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (void)pickerView:(WMYPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
@end

NS_ASSUME_NONNULL_END
