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
#import "BUPerfilEmpresaViewController.h"
@interface BUDetallePublicacionViewController ()
{
    NSManagedObjectContext *context;
}
@property BOOL esNavegable;
@property (strong) Persona *userbrockus;
@property (strong)BUPerfilEmpresaViewController *miperfil;
@end

@implementation BUDetallePublicacionViewController

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
    
    /*test*/
    BUAppDelegate * buappdelegate=[[UIApplication sharedApplication]delegate];
    context =[buappdelegate managedObjectContext];
    //self.salir=[[BUPerfilEmpresaViewController alloc] initWithNibName:@"BUPerfilEmpresaViewController" bundle:nil];
    
    BUConsultaPublicacion *consulta=[[BUConsultaPublicacion alloc] init];
    NSString *userStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserBrockus"];
    self.userbrockus = [consulta recuperaPersona:userStr :context];
    
    if (self.publicacion.toPersona.nombre == self.userbrockus.nombre) {
        NSLog(@"tu mismo");
        
    }
    
    
    [self.oPersona setTitle:self.publicacion.toPersona.nombre forState:UIControlStateNormal];
    self.oEmpresa.text = self.publicacion.toPersona.toEmpresa.nombre;
    //self.oEmail.textInputContextIdentifier = self.publicacion.toPersona.usuario;
    [self.oEmail setTitle:self.publicacion.toPersona.usuario forState:UIControlStateNormal] ;
    
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

- (IBAction)openMail:(id)sender {
    if(![MFMailComposeViewController canSendMail]) {
        NSLog(@"No se puede enviar email desde este dispositivo");
        return;
    }
    
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    
    // Asunto del mensaje
    [mailer setSubject:@"Notificacion - BroukUs"];
    NSArray *toRecipients = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",self.publicacion.toPersona.usuario], nil];
    [mailer setToRecipients:toRecipients];
    
    // El cuerpo del mensaje
    NSString *emailBody = @"Escribe tu mensaje.";
    [mailer setMessageBody:emailBody isHTML:NO];

    // Mostramos la ventana para editar el mensaje.
    [self presentViewController:mailer animated:YES completion:nil];
}

- (IBAction)descargaTapped:(id)sender {
    BUAnexloLinkVC *anexo = [[BUAnexloLinkVC alloc] initWithURL:self
                          .publicacion.linkAnexo];
    [self.navigationController pushViewController:anexo animated:YES];
    
//    NSURLConnection
    
}
- (IBAction)openPerfilPersona:(id)sender {
    if (self.esNavegable) {
        
        BUAppDelegate * buappdelegate=[[UIApplication sharedApplication]delegate];
        context =[buappdelegate managedObjectContext];
        //self.salir=[[BUPerfilEmpresaViewController alloc] initWithNibName:@"BUPerfilEmpresaViewController" bundle:nil];
        
        BUConsultaPublicacion *consulta=[[BUConsultaPublicacion alloc] init];
        NSString *userStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserBrockus"];
        self.userbrockus = [consulta recuperaPersona:userStr :context];
        
        if (self.publicacion.toPersona.nombre == self.userbrockus.nombre) {
            NSLog(@"tu mismo");
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:1.5];
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
            [UIView commitAnimations];
            self.miperfil=[[BUPerfilePersonalViewController alloc]initWithNibName:@"BUPerfilePersonalViewController" bundle:nil];
            self.miperfil.delegate =(id)self;
            [self.navigationController pushViewController:self.miperfil animated:YES];
            
            return;
            
        }
        
        
        
        BUPerfilEmpresaDesconocidoViewController *perfil = [[BUPerfilEmpresaDesconocidoViewController alloc] initWithPersona:self.publicacion.toPersona];
        [self.navigationController pushViewController:perfil animated:YES];
    }
}

# pragma mark - Metodos del MFMailComposeViewController

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    UIAlertView *mensaje = nil;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            mensaje = [[UIAlertView alloc] initWithTitle:@"Información" message:@"Correo enviado" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    if (mensaje != nil) {
        [mensaje show];
    }
    // Quitamos la ventana del correo.
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
