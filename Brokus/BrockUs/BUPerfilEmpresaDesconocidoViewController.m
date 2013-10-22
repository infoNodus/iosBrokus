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
#import "Circulo.h"

@interface BUPerfilEmpresaDesconocidoViewController ()
{
    NSManagedObjectContext *context;//asigna el contexto para usarlo posteriormente
}

@property (strong) Persona *userbrockus;//implementamoms una propiedad para acceder a un objeto persona
@property (strong) BUPublicacionViewController *pub;//implementamoms una propiedad para acceder al controlador de publicacion
@property (strong) BUDetallePublicacionViewController *detalle;//implementamoms una propiedad para acceder al controlador de detalle
@property (strong) NSArray *listaPublicaciones;//implementamos una lista de publicaciones
@property (weak, nonatomic) IBOutlet UIButton *oInvitarOrEMail;//implementamos una propiedad para acceder al boton de enviar un mail

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
    }else{
        self.personaTxt.text = @"Nombre";
    }
    if (self.persona.puesto != nil) {
        self.puestoTxt.text = self.persona.puesto;
    }else{
        self.puestoTxt.text = @"Puesto";
    }
    
    if (self.persona.toEmpresa.nombre != nil) {
        self.empresaTxt.text = self.persona.toEmpresa.nombre;
    }else{
        self.empresaTxt.text = @"Empresa";
    }
    if (self.persona.toEmpresa.toSubsector.toSector.nombre != nil) {
        self.sectorTxt.text = self.persona.toEmpresa.toSubsector.toSector.nombre;
    }else{
        self.sectorTxt.text = @"Sector";
    }
    if (self.persona.toEmpresa.toSubsector.nombre != nil) {
        self.subsectorTxt.text = self.persona.toEmpresa.toSubsector.nombre;
    }else{
        self.subsectorTxt.text = @"Subsector";
    }
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
    
    
    // Si la persona es del circulo de confianza aparece el boton de enviar correo,
    // si no aprace el boton de invitar.
    // Para el metodo que implemente este boton self.oInvitarOrEmail se tiene que hacer la misma comparacion para saber cual es la accion que se va a tomar
    if ([self personaEstaEnCirculo:self.persona]) {
        [self.oInvitarOrEMail setTitle:@"Enviar correo" forState:UIControlStateNormal] ;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) personaEstaEnCirculo:(Persona*)persona {
    for (Circulo *amigo in self.userbrockus.toCirculo) {
        if([amigo.toAmigo.usuario isEqualToString:persona.usuario]) {
            return YES;
        }
    }
    return NO;
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
- (IBAction)openCorreoOrInvitar:(id)sender {
    if ([self personaEstaEnCirculo:self.persona]) {
        // Enviar correo
        if(![MFMailComposeViewController canSendMail]) {
            NSLog(@"No se puede enviar email desde este dispositivo");
            return;
        }
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        
        // Asunto del mensaje
        [mailer setSubject:@"Notificacion - Brokus"];
        NSArray *toRecipients = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",self.persona.usuario], nil];
        [mailer setToRecipients:toRecipients];
        
        // El cuerpo del mensaje
        NSString *emailBody = @"Escribe tu mensaje.";
        [mailer setMessageBody:emailBody isHTML:NO];
        
        // Mostramos la ventana para editar el mensaje.
        [self presentViewController:mailer animated:YES completion:nil];
    } else {
        // Invitar
    }
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BUDetallePublicacionViewController *detalle = [[BUDetallePublicacionViewController alloc] initWithPublicacion:self.listaPublicaciones[indexPath.row] navegacionAlPerfil:NO];
    NSLog(@"%@", self.navigationController);
    [self.navigationController pushViewController:detalle animated:YES];
}

# pragma mark - Metodos del MFMailComposeViewController

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    UIAlertView *mensaje = nil;
    // Resultados de las acciones del correo
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
