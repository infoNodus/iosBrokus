//
//  BUPublicacionViewController.m
//  BrockUs
//
//  Created by Nodus9 on 04/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.


#import "BUPublicacionViewController.h"
#import "BUPerfilEmpresaViewController.h"
#import "BUInvitarPersonaViewController.h"
#import "BUMuroPublicacionesViewController.h"
#import "BUAppDelegate.h"
#import "Publicacion.h"
#import "Subsector.h"
#import "BUConsultaPublicacion.h"
#import "Sector.h"

@interface BUPublicacionViewController(){
    
    NSManagedObjectContext *context; //asigna el contexto para usarlo posteriormente
    Subsector *subsect; //se declara la variable del subsector para utilizarla posteriormente
    BOOL *isSector; //se declara la variable booleana del subsector para utilizarla posteriormente y con esta poder saber de que tipo de sector es
    Sector *nombreSector; //se declara la variable sector para utilizarla posteriormente
    Subsector *nombreSubSector; //se declara la variable subsector para utilizarla posteriormente

}

@property (strong) BUPublicacionViewController *mostrarpublicacion; //propiedad para acceder al controlador de mostrar las publicaciones.
@property (nonatomic, retain) NSManagedObjectContext *context; //asigna el contexto para usarlo posteriormente
@property (strong) BUPerfilEmpresaViewController *pub; //propiedad para acceder al controlador del perfil de la empresa donde se muestran las publicaciones realizadas
@property (strong) BUPerfilEmpresaViewController *perfil; //propiedad para acceder al controlador del perfil de la empresa
@property (strong) BUMuroPublicacionesViewController *muro;//propiedad para acceder al controlador del muro de publicaciones
@property (strong) NSString* link; //propiedad para almacenar los datos del link para los anexos
@property (strong, nonatomic) IBOutlet UIBarButtonItem *oAceptar; //propiedad para declarar el botón de aceptar

@end


@implementation BUPublicacionViewController
@synthesize selectedText; //permite indicarle a Xcode que auto genere los get y set del texto seleccionado
@synthesize subSector;  //permite indicarle a Xcode que auto genere los get y set del subsector
@synthesize comboSector; //permite indicarle a Xcode que auto genere los get y set del sector
@synthesize sectorSeleccionado; //permite indicarle a Xcode que auto genere los get y set del sector seleccionado
@synthesize date; //permite indicarle a Xcode que auto genere los get y set de la fecha



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Nueva publicacón"; //Asigna el titulo a la sección
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = self.oAceptar;
    
    BUAppDelegate * buappdelegate=[[UIApplication sharedApplication]delegate]; //inicializa una instancia del appdelegate
    context =[buappdelegate managedObjectContext]; //asigna el contexto actual

    self.muestrafecha =[[UILabel alloc] init]; //inicializa la variable muestra fecha
    self.mostrarpublicacion = [[BUPublicacionViewController alloc]initWithNibName:@"BUPublicacionViewController" bundle:nil];//asigna una instancia del controlador para mostrar las publicaciones
    self.perfil=[[BUPerfilEmpresaViewController alloc] initWithNibName:@"BUPerfilEmpresaViewController" bundle:nil];//asigna una instancia del controlador para mostrar el perfil de la empresa
 
    self.muro=[[BUMuroPublicacionesViewController alloc]initWithNibName:@"BUMuroPublicacionesViewController" bundle:nil];//asigna una instancia del controlador para mostrar el muro de las publicaciones
    
    
    self.context = [self context];
    
    if (self.context == nil)
    {
        self.context = [(BUAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }

    
    self.DescripcionTxt.text=@"";//se utiliza para limpiar automáticamente el campo de la descripción de la publicación
    
    
    NSError *error;
    NSFetchRequest *requestSector = [[NSFetchRequest alloc] init];
    NSEntityDescription *selectSector = [NSEntityDescription
                                         entityForName:@"Sector" inManagedObjectContext:self.context];//determinamos la tabla de la que obtendremos la información
    
    [requestSector setEntity:selectSector];
    
    arraySectores= [self.context executeFetchRequest:requestSector error:&error];//se ejecuta la consulta y se guarda en un array
    
    
    Sector *sect=[arraySectores objectAtIndex:0];
    self.sector.text=sect.nombre;// se asigna el nombre del primer objeto del vector a la caja de texto
    self.sector.delegate=self;
    pickerSectores = [[UIPickerView alloc] init];
    pickerSectores.showsSelectionIndicator = YES;
    pickerSectores.dataSource = self;
    pickerSectores.delegate = self;
    
    //se crea un boton para mostrar en la caja de texto de sectores
    UIToolbar* toolbarSectores = [[UIToolbar alloc] init];
    toolbarSectores.barStyle = UIBarStyleBlackTranslucent;
    [toolbarSectores sizeToFit];
    
    //Se hace el botón done alineado a la derecha
    UIBarButtonItem *flexibleSpaceLeftSectores = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //Se asigna etiqueta y metodo qu se ejucatara al dar click sobre el boton
    UIBarButtonItem* aceptar = [[UIBarButtonItem alloc] initWithTitle:@"Aceptar"
                                                                style:UIBarButtonItemStyleDone target:self
                                                               action:@selector(doneClickedSectores:)];
    
    
    [toolbarSectores setItems:[NSArray arrayWithObjects:flexibleSpaceLeftSectores, aceptar, nil]];
    
    //custom input view
    
    self.sector.inputView = pickerSectores;
    self.sector.inputAccessoryView = toolbarSectores;
    
    
    NSFetchRequest *fetchSubsector = [[NSFetchRequest alloc] init]; //seleccionamos la tabla de la base de datos.
    
    //obtenemos el subsector para el que se hace la publicacion
    NSEntityDescription *requestSubsector=[NSEntityDescription entityForName:@"Subsector" inManagedObjectContext:context];
    [fetchSubsector setEntity:requestSubsector]; //obtenemos el resultado de la consulta
    NSPredicate *predicatesubsector=[NSPredicate predicateWithFormat:@"toSector=%@",sect];
    [fetchSubsector setPredicate:predicatesubsector]; //La clase NSPredicate se utiliza para definir las condiciones lógicas utilizadas para restringir la busqueda del subsector o para hacer el filtrado.
    
    
    arraySubsectores=[context executeFetchRequest:fetchSubsector error:&error];//se ejecuta la consulta y se almacena en un array
    subsect=[arraySubsectores objectAtIndex:0];
    subSector.text=subsect.nombre;//se coloca el nombre del subsector al textfield
    
    subSector.delegate=self;//se le asigna el valor del subsector al delegate
    pickerView = [[UIPickerView alloc] init]; //se inicializa el picker para asignar los datos del subsector al picker
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    UIToolbar* toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [toolbar sizeToFit];
    
    //pone el boton done alineado a la derecha
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //Se asigna etiqueta y metodo qu se ejucatara al dar click sobre el boton
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Aceptar"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneClicked:)];
    
    
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
    //se agrega el picker y el boton al textview
    
    subSector.inputView = pickerView;
    subSector.inputAccessoryView = toolbar;
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
    
    NSDate *currentTime = [NSDate dateWithTimeIntervalSinceNow:100000];//se obtiene la fecha actual pero con un día mas para poner la fecha limite
    [datePicker setMinimumDate:currentTime];
    [datePicker setMaximumDate:[currentTime dateByAddingTimeInterval:400000]];//fecha maxima de publicacion(5 dias)
    
    
    [datetoolbar setItems:[NSArray arrayWithObjects:dateflexibleSpaceLeft, doneDateButton, nil]];
    

    
    date.inputView = datePicker;
    date.inputAccessoryView = datetoolbar;
    
    
}
-(void)doneClickedDate:(id) sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];//se inicializa el formato de la fecha
    [df setDateFormat:@"MM/dd/yyyy"];//se declara el tipo de formato de la fecha
    date.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];//se coloca la fecha obtenida al campo de texto de fecha
    [date resignFirstResponder]; //Oculta el Pickerview de la fecha
    
}



//-- UIPickerViewDelegate, UIPickerViewDataSource

-(void)doneClickedSectores:(id) sender
{
    
    [self.sector resignFirstResponder]; //oculta el pickerView del sector
    
}
-(void)doneClicked:(id) sender
{
    
    [self.subSector resignFirstResponder]; //oculta el pickerView del subsector
    
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(isSector){
        //se obtiene el sector del array y se asigna el nombre a la caja de texto
        nombreSector=[dataArray objectAtIndex:row];
        self.sector.text=nombreSector.nombre;
        [self cargarSubsector];
        
    }else{
        //se obtiene el subsector del array y se asigna el nombre a la caja de texto
        nombreSubSector=[dataArray objectAtIndex:row];
        self.subSector.text =nombreSubSector.nombre;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [dataArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    if(isSector){
        nombreSector=[dataArray objectAtIndex:row];//asigna el nombre del sector a la columna
        return nombreSector.nombre;//regresa el nombre del sector
    }else{
        nombreSubSector=[dataArray objectAtIndex:row];//asigna el nombre del subsector a la columna
        return nombreSubSector.nombre; //regresa el nombre del subsector
    }
    
}




//ocultar teclado cuando estas escribiendo en un textfield
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

// Valida que las cajas de texto no esten vacias.
- (BOOL) entradasVacias{
    if([self.tituloTxt.text isEqualToString:@""]) {
        return YES;
    }
    if([self.DescripcionTxt.text isEqualToString:@""]) {
        return YES;
    }
    if([self.date.text isEqualToString:@""]) {
        return YES;
    }
    if([self.comboSector.text isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

- (void) alertaerror:(NSString *)mensaje {//muestra un mensaje de error
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:mensaje delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}
//Validacion de texto vacio
-(BOOL)validar{
    if ([self entradasVacias]) {
        [self alertaerror:@" Cajas de texto no deben estar vacias"];
        return NO;
}
}
  
- (IBAction)Aceptar:(id)sender{
    if ([self validar]) {
        BUConsultaPublicacion *consulta = [[BUConsultaPublicacion alloc] init];//selecciona la tabla de la cual se hará la consulta
        Persona *persona = [consulta recuperaPersona:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserBrockus"] :context];//se recuperan datos de la persona que actualmente usa la app
        Publicacion *insertPublicacion=[NSEntityDescription insertNewObjectForEntityForName:@"Publicacion" inManagedObjectContext:context];//inserta una nueva publicación
        
        //Valida que el titulo y la descripción de la publicación no esten vacios
        if([_tituloTxt.text length]==0 || [_DescripcionTxt.text length]==0)
        {
            UIAlertView *vacio=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Llene el título o la descripción" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [vacio show];
            self.tituloTxt.clearButtonMode=YES;
            
        
        //Valida que el titulo tenga como máximo 60 caracteres.
        }else if ([_tituloTxt.text length]>60)
        {
            UIAlertView *descriplarga=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Título demasiado largo" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [descriplarga show];
            self.tituloTxt.clearButtonMode=YES;
        }
       ///
        else{
            insertPublicacion.descripcion=self.DescripcionTxt.text;//se obtiene la descripción que escribio el usuario para guardarse en la tabla
            insertPublicacion.titulo=self.tituloTxt.text;//se obtiene el título de la publicación que escribió el usuario para guardarse en la tabla
            
            //inserta la fecha
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
            insertPublicacion.urlPath = path; //inserta la url del archivo o anexo
            insertPublicacion.img = imageData;//guarda la imagen en la tabla
            insertPublicacion.nameImg = finalString;//inserta el nombre de la imagen
            [imageData writeToFile:path atomically:YES];
            insertPublicacion.toPersona=persona;//asigna la imagen al usuario
            
            //obtener subsector para la persona
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
            //guarda la url del anexo a la base de datos
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
                //Mensage de datos correctos
                NSLog(@"Datos guardados correctamente");
                UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"INFORMACION" message:@"Publicación realizada satisfactoriamente" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
                
            }
        }
        
        self.perfil.delegate=(id)self;
        UINavigationController *navContr = [[UINavigationController alloc] initWithRootViewController:self.perfil];
        navContr.title=@"Perfil";//se le asigna el título a la sección
        [self presentViewController:navContr animated:YES completion:nil];
        
    }

    }
    
- (IBAction)cargarImagen:(id)sender {//se le asigna al botón de cargar imagen el código para guardar la imagen en la tabla
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
    [self.cargarImagenButton setBackgroundColor:[UIColor blueColor]]; //mejorar el diseño
}



- (IBAction)Recomendar:(id)sender {//este botón aun no tiene ninguna acción
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


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {//se crea un input text dentro del alertview, asi como también válida que al principio comiencen todos los links con http://
    
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
        self.link = theTextField.text;//guarda la url del anexo en la tabla
    }
}

- (IBAction)CargarArchivo:(id)sender {//Muestra un mensage de alerta antes de escribir la url del link
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"IMPORTANTE" message:@"Proporciona un link donde se encuentra tu archivo (Dropbox, Mega, etc). No Olvides poner al principio http:// "  delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"OK", nil];
            alert.alertViewStyle= UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].text = @"http://";
            [alert show];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {//escalación de la imagen, para ver el tamaño que sea correcto
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

-(NSString *)getPath:(NSString *)fileName{//implementación del método getpath
    NSString *root = [[NSBundle mainBundle] bundlePath];
    NSURL *imageURL = [[NSURL alloc] initFileURLWithPath:[root stringByAppendingString:[@"/" stringByAppendingString:fileName]]];
    [imageURL absoluteURL];
    NSString *path= [imageURL absoluteString];
    NSLog(@"%@",path);
    return path;
}

-(NSData *)getImageBinary:(NSString *)fileName{//implementación del método getImageBinary
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
- (IBAction)subsectorClicked:(id)sender {
    isSector=NO;
    //filtramos el picker de subsectores segun el sector seleccionado
    dataArray=arraySubsectores;
    [pickerView reloadAllComponents];
}
- (IBAction)sectorClicked:(id)sender {
    isSector=YES;
    //filtramos el picker de sectores segun el subsector seleccionado
    dataArray=arraySectores;
    [pickerView reloadAllComponents];
}

-(void)cargarSubsector{//método para guardar el subsector en la base de datos
    Sector *seleccionado;
    for (int i=0; i<[arraySectores count]; i++) {
        Sector *forsector=[arraySectores objectAtIndex:i];
        if([forsector.nombre isEqualToString:self.sector.text]){
            seleccionado=[arraySectores objectAtIndex:i];
        }
    }
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];//seleccionamos la tabla
    NSEntityDescription *selectSubSector = [NSEntityDescription
                                            entityForName:@"Subsector" inManagedObjectContext:context];//realizamos el select de la tabla
    
    [fetchRequest setEntity:selectSubSector];//se obtiene el resultado de la consulta
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"toSector = %@",seleccionado];
    [fetchRequest setPredicate:predicate];
    
    arraySubsectores= [context executeFetchRequest:fetchRequest error:&error];//se selecciona y se guarda la consulta en un array
    Subsector *s=[arraySubsectores objectAtIndex:0];
    self.subSector.text=s.nombre;
    
}
@end
