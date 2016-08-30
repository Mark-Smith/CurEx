//
//  CEExchangeViewController.m
//  CurEx
//
//  Created by Mark Smith on 26/08/2016.
//  Copyright © 2016 ___CurEx___. All rights reserved.
//

#import "CEExchangeViewController.h"
#import "CEDataManager.h"
#import "CECurrencyManager.h"
#import "UIView+Toast.h"
#import "UIView+ToastExtras.h"
#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

#define kRefreshInterval 10


@interface CEExchangeViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSArray *currencies;
@property (nonatomic, strong) NSString *sourceCurrency;
@property (nonatomic, strong) NSString *destinationCurrency;
@property (assign) CGFloat sourceValue;
@property (assign) CGFloat destinationValue;
@property (weak, nonatomic) IBOutlet UITextField *sourceValueTextField;
@property (weak, nonatomic) IBOutlet UITextField *sourceCurrencyTextField;
@property (weak, nonatomic) IBOutlet UITextField *destinationValueTextField;
@property (weak, nonatomic) IBOutlet UITextField *destinationCurrencyTextField;
@property (nonatomic, strong) NSDictionary *rates;
@property (nonatomic, strong) UIPickerView *sourceCurrencyPicker;
@property (nonatomic, strong) UIPickerView *destinationCurrencyPicker;

@property (nonatomic, strong) NSDate *dateOfSourceCurrencySelection;

@end


@implementation CEExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // populate source and destination currency arrays from locally stored json file
    self.currencies = [[CEDataManager instance] getCurrencyCodes];
    self.currencies = [self.currencies sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    // default currencies - defaults for the moment, but will be based on user's location
    self.sourceCurrency = @"EUR";
    self.destinationCurrency = @"GBP";
    
    // default source value -  note that the destination value will only be set after a currency lookup has been made.
    self.sourceValue = 1.;
    
    // be notified of changes to text fields
    [self.sourceCurrencyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // configure text fields
    
    self.sourceCurrencyPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    [self.sourceCurrencyPicker setDataSource: self];
    [self.sourceCurrencyPicker setDelegate: self];
    self.sourceCurrencyPicker.showsSelectionIndicator = YES;
    self.sourceCurrencyTextField.inputView = self.sourceCurrencyPicker;
    
    self.destinationCurrencyPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    [self.destinationCurrencyPicker setDataSource: self];
    [self.destinationCurrencyPicker setDelegate: self];
    self.destinationCurrencyPicker.showsSelectionIndicator = YES;
    self.destinationCurrencyTextField.inputView = self.destinationCurrencyPicker;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 50)];
    numberToolbar.barStyle = UIBarButtonItemStylePlain;
    numberToolbar.barTintColor = [UIColor lightGrayColor];
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    self.sourceValueTextField.inputAccessoryView = numberToolbar;
    
    // set initial currency codes
    self.sourceValueTextField.text = [NSString stringWithFormat: @"%.2f", self.sourceValue];
    self.sourceCurrencyTextField.text = self.sourceCurrency;
    self.destinationCurrencyTextField.text = self.destinationCurrency;
    
    // only refresh list of rates (for the currently selected osurce currency) after a period of kRefreshInterval seconds. Ensure that rates will be refreshed initially.
    self.dateOfSourceCurrencySelection = [NSDate distantPast];
    
    //[self.sourceValueTextField becomeFirstResponder];
}

// dismiss keyboard on background tap
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    
    // catch all - assume picker is showing
    [self.sourceCurrencyTextField resignFirstResponder];
    [self.destinationCurrencyTextField resignFirstResponder];
    [super touchesBegan:touches withEvent:event];
}

// get dictionary of currencies based on value of source currency
- (void)getRatesForCurrency:(NSString*)currency {
    
    self.dateOfSourceCurrencySelection = [NSDate date];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [[CEDataManager instance] getLatestRatesForCurrency:currency success:^(NSDictionary *ratesDict) {
            
            // store the rates
            self.rates = ratesDict;
            
            // calculate and display result
            CGFloat rate = [ratesDict[self.destinationCurrency] floatValue];
            self.destinationValue = [[CECurrencyManager instance] convertValue:self.sourceValue usingRate:rate];
            self.destinationValueTextField.text = [NSString stringWithFormat: @"%.2f", self.destinationValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
        } failure:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
            [self.navigationController.view makeToast:@"Failed to Load Exchange Rates"];
        }];
        
        
    });
    
    
}

- (IBAction)calculate:(id)sender {
    
    if([[NSDate date] timeIntervalSinceDate:self.dateOfSourceCurrencySelection] > kRefreshInterval) {
        
        // too long since last obtained rates, so fetch them again
        [self getRatesForCurrency:self.sourceCurrency];
    } else {
        // calculate and display result
        CGFloat rate = [self.rates[self.destinationCurrency] floatValue];
        self.destinationValue = [[CECurrencyManager instance] convertValue:self.sourceValue usingRate:rate];
        self.destinationValueTextField.text = [NSString stringWithFormat: @"%.2f", self.destinationValue];
    }
}

// be notified of changes to text fields
-(void)textFieldDidChange :(UITextField *)textField{
    NSLog( @"text changed: %@", textField.text);
    
    if (textField == self.sourceCurrencyTextField) {
        self.destinationValue = 0.;
        self.dateOfSourceCurrencySelection = [NSDate date];
    }
    if (textField != self.sourceValueTextField) {
        self.destinationValue = 0.;
        self.destinationValueTextField.text = @"";
    }
}

#pragma mark - number pad methods

-(void)cancelNumberPad {
    [self.sourceValueTextField resignFirstResponder];
}

-(void)doneWithNumberPad {
    self.sourceValue = [self.sourceValueTextField.text integerValue];
    [self.sourceValueTextField resignFirstResponder];
}


#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldEndEditing");
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing");
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"textField:shouldChangeCharactersInRange:replacementString:");
    return TRUE;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    NSLog(@"textFieldShouldClear:");
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    return YES;
}


#pragma mark - UIPickerViewDelegate methods

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    
    self.destinationValue = 0.;
    self.destinationValueTextField.text = @"";
    
    if (pickerView == self.sourceCurrencyPicker) {
        
        // update text field
        self.sourceCurrency = self.currencies[row];
        self.sourceCurrencyTextField.text = self.sourceCurrency;
        [self.sourceCurrencyTextField resignFirstResponder];
        
    } else { // destination currency picker
        
        // update text field
        self.destinationCurrency = self.currencies[row];
        self.destinationCurrencyTextField.text = self.destinationCurrency;
        [self.destinationCurrencyTextField resignFirstResponder];
    }

}

#pragma mark - UIPickerViewDataSource methods

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger numRows = self.currencies.count;
    return self.currencies.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.currencies[row];
}


@end
