///Users/nodus9/Dropbox/Brockus/v/BrockUs.xcodeproj
//  BUPublicacionViewController.h
//  BrockUs
//
//  Created by Nodus9 on 04/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BUPerfilEmpresaViewController.h"


@protocol BUPublicacionViewControllerDelegate;

@class ComboSector;
@interface BUPublicacionViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    UIDatePicker *datePicker; //Declaración del picker para la fecha
    UIPickerView* pickerView; //Declaración de la vista del picker
    UIPickerView *pickerSectores; //Declaración del picker para los sectores
    NSArray *dataArray; //Declaración del array para la fecha
    NSArray *arraySectores; //Declaración del array para los sectores
    NSArray *arraySubsectores; //Declaración del array para los subsectores
}

//Declaración de botones
- (IBAction)cancelar:(id)sender; //Declaración del botón Cancelar
- (IBAction)Aceptar:(id)sender;//Declaración del botón Aceptar
- (IBAction)cargarImagen:(id)sender;//Declaración del botón Cargar una Imagen
- (IBAction)Recomendar:(id)sender; //Declaración del botón Recomendar
- (IBAction)CargarArchivo:(id)sender; //Declaración del botón Cargar un archivo
- (IBAction)subsectorClicked:(id)sender; //Declaración del boton subsector
- (IBAction)sectorClicked:(id)sender;//Declaración del boton sector

//Declaración de propiedades
@property (weak, nonatomic) IBOutlet UILabel *muestrafecha; //Declaración del Label para mostrar la fecha
@property (nonatomic) Boolean dateChooserVisible; //Declaración de la propiedad booleana para mostrar la fecha
@property (strong, nonatomic) IBOutlet UITextField *date; //Declaración del campo de texto para seleccionar la fecha
@property (weak, nonatomic) IBOutlet UITextView *DescripcionTxt;//Declaración del campo de texto para escribir la descripción
@property (weak, nonatomic) IBOutlet UITextField *tituloTxt;//Declaración del campo de texto para escribir el título
@property (strong, nonatomic) IBOutlet UIImageView *imagenPub;//Declaración del ImageView para seleccionar la imagen
@property (weak) UIViewController *presenterVC;//Declaració  del presenter view controller
@property (strong) NSDate *fecha; //Declaración de la fecha
@property (strong) NSManagedObjectContext *managedObjectContext; //Declaración del manejo de contexto
@property (strong, nonatomic) IBOutlet UIImageView *imageView; //Declaración del imageview para mostrar la imagen
@property (strong, nonatomic) IBOutlet UIButton *cargarImagenButton;//Declaración del boton cargar imagen
@property (weak) id <BUPublicacionViewControllerDelegate> delegate;//Declaración del delegate
@property (strong, nonatomic) IBOutlet UITextField *subSector;//Declaración del campo de texto para el subsector
@property (retain, nonatomic) NSString* selectedText; //the UITextField text
@property (strong) IBOutlet UITextField *comboSector; //Declaración del campo de texto para el sector
@property (strong,nonatomic) ComboSector *sectorSeleccionado; //Declaración del combobox para el sector seleccionado
@property (strong, nonatomic) IBOutlet UITextField *sector; //Declaración del campo de texto para el sector

//Declaración de métodos
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;//Declaración del métodos textview para mostrar el texto de la publicación
-(NSString *)getPath:(NSString *)fileName; //Declaración del método getpath para la imagen
-(NSData *)getImageBinary:(NSString *)fileName; //Declaración del método getImageBinary para la imagen

@end
