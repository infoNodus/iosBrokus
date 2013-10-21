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
#import "BUConsultaPublicacion.h"

@interface BUConsultaDetallePubVC (){
    BOOL *isSector;
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
    
    fechaTermino.text=[formatter stringFromDate:publicacion.fecha];
    self.tituloTxt.text=publicacion.titulo;
    self.descripcionTxt.text=publicacion.descripcion;
    self.subSectorTxt.text=publicacion.toSubsector.nombre;
    self.linkanexo.text = publicacion.linkAnexo;
    self.link = publicacion.linkAnexo;
    
    self.imagenPub.image=[[UIImage alloc] initWithData:publicacion.img];
  //  self.subSectorTxt.text=@"Edificacion Residencial";
    
    //obtener subsector para la perosona
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSError *error;
    
    //obtenemos la empresa para la que se hace la publicacion
    NSEntityDescription *requestEmpresa=[NSEntityDescription entityForName:@"Subsector" inManagedObjectContext:context];
    [fetchRequest setEntity:requestEmpresa];
    //usamos la propiedad persona para obtener su empresa
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"nombre=%@",publicacion.toSubsector.nombre];
    [fetchRequest setPredicate:predicate];
    
    
    NSArray *fetchedSector=[context executeFetchRequest:fetchRequest error:&error];
    //Creamos la variable empresa y en el for le asignamos la empresa obtenida
    Subsector *subsector;
    for (int i=0; i<[fetchedSector count]; i++) {
        subsector=[fetchedSector objectAtIndex:i];
        //NSLog(@"Empresa: %@",[fetchedSubSector objectAtIndex:i]);
    }
    self.sectorTxt.text=subsector.toSector.nombre;
    
    
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
    [datePicker setMaximumDate:[currentTime dateByAddingTimeInterval:400000]];
    
    
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
    
    
    ///inicializamos el picker con los subsectores y se lo cargamos al textview
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *selectSubSector = [NSEntityDescription
                                            entityForName:@"Subsector" inManagedObjectContext:context];
    
    [fetch setEntity:selectSubSector];
    
    arraySubsectores=[[NSArray alloc]init];
    arraySubsectores=[context executeFetchRequest:fetch error:&error];
    
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
        NSComparisonResult result = [today compare:[datePicker date]];
        
        if(result==NSOrderedAscending)
            publicacion.fecha=[datePicker date];
        else if(result==NSOrderedDescending){
            NSLog(@"Seleccionar una fecha superior");
        }
      
        
        publicacion.titulo=self.tituloTxt.text;
        publicacion.descripcion=self.descripcionTxt.text;

        publicacion.linkAnexo=self.link;

        
        if (nombreSubSector!=nil) {
            publicacion.toSubsector=nombreSubSector;
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
        
        NSLog(@"Publicacion editada:%@",publicacion);
    }
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Error al actualizar los datos: %@ %@", error, [error localizedDescription]);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sectorTapped:(id)sender {
    isSector=YES;
    self.subSectorTxt.text=@"";
    dataArray=arraySectores;
    [pickerView reloadAllComponents];
}

- (IBAction)subSectorTapped:(id)sender {
    isSector=NO;
    //filtramos el picker de subsectores segun el sector seleccionado
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
    dataArray=arraySubsectores;
    [pickerView reloadAllComponents];
}




-(void)doneClickedDate:(id) sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    fechaTermino.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
    [fechaTermino resignFirstResponder]; //hides the pickerView
    
}
-(void)doneClickedSectores:(id) sender
{

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
