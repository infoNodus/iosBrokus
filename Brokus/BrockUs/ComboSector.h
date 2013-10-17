//
//  ComboBox.h
//
//  Created by Dor Alon on 12/17/11.
//  http://doralon.net

#import <UIKit/UIKit.h>
#import "BURegistroViewController.h"


@interface ComboSector : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
{
    UIPickerView* pickerView;
    
    NSArray *dataArray;
}

-(void) setComboData:(NSArray*) data; //set the picker view items
-(NSArray*)loadSubsector:(NSString *)textfield;

@property(strong)IBOutlet UITextField* textField;
@property (strong) NSManagedObjectContext *context;

@property (strong) ComboSector *combo;
@property (retain, nonatomic) NSString* selectedText; //the UITextField text

@end
