//
//  BUPerfilEmpresaViewController.m
//  BrockUs
//
//  Created by HUB 3C 2 on 25/09/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import "BUPerfilEmpresaViewController.h"
#import "BULoginViewController.h"
#import "BUAppDelegate.h"
#import "BUConsultaPublicacion.h"
#import "Persona.h"
#import "Empresa.h"
#import "BUPublicacionViewController.h"

@interface BUPerfilEmpresaViewController ()
{
    NSManagedObjectContext *context;
}

@property (strong) BULoginViewController *registro;
@property (strong) BURegistroViewController*publicaciones;
@property (strong) Persona *userbrockus;
@property (strong) BUPublicacionViewController *pub;
@end
NSString *userenterprise;
@implementation BUPerfilEmpresaViewController

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
    
    
    BUAppDelegate * buappdelegate=[[UIApplication sharedApplication]delegate];
    context =[buappdelegate managedObjectContext];
    
    
    //[[self UserNameBrockus ] setDelegate:self];
    //[[self PassInputText] setDelegate:self];
    // Do any additional setup after loading the view from its nib.
    
    self.registro=[[BULoginViewController alloc] initWithNibName:@"BULoginViewController" bundle:nil];
    
    self.publicaciones =[[BURegistroViewController alloc] initWithNibName:@"BURegistroViewController" bundle:nil];
    
    
    
    self.pub=[[BUPublicacionViewController alloc] initWithNibName:@"BUPublicacionViewController" bundle:nil];

    BUConsultaPublicacion *consulta=[[BUConsultaPublicacion alloc] init];
    NSString *userStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserBrockus"];
    self.userbrockus = [consulta recuperaPersona:userStr :context];
    NSLog(@"%@",self.userbrockus);
    self.MailUser.text =self.userbrockus.usuario;
    self.EnterpriseUser.text = self.userbrockus.toEmpresa.nombre;
    self.PuestoUser.text = self.userbrockus.puesto;
    self.UserNameBrockus.text = self.userbrockus.nombre;
    if (self.userbrockus.logo != nil) {
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //Here you must return the number of sectiosn you want
      return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    //Here, for each section, you must return the number of rows it will contain
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
   }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     }

- (IBAction)SalirTapped:(id)sender {
    self.registro.delegate=self;
    [self presentViewController:self.registro animated:YES completion:nil];
    
}

- (IBAction)CrearPublicacionBtn:(id)sender {
   // self.publicaciones.delegate=self;
    //[self presentViewController:self.publicaciones animated:YES completion:nil];
    //BURealizaPublicacionViewController *pub=[[BURealizaPublicacionViewController alloc] init];
    // [self presentViewController:pub animated:YES completion:nil];
    self.pub.delegate=self;
    [self presentViewController:self.pub animated:YES completion:nil];

    
    
}



@end
