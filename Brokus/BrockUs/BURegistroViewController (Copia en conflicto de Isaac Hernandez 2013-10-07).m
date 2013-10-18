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
    ComboSector* sector;
    ComboSector* subsector;
    NSArray* sub;
}
@property (strong)BULoginViewController *log;
@property (strong)BUPerfilEmpresaViewController * perfil;
@end

@implementation BURegistroViewController



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
    NSString *passRegex = @"^[a-zA-Z]+(([\\'\\,\\.\\ -][a-zA-Z])?[a-zA-Z]\\s*)*$";
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
    
    sector = [[ComboSector alloc] init];
    [sector setComboData:fetchedSector];
    [self.view addSubview:sector.view];
    sector.view.frame = CGRectMake(10, 450, 302, 31);
    
    }

-(void)cargaSubsector: (NSArray*)array{
    sub=[[NSArray alloc] init];
    sub=array;
}

-(void)viewWillAppear:(BOOL)animated{
    subsector=[[ComboSector alloc]init];
    [subsector setComboData:sub];
    [self.view addSubview:subsector.view];
    subsector.view.frame = CGRectMake(10, 490, 302, 31);
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
            
            self.log.delegate=self;
            [self presentViewController:self.log animated:YES completion:nil ];
                         
        }

            }
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
    /*if([self validaPass:self.contrasenaTxt.text]==1){
       [self verAlertaError:@"Contraseña invalida."];
        return NO;
    }*/
    if([self validaPass:self.repetirContrasenaTxt.text]==0){
       [self verAlertaError:@"Contraseña invalida."];
    return NO;
    }
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
    NSString *passRegex = @"^[a-zA-Z]+(([\\'\\,\\.\\ -][a-zA-Z])?[a-zA-Z]\\s*)*$";
    NSPredicate *passTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passRegex];
    //	return 0;
    return [passTest evaluateWithObject:pass];
}
- (IBAction)CancelarTapped:(id)sender {
    
  self.log.delegate=self;
    [self presentViewController:self.log animated:YES completion:nil ];
    
}
@end
