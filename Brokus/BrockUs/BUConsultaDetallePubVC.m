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
#import "BUPublicacionesActivasVC.h"
#import "BUConsultaPublicacion.h"

@interface BUConsultaDetallePubVC (){
    BOOL isSector;
    BOOL didSelect;
    Sector *nombreSector;
    Subsector *nombreSubSector;
}
@property (strong) NSString* link;
@end

@implementation BUConsultaDetallePubVC
@synthesize publicacion;
@synthesize context;
@synthesize datePicker;
@synthesize fechaTermino;
@synthesize sectorSeleccionado;
@synthesize linkanexo;

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
    didSelect=NO;
    //la variable publicacion contiene la informacion de la publicacion seleccionada en publicaciones activas, con esta cargamos todas las cajas de texto de nuestra vista.
    fechaTermino.text=[formatter stringFromDate:publicacion.fecha];
    self.tituloTxt.text=publicacion.titulo;
    self.descripcionTxt.text=publicacion.descripcion;
    self.subSectorTxt.text=publicacion.toSubsector.nombre;
    self.linkanexo.text = publicacion.linkAnexo;
    self.link = publicacion.linkAnexo;
    
    self.imagenPub.image=[[UIImage alloc] initWithData:publicacion.img];
    
    //obtener subsector para la perosona
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSError *error;
    
    //obtenemos el subsector para el que se hace la publicacion
    NSEntityDescription *requestSubsector=[NSEntityDescription entityForName:@"Subsector" inManagedObjectContext:context];
    [fetchRequest setEntity:requestSubsector];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"nombre=%@",publicacion.toSubsector.nombre];
    [fetchRequest setPredicate:predicate];
    
    
    NSArray *fetchedSector=[context executeFetchRequest:fetchRequest error:&error];
    
    Subsector *subsector;
    for (int i=0; i<[fetchedSector count]; i++) {
        subsector=[fetchedSector objectAtIndex:i];
    }
    
    //asignamos el sector ligado al subsector al textview
    self.sectorTxt.text=subsector.toSector.nombre;
    
    //se genera el datepicker para la caja de texto fecha de termino
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
    NSDate *currentTime = [NSDate dateWithTimeIntervalSinceNow:100000];
    [datePicker setMinimumDate:currentTime];
    [datePicker setMaximumDate:[currentTime dateByAddingTimeInterval:400000]];//se establece un limite de 5 dias máximo de vida de la pub
    
    
    [datetoolbar setItems:[NSArray arrayWithObjects:dateflexibleSpaceLeft, doneDateButton, nil]];
    
    //custom input view
    
    fechaTermino.inputView = datePicker;
    fechaTermino.inputAccessoryView = datetoolbar;
    
    
    ////ponemos el picker para el sector
    ////////
    ////////
    
    NSFetchRequest *requestSector = [[NSFetchRequest alloc] init];
    NSEntityDescription *selectSector = [NSEntityDescription
                                         entityForName:@"Sector" inManagedObjectContext:context];
    
    [requestSector setEntity:selectSector];
    arraySectores=[[NSArray alloc]init];
    
    arraySectores= [context executeFetchRequest:requestSector error:&error];
    
    self.subSectorTxt.delegate=self;
    pickerSectores = [[UIPickerView alloc] init];
    pickerSectores.showsSelectionIndicator = YES;
    pickerSectores.dataSource = self;
    pickerSectores.delegate = self;
    
    UIToolbar* toolbarSectores = [[UIToolbar alloc] init];
    toolbarSectores.barStyle = UIBarStyleBlackTranslucent;
    [toolbarSectores sizeToFit];
    
    //to make the done button aligned to the right
    UIBarButtonItem *flexibleSpaceLeftSectores = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIBarButtonItem* aceptar = [[UIBarButtonItem alloc] initWithTitle:@"Aceptar"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneClickedSectores:)];
    
    
    [toolbarSectores setItems:[NSArray arrayWithObjects:flexibleSpaceLeftSectores, aceptar, nil]];
    
    //custom input view
    
    self.sectorTxt.inputView = pickerSectores;
    self.sectorTxt.inputAccessoryView = toolbarSectores;
    
    
    arraySubsectores=[[NSArray alloc]init];
    
    //se genera el picker para los subsectores
    //
    //
    self.subSectorTxt.delegate=self;
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
    
    self.subSectorTxt.inputView = pickerView;
    self.subSectorTxt.inputAccessoryView = toolbar;

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)cargarNuevaTapped:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
    //[self.cargarImagenButton setBackgroundColor:[UIColor blueColor]]; //mejorar el diseño
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    CGSize newSize = CGSizeMake(100.0,100.0);
    UIGraphicsBeginImageContext(newSize);
    [chosenImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.imagenPub.image = newImage;
    self.imagenPub.contentMode = UIViewContentModeScaleAspectFit;
    self.imagenPub.frame = CGRectMake(110, 10, 100, 100);
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    //[self.cargarImagenButton setBackgroundColor:[UIColor whiteColor]];
}

- (IBAction)cancelarTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)editarTapped:(id)sender {
    if (publicacion) {
        NSDate *today=[NSDate date];
        NSComparisonResult result = [today compare:[datePicker date]];//contiene el resultado del a compracion de la fecha
        
        if(result==NSOrderedAscending)//true cuando la fecha es mayor a la del dia en que se genera la modificacion
            publicacion.fecha=[datePicker date];// se asigna la fecha seleccionada al textview
        else if(result==NSOrderedDescending){//true cuando la fecha es menor o igual a la actual
            NSLog(@"Seleccionar una fecha superior");
        }
      
        
        publicacion.titulo=self.tituloTxt.text;
        publicacion.descripcion=self.descripcionTxt.text;

        publicacion.linkAnexo=self.link;

        
        //se obtiene el sector que selecciona el usuario
        for (int i=0; i<[arraySectores count]; i++) {
            Sector *forsector=[arraySectores objectAtIndex:i];
            if([forsector.nombre isEqualToString:self.sectorTxt.text]){
                nombreSubSector=[arraySectores objectAtIndex:i];
            }
        }
        //consulta sobre la tabla subsector
        NSError *error = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *selectSubSector = [NSEntityDescription
                                                entityForName:@"Subsector" inManagedObjectContext:context];
        
        [fetchRequest setEntity:selectSubSector];
        //filtramos por sector para obtener el subsector seleccionado
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"toSector = %@",nombreSubSector];
        [fetchRequest setPredicate:predicate];// se ejecuta la consulta
        NSArray *savedSub=[context executeFetchRequest:fetchRequest error:&error];//se obtiene un array con un solo objeto,, que es el subsector seleccionado
        if (nombreSubSector!=nil) {
            NSLog(@"%@",nombreSubSector);
            publicacion.toSubsector=[savedSub objectAtIndex:0];// se asigna el subsector a la publicacion.
            
        }

        if (self.subSectorTxt.text.length<=0 || self.sectorTxt.text.length <=0) {
        self.sectorTxt.text=@"Construccion";
            self.subSectorTxt.text=@"Edificacion No Residencial";
            
            UIAlertView *alerta =[[UIAlertView alloc] initWithTitle:@"Error" message:@"Favor de Selecionar Sector o Subsector si no se Selecionaran sector y subsector por defailt" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];

            [alerta show];
        
        }

        
        
        NSData *imageData = UIImageJPEGRepresentation(self.imagenPub.image, 1);
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [path stringByAppendingString:publicacion.nameImg];
        publicacion.img = imageData;
        
    }
    
    NSError *error = nil;
    // Save the object to persistent store if doesn't exists errors
    if (![context save:&error]) {
        NSLog(@"Error al actualizar los datos: %@ %@", error, [error localizedDescription]);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sectorTapped:(id)sender {
    isSector=YES;
    dataArray=arraySectores;
    [pickerView reloadAllComponents];
}

- (IBAction)subSectorTapped:(id)sender {
    isSector=NO;
    //filtramos el picker de subsectores segun el sector seleccionado
    dataArray=arraySubsectores;
    [pickerView reloadAllComponents];
}

-(void)cargaSubsector{
    Sector *seleccionado;
    for (int i=0; i<[arraySectores count]; i++) {
        Sector *forsector=[arraySectores objectAtIndex:i];
        if([forsector.nombre isEqualToString:self.sectorTxt.text]){
            seleccionado=[arraySectores objectAtIndex:i];
        }
    }
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *selectSubSector = [NSEntityDescription
                                            entityForName:@"Subsector" inManagedObjectContext:context];
    
    [fetchRequest setEntity:selectSubSector];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"toSector = %@",seleccionado];
    [fetchRequest setPredicate:predicate];
    
    arraySubsectores= [context executeFetchRequest:fetchRequest error:&error];
    Subsector *s=[arraySubsectores objectAtIndex:0];
    self.subSectorTxt.text=s.nombre;
}



//se ejecuta cuando seleccionamos la fecha y damos click en aceptar
-(void)doneClickedDate:(id) sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];//tipo de formato que tendra la fecha
    fechaTermino.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];//se asigna el formato de fecha al datepicker
    [fechaTermino resignFirstResponder]; //hides the pickerView
    
}
-(void)doneClickedSectores:(id) sender
{
    if (!didSelect) {
        Sector *s=[arraySectores objectAtIndex:0];
        self.sectorTxt.text=s.nombre;
        [self cargaSubsector];
    }
    [self.sectorTxt resignFirstResponder]; //hides the pickerView
    
}
-(void)doneClicked:(id) sender
{
    
    [self.subSectorTxt resignFirstResponder]; //hides the pickerView
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(isSector){
        nombreSector=[dataArray objectAtIndex:row];
        self.sectorTxt.text=nombreSector.nombre;
        [self cargaSubsector];
        didSelect=YES;
    }else{
        nombreSubSector=[dataArray objectAtIndex:row];
        self.subSectorTxt.text =nombreSubSector.nombre;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [dataArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    if(isSector){
        nombreSector=[dataArray objectAtIndex:row];
        return nombreSector.nombre;
    }else{
        nombreSubSector=[dataArray objectAtIndex:row];
        return nombreSubSector.nombre;
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        UITextField *theTextField = [alertView textFieldAtIndex:0];
                NSString *urlRegEx =
        @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
        NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
        if(![urlTest evaluateWithObject:theTextField.text]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error Link invalido" message:@"Proporciona un link donde se encuentra tu archivo (Dropbox, Mega, etc). No Olvides poner al principio http:// "  delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"OK", nil];
            
            alert.alertViewStyle=UIAlertViewStylePlainTextInput;
            [alert textFieldAtIndex:0].text = theTextField.text;
            [alert show];
            return;
        }
        self.link = theTextField.text;
        self.linkanexo.text =  [[alertView textFieldAtIndex:0]text];
    }
    
}

- (IBAction)AnexoBtn:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"IMPORTANTE" message:@"Proporciona un link donde se encuentra tu archivo (Dropbox, Mega, etc). No Olvides poner al principio http:// "  delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle= UIAlertViewStylePlainTextInput;
    if(self.link == nil || [self.link isEqualToString:@""]) {
        [alert textFieldAtIndex:0].text = @"http://";
    } else {
        [alert textFieldAtIndex:0].text = self.link;
    }
    [alert show];
    
    BUConsultaPublicacion *consulta = [[BUConsultaPublicacion alloc] init];
    Persona *persona = [consulta recuperaPersona:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserBrockus"] :context];
    Publicacion *insertPublicacion=[NSEntityDescription insertNewObjectForEntityForName:@"Publicacion" inManagedObjectContext:context];
    if(![self.link isEqualToString:@""]) {
        insertPublicacion.linkAnexo = self.link;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
@end
