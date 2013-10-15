//
//  BUConsultaDetallePubVC.m
//  BrockUs
//
//  Created by Nodus12 on 11/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import "BUConsultaDetallePubVC.h"
#import "BUAppDelegate.h"
#import "Subsector.h"
#import "Sector.h"
#import "ComboSector.h"
#import "BUPublicacionesActivasVC.h"

@interface BUConsultaDetallePubVC ()

@end

@implementation BUConsultaDetallePubVC
@synthesize publicacion;
@synthesize context;
@synthesize datePicker;
@synthesize fechaTermino;
@synthesize sectorSeleccionado;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    BUAppDelegate * buappdelegate=[[UIApplication sharedApplication]delegate];
    context =[buappdelegate managedObjectContext];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    fechaTermino.text=[formatter stringFromDate:publicacion.fecha];
    self.tituloTxt.text=publicacion.titulo;
    self.descripcionTxt.text=publicacion.descripcion;
    self.subSectorTxt.text=publicacion.toSubsector.nombre;
    self.imagenPub.image=[[UIImage alloc] initWithData:publicacion.img];
    
    
    //obtener subsector para la perosona
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSError *error;
    
    //obtenemos la empresa para la que se hace la publicacion
    NSEntityDescription *requestEmpresa=[NSEntityDescription entityForName:@"Subsector" inManagedObjectContext:context];
    [fetchRequest setEntity:requestEmpresa];
    //usamos la propiedad persona para obtener su empresa
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@" nombre=%@",publicacion.toSubsector.nombre];
    [fetchRequest setPredicate:predicate];
    
    
    NSArray *fetchedSector=[context executeFetchRequest:fetchRequest error:&error];
    //Creamos la variable empresa y en el for le asignamos la empresa obtenida
    Subsector *sector;
    for (int i=0; i<[fetchedSector count]; i++) {
        sector=[fetchedSector objectAtIndex:i];
        //NSLog(@"Empresa: %@",[fetchedSubSector objectAtIndex:i]);
    }
    self.sectorTxt.text=sector.toSector.nombre;
    
    
    fechaTermino.delegate=self;
    datePicker =[[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    //to make the done button aligned to the right
    UIToolbar* datetoolbar = [[UIToolbar alloc] init];
    datetoolbar.barStyle = UIBarStyleBlackTranslucent;
    [datetoolbar sizeToFit];
    
    //to make the done button aligned to the right
    UIBarButtonItem *dateflexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem* doneDateButton = [[UIBarButtonItem alloc] initWithTitle:@"Aceptar"
                                                                       style:UIBarButtonItemStyleDone target:self
                                                                      action:@selector(doneClickedDate:)];
    NSDate *currentTime = [NSDate dateWithTimeIntervalSinceNow:0];
    [datePicker setMinimumDate:currentTime];
    [datePicker setMaximumDate:[currentTime dateByAddingTimeInterval:400000]];
    
    
    [datetoolbar setItems:[NSArray arrayWithObjects:dateflexibleSpaceLeft, doneDateButton, nil]];
    
    //custom input view
    
    fechaTermino.inputView = datePicker;
    fechaTermino.inputAccessoryView = datetoolbar;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fechsTerminoTapped:(id)sender {
}

- (IBAction)sectorTapped:(id)sender {
    
}

- (IBAction)subSectorTapped:(id)sender {
}

- (IBAction)cargarNuevaTapped:(id)sender {
}

- (IBAction)cancelarTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)editarTapped:(id)sender {
    if (publicacion) {
        // Update existing device
        publicacion.fecha=[datePicker date];
        publicacion.titulo=self.tituloTxt.text;
        publicacion.descripcion=self.descripcionTxt.text;
        
        
    }
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Error al actualizar los datos: %@ %@", error, [error localizedDescription]);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneClickedDate:(id) sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    fechaTermino.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
    [fechaTermino resignFirstResponder]; //hides the pickerView
    
}


@end
