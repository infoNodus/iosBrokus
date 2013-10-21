//
//  BULoginViewController.m
//  BrockUs
//
//  Created by HUB 3C 2 on 25/09/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import "BULoginViewController.h"
#import "BUAppDelegate.h"
#import "BUPerfilEmpresaViewController.h"
#import "BURegistroViewController.h"
#import "BUConsultaPublicacion.h"

@interface BULoginViewController (){
    NSManagedObjectContext *context;
}
@property (strong) BUPerfilEmpresaViewController *perfil; //propiedad para acceder al controlador del perfil de la empresa
@property (strong) BURegistroViewController *registro; //propiedad para acceder al controlador del registro
@property (strong)BULoginViewController *log; //propiedad para acceder al controlador de login

@end

@implementation BULoginViewController

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
    [[self UsertInputText ] setDelegate:self];//inicializar el campo de texto para el login del user
    [[self PassInputText] setDelegate:self];//inicializar el campo de  Contraseña para la constraseña del user
    
    
    BUAppDelegate * buappdelegate=[[UIApplication sharedApplication]delegate];//Se inicializa una instancia del appdelegate
    context =[buappdelegate managedObjectContext];//asignación del contexto actual
    
    BUConsultaPublicacion *consulta = [[BUConsultaPublicacion alloc] init];//Se inicializa una instancia del BUConsulta
    [consulta desactivaPublicacionesCaducadastoContext:context];//asignación del contexto actual
    
    self.perfil=[[BUPerfilEmpresaViewController alloc] initWithNibName:@"BUPerfilEmpresaViewController" bundle:nil];
    self.registro=[[BURegistroViewController alloc] initWithNibName:@"BURegistroViewController" bundle:nil];
    
}

//IMPORTANTE ES PARA OCULTAR EL TECLADO ANTES IR AL XIB Y PONER DID ON EXIT ADEMAS DE EN EL .H PONER EN TU INTERFAZ<UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([_UsertInputText.text length] == 0) {
        return NO;
    }
    return YES;
}
//funcion que ayuda ak LoginBtnTapped a validar si el emailingresaod es un mail correcto
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    //	return 0;
    return [emailTest evaluateWithObject:candidate];
}


//Termino de validar el mail

- (BOOL) validaPass: (NSString *) pass{
    NSString *passRegex = @"^[a-zA-Z]+(([\\'\\,\\.\\ -][a-zA-Z])?[a-zA-Z]\\s*)*$";
    NSPredicate *passTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passRegex];
    //	return 0;
    return [passTest evaluateWithObject:pass];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LoginBtnTapped:(id)sender {
    //inicia la validacion del usuario ke si sea un email valido ke si sea password valida formato de caracteres etc...
    if ([_UsertInputText.text length]==0 && [_PassInputText.text length]==0 )
    {
        UIAlertView *vacio = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Llene Campo Email y Password" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [vacio show];
        self.UsertInputText.clearButtonMode=YES;
        self.UsertInputText.clearsOnBeginEditing=YES;
        
    }
    
    else if ([_UsertInputText.text length]!=0 && [_PassInputText.text length]==0  )
    {
        if ([self validateEmail:[_UsertInputText.self text]] ==1)
        {
            UIAlertView *passfal = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Llene Campo Password" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [passfal show];
            self.UsertInputText.clearButtonMode=YES;
            self.UsertInputText.clearsOnBeginEditing=YES;
        }
        else if([self validateEmail:[_UsertInputText.self text]]==0)
        {
            UIAlertView *usermal = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error en Formato de Email y Llene Campo Password" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [usermal show];
            self.UsertInputText.clearButtonMode=YES;
            self.UsertInputText.clearsOnBeginEditing=YES;
        }
    }
    else if ([_UsertInputText.text length]==0 && [_PassInputText.text length]!=0  )
    {
        if ([self validaPass:[_PassInputText.self text]] ==1)
        {
            UIAlertView *passfal = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Llene Campo Email" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [passfal show];
            self.UsertInputText.clearButtonMode=YES;
            self.UsertInputText.clearsOnBeginEditing=YES;
        }
        else if ([self validaPass:[_PassInputText.self text]]==0)
        {
            UIAlertView *usermal = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error en Formato de Contraseña y Llene Campo Email" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [usermal show];
            self.UsertInputText.clearButtonMode=YES;
            self.UsertInputText.clearsOnBeginEditing=YES;
        }
        
    }
    else if ([_UsertInputText.text length]!=0 && [_PassInputText.text length]!=0  )
    {
        if (([self validateEmail:[_UsertInputText.self text]] ==1) && [self validaPass:[_PassInputText.self text]]==0) //si valida pass es igual a 0 es correcto si es 1 es incorrrecto
        {
            self.UsertInputText.clearButtonMode=YES;
            self.UsertInputText.clearsOnBeginEditing=YES;
            
            //     self.registro.delegate=self;
            //   [self presentViewController:self.registro animated:YES completion:nil];
            
            
            self.ErrrorLabel.text =@"Espere Un Momento Por Favor";
            self.UsertInputText.clearButtonMode=NO;
            self.UsertInputText.clearsOnBeginEditing=NO;
            
            NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Persona" inManagedObjectContext:context];
            NSFetchRequest *request =[[NSFetchRequest alloc]init];
            [request setEntity:entityDesc];
            
            
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"usuario like %@ and contrasena like %@",self.UsertInputText.text, self.PassInputText.text];
            //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"usuario = %@", self.UsertInputText.text];
            [request setPredicate:predicate];
            
            NSError *error;
            NSArray *matchinData=[context executeFetchRequest:request error:&error];
            
            if (matchinData.count <= 0)
            {
                self.ErrrorLabel.hidden=NO;
                self.ErrrorLabel.text=@"Error en Usuario o Contraseña";
                // UIAlertView *usermal = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Usuario ò Passowrd  Incorrecta" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                //[usermal show];
                //UIAlertView *ise=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Al Parecer no Estas Registrado, Espera..." delegate:self cancelButtonTitle:@"Registrarme" otherButtonTitles:@"Reintentar", nil];
                
                //[ise show];
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Mensaje" message:@"Al Parecer no estas Registrado o Introduciste mal los Datos" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Registrarse",nil];
                [alert setTag:1];
                [alert show];
            }
            else
            {
                NSString *usuario;
                NSString *contrasena;
                for (NSManagedObject *obj in matchinData) {
                    usuario=[obj valueForKey:@"usuario"];
                    contrasena=[obj valueForKey:@"contrasena"];
                    
                    
                    
                    if (_PassInputText.text ==contrasena) {
                        self.ErrrorLabel.hidden=NO;
                        self.ErrrorLabel.text=@"Password Incorrecta";
                    }
                    else{
                        self.ErrrorLabel.hidden=NO;
                        self.ErrrorLabel.text=@"Usuario Correcto Iniciando";
                        UIAlertView *usermal = [[UIAlertView alloc] initWithTitle:@"Correcto" message:@"Iniciando..." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                        [usermal show];
                        
                        [[NSUserDefaults standardUserDefaults] setValue:self.UsertInputText.text forKey:@"UserBrockus"];
                        
                        [UIView beginAnimations:nil context:NULL];
                        [UIView setAnimationDuration:1];
                        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
                        [UIView commitAnimations];
                        
                        self.perfil.delegate=(id)self;
                        UINavigationController *navContr = [[UINavigationController alloc] initWithRootViewController:self.perfil];
                        navContr.title=@"Perfil";
                        [self presentViewController:navContr animated:YES completion:nil];
                        
                    }
                }
            }
            
  }
        else if (([self validateEmail:[_UsertInputText.self text]] ==0) && [self validaPass:[_PassInputText.self text]]==1)
        {
            UIAlertView *usermal = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Formato de Email Invalido" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [usermal show];
            self.UsertInputText.clearButtonMode=YES;
            self.UsertInputText.clearsOnBeginEditing=YES;
            
        }
        else  if (([self validateEmail:[_UsertInputText.self text]] ==1) && [self validaPass:[_PassInputText.self text]]==1) //Si todo es correcto aki se envia la validacion a
        {
            self.ErrrorLabel.text =@"Espere Un Momento Por Favor";
            self.UsertInputText.clearButtonMode=NO;
            self.UsertInputText.clearsOnBeginEditing=NO;
            
            NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Persona" inManagedObjectContext:context];
            NSFetchRequest *request =[[NSFetchRequest alloc]init];
            [request setEntity:entityDesc];
            
            
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"usuario like %@ and contrasena like %@",self.UsertInputText.text, self.PassInputText.text];
            [request setPredicate:predicate];
            
            NSError *error;
            NSArray *matchinData=[context executeFetchRequest:request error:&error];
            
            if (matchinData.count <= 0)
            {
                self.ErrrorLabel.hidden=NO;
                self.ErrrorLabel.text=@"Error en Usuario o Contraseña";
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Mensaje" message:@"Al Parecer no estas Registrado o Introduciste mal los Datos" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Registrarse",nil];
                [alert setTag:1];
                [alert show];
                }
            else
            {
                NSString *usuario;
                NSString *contrasena;
                for (NSManagedObject *obj in matchinData) {
                    usuario=[obj valueForKey:@"usuario"];
                    contrasena=[obj valueForKey:@"contrasena"];
                    
                    
                    
                    if (_PassInputText.text ==contrasena) {
                        
                        
                        self.ErrrorLabel.hidden=NO;
                    }
                    else{
                        
                        // self.ErrrorLabel.text=[NSString stringWithFormat:@"user: %@, password:%@",usuario,contrasena];
                        
                        //  user=usuario;
                        self.ErrrorLabel.hidden=NO;
                        self.ErrrorLabel.text=@"Usuario Correcto Iniciando";
                        UIAlertView *usermal = [[UIAlertView alloc] initWithTitle:@"Correcto" message:@"Iniciando..." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                        [usermal show];
                        
                        [[NSUserDefaults standardUserDefaults] setValue:self.UsertInputText.text forKey:@"UserBrockus"];
                        
                        
                        [UIView beginAnimations:nil context:NULL];
                        [UIView setAnimationDuration:1];
                        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
                        [UIView commitAnimations];
                        
                        
                        self.perfil.delegate=(id)self;
                        UINavigationController *navContr = [[UINavigationController alloc] initWithRootViewController:self.perfil];
                        navContr.title=@"Perfil";
                        
                        // self.navigationItem.leftBarButtonItem = self.btnSalir;
                        // self.navigationItem.rightBarButtonItem = self.btnCrearPublicacion;
                        self.title = @"Perfil";
                        
                        
                        [self presentViewController:navContr animated:YES completion:nil];
                        
                    }
                }
            }
        }
        
    }
       //Termina validacion de email correcto y datos llenos enlos textfield
    
}





//objeto ke se comunica cuando un usuario no esta registrado o a introducido mal su password
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex

{
    //si el user introduce mal su password se muestra el mensaje y si presiona en cancelar se da otro oportunidad de ke el user
    //ingrese bien su user y password
    if (buttonIndex ==0) {
        NSLog(@"Cancelar: %i, was pressed.", buttonIndex);
    }
    //si el user no esta registrado se le dice ke se registre y se envia al xib de registro de usuarios
    else if (buttonIndex==1){
        NSLog(@"Registrar: %i, was pressed.", buttonIndex);
        self.registro.delegate=(id)self;//se denota ake xib se e va a enviar
        [self presentViewController:self.registro animated:YES completion:nil]; //procede a acer la transsion de pantalla al enviar al usuario
// al xib de registro
    }
    
}
//Objeto ke da acceso al registro del usuario para despues ser logeado
- (IBAction)RegisterBtnTapped:(id)sender {
    
    //////////////////////////////////////////
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [UIView commitAnimations];
    ////Estas Lineas de codigo especifican una animacion al acer cambio de xib
    //cabe señalar ke la linea mas siginificativa es    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    //en la propiedad setAnimationTransicition: y los sig son los tipos de animacion ke se pueden escoger ke son de uivviewtransitionanimation-animacion a selecionar
    
    
    self.registro.delegate=(id)self;//mediante el delegate ya declarado en el .m del xib del registro
    [self presentViewController:self.registro animated:YES completion:nil]; //y con esto procedemos a pasar al sig xib con transicion animada al .xib BURegistroViewController
    
    
}
@end
