//
//  BUPerfilEmpresaDesconocidoViewController.m
//  BrockUs
//
//  Created by Nodus9 on 08/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import "BUPerfilEmpresaDesconocidoViewController.h"
#import "BUConsultaPublicacion.h"
#import "BUAppDelegate.h"
#import "Persona.h"
#import "Empresa.h"
#import "Publicacion.h"
#import "Sector.h"
#import "Subsector.h"
#import "BUPublicacionViewController.h"
#import "BUMinVistaViewController.h"
#import "BUDetallePublicacionViewController.h"

@interface BUPerfilEmpresaDesconocidoViewController ()
{
    NSManagedObjectContext *context;
}

@property (strong) Persona *userbrockus;
@property (strong) BUPublicacionViewController *pub;
@property (strong) BUDetallePublicacionViewController *detalle;
@property (strong) NSArray *listaPublicaciones;



@end

@implementation BUPerfilEmpresaDesconocidoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithPersona:(Persona *)persona {
    self = [super initWithNibName:@"BUPerfilEmpresaDesconocidoViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.persona = persona;
        self.title=self.persona.nombre;
        //self.oEmail.titleLabel.text = self.publicacion.toPersona.usuario;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    BUAppDelegate * buappdelegate=[[UIApplication sharedApplication]delegate];
    context =[buappdelegate managedObjectContext];
//
    BUConsultaPublicacion *consulta=[[BUConsultaPublicacion alloc] init];
    NSString *userStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserBrockus"];
    self.userbrockus = [consulta recuperaPersona:userStr :context];
    
    if (self.persona.nombre) {
        self.personaTxt.text = self.persona.nombre;
    }
    //self.personaTxt.text = self.persona.nombre;
    self.puestoTxt.text = self.persona.puesto;
    self.empresaTxt.text = self.persona.toEmpresa.nombre;
    self.sectorTxt.text = self.persona.toEmpresa.toSubsector.toSector.nombre;
    self.subsectorTxt.text = self.persona.toEmpresa.toSubsector.nombre;
    if(self.persona.img != nil) {
        self.oImagen.image = [[UIImage alloc] initWithData:self.persona.img];
    }
    //self.oEmail.textInputContextIdentifier = self.publicacion.toPersona.usuario;
    
    
    self.listaPublicaciones = [[NSArray alloc] init];
    self.listaPublicaciones = [consulta recuperaConsultasPorPersona:self.persona];
    
    
    //ordenadas
    NSSortDescriptor *byFechaIni = [NSSortDescriptor sortDescriptorWithKey:@"fechaIni" ascending:NO];
    NSSortDescriptor *byFechaFin = [NSSortDescriptor sortDescriptorWithKey:@"fecha" ascending:NO];
    NSSortDescriptor *byTitulo = [NSSortDescriptor sortDescriptorWithKey:@"titulo" ascending:NO];
    NSSortDescriptor *byDescripcion = [NSSortDescriptor sortDescriptorWithKey:@"descripcion" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:byFechaIni, byFechaFin, byTitulo,byDescripcion, nil];
    self.listaPublicaciones = [self.listaPublicaciones sortedArrayUsingDescriptors:sortDescriptors];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    BUDetallePublicacionViewController *detalle = [[BUDetallePublicacionViewController alloc] initWithPublicacion:self.listaPublicaciones[indexPath.row] navegacionAlPerfil:NO];
    NSLog(@"%@", self.navigationController);
    [self.navigationController pushViewController:detalle animated:YES];
}


@end
