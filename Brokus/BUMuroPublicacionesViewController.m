//
//  BUMuroPublicacionesViewController.m
//  BrockUs
//
//  Created by Nodus5 on 26/09/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import "BUMuroPublicacionesViewController.h"
#import "Persona.h"
#import "Publicacion.h"
#import "BUConsultaPublicacion.h"
#import "BUAppDelegate.h"
#import "BUMinVistaViewController.h"
#import "Sector.h"
#import "Subsector.h"
#import "BUDetallePublicacionViewController.h"
#import "BUPublicacionViewController.h"

@interface BUMuroPublicacionesViewController ()
{
    NSManagedObjectContext *context;
}
@property (strong) Persona* persona;
@property (strong) NSArray* listaPublicaciones;
@property (strong) BUMuroPublicacionesViewController *regresar;
@end

@implementation BUMuroPublicacionesViewController

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
    self.listaPublicaciones = [[NSArray alloc] init];
    
  
    BUAppDelegate * buappdelegate=[[UIApplication sharedApplication]delegate];
    context =[buappdelegate managedObjectContext];
    
    BUConsultaPublicacion *consulta = [[BUConsultaPublicacion alloc] init];
    
    self.persona = [consulta recuperaPersona:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserBrockus"] :context];
    if(self.persona != nil && self.persona.toPublicacion != nil && [self.persona.toPublicacion count] > 0) {
        self.listaPublicaciones = [self.persona.toPublicacion allObjects];
    }
        self.regresar=[[BUPublicacionViewController alloc] initWithNibName:@"BUPublicacionViewController" bundle:nil];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //5
    static NSString *cellIdentifier = @"publicacionCell";
    
    BUMinVistaViewController *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BUMinVistaViewController" owner:self
                                            options:nil] lastObject];
    }
    Publicacion *publicacion = self.listaPublicaciones[indexPath.row];
    NSLog(@"MURO PUBLICACIONES, subsector:%@",publicacion.toSubsector.nombre);
    cell.txtDescripcion.text = publicacion.descripcion;
    cell.txtTitulo.text = publicacion.titulo;
    cell.txtSector.text = publicacion.toSubsector.nombre;
    
    if(publicacion.img != nil) {
        cell.imgImagen.image = [[UIImage alloc] initWithData:publicacion.img];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BUDetallePublicacionViewController *detalle = [[BUDetallePublicacionViewController alloc] initWithPublicacion:self.listaPublicaciones[indexPath.row]];
    [self.navigationController pushViewController:detalle animated:YES];
    
}
- (IBAction)CancelarTapped:(id)sender {
    self.regresar.delegate=(id)self;
    [self presentViewController:self.regresar animated:YES completion:nil];
}
@end
