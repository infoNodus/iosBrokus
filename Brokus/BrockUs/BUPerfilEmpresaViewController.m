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
@property (strong) NSMutableArray *listaPublicaciones;
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
    // Se especifica los botones y el titulo que
    self.navigationItem.leftBarButtonItem = self.btnSalir;
    self.navigationItem.rightBarButtonItem = self.btnCrearPublicacion;
    self.title = @"Perfil";
    
    // se inicializa el contexto
    BUAppDelegate * buappdelegate=[[UIApplication sharedApplication]delegate];
    context =[buappdelegate managedObjectContext];
    
    // Se inicializan las vistas
    self.registro=[[BULoginViewController alloc] initWithNibName:@"BULoginViewController" bundle:nil];
    self.publicaciones =[[BURegistroViewController alloc] initWithNibName:@"BURegistroViewController" bundle:nil];
    self.miperfil=[[BUPerfilePersonalViewController alloc]initWithNibName:@"BUPerfilePersonalViewController" bundle:nil];
    self.pub=[[BUPublicacionViewController alloc] initWithNibName:@"BUPublicacionViewController" bundle:nil];
    self.circulo=[[BUCirculoConfianzaViewController alloc] initWithNibName:@"BUCirculoConfianzaViewController" bundle:nil];
    
    
    BUConsultaPublicacion *consulta=[[BUConsultaPublicacion alloc] init];
    NSString *userStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserBrockus"];
    // Se recupera el usuario logeado
    self.userbrockus = [consulta recuperaPersona:userStr :context];
    
    // Se inicializan las etiquetas de la ventana
    self.MailUser.text =self.userbrockus.usuario;
    self.EnterpriseUser.text = self.userbrockus.toEmpresa.nombre;
    self.PuestoUser.text = self.userbrockus.puesto;
    self.UserNameBrockus.text = self.userbrockus.nombre;
    self.Sector.text = self.userbrockus.toEmpresa.toSubsector.toSector.nombre;
    if (self.userbrockus.img != nil) {
        self.ImageUser.image = [[UIImage alloc] initWithData:self.userbrockus.img];
    }
    
    // Recuperamos las publicaciones por el sector de la empresa del usuario logeado.
    self.listaPublicaciones = [[NSMutableArray alloc] init];
    self.listaPublicaciones = [consulta recuperaPublicacionPor:self.userbrockus.toEmpresa.toSubsector.toSector context:context];
    
    // Se ordena la informacion de la lista de publicaciones
    NSSortDescriptor *byFechaIni = [NSSortDescriptor sortDescriptorWithKey:@"fechaIni" ascending:NO];
    NSSortDescriptor *byFechaFin = [NSSortDescriptor sortDescriptorWithKey:@"fecha" ascending:NO];
    NSSortDescriptor *byTitulo = [NSSortDescriptor sortDescriptorWithKey:@"titulo" ascending:NO];
    NSSortDescriptor *byDescripcion = [NSSortDescriptor sortDescriptorWithKey:@"descripcion" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:byFechaIni, byFechaFin, byTitulo,byDescripcion, nil];
    self.listaPublicaciones = [[self.listaPublicaciones sortedArrayUsingDescriptors:sortDescriptors] copy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Cierra la sesion del usuario y se dirige al login
- (IBAction)SalirTapped:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    [UIView commitAnimations];
    
    self.registro.delegate=(id)self;
    [self presentViewController:self.registro animated:YES completion:nil];
    
}

// Se dirige a crear una publicacion.
- (IBAction)CrearPublicacionBtn:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [UIView commitAnimations];
    
    self.pub.delegate=(id)self;
    [self.navigationController pushViewController:self.pub animated:YES];
    UIAlertView *alertafecha =[[UIAlertView alloc]initWithTitle:@"IMPORTANTE" message:@"Antes de publicar selecciona la fecha límite de duración (recuerda seleccionar entre 1 y 5 días máximo, toma encuenta que el día seleccionado será cuando se eliminará la publicación." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertafecha show];
}

// Se direje al perfil del usuario logeado.
- (IBAction)miperfil:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    [UIView commitAnimations];
    self.miperfil.delegate =(id)self;
    [self.navigationController pushViewController:self.miperfil animated:YES];
    UIAlertView *alertafecha =[[UIAlertView alloc]initWithTitle:@"IMPORTANTE" message:@"Recuerda que esto es una vista previa de como te ven los demas usuarios." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertafecha show];
    
}

// Se direje al circulo de confianza del usuario logeado.
- (IBAction)CirculoConfianza:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [UIView commitAnimations];
    self.circulo.delegate=(id)self;
    UINavigationController *navContr = [[UINavigationController alloc] initWithRootViewController:self.self.circulo];
    navContr.title=@"Perfil";
    [self.navigationController pushViewController:self.circulo animated:YES];
}

// Se direje a la administracion de las publicaciones del usuario logeado.
- (IBAction)MisPublicacionesTapped:(id)sender {
    UIAlertView *eliminar = [[UIAlertView alloc]initWithTitle:@"IMPORTANTE" message:@"Para desactivar (eliminar) una publicación, solamente debes dejar seleccionada la publicación y deslizar suavemente a la izquierda y a continuación aparecerá un botón con el cual podras desactivar la publicación." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [eliminar show];
    BUSeccionPublicacionesViewController *secPub=[[BUSeccionPublicacionesViewController alloc]init];
    [self presentViewController:secPub animated:YES completion:nil];
}

#pragma mark - TableViewController methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listaPublicaciones count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
