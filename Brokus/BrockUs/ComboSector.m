//
//  Combo.m
//
//  Created by Dor Alon on 12/17/11.
//

#import "ComboSector.h"
#import "Subsector.h"
#import "Sector.h"
#import "BUAppDelegate.h"

@interface ComboSector (){

}

@end
@implementation ComboSector

@synthesize context;
@synthesize selectedText;
@synthesize textField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    Sector *initialize=[dataArray objectAtIndex:0];
    selectedText=initialize.nombre;
    //textField.text=selectedText;
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//-- UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    Sector *sector=[dataArray objectAtIndex:row];
    textField.text =sector.nombre;
    selectedText = textField.text;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [dataArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    Sector *sector=[dataArray objectAtIndex:row];
    return sector.nombre;
}

//-- ComboBox


-(void) setComboData:(NSArray*) data
{
    dataArray = data;    
}


-(void)doneClicked:(id) sender
{
    [textField resignFirstResponder]; //hides the pickerView

}


- (IBAction)showPicker:(id)sender {
    
    pickerView = [[UIPickerView alloc] init];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;

    UIToolbar* toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [toolbar sizeToFit];
    
    //to make the done button aligned to the right
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Aceptar"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneClicked:)];
    
    
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];

    //custom input view
    
    textField.inputView = pickerView;
    textField.inputAccessoryView = toolbar;
    

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)aTextField
{
    [self showPicker:aTextField];
    return YES;
}

-(NSArray*)loadSubsector:(NSString *)textfield
{
    BUAppDelegate * buappdelegate=[[UIApplication sharedApplication]delegate];
    context =[buappdelegate managedObjectContext];
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *selectSector = [NSEntityDescription
                                         entityForName:@"Sector" inManagedObjectContext:context];
    
    [fetchRequest setEntity:selectSector];
    NSArray *fetchedSector= [context executeFetchRequest:fetchRequest error:&error];

    
    Sector *seleccionado;
    for (int i=0; i<[fetchedSector count]; i++) {
        Sector *forsector=[fetchedSector objectAtIndex:i];
        //NSLog(@"Sector %@",forsector.nombre);
        //NSLog(@"textfield %@",textfield);
        if([forsector.nombre isEqualToString:textfield]){
            seleccionado=[fetchedSector objectAtIndex:i];
            //NSLog(@"SELECCIONADO: %@",seleccionado);
        }
    }
    
    NSEntityDescription *selectSubSector = [NSEntityDescription
                                            entityForName:@"Subsector" inManagedObjectContext:context];
    
    [fetchRequest setEntity:selectSubSector];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"toSector = %@",seleccionado];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedSubSector= [context executeFetchRequest:fetchRequest error:&error];

    
    return fetchedSubSector;
    
    
}


@end
