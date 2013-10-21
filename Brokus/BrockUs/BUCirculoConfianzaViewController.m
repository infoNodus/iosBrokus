//
//  BUCirculoConfianzaViewController.m
//  BrockUs
//
//  Created by Nodus5 on 10/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import "BUCirculoConfianzaViewController.h"
#import "BUConsultaPublicacion.h"
#import "BUAppDelegate.h"
#import "BUPublicacionViewController.h"
#import "Persona.h"
#import "Empresa.h"
#import "Sector.h"
#import "Subsector.h"
#import "Circulo.h"
#import "Publicacion.h"
#import "BUMinVistaCirculoCell.h"
#import "BUPerfilEmpresaViewController.h"
#import "BUPerfilEmpresaDesconocidoViewController.h"


@interface BUCirculoConfianzaViewController ()
{
    NSManagedObjectContext *context;//asigna el contexto para usarlo posteriormente
}
@property (strong) BULoginViewController *registro; //propiedad para acceder al controlador de login
@property (strong) BURegistroViewController*publicaciones;//propiedad para acceder al controlador de publicaciones
@property (strong) Persona *userbrockus;//propiedad para acceder a la persona actual (loggeada)
@property (strong) BUPublicacionViewController *pub;//propiedad para acceder al controlador de una publicacion
@property (strong) NSArray *listaPersonas;//propiedad para acceder a la lista de personas en tu circulo de amigos
@property (strong) NSOrderedSet *listaCirculo;//propiedad para acceder a tu circulo
@property (strong) BUPerfilEmpresaViewController *miperfil;//propiedad para acceder al controlador de perfil
@property (strong) BUCirculoConfianzaViewController *circulo;//propiedad para acceder al controlador de circulo
@property (strong) BUPerfilEmpresaViewController *salir;//propiedad para acceder al controlador de perfil de empresa
@end

//NSString *userenterprise;

@implementation BUCirculoConfianzaViewController

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
    self.title = @"Circulo de Confianza";//asigana titulo a la seccion
    BUAppDelegate * buappdelegate=[[UIApplication sharedApplication]delegate];//inicializamos una instancia del appdelegate
    context =[buappdelegate managedObjectContext];//asiganamos el contexto actual
    self.salir=[[BUPerfilEmpresaViewController alloc] initWithNibName:@"BUPerfilEmpresaViewController" bundle:nil];//asignamos una instancia del controlador para el perfil de una empresa
    BUConsultaPublicacion *consulta=[[BUConsultaPublicacion alloc] init];//asignamos una instancia del controlador para hacer una consulta
    NSString *userStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserBrockus"];//inicializamos una variable donde guardaremos el usuario actual
    self.userbrockus = [consulta recuperaPersona:userStr :context];//recuperamos el usuario actual
    if (self.userbrockus.usuario != nil) {//asignamos el correo del usuario que acabamos de recuperar, si el correo es nulo asignamos un texto por default
        self.MailUser.text =self.userbrockus.usuario;
    }else{
        self.UserNameBrockus.text = @"Mail";
    }
    if (self.userbrockus.toEmpresa.nombre != nil) {//asignamos el nombre de la empresa del usuario que acabamos de recuperar, si la empresa es nula asignamos un texto por default
        self.EnterpriseUser.text = self.userbrockus.toEmpresa.nombre;
    }else{
        self.UserNameBrockus.text = @"Empresa";
    }
    if (self.userbrockus.puesto != nil) {//asignamos el puesto del usuario que acabamos de recuperar, si el puesto es nulo asignamos un texto por default
        self.PuestoUser.text = self.userbrockus.puesto;
    }else{
        self.UserNameBrockus.text = @"Puesto";
    }
    if (self.userbrockus.nombre != nil) {//asignamos el nombre del usuario que acabamos de recuperar, si el nombre es nulo asignamos un texto por default
        self.UserNameBrockus.text = self.userbrockus.nombre;
    }else{
        self.UserNameBrockus.text = @"Nombre";
    }
    if (self.userbrockus.toEmpresa.toSubsector.toSector.nombre != nil) {//asignamos el sector del usuario que acabamos de recuperar, si el sector es nulo asignamos un texto por default
        self.Sector.text = self.userbrockus.toEmpresa.toSubsector.toSector.nombre;
    }else{
        self.UserNameBrockus.text = @"Sector";
    }
    if (self.userbrockus.img != nil) {//asignamos la imagen del usuario que acabamos de recuperar, si la imagen es nulo asignamos una imagen por default
        self.ImageUser.image = [[UIImage alloc] initWithData:self.userbrockus.img];
    }

    self.listaPersonas = [[NSArray alloc] init];//inicializamos el arreglo donde guardaremos las personas del circulo de confianza
    self.listaPersonas = [self.userbrockus.toCirculo allObjects];//recuperamos las personas de nuestro circulo
    NSUInteger numeroPersonasCirculo = [self.userbrockus.toCirculo count];//contamos las personas del circulo
    NSLog(@"numero de personas %lu", (unsigned long)numeroPersonasCirculo);//imprimimos el numero de personas en el circulo
    
    
    NSSortDescriptor *byName = [NSSortDescriptor sortDescriptorWithKey:@"toAmigo.nombre" ascending:YES];//creamos una regla para ordenar las personas de nuetro circulo segun el nombre
    NSSortDescriptor *byEmpresa = [NSSortDescriptor sortDescriptorWithKey:@"toAmigo.toEmpresa.nombre" ascending:YES];//creamos una regla para ordenar las personas de nuetro circulo segun la empresa
    NSSortDescriptor *byPuesto = [NSSortDescriptor sortDescriptorWithKey:@"toAmigo.puesto" ascending:YES];//creamos una regla para ordenar las personas de nuetro circulo segun el puesto
    NSArray *sortDescriptors = [NSArray arrayWithObjects:byName, byEmpresa, byPuesto, nil];//escogemos el orden de las reglas
    self.listaPersonas = [self.listaPersonas sortedArrayUsingDescriptors:sortDescriptors];//reordenamos el arreglo aplicando las reglas
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewController methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.listaPersonas count] <= 10) {//si en nuestro circulo de confiansa hay menos de 10 personas las mostramos todas
        return [self.listaPersonas count];
    }else{
        return 10;//si hay mas solo mostramos 10
    }
    return [self.listaPersonas count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"circuloCell";//donamos un identificador a las celdas
    
    BUMinVistaCirculoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];//inicializamos una celda costumizada
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BUMinVistaCirculoCell" owner:self options:nil] lastObject];
    }
    Circulo *personaCirculo = self.listaPersonas[indexPath.row];//asignamos un objeto a la celda
    NSLog(@"lista %@", personaCirculo.toAmigo.nombre);
    
    if (personaCirculo.toAmigo.toEmpresa.nombre != nil) {//asignamos el nombre de la empresa de la persona que recuperamos de nuestra circulo, si es nulo asignamos uno por default
        cell.empresaTxt.text = personaCirculo.toAmigo.toEmpresa.nombre;
    }else{
        cell.empresaTxt.text = @"Empresa";
    }
    
    if (personaCirculo.toAmigo.nombre != nil) {//asignamos el nombre de usuario de la persona que recuperamos de nuestra circulo, si es nulo asignamos uno por default
        cell.usuarioTxt.text = personaCirculo.toAmigo.nombre;
    }else{
        cell.usuarioTxt.text = @"Nombre";
    }
    
    if (personaCirculo.toAmigo.puesto != nil) {//asignamos el puesto de la persona que recuperamos de nuestra circulo, si es nulo asignamos por uno por default
        cell.cargoTxt.text = personaCirculo.toAmigo.puesto;
    }else{
        cell.cargoTxt.text = @"Puesto";
    }
    
    
    if(personaCirculo.toAmigo.img != nil) {
        cell.imageView.image = [[UIImage alloc] initWithData:personaCirculo.toAmigo.img];//asignamos la imagen de la persona que recuperamos de nuestra circulo, si es nula asignamos una imagen por default
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    BUDetallePublicacionViewController *detalle = [[BUDetallePublicacionViewController alloc] initWithPublicacion:self.listaPublicaciones[indexPath.row]];
//    NSLog(@"%@", self.navigationController);
//    [self.navigationController pushViewController:detalle animated:YES];
    
    Circulo *personaCirculo = self.listaPersonas[indexPath.row];
    BUPerfilEmpresaDesconocidoViewController *detalle = [[BUPerfilEmpresaDesconocidoViewController alloc] initWithPersona:personaCirculo.toAmigo ];
    [self.navigationController pushViewController:detalle animated:YES];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 
 */


- (IBAction)Salir:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.4];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    [UIView commitAnimations];
    
   self.salir.delegate=(id)self;
[self presentViewController:self.salir animated:YES completion:nil ];

}



//agregar al circulo de confiansa
/*
 *cuando una persona solicite la agregacion de otra a su circulo de confianza primero debemos saber si no ha llegado al limite de personas permitidas,
 *para esto contaremos las personas de la base de datos y dependiendo de la respuesta permitiremos o no la incercion
 *
 *este es un posible metodo para contarlos pero no ha sido testeado aun
 *
 int entityCount = 0;
 NSEntityDescription *entity = [NSEntityDescription entityForName:@"YourEntity" inManagedObjectContext:_managedObjectContext];
 NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
 [fetchRequest setEntity:entity];
 [fetchRequest setIncludesPropertyValues:NO];
 [fetchRequest setIncludesSubentities:NO];
 NSError *error = nil;
 NSUInteger count = [_managedObjectContext countForFetchRequest: fetchRequest error: &error];
 if(error == nil){
 entityCount = count;
 }
 *
 *
 */
@end
