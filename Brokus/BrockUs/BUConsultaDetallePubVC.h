//
//  BUConsultaDetallePubVC.h
//  BrockUs
//
//  Created by Nodus12 on 11/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Publicacion.h"

@class ComboSector;
@interface BUConsultaDetallePubVC : UIViewController<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    UIPickerView* pickerView;
    UIPickerView* pickerSectores;
    NSArray *dataArray;
    NSArray *arraySectores;
    NSArray *arraySubsectores;

}

@property (strong)Publicacion *publicacion;
@property (strong) NSManagedObjectContext *context;
@property (strong) UIDatePicker *datePicker;

@property (strong) ComboSector *sectorSeleccionado;
//PROPERTIES DEL XIB
@property (strong, nonatomic) IBOutlet UITextField *fechaTermino;
@property (strong, nonatomic) IBOutlet UITextField *tituloTxt;
@property (strong, nonatomic) IBOutlet UITextView *descripcionTxt;
@property (strong, nonatomic) IBOutlet UITextField *sectorTxt;
@property (strong, nonatomic) IBOutlet UITextField *subSectorTxt;
@property (strong, nonatomic) IBOutlet UIImageView *imagenPub;



//EVENTOS

- (IBAction)cargarNuevaTapped:(id)sender;
- (IBAction)cancelarTapped:(id)sender;
- (IBAction)editarTapped:(id)sender;
- (IBAction)sectorTapped:(id)sender;
- (IBAction)subSectorTapped:(id)sender;






@end
