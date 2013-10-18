//
//  BUPerfilePersonalViewController.m
//  BrockUs
//
//  Created by Nodus9 on 04/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import "BUPerfilePersonalViewController.h"
#import "BUPerfilEmpresaViewController.h"
#import "BUAppDelegate.h"
#import "Persona.h"
#import "Sector.h"
#import "Subsector.h"
#import "Empresa.h"
#import "BUConsultaPublicacion.h"

@interface BUPerfilePersonalViewController (){
    NSManagedObjectContext *context;
}
@property BUPerfilEmpresaViewController *regresar;
@property (strong) Persona *userbrockus;

@end

@implementation BUPerfilePersonalViewController

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
    self.regresar=[[BUPerfilEmpresaViewController alloc]initWithNibName:@"BUPerfilEmpresaViewController" bundle:nil];
    
    
    BUAppDelegate * buappdelegate=[[UIApplication sharedApplication]delegate];
    context =[buappdelegate managedObjectContext];

    
    BUConsultaPublicacion *consulta=[[BUConsultaPublicacion alloc] init];
    NSString *userStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserBrockus"];
    self.userbrockus = [consulta recuperaPersona:userStr :context];
    //NSLog(@"%@",self.userbrockus);
    if (self.userbrockus.usuario != nil) {
        self.NombrePersonaLabel.text =self.userbrockus.usuario;
    }
    //self.NombrePersonaLabel.text =self.userbrockus.usuario;
    if (self.userbrockus.toEmpresa.nombre != nil) {
        self.EmpresaLabel.text = self.userbrockus.toEmpresa.nombre;
    }
    //self.EmpresaLabel.text = self.userbrockus.toEmpresa.nombre;
    if (self.userbrockus.puesto != nil) {
        self.puestoPersonaLabel.text = self.userbrockus.puesto;
    }
    //self.puestoPersonaLabel.text = self.userbrockus.puesto;
    if (self.userbrockus.nombre != nil) {
        self.CorreoLabel.text = self.userbrockus.nombre;
    }
    //self.CorreoLabel.text = self.userbrockus.nombre;
    if (self.userbrockus.toEmpresa.toSubsector.toSector.nombre != nil) {
        self.PersonaSectorLabel.text = self.userbrockus.toEmpresa.toSubsector.toSector.nombre;
    }
    //self.PersonaSectorLabel.text = self.userbrockus.toEmpresa.toSubsector.toSector.nombre;
    if (self.userbrockus.toEmpresa.toSubsector.nombre != nil) {
        self.PersonaSubsectorLabel.text=self.userbrockus.toEmpresa.toSubsector.nombre;
    }
    //self.PersonaSubsectorLabel.text=self.userbrockus.toEmpresa.toSubsector.nombre;
    if (self.userbrockus.img != nil) {
        self.ImagePerfil.image = [[UIImage alloc] initWithData:self.userbrockus.img];
    }
    self.title = self.userbrockus.nombre;
   // self.listaPublicaciones = [[NSArray alloc] init];
    //self.listaPublicaciones = [consulta recuperaPublicacionPorEmpresa:self.userbrockus.toEmpresa toContext:context];
    //NSLog(@"Registros: %d",[self.listaPublicaciones count]);*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)AgregarMisCirculos:(id)sender {
      NSLog(@"hdjfhdjf");
}

- (IBAction)EnviarMensaje:(id)sender {
      NSLog(@"hdjfhdjf");
}

- (IBAction)salir:(id)sender {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    [UIView commitAnimations];
    self.regresar.delegate =(id)self;
    UINavigationController *navContr = [[UINavigationController alloc] initWithRootViewController:self.regresar];
    [self presentViewController:navContr animated:YES completion:nil];
    NSLog(@"regresar al perfil");
}
@end
