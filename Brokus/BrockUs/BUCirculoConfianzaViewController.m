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
    NSManagedObjectContext *context;
}
//test
@property (strong) BULoginViewController *registro;
@property (strong) BURegistroViewController*publicaciones;
@property (strong) Persona *userbrockus;
@property (strong) BUPublicacionViewController *pub;
@property (strong) NSArray *listaPublicaciones;
@property (strong) NSOrderedSet *listaCirculo;
@property (strong) BUPerfilEmpresaViewController *miperfil;
@property (strong) BUCirculoConfianzaViewController *circulo;
@property (strong) BUPerfilEmpresaViewController *salir;
//test
@end
//test
NSString *userenterprise;
//test
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
    self.title = @"Circulo de Confianza";
    BUAppDelegate * buappdelegate=[[UIApplication sharedApplication]delegate];
    context =[buappdelegate managedObjectContext];
     self.salir=[[BUPerfilEmpresaViewController alloc] initWithNibName:@"BUPerfilEmpresaViewController" bundle:nil];
    
    BUConsultaPublicacion *consulta=[[BUConsultaPublicacion alloc] init];
    NSString *userStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserBrockus"];
    self.userbrockus = [consulta recuperaPersona:userStr :context];
    //NSLog(@"%@",self.userbrockus);
    if (self.userbrockus.usuario != nil) {
        self.MailUser.text =self.userbrockus.usuario;
    }
    //self.MailUser.text =self.userbrockus.usuario;
    if (self.userbrockus.toEmpresa.nombre != nil) {
        self.EnterpriseUser.text = self.userbrockus.toEmpresa.nombre;
    }
    //self.EnterpriseUser.text = self.userbrockus.toEmpresa.nombre;
    if (self.userbrockus.puesto != nil) {
        self.PuestoUser.text = self.userbrockus.puesto;
    }//else cambiar el texto en caso de q exista un campo vacio para q pongo la etiqueta "puesto"
    //self.PuestoUser.text = self.userbrockus.puesto;
    if (self.userbrockus.nombre != nil) {
        self.UserNameBrockus.text = self.userbrockus.nombre;
    }
    //self.UserNameBrockus.text = self.userbrockus.nombre;
    if (self.userbrockus.toEmpresa.toSubsector.toSector.nombre != nil) {
        self.Sector.text = self.userbrockus.toEmpresa.toSubsector.toSector.nombre;
    }
    //self.Sector.text = self.userbrockus.toEmpresa.toSubsector.toSector.nombre;
    if (self.userbrockus.img != nil) {
        self.ImageUser.image = [[UIImage alloc] initWithData:self.userbrockus.img];
    }
//    ordenar como estan en base de datos
//    self.listaCirculo = [[NSOrderedSet alloc] initWithSet:self.userbrockus.toCirculo];
//    self.listaPublicaciones = [[NSArray alloc] init];
//    self.listaPublicaciones = [self.listaCirculo copy];
//    ordenar como estan en base de datos

    self.listaPublicaciones = [[NSArray alloc] init];
    self.listaPublicaciones = [self.userbrockus.toCirculo allObjects];
    NSUInteger numeroPersonasCirculo = [self.userbrockus.toCirculo count];
    NSLog(@"numero de personas %lu", (unsigned long)numeroPersonasCirculo);//contar personas en el circulo de amigos
    
    
    //ordenadas
    NSSortDescriptor *byName = [NSSortDescriptor sortDescriptorWithKey:@"toAmigo.nombre" ascending:YES];
    NSSortDescriptor *byEmpresa = [NSSortDescriptor sortDescriptorWithKey:@"toAmigo.toEmpresa.nombre" ascending:YES];
    NSSortDescriptor *byPuesto = [NSSortDescriptor sortDescriptorWithKey:@"toAmigo.puesto" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:byName, byEmpresa, byPuesto, nil];
    self.listaPublicaciones = [self.listaPublicaciones sortedArrayUsingDescriptors:sortDescriptors];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewController methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.listaPublicaciones count] <= 10) {
        return [self.listaPublicaciones count];
    }else{
        return 10;
    }
    
    return [self.listaPublicaciones count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"circuloCell";
    
    BUMinVistaCirculoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BUMinVistaCirculoCell" owner:self
                                            options:nil] lastObject];
    }
    //Circulo *personaCirculo = self.listaPublicaciones[indexPath.row];
    Circulo *personaCirculo = self.listaPublicaciones[indexPath.row];
    NSLog(@"lista %@", personaCirculo.toAmigo.nombre);
    cell.empresaTxt.text = personaCirculo.toAmigo.toEmpresa.nombre;
    cell.usuarioTxt.text = personaCirculo.toAmigo.nombre;
    cell.cargoTxt.text = personaCirculo.toAmigo.puesto;
    
    if(personaCirculo.toAmigo.img != nil) {
        cell.imageView.image = [[UIImage alloc] initWithData:personaCirculo.toAmigo.img];
    }
    
//    //[cell setSelected:YES animated:YES];
//    return cell;
//    
//  
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    BUDetallePublicacionViewController *detalle = [[BUDetallePublicacionViewController alloc] initWithPublicacion:self.listaPublicaciones[indexPath.row]];
//    NSLog(@"%@", self.navigationController);
//    [self.navigationController pushViewController:detalle animated:YES];
    
    Circulo *personaCirculo = self.listaPublicaciones[indexPath.row];
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
