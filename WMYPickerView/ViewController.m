//
//  ViewController.m
//  WMYPickerView
//
//  Created by Wmy on 16/3/4.
//  Copyright © 2016年 Wmy. All rights reserved.
//

#import "ViewController.h"
#import "WMYPickerView.h"

@interface ViewController () <WMYPickerViewDataSource, WMYPickerViewDelegate>
@property (nonatomic, strong) WMYPickerView *pickerView;
@property (nonatomic, strong) NSArray *componentArr1;
@property (nonatomic, strong) NSArray *componentArr2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *arr1 = @[@"2-0"];
    NSArray *arr2 = @[@"2-0", @"2-1", @"2-2", @"2-3", @"2-4", @"2-5", @"2-6"];
    NSArray *arr3 = @[];
    NSArray *arr4 = @[@"2-0", @"2-1", @"2-2"];
    NSArray *arr5 = @[@"2-0", @"2-1", @"2-2", @"2-3", @"2-4", @"2-5", @"2-6", @"2-7", @"2-8", @"2-9"];
    NSArray *arr6 = @[@"2-0", @"2-1", @"2-2", @"2-3"];
    
    _componentArr1 = @[@"1-0", @"1-1", @"1-2", @"1-3", @"1-4", @"1-5"];
    _componentArr2 = @[arr1, arr2, arr3, arr4, arr5, arr6];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.pickerView show];
        [_pickerView selectRow:1 inComponent:0 animated:YES];
        [_pickerView selectRow:5 inComponent:1 animated:YES];
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.pickerView show];
}

#pragma mark - picker view delegate dataSource
- (NSInteger)numberOfComponentsInPickerView:(WMYPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(WMYPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0)
        return _componentArr1.count;
    else
    {
        NSInteger rowIndex = [pickerView selectedRowInComponent:0];
        return [_componentArr2[rowIndex] count];
    }
}

- (NSString *)pickerView:(WMYPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0)
        return _componentArr1[row];
    else
    {
        NSInteger rowIndex = [pickerView selectedRowInComponent:0];
        return _componentArr2[rowIndex][row];
    }
}

- (void)pickerView:(WMYPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"didSelected - %lu, %lu", component, row);
}

- (void)confirmSelectedInPickerView:(WMYPickerView *)pickerView {
    NSLog(@"confirmSelected - %lu, %lu", [pickerView selectedRowInComponent:0], [pickerView selectedRowInComponent:1]);
}

#pragma mark - getter

- (WMYPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[WMYPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

@end
