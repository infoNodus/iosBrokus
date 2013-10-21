//
//  BUDetallePublicacionViewController.m
//  BrockUs
//
//  Created by Nodus3 on 04/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import "BUDetallePublicacionViewController.h"
#import "Persona.h"
#import "Empresa.h"
#import "Publicacion.h"
#import "BUAnexloLinkVC.h"
#import "BUPerfilEmpresaDesconocidoViewController.h"
#import "BUPerfilePersonalViewController.h"
#import "BUAppDelegate.h"
#import "BUConsultaPublicacion.h"
@interface BUDetallePublicacionViewController ()
{
    NSManagedObjectContext *context;
}
@property BOOL esNavegable;
@property (strong) Persona *userbrockus;
@end

@implementation BUDetallePublicacionViewController

// Contructor que inicializa la ventana con una publicacion
-(id) initWithPublicacion:(Publicacion *)publicacion {
    self = [super initWithNibName:@"BUDetallePublicacionViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.publicacion = publicacion;
        self.esNavegable = YES;
        self.title=self.publicacion.titulo;
        //self.oEmail.titleLabel.text = self.publicacion.toPersona.usuario;
    }
    return self;
}

// Contructor que inicializa la ventana con una publicacion y el parametro BOOL es para saber si es navegable hacia el perfil de la persona que realizo la publicación
-(id) initWithPublicacion:(Publicacion *)publicacion navegacionAlPerfil:(BOOL)isNavegable
{
    self = [self initWithPublicacion:publicacion];
    self.esNavegable = isNavegable;
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.oDetalle.text = self.publicacion.descripcion;
    if(self.publicacion.img != nil) {
        self.oImagen.image = [[UIImage alloc] initWithData:self.publicacion.img];
    }
    
    // Se inicializa el contexto para core data
    BUAppDelegate * buappdelegate=[[UIApplication sharedApplication]delegate];
    context =[buappdelegate managedObjectContext];
    //self.salir=[[BUPerfilEmpresaViewController alloc] initWithNibName:@"BUPerfilEmpresaViewController" bundle:nil];
    
    // Objeto para realizar cunsultas a core data
    BUConsultaPublicacion *consulta=[[BUConsultaPublicacion alloc] init];
    
    // Se obtiene el nombre del usuario que esta en logeado
    NSString *userStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserBrockus"];
    
    // Recuperamos el usuario  a partir del nombre del usuario
    self.userbrockus = [consulta recuperaPersona:userStr :context];
    
//    if (self.publicacion.toPersona.nombre == self.userbrockus.nombre) {
//        NSLog(@"tu mismo");
//        
//    }
    

    // Se establece el titulo del boton
    [self.oPersona setTitle:self.publicacion.toPersona.nombre forState:UIControlStateNormal];
    [self.oEmail setTitle:self.publicacion.toPersona.usuario forState:UIControlStateNormal];
    self.oEmpresa.text = self.publicacion.toPersona.toEmpresa.nombre;
    
    
    // Si la publicacion no tiene anexos se desahabilita la opcion de descargar anexos.
    if(self.publicacion.linkAnexo == nil) {
        [self.oDescarga setEnabled:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Metodo para poder utilizar el servicio de los correos de iOS
- (IBAction)openMail:(id)sender {
    // Verifica si el dispositivo puede enviar correos
    if(![MFMailComposeViewController canSendMail]) {
        NSLog(@"No se puede enviar email desde este dispositivo");
        return;
    }
    
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    
    // Asunto del mensaje
    [mailer setSubject:@"Notificacion - Brokus"];
    NSArray *toRecipients = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",self.publicacion.toPersona.usuario], nil];
    [mailer setToRecipients:toRecipients];
    
    // El cuerpo del mensaje
    NSString *emailBody = @"Escribe tu mensaje.";
    [mailer setMessageBody:emailBody isHTML:NO];
    
    // Mostramos la ventana para editar el mensaje.
    [self presentViewController:mailer animated:YES completion:nil];
}

// Se muestran los anexos...
- (IBAction)descargaTapped:(id)sender {

    BUAnexloLinkVC *anexo = [[BUAnexloLinkVC alloc] initWithURL:self
                             .publicacion.linkAnexo];
    [self.navigationController pushViewController:anexo animated:YES];
}

// Se muestra el perfil de la persona que realiza la publicacion.
- (IBAction)openPerfilPersona:(id)sender {
    // Solamente hace la navegacion si esta es permitida
    if (self.esNavegable) {
        
        // Contexto
        BUAppDelegate * buappdelegate=[[UIApplication sharedApplication]delegate];
        context =[buappdelegate managedObjectContext];
        
        BUConsultaPublicacion *consulta=[[BUConsultaPublicacion alloc] init];
        NSString *userStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserBrockus"];
        
        // Se recupera el usuario logeado
        self.userbrockus = [consulta recuperaPersona:userStr :context];
        
        // Si la publicacion la realizo el usuario logeado lo manda a su perfil.
        if (self.publicacion.toPersona.nombre == self.userbrockus.nombre) {
            NSLog(@"tu mismo");
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:1.5];
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
            [UIView commitAnimations];
            BUPerfilePersonalViewController *perfil = [[BUPerfilePersonalViewController alloc] initWithNibName:@"BUPerfilePersonalViewController" bundle:nil];
            [self.navigationController pushViewController:perfil animated:YES];
            return;
        }
        
        // Si la publicacion la realiza otro usuario nos muestra su perfil con sus demas publicaciones
        BUPerfilEmpresaDesconocidoViewController *perfil = [[BUPerfilEmpresaDesconocidoViewController alloc] initWithPersona:self.publicacion.toPersona];
        [self.navigationController pushViewController:perfil animated:YES];
    }
}

# pragma mark - Metodos del MFMailComposeViewController

// Nos retorna la respuesta de la accion del envio de correo.
-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    UIAlertView *mensaje = nil;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Correo cancelado: cancela la operación y ningún mensaje de correo electrónico se puso en cola.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Correo salvó: se guardó el mensaje de correo electrónico en la carpeta de borradores.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail Enviar: el mensaje de correo electrónico se pone en cola en el buzón de salida. Está listo para enviar.");
            mensaje = [[UIAlertView alloc] initWithTitle:@"Información" message:@"Correo enviado" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Correo falló: el mensaje de correo electrónico no se ha guardado o en cola, posiblemente debido a un error.");
            break;
        default:
            NSLog(@"Correo no enviado.");
            break;
    }
    if (mensaje != nil) {
        [mensaje show];
    }
    // Quitamos la ventana del correo.
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
