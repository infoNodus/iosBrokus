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
#import "ComboSector.h"


//#import "BUValidaciones.h"

@interface BURegistroViewController (){
    NSManagedObjectContext *context;
    NSString *cadena;
    NSArray* sub;
}
@property (strong)BULoginViewController *log;
@property (strong)BUPerfilEmpresaViewController * perfil;
@end

@implementation BURegistroViewController
@synthesize selectedText;
@synthesize subSector;
@synthesize comboSector;
@synthesize sectorSeleccionado;



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
    
    NSArray *fetchedSector= [context executeFetchRequest:requestSector error:&error];
    
    sectorSeleccionado = [[ComboSector alloc] init];
    [sectorSeleccionado setComboData:fetchedSector];
    [self.view addSubview:sectorSeleccionado.view];
    sectorSeleccionado.view.frame = CGRectMake(10, 440, 302, 31);
    
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)aTextField
{
    
    sub=[[NSArray alloc]init];
    cadena=sectorSeleccionado.selectedText;
    sub=[sectorSeleccionado loadSubsector:cadena];
    for (int i=0; i<[sub count]; i++) {
        Subsector *sect=[sub objectAtIndex:i];
        //NSLog(@"SUBSECTORES A MOSTRAR %@",sect.nombre);
    }
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
    
//    UIImage *DataToImage = [[UIImage alloc] initWithData:imageData];
//    self.Imagen.image = DataToImage;
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
            if([sector.nombre isEqualToString:@"Edificacion no residencial"]){
                seleccionado=[fetchedSector objectAtIndex:i];
                NSLog(@"SELECCIONADO: %@",seleccionado);
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
        [self verAlertaError:@"Las cajas de texto no deben estar vacias."];
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
@end
