//
//  BURegistroViewController.m
//  BrockUs
//
//  Created by HUB 3C 2 on 25/09/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import "BURegistroViewController.h"
#import "Empresa.h"
#import "Persona.h"
#import "Subsector.h"
#import "BUAppDelegate.h"
#import "BUPerfilEmpresaViewController.h"
#import "Sector.h"


//#import "BUValidaciones.h"

@interface BURegistroViewController (){
    NSManagedObjectContext *context;
    Subsector *subsect;
    BOOL *isSector;
    Sector *nombreSector;
    Subsector *nombreSubSector;
}
@property (strong)BULoginViewController *log;
@property (strong)BUPerfilEmpresaViewController * perfil;
@end

@implementation BURegistroViewController
@synthesize selectedText;
@synthesize subSector;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}






- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    //	return 0;
    return [emailTest evaluateWithObject:candidate];
}


//Termino de validar el mail

- (BOOL) validaPass:(NSString *)candidate: (NSString *) pass{
    NSString *passRegex = @"[A-Z0-9a-z]";
    NSPredicate *passTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passRegex];
    //	return 0;
    return [passTest evaluateWithObject:pass];
}

- (BOOL) validaChars:(NSString *) carecteres{
    NSString *passRegex = @"^[a-zA-Z]+(([\\'\\,\\.\\ -][a-zA-Z])?[a-zA-Z]\\s*)*$";
    NSPredicate *passTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passRegex];
    //return 0;
    return [passTest evaluateWithObject:carecteres];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)viewDidLoad
{
    
    scroll.pagingEnabled=YES;
    [scroll setScrollEnabled:YES];
    [scroll setContentSize:CGSizeMake(320, 600)];
    [super viewDidLoad];
      
    // Do any additional setup after loading the view from its nib.
    BUAppDelegate * buappdelegate=[[UIApplication sharedApplication]delegate];
    context =[buappdelegate managedObjectContext];
    
    self.log=[[BULoginViewController alloc] initWithNibName:@"BULoginViewController" bundle:nil];
    self.perfil=[[BUPerfilEmpresaViewController alloc]initWithNibName:@"BUPerfilEmpresaViewController " bundle:nil];
    
    
    NSError *error;
    NSFetchRequest *requestSector = [[NSFetchRequest alloc] init];
    NSEntityDescription *selectSector = [NSEntityDescription
                                         entityForName:@"Sector" inManagedObjectContext:context];
    
    [requestSector setEntity:selectSector];
    
    arraySectores= [context executeFetchRequest:requestSector error:&error];
    
    Sector *sect=[arraySectores objectAtIndex:0];
    
    self.sector.text=sect.nombre;
    self.sector.delegate=self;
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
    
    self.sector.inputView = pickerSectores;
    self.sector.inputAccessoryView = toolbarSectores;
    
    NSFetchRequest *fetchSubsector = [[NSFetchRequest alloc] init];
    
    //obtenemos el subsector para el que se hace la publicacion
    NSEntityDescription *requestSubsector=[NSEntityDescription entityForName:@"Subsector" inManagedObjectContext:context];
    [fetchSubsector setEntity:requestSubsector];
    NSPredicate *predicatesubsector=[NSPredicate predicateWithFormat:@"toSector=%@",sect];
    [fetchSubsector setPredicate:predicatesubsector];
    
    
    arraySubsectores=[context executeFetchRequest:fetchSubsector error:&error];
    
    subsect=[arraySubsectores objectAtIndex:0];
    subSector.text=subsect.nombre;
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

    
    }



//-- UIPickerViewDelegate, UIPickerViewDataSource

-(void)doneClickedSectores:(id) sender
{
    
    [self.sector resignFirstResponder]; //hides the pickerView
    
}
-(void)doneClicked:(id) sender
{
    
    [self.subSector resignFirstResponder]; //hides the pickerView
    
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(isSector){
        nombreSector=[dataArray objectAtIndex:row];
        self.sector.text=nombreSector.nombre;
        [self cargasSubsector];
        
    }else{
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
        nombreSector=[dataArray objectAtIndex:row];
        return nombreSector.nombre;
    }else{
        nombreSubSector=[dataArray objectAtIndex:row];
        return nombreSubSector.nombre;
    }
    
}






- (IBAction)SelecImg:(id)sender {
    
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
    self.Imagen.image = newImage;
    self.Imagen.contentMode = UIViewContentModeScaleAspectFit;
    self.Imagen.frame = CGRectMake(110, 10, 100, 100);
    
//UIImage *DataToImage = [[UIImage alloc] initWithData:imageData];
   // self.Imagen.image = DataToImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    //[self.cargarImagenButton setBackgroundColor:[UIColor whiteColor]];
}

- (IBAction)registrarTapped:(id)sender {
    if([self validar]) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSError *error;
        NSLog(@"Context: %@", context);
        
    

        Empresa *insertaEmpresa =[NSEntityDescription insertNewObjectForEntityForName:@"Empresa" inManagedObjectContext:context];
        Persona *insertaPersona = [NSEntityDescription insertNewObjectForEntityForName:@"Persona" inManagedObjectContext:context];
        
        NSEntityDescription *empresa = [NSEntityDescription
                                       entityForName:@"Empresa" inManagedObjectContext:context];
        
        
        
        NSEntityDescription *sector = [NSEntityDescription
                                       entityForName:@"Subsector" inManagedObjectContext:context];
        
        [fetchRequest setEntity:empresa];
        
        NSArray *fetchedEmpresa = [context executeFetchRequest:fetchRequest error:&error];
    
        
        //insertar imagen en BD
        NSString *stringA = @"/";
        NSString *stringB = self.nombrePersonaTxt.text;
        NSString *stringC = @"-";
        NSString *stringD = self.nombreEmpresaTxt.text;
        NSString *stringE = @".jpg";
        NSString *finalString = [NSString stringWithFormat:@"%@%@%@%@%@", stringA, stringB, stringC, stringD, stringE]; //agregar random
        //NSData *imageData = UIImageJPEGRepresentation(newImage, 1);
        NSData *imageData = UIImageJPEGRepresentation(self.Imagen.image, 1);
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        //path = [path stringByAppendingString:@"/yourLocalImage.jpg"];
        path = [path stringByAppendingString:finalString];
        //NSLog(path);
        
        
        insertaPersona.urlPath = path; //getPath:fileName
        //[persona setValue:[self getImageBinary:fileName] forKey:@"img"];
        insertaPersona.img = imageData;
        //[persona setValue:fileName forKey:@"nameImg"];
        insertaPersona.nameImg = finalString;
        
        [imageData writeToFile:path atomically:YES];
        //insertar imagen en BD
    
        
        insertaEmpresa.nombre=self.nombreEmpresaTxt.text;
        insertaPersona.nombre=self.nombrePersonaTxt.text;
        insertaPersona.puesto=self.puestoPersonaTxt.text;
        insertaPersona.usuario=self.usuarioTxt.text;
        insertaPersona.contrasena=self.contrasenaTxt.text;
        insertaPersona.toEmpresa=insertaEmpresa;
        
        
        [fetchRequest setEntity:sector];
        NSArray *fetchedSector = [context executeFetchRequest:fetchRequest error:&error];
        Subsector *seleccionado;
        
        for (int i=0; i<[fetchedSector count]; i++) {
            Subsector *sector=[fetchedSector objectAtIndex:i];
            NSLog(@"Subsector %@",sector.nombre);
            if([sector.nombre isEqualToString:subSector.text]){
                seleccionado=[fetchedSector objectAtIndex:i];
            }
        }
        
        
            insertaEmpresa.toSubsector=seleccionado;
        
        
        
        
        
        for (NSManagedObject *info in fetchedEmpresa) {
            NSLog(@"Name: %@", [info valueForKey:@"nombre"]);
            NSLog(@"Persona: %@", [info valueForKey:@"toPersona"]);
            NSLog(@"Subsector: %@", [info valueForKey:@"toSubsector"]);
            
        }
        
        BOOL success=[context save:&error];
        if(success==NO || error!=nil){
            NSLog(@"Error al guardar consulta: %@", [error description]);
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Correcto" message:@"Usuario Registrado Procede a Logearte" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alerta show];
            
            self.log.delegate=(id)self;
            [self presentViewController:self.log animated:YES completion:nil ];

        }else{
            NSLog(@"Datos guardados correctamente");
            
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Correcto" message:@"Usuario Registrado Procede a Logearte" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alerta show];
            
            self.log.delegate=(id)self;
            [self presentViewController:self.log animated:YES completion:nil ];
                         
        }

            }
}

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

- (IBAction)logoBtn:(id)sender {
    
}
- (IBAction)prueba:(id)sender {
    
    
}


// Valida todo
- (BOOL)validar {
    if([self entradasVacias]) {
        [self verAlertaError:@" Cajas de texto no deben estar vacias y la contraseña no debe ser menor a 5 caracteres"];
        return NO;
    }
    
    if ([self.contrasenaTxt.text length]<5 || [self.repetirContrasenaTxt.text length]<5) {
        UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Contrasenas no menores a 5 Caracteres" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alerta show];
        return NO;
    }
    
    if([self validateEmail:self.usuarioTxt.text] == 0) {
        [self verAlertaError:@"El formato del usuario debe ser un correo electronico."];
        return NO;
    }
    /*if([self validaPass:self.contrasenaTxt.text]==0){
       [self verAlertaError:@"Contraseña invalida.1"];
        return NO;
    }
    if([self validaPass:self.repetirContrasenaTxt.text]==1){
       [self verAlertaError:@"Contraseña invalida"];
    return NO;
    }*/
    if(![self validaPassConPass]) {
        [self verAlertaError:@"Las contraseñas NO coinciden."];
        return NO;
    }
    
    if ([self existeUsuario]) {
        [self verAlertaError:@"El usuario ya existe."];
        return NO;
    }
    if ([self validaChars:self.nombreEmpresaTxt.text]==0) {
    [self verAlertaError:@"Carecteres No Validos"];
        return NO;
    }
    if([self validaChars:self.nombrePersonaTxt.text]==0){
        [self verAlertaError:@"Caracteres No Validos"];
        return NO;
    }
    if ([self validaChars:self.puestoPersonaTxt.text]==0)
    {[self verAlertaError:@"Caracteres No Validos"];
    return NO;
}
    
    return YES;
}
//Valida Caracteres Invalidos;


- (void) verAlertaError:(NSString *)mensaje {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:mensaje delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

// Valida que las cajas de texto no esten vacias.
- (BOOL) entradasVacias{
    if([self.nombreEmpresaTxt.text isEqualToString:@""]) {
        //[self.nombreEmpresaTxt becomeFirstResponder];
        return YES;
    }
    if([self.nombrePersonaTxt.text isEqualToString:@""]) {
        //[self.nombrePersonaTxt becomeFirstResponder];
        return YES;
    } 
    if([self.puestoPersonaTxt.text isEqualToString:@""]) {
        return YES;
    }
    if([self.usuarioTxt.text isEqualToString:@""]) {
        return YES;
    }
    if([self.contrasenaTxt.text isEqualToString:@""]) {
        return YES;
    }
    if([self.repetirContrasenaTxt.text isEqualToString:@""]) {
        return YES;
    }
    if ([self.subSector.text isEqualToString:@""]) {
        return YES;
        self.subSector.text=subsect.nombre;
    }
    return NO;
}

//Valida que las cajas de texto de las contraseñas sean iguales.
-(BOOL) validaPassConPass {
    if([self.contrasenaTxt.text isEqualToString:self.repetirContrasenaTxt.text]) {
        return YES;
    }
    return NO;
}

//Valida que el usuario introducido no exista en la base de datos
-(BOOL) existeUsuario{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Persona" inManagedObjectContext:context];
    NSFetchRequest *request =[[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"usuario = %@",self.usuarioTxt.text];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *matchinData=[context executeFetchRequest:request error:&error];
    if (matchinData.count > 0)
    {
        return YES;
    }
    return NO;
}

//IMPORTANTE ES PARA OCULTAR EL TECLADO ANTES IR AL XIB Y PONER DID ON EXIT ADEMAS DE EN EL .H PONER EN TU INTERFAZ<UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([textField.text length] == 0) {
        return NO;
    }
    return YES;
}
- (BOOL) validaPass: (NSString *) pass{
    NSString *passRegex = @"^[0-9a-zA-Z]+(([\\'\\,\\.\\ -][a-zA-Z])?[a-zA-Z]\\s*)*$";
    NSPredicate *passTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passRegex];
    //	return 0;
    return [passTest evaluateWithObject:pass];
}
- (IBAction)CancelarTapped:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.4];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    [UIView commitAnimations];
    
  self.log.delegate=(id)self;
    [self presentViewController:self.log animated:YES completion:nil ];
    
}


- (IBAction)sectorClicked:(id)sender {
    isSector=YES;
    dataArray=arraySectores;
    [pickerView reloadAllComponents];
}

- (IBAction)subsectorClicked:(id)sender {
    isSector=NO;
    //filtramos el picker de subsectores segun el sector seleccionado
    dataArray=arraySubsectores;
    [pickerView reloadAllComponents];

}

-(void)cargasSubsector{
    Sector *seleccionado;
    for (int i=0; i<[arraySectores count]; i++) {
        Sector *forsector=[arraySectores objectAtIndex:i];
        if(forsector==nombreSector){
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
    self.subSector.text=s.nombre;

}
@end
