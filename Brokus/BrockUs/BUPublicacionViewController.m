//
//  BUPublicacionViewController.m
//  BrockUs
//
//  Created by Nodus9 on 04/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import "BUPublicacionViewController.h"
#import "BUPerfilEmpresaViewController.h"
#import "BUInvitarPersonaViewController.h"
#import "BUMuroPublicacionesViewController.h"
#import "BUAppDelegate.h"
#import "Publicacion.h"
#import "ComboSector.h"
#import "Subsector.h"
#import "BUConsultaPublicacion.h"

@interface BUPublicacionViewController(){
    
    NSManagedObjectContext *context;
    NSString *cadena;
    NSArray* sub;

}

@property (strong) BUPublicacionViewController *mostrarpublicacion;
@property (nonatomic, retain) NSManagedObjectContext *context;
@property (strong) BUPerfilEmpresaViewController *pub;
@property (strong) BUPerfilEmpresaViewController *perfil;
@property (strong) BUMuroPublicacionesViewController *muro;
//@property (nonatomic, retain) NSManagedObjectContext *context;
@property (strong) NSString* link;

@end


@implementation BUPublicacionViewController
@synthesize selectedText;
@synthesize subSector;
@synthesize comboSector;
@synthesize sectorSeleccionado;
@synthesize date;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//VALIDACIONES

//Termina validacion

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    BUAppDelegate * buappdelegate=[[UIApplication sharedApplication]delegate];
    context =[buappdelegate managedObjectContext];

    self.muestrafecha =[[UILabel alloc] init];
    self.subSector.text=@"Edificacion Residencial";
    
    self.perfil=[[BUPerfilEmpresaViewController alloc] initWithNibName:@"BUPerfilEmpresaViewController" bundle:nil];
 
    self.muro=[[BUMuroPublicacionesViewController alloc]initWithNibName:@"BUMuroPublicacionesViewController" bundle:nil];
    
   
    
    self.context = [self context];
    
    if (self.context == nil)
    {
        self.context = [(BUAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }

    
    self.DescripcionTxt.text=@"";
    
    
    NSError *error;
    NSFetchRequest *requestSector = [[NSFetchRequest alloc] init];
    NSEntityDescription *selectSector = [NSEntityDescription
                                         entityForName:@"Sector" inManagedObjectContext:self.context];
    
    [requestSector setEntity:selectSector];
    
    NSArray *fetchedSector= [self.context executeFetchRequest:requestSector error:&error];
    
    sectorSeleccionado = [[ComboSector alloc] init];
    [sectorSeleccionado setComboData:fetchedSector];
    [self.view addSubview:sectorSeleccionado.view];
    sectorSeleccionado.view.frame = CGRectMake(10, 370, 302, 31);
    
    
    subSector.delegate=self;
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
    
    subSector.inputView = pickerView;
    subSector.inputAccessoryView = toolbar;
    //subSector.hidden=YES;
    date.delegate=self;
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
    NSDate *currentTime = [NSDate dateWithTimeIntervalSinceNow:0];//fecha actual
    [datePicker setMinimumDate:currentTime];
    [datePicker setMaximumDate:[currentTime dateByAddingTimeInterval:400000]];
    
    
    [datetoolbar setItems:[NSArray arrayWithObjects:dateflexibleSpaceLeft, doneDateButton, nil]];
    
    //custom input view
    
    date.inputView = datePicker;
    date.inputAccessoryView = datetoolbar;
    
    
}
-(void)doneClickedDate:(id) sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    date.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
    [date resignFirstResponder]; //hides the pickerView
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)aTextField
{
    
    sub=[[NSArray alloc]init];
    cadena=sectorSeleccionado.selectedText;
    sub=[sectorSeleccionado loadSubsector:cadena];
    [self setComboData:sub];
    [pickerView reloadAllComponents];
    return YES;
}


//-- UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    Subsector *nombreSubSector=[dataArray objectAtIndex:row];
    subSector.text =nombreSubSector.nombre;
    selectedText = subSector.text;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [dataArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    Subsector *nombreSubSector=[dataArray objectAtIndex:row];
    
    return nombreSubSector.nombre;
}

//-- ComboBox


-(void) setComboData:(NSArray*) data
{
    dataArray = data;
}


-(void)doneClicked:(id) sender
{
    [subSector resignFirstResponder]; //hides the pickerView
    
}


//ocultar teclado
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([textField.text length] == 0) {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelar:(id)sender {
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    [UIView commitAnimations];

    self.perfil.delegate=(id)self;
    UINavigationController *navContr = [[UINavigationController alloc] initWithRootViewController:self.perfil];
    navContr.title=@"Perfil";
    [self presentViewController:navContr animated:YES completion:nil];
   


}

- (IBAction)Aceptar:(id)sender{
    
    BUConsultaPublicacion *consulta = [[BUConsultaPublicacion alloc] init];
    Persona *persona = [consulta recuperaPersona:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserBrockus"] :context];
    Publicacion *insertPublicacion=[NSEntityDescription insertNewObjectForEntityForName:@"Publicacion" inManagedObjectContext:context];
    
    if([_tituloTxt.text length]==0 || [_DescripcionTxt.text length]==0)
    {
        UIAlertView *vacio=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Llene el titulo o la descripcion" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [vacio show];
        self.tituloTxt.clearButtonMode=YES;
        
        //self.DescripcionTxt.clearsOnBeginEditing=YES;
    }else if ([_tituloTxt.text length]>60)
    {
        UIAlertView *descriplarga=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Titulo demasiado largo" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [descriplarga show];
        self.tituloTxt.clearButtonMode=YES;
    }else{
        insertPublicacion.descripcion=self.DescripcionTxt.text;
        insertPublicacion.titulo=self.tituloTxt.text;
        
        //inserta fecha
        NSDate *termino=[datePicker date];
        insertPublicacion.fecha=termino;
        
        
        //insertar imagen en BD
        NSString *stringA = @"/";
        NSString *stringB = self.tituloTxt.text;//agregar parametros para hacer nom de imagen unico
        NSString *stringC = @".jpg";
        NSString *finalString = [NSString stringWithFormat:@"%@%@%@", stringA, stringB, stringC]; //agregar random
        NSData *imageData = UIImageJPEGRepresentation(self.imagenPub.image, 1);
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [path stringByAppendingString:finalString];
        insertPublicacion.urlPath = path; //getPath:fileName
        //[persona setValue:[self getImageBinary:fileName] forKey:@"img"];
        insertPublicacion.img = imageData;
        //[persona setValue:fileName forKey:@"nameImg"];
        insertPublicacion.nameImg = finalString;
        [imageData writeToFile:path atomically:YES];
        insertPublicacion.toPersona=persona;
        
        //obtener subsector para la perosona
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSError *error;
        
        //obtenemos la empresa para la que se hace la publicacion
        /*NSEntityDescription *requestEmpresa=[NSEntityDescription entityForName:@"Empresa" inManagedObjectContext:context];
        [fetchRequest setEntity:requestEmpresa];
        //usamos la propiedad persona para obtener su empresa
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"ANY toPersona IN %@",[NSArray arrayWithObject:persona]];
        [fetchRequest setPredicate:predicate];
        
        
        NSArray *fetchedEmpresa=[context executeFetchRequest:fetchRequest error:&error];
        //Creamos la variable empresa y en el for le asignamos la empresa obtenida
        Empresa *empresa;
        for (int i=0; i<[fetchedEmpresa count]; i++) {
            empresa=[fetchedEmpresa objectAtIndex:i];
            //NSLog(@"Empresa: %@",[fetchedSubSector objectAtIndex:i]);
        }*/
        
        
        //Obtenemos el subsector para el cual se realiza la publicacion
        NSEntityDescription *requestSubsector=[NSEntityDescription entityForName:@"Subsector" inManagedObjectContext:context];
        [fetchRequest setEntity:requestSubsector];
        
        
        NSArray *fetchedSubSector=[context executeFetchRequest:fetchRequest error:&error];
        Subsector *subsector;
        for (int i=0; i<[fetchedSubSector count]; i++) {
            Subsector *x=[fetchedSubSector objectAtIndex:i];
            if ([subSector.text isEqualToString:x.nombre]) {
                subsector=[fetchedSubSector objectAtIndex:i];
                //NSLog(@"Subsector: %@",[fetchedSubSector objectAtIndex:i]);
            }

        }
        
        if(![self.link isEqualToString:@""]) {
            insertPublicacion.linkAnexo = self.link;
        }
        
        insertPublicacion.toSubsector=subsector;
        NSLog(@"Subsector Seleccionado: %@",subsector);
        insertPublicacion.status = [[NSNumber alloc] initWithInt:1];
        insertPublicacion.fechaIni = [[NSDate alloc] init];
        BOOL success=[context save:&error];
        if(success==NO || error!=nil){
            NSLog(@"Error al guardar consulta: %@", [error description]);
           

        }else{
            NSLog(@"Datos guardados correctamente");
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"INFORMACION" message:@"Publicación realizada satisfactoriamente" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
               [alert show];
            
            
        }
    }

    self.perfil.delegate=(id)self;
    UINavigationController *navContr = [[UINavigationController alloc] initWithRootViewController:self.perfil];
    navContr.title=@"Perfil";
    [self presentViewController:navContr animated:YES completion:nil];
   
}

- (IBAction)cargarImagen:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
    [self.cargarImagenButton setBackgroundColor:[UIColor blueColor]]; //mejorar el diseño
}



- (IBAction)Recomendar:(id)sender {
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Publicacion" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *datos in fetchedObjects) {
        NSLog(@"Direccion Imagen: %@", [datos valueForKey:@"urlPath"]);
        NSLog(@"Nombre Imagen: %@", [datos valueForKey:@"nameImg"]);
        NSLog(@"");
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent: [datos valueForKey:@"nameImg"] ];
//        UIImage* image = [UIImage imageWithContentsOfFile:path];
//        self.imageView.image = image;
//        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        self.imageView.frame = CGRectMake(120, 140, 80, 80);
//        
//        /*test*/
        NSLog(@"dentro del for");
    }
    NSLog(@"fuera del for");
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UITextField *theTextField = [alertView textFieldAtIndex:0];
    if(buttonIndex == 1) {
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
    }
}

- (IBAction)CargarArchivo:(id)sender {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"IMPORTANTE" message:@"Proporciona un link donde se encuentra tu archivo (Dropbox, Mega, etc). No Olvides poner al principio http:// "  delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"OK", nil];
            alert.alertViewStyle= UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].text = @"http://";
            [alert show];
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
    [self.cargarImagenButton setBackgroundColor:[UIColor whiteColor]];
}

//- (void)insertNewObject:(NSString *)fileName{
//    NSManagedObject *publicacion = [NSEntityDescription
//                                    insertNewObjectForEntityForName:@"Publicacion"
//                                    inManagedObjectContext:º];
//    [publicacion setValue:[self getPath:fileName] forKey:@"urlPath"];
//    [publicacion setValue:[self getImageBinary:fileName] forKey:@"img"];
//    [publicacion setValue:fileName forKey:@"nameImg"];
//    [publicacion setValue:nil forKey:@"descripcion"];
//    [publicacion setValue:nil forKey:@"fecha"];
//    //[publicacion setValue:nil forKey:@"id"];
//    [publicacion setValue:nil forKey:@"titulo"];
//    NSLog(@"insercion realizada");
//    //insert
//    // Save the context.
//    NSError *error = nil;
//    if (![self.context save:&error]) {
//        // Replace this implementation with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    //NSString *direccion = [self getPath:fileName];
//}

-(NSString *)getPath:(NSString *)fileName{
    NSString *root = [[NSBundle mainBundle] bundlePath];
    NSURL *imageURL = [[NSURL alloc] initFileURLWithPath:[root stringByAppendingString:[@"/" stringByAppendingString:fileName]]];
    [imageURL absoluteURL];
    NSString *path= [imageURL absoluteString];
    NSLog(@"%@",path);
    return path;
}

-(NSData *)getImageBinary:(NSString *)fileName{
    NSString *root = [[NSBundle mainBundle] bundlePath];
    NSString *filePath = [[NSString alloc] initWithString:[root stringByAppendingString:[@"/"stringByAppendingString:fileName]]];
    NSLog(@"%@",filePath);
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:[root stringByAppendingString:[@"/"stringByAppendingString:fileName]]];
    NSData *imgData = UIImageJPEGRepresentation(img, 1.0);
    return imgData;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
@end
