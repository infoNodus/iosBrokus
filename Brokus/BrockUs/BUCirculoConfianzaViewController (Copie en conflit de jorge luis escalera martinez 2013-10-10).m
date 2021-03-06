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
#import "BUMinVistaViewController.h"
#import "BUDetallePublicacionViewController.h"


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
@property (strong) BUPerfilEmpresaViewController *miperfil;
@property (strong) BUCirculoConfianzaViewController *circulo;
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
    
    BUAppDelegate * buappdelegate=[[UIApplication sharedApplication]delegate];
    context =[buappdelegate managedObjectContext];
    
    //test
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
    //self.listaPublicaciones = [consulta recuperaPersonasCirculoPorPersona:self.userbrockus.toCirculo toContext:context];
    self.listaPublicaciones = [self.userbrockus.toCirculo copy];
    
    
    //test
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewController methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(self.listaPublicaciones);
    return [self.listaPublicaciones count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    //5
//    static NSString *cellIdentifier = @"publicacionCell";
//    
//    BUMinVistaViewController *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"BUMinVistaViewController" owner:self
//                                            options:nil] lastObject];
//    }
//    //Publicacion *publicacion = self.listaPublicaciones[indexPath.row];
//    //Circulo *personaCirculo = self.listaPublicaciones[indexPath.row];
//    
////    cell.txtDescripcion.text = personaCirculo.isAceptado;
////    cell.txtTitulo.text = personaCirculo.titulo;
////    cell.txtSector.text = publicacion.toSubsector.toSector.nombre;
////    if(publicacion.img != nil) {
////        cell.imgImagen.image = [[UIImage alloc] initWithData:publicacion.img];
////    }
//    //[cell setSelected:YES animated:YES];
//    return cell;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = self.listaPublicaciones[indexPath.row];
    
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BUDetallePublicacionViewController *detalle = [[BUDetallePublicacionViewController alloc] initWithPublicacion:self.listaPublicaciones[indexPath.row]];
    NSLog(@"%@", self.navigationController);
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


@end
