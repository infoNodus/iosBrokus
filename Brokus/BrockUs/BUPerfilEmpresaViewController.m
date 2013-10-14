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
#import "BUPerfilePersonalViewController.h"
#import "BUCirculoConfianzaViewController.h"
#import "BUSeccionPublicacionesViewController.h"


@interface BUPerfilEmpresaViewController ()
{
    NSManagedObjectContext *context;
}

@property (strong) BULoginViewController *registro;
@property (strong) BURegistroViewController*publicaciones;
@property (strong) Persona *userbrockus;
@property (strong) BUPublicacionViewController *pub;
@property (strong) NSArray *listaPublicaciones;
@property (strong)BUPerfilEmpresaViewController *miperfil;
@property (strong) BUCirculoConfianzaViewController *circulo;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnCrearPublicacion;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnSalir;

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
    self.navigationItem.leftBarButtonItem = self.btnSalir;
    self.navigationItem.rightBarButtonItem = self.btnCrearPublicacion;
    self.title = @"Perfil";
    
    BUAppDelegate * buappdelegate=[[UIApplication sharedApplication]delegate];
    context =[buappdelegate managedObjectContext];
    
    
    //[[self UserNameBrockus ] setDelegate:self];
    //[[self PassInputText] setDelegate:self];
    // Do any additional setup after loading the view from its nib.
    
    self.registro=[[BULoginViewController alloc] initWithNibName:@"BULoginViewController" bundle:nil];
    
    self.publicaciones =[[BURegistroViewController alloc] initWithNibName:@"BURegistroViewController" bundle:nil];

    self.miperfil=[[BUPerfilePersonalViewController alloc]initWithNibName:@"BUPerfilePersonalViewController" bundle:nil];
    
    self.pub=[[BUPublicacionViewController alloc] initWithNibName:@"BUPublicacionViewController" bundle:nil];
    
    
    
    self.circulo=[[BUCirculoConfianzaViewController alloc] initWithNibName:@"BUCirculoConfianzaViewController" bundle:nil];

    BUConsultaPublicacion *consulta=[[BUConsultaPublicacion alloc] init];
    NSString *userStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserBrockus"];
    self.userbrockus = [consulta recuperaPersona:userStr :context];
    //NSLog(@"%@",self.userbrockus);
    self.MailUser.text =self.userbrockus.usuario;
    self.EnterpriseUser.text = self.userbrockus.toEmpresa.nombre;
    self.PuestoUser.text = self.userbrockus.puesto;
    self.UserNameBrockus.text = self.userbrockus.nombre;
    self.Sector.text = self.userbrockus.toEmpresa.toSubsector.toSector.nombre;
    if (self.userbrockus.img != nil) {
        self.ImageUser.image = [[UIImage alloc] initWithData:self.userbrockus.img];
    }
    self.listaPublicaciones = [[NSArray alloc] init];
    self.listaPublicaciones = [consulta recuperaPublicacionPorEmpresa:self.userbrockus.toEmpresa toContext:context];
    //NSLog(@"Registros: %d",[self.listaPublicaciones count]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)SalirTapped:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    [UIView commitAnimations];
    
    self.registro.delegate=(id)self;
    [self presentViewController:self.registro animated:YES completion:nil];
    
}

- (IBAction)CrearPublicacionBtn:(id)sender {
   // self.publicaciones.delegate=self;
    //[self presentViewController:self.publicaciones animated:YES completion:nil];
    //BURealizaPublicacionViewController *pub=[[BURealizaPublicacionViewController alloc] init];
    // [self presentViewController:pub animated:YES completion:nil];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [UIView commitAnimations];
    
    self.pub.delegate=(id)self;
    [self presentViewController:self.pub animated:YES completion:nil];
    UIAlertView *alertafecha =[[UIAlertView alloc]initWithTitle:@"IMPORTANTE" message:@"Antes de publicar selecciona la fecha límite de duración (recuerda seleccionar entre 1 y 5 días máximo, toma encuenta que el día seleccionado será cuando se eliminará la publicación." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertafecha show];
}

- (IBAction)Busqueda:(id)sender {
}

- (IBAction)miperfil:(id)sender {
   
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    [UIView commitAnimations];
    
     self.miperfil.delegate =(id)self;
    [self.navigationController pushViewController:self.miperfil animated:YES];
//    [self presentViewController:self.miperfil animated:YES completion:nil];
    
    UIAlertView *alertafecha =[[UIAlertView alloc]initWithTitle:@"IMPORTANTE" message:@"Recuerda que esto es una vista previa de como te ven los demas usuarios." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertafecha show];
    
}

- (IBAction)CirculoConfianza:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [UIView commitAnimations];
    
    
    self.circulo.delegate=(id)self;
    UINavigationController *navContr = [[UINavigationController alloc] initWithRootViewController:self.self.circulo];
    navContr.title=@"Perfil";
    [self.navigationController pushViewController:self.circulo animated:YES];
//    [self presentViewController:self.circulo animated:YES completion:nil];
}

- (IBAction)MisPublicacionesTapped:(id)sender {
    BUSeccionPublicacionesViewController *secPub=[[BUSeccionPublicacionesViewController alloc]init];
    [self presentViewController:secPub animated:YES completion:nil];
}

#pragma mark - TableViewController methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listaPublicaciones count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
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
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    cell.txtFechaInicio.text = [df stringFromDate:publicacion.fechaIni];
    cell.txtFechaFin.text = [df stringFromDate:publicacion.fecha];
    cell.txtSector.text = publicacion.toSubsector.toSector.nombre;
    if(publicacion.img != nil) {
        cell.imgImagen.image = [[UIImage alloc] initWithData:publicacion.img];
    }
    //[cell setSelected:YES animated:YES];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    BUDetallePublicacionViewController *detalle = [[BUDetallePublicacionViewController alloc] initWithPublicacion:self.listaPublicaciones[indexPath.row]];
    NSLog(@"%@", self.navigationController);
    [self.navigationController pushViewController:detalle animated:YES];
}


@end
