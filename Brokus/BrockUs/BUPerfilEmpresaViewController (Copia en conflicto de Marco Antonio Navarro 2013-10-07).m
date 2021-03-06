//
//  BUPerfilEmpresaViewController.m
//  BrockUs
//
//  Created by HUB 3C 2 on 25/09/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import "BUMinVistaViewController.h"
#import "BUPerfilEmpresaViewController.h"
#import "BULoginViewController.h"
#import "BUAppDelegate.h"
#import "BUConsultaPublicacion.h"
#import "Persona.h"
#import "Empresa.h"
#import "Sector.h"
#import "Subsector.h"
#import "Publicacion.h"
#import "BUPublicacionViewController.h"
#import "BUDetallePublicacionViewController.h"

@interface BUPerfilEmpresaViewController ()
{
    NSManagedObjectContext *context;
}

@property (strong) BULoginViewController *registro;
@property (strong) BURegistroViewController*publicaciones;
@property (strong) Persona *userbrockus;
@property (strong) BUPublicacionViewController *pub;
@property (strong) NSArray *listaPublicaciones;
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
        self.ImageUser.image = [[UIImage alloc] initWithData:self.userbrockus.logo];
    }
    self.listaPublicaciones = [[NSArray alloc] init];
    self.listaPublicaciones = [consulta recuperaPublicacionPorEmpresa:self.userbrockus.toEmpresa toContext:context];
    NSLog(@"Registros: %d",[self.listaPublicaciones count]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)verperfil:(id)sender {
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
    //self.pub.delegate=self;
    [self presentViewController:self.pub animated:YES completion:nil];
}

#pragma mark - TableViewController methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listaPublicaciones count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //5
    static NSString *cellIdentifier = @"publicacionCell";
    
    BUMinVistaViewController *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BUMinVistaViewController" owner:self
                                            options:nil] lastObject];
    }
    Publicacion *publicacion = self.listaPublicaciones[indexPath.row];
    
    cell.txtDescripcion.text = publicacion.descripcion;
    cell.txtTitulo.text = publicacion.titulo;
    cell.txtSector.text = publicacion.toSubsector.toSector.nombre;
    if(publicacion.img != nil) {
        cell.imgImagen.image = [[UIImage alloc] initWithData:publicacion.img];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BUDetallePublicacionViewController *detalle = [[BUDetallePublicacionViewController alloc] initWithPublicacion:self.listaPublicaciones[indexPath.row]];
    [self.navigationController pushViewController:detalle animated:YES];
    
}


@end
