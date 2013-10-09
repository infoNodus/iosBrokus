///Users/nodus9/Dropbox/Brockus/v/BrockUs.xcodeproj
//  BUPublicacionViewController.h
//  BrockUs
//
//  Created by Nodus9 on 04/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BUPerfilEmpresaViewController.h"
#import "BUSeleccionaFechaViewController.h"

@protocol BUPublicacionViewControllerDelegate;

@class ComboSector;
@interface BUPublicacionViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    UIDatePicker *datePicker;
    UIPickerView* pickerView;
    NSArray *dataArray;
  //  IBOutlet UILabel *muestrafecha;

}


- (IBAction)cancelar:(id)sender;
- (IBAction)Aceptar:(id)sender;
- (IBAction)cargarImagen:(id)sender;
- (IBAction)Recomendar:(id)sender;
- (IBAction)CargarArchivo:(id)sender;

//fecha
- (IBAction)Fecha:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *muestrafecha;
@property (nonatomic) Boolean dateChooserVisible;

//Campos de texto a llenar
@property (weak, nonatomic) IBOutlet UITextView *DescripcionTxt;
@property (weak, nonatomic) IBOutlet UITextField *tituloTxt;



@property (strong, nonatomic) IBOutlet UIImageView *imagenPub;

@property (weak) UIViewController *presenterVC;
@property (strong) NSDate *fecha;
@property (strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *cargarImagenButton;
@property (weak) id <BUPublicacionViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *subSector;
@property (retain, nonatomic) NSString* selectedText; //the UITextField text
@property (strong) IBOutlet UITextField *comboSector;
@property (strong,nonatomic) ComboSector *sectorSeleccionado;
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
/*metodos para cargar anexos, test*/
//- (void)insertNewObject:(NSString *)fileName;
-(NSString *)getPath:(NSString *)fileName;
-(NSData *)getImageBinary:(NSString *)fileName;
/*metodos para cargar anexos, test*/

@end
