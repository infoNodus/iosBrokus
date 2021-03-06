//
//  BURegistroViewController.h
//  BrockUs
//
//  Created by HUB 3C 2 on 25/09/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <UIKit/UIKit.h>


//#import "Sector.h"
//#import "Persona.h"



@protocol BURegistroViewControllerDelegate;
@interface BURegistroViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    IBOutlet  UIScrollView *scroll;
    UIPickerView* pickerView;
    UIPickerView *pickerSectores;
    NSArray *dataArray;
    NSArray *arraySectores;
    NSArray *arraySubsectores;

    
    
}


@property (strong) NSManagedObjectContext *managedObjectContext;
//@property (strong) Subsector *sector;
//@property (strong) Persona *persona;
@property (weak) id <BURegistroViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *nombreEmpresaTxt;
@property (weak, nonatomic) IBOutlet UITextField *nombrePersonaTxt;
@property (weak, nonatomic) IBOutlet UITextField *puestoPersonaTxt;
@property (weak, nonatomic) IBOutlet UITextField *usuarioTxt;
@property (weak, nonatomic) IBOutlet UITextField *contrasenaTxt;
@property (weak, nonatomic) IBOutlet UITextField *repetirContrasenaTxt;



@property (strong, nonatomic) IBOutlet UITextField *subSector;
@property (retain, nonatomic) NSString* selectedText; //the UITextField text

@property (strong, nonatomic) IBOutlet UITextField *sector;


- (IBAction)SelecImg:(id)sender;


- (IBAction)registrarTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *Imagen;

- (IBAction)sectorClicked:(id)sender;
- (IBAction)subsectorClicked:(id)sender;







@end
