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

-(id) initWithPersona:(Persona *)persona {//inicializador custom para iniciar con una persona
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
    
    BUAppDelegate * buappdelegate=[[UIApplication sharedApplication]delegate];//inicializamos una instancia del appdelegate
    context =[buappdelegate managedObjectContext];//asiganamos el contexto actual

    BUConsultaPublicacion *consulta=[[BUConsultaPublicacion alloc] init];//asignamos una instancia del controlador para hacer una consulta

    NSString *userStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserBrockus"];//inicializamos una variable donde guardaremos el usuario actual

    self.userbrockus = [consulta recuperaPersona:userStr :context];//recuperamos el usuario actual
    
    if (self.persona.nombre) {//asignamos el nombre del usuario que acabamos de recuperar, si el correo es nulo asignamos un texto por default
        self.personaTxt.text = self.persona.nombre;
    }else{
        self.personaTxt.text = @"Nombre";
    }
    if (self.persona.puesto != nil) {//asignamos el puesto del usuario que acabamos de recuperar, si el correo es nulo asignamos un texto por default
        self.puestoTxt.text = self.persona.puesto;
    }else{
        self.puestoTxt.text = @"Puesto";
    }
    
    if (self.persona.toEmpresa.nombre != nil) {//asignamos el nombre de la empresa del usuario que acabamos de recuperar, si el correo es nulo asignamos un texto por default
        self.empresaTxt.text = self.persona.toEmpresa.nombre;
    }else{
        self.empresaTxt.text = @"Empresa";
    }
    if (self.persona.toEmpresa.toSubsector.toSector.nombre != nil) {//asignamos el sector del usuario que acabamos de recuperar, si el correo es nulo asignamos un texto por default
        self.sectorTxt.text = self.persona.toEmpresa.toSubsector.toSector.nombre;
    }else{
        self.sectorTxt.text = @"Sector";
    }
    if (self.persona.toEmpresa.toSubsector.nombre != nil) {//asignamos el subsector del usuario que acabamos de recuperar, si el correo es nulo asignamos un texto por default
        self.subsectorTxt.text = self.persona.toEmpresa.toSubsector.nombre;
    }else{
        self.subsectorTxt.text = @"Subsector";
    }
    if(self.persona.img != nil) {//asignamos la imagen del usuario que acabamos de recuperar, si el correo es nulo asignamos un texto por default
        self.oImagen.image = [[UIImage alloc] initWithData:self.persona.img];
    }
    //self.oEmail.textInputContextIdentifier = self.publicacion.toPersona.usuario;
    
    
    self.listaPublicaciones = [[NSArray alloc] init];//inicializamos el arreglo donde guardaremos las publicaciones
    self.listaPublicaciones = [consulta recuperaConsultasPorPersona:self.persona];//recuperamos las publicaciones
    
    
    //ordenadas
    NSSortDescriptor *byFechaIni = [NSSortDescriptor sortDescriptorWithKey:@"fechaIni" ascending:NO];//creamos una regla para ordenar las publicaciones de nuetro circulo segun la fecha de inicio
    NSSortDescriptor *byFechaFin = [NSSortDescriptor sortDescriptorWithKey:@"fecha" ascending:NO];//creamos una regla para ordenar las publicaciones de nuetro circulo segun la fecha de fin
    NSSortDescriptor *byTitulo = [NSSortDescriptor sortDescriptorWithKey:@"titulo" ascending:NO];//creamos una regla para ordenar las publicaciones de nuetro circulo segun el titulo
    NSSortDescriptor *byDescripcion = [NSSortDescriptor sortDescriptorWithKey:@"descripcion" ascending:NO];//creamos una regla para ordenar las publicaciones de nuetro circulo segun la descripcion
    NSArray *sortDescriptors = [NSArray arrayWithObjects:byFechaIni, byFechaFin, byTitulo,byDescripcion, nil];//asignamos el orden de las reglas
    self.listaPublicaciones = [self.listaPublicaciones sortedArrayUsingDescriptors:sortDescriptors];//reordenamos el arreglo aplicando las reglas
    
    
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

- (BOOL) personaEstaEnCirculo:(Persona*)persona {//averiguar si una persona pertenece a tu circulo
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
    static NSString *cellIdentifier = @"publicacionCell";//donamos un identificador a las celdas
    
    BUMinVistaViewController *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];//inicializamos una celda costumizada
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BUMinVistaViewController" owner:self
                                            options:nil] lastObject];
    }
    Publicacion *publicacion = self.listaPublicaciones[indexPath.row];//asignamos un objeto a la celda
    
    if (publicacion.descripcion != nil) {//asignamos la descripcion de la publicacion que recuperamos, si es nulo asignamos uno por default
        cell.txtDescripcion.text = publicacion.descripcion;
    }else{
        cell.txtDescripcion.text = @"Descripcion";
    }
    if (publicacion.titulo != nil) {//asignamos el titulo de la publicacion que recuperamos, si es nulo asignamos uno por default
        cell.txtTitulo.text = publicacion.titulo;
    }else{
        cell.txtTitulo.text = @"Titulo";
    }
    if (publicacion.toSubsector.toSector.nombre != nil) {//asignamos el sector de la publicacion que recuperamos, si es nulo asignamos uno por default
        cell.txtSector.text = publicacion.toSubsector.toSector.nombre;
    }else{
        cell.txtSector.text = @"Sector";
    }
    //cell.txtSector.text = publicacion.toSubsector.toSector.nombre;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];//inicializamos un obejeto fecha
    [df setDateFormat:@"MM/dd/yyyy"];//seteamos un formato para la fecha
    cell.txtFechaInicio.text = [df stringFromDate:publicacion.fechaIni];
    cell.txtFechaFin.text = [df stringFromDate:publicacion.fecha];
    //cell.txtSector.text = publicacion.toSubsector.toSector.nombre;
    if(publicacion.img != nil) {//asignamos la imagen de la publicacion que recuperamos, si es nulo asignamos uno por default
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
