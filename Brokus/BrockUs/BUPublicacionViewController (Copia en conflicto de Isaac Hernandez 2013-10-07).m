//
//  BUPublicacionViewController.m
//  BrockUs
//
//  Created by Nodus9 on 04/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import "BUPublicacionViewController.h"
#import "BUPerfilEmpresaViewController.h"
#import "BUInvitarPersonaViewController.h"
#import "BUMuroPublicacionesViewController.h"
#import "BUAppDelegate.h"
#import "Publicacion.h"
#import "BUSeleccionaFechaViewController.h"
#import "ComboSector.h"


@interface BUPublicacionViewController (){
 NSManagedObjectContext *context;
    ComboSector* sector;
    ComboSector* subsector;
    NSArray* sub;
}

@property (strong) BUPerfilEmpresaViewController *perfil;
@property (strong) BUInvitarPersonaViewController *invitar;
@property (strong) BUMuroPublicacionesViewController *muro;
@property (strong) BUSeleccionaFechaViewController *selfecha;
@property (nonatomic, retain) NSManagedObjectContext *context;

@end


@implementation BUPublicacionViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//VALIDACIONES

// Valida todo
- (BOOL)validar {
    if([self entradasVacias]) {
        [self verAlertaError:@"Las cajas de texto no deben estar vacias."];
        return NO;
    }
    return YES;
}

- (void) verAlertaError:(NSString *)mensaje {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:mensaje delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}
// Valida que las cajas de texto no esten vacias.
- (BOOL) entradasVacias{
    if([self.tituloTxt.text isEqualToString:@""]) {
        //[self.nombreEmpresaTxt becomeFirstResponder];
        return YES;
    }
    
    if([self.DescripcionTxt.text isEqualToString:@""]) {
        //[self.nombrePersonaTxt becomeFirstResponder];
        return YES;
    }
    return NO;
}
//Termina validacion

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.perfil=[[BUPerfilEmpresaViewController alloc] initWithNibName:@"BUPerfilEmpresaViewController" bundle:nil];
    self.invitar=[[BUInvitarPersonaViewController alloc]initWithNibName:@"BUInvitarPersonaViewController" bundle:nil];
    self.muro=[[BUMuroPublicacionesViewController alloc]initWithNibName:@"BUMuroPublicacionesViewController" bundle:nil];
    
    self.selfecha=[[BUSeleccionaFechaViewController alloc]initWithNibName:@"BUSeleccionaFechaViewController" bundle:nil];
    
    
    
    self.context = [self context];
    
    if (self.context == nil)
    {
        self.context = [(BUAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    self.DescripcionTxt.text=@"";
    
    
    NSError *error;
    NSFetchRequest *requestSector = [[NSFetchRequest alloc] init];
    NSEntityDescription *selectSector = [NSEntityDescription
                                         entityForName:@"Sector" inManagedObjectContext:context];
    
    [requestSector setEntity:selectSector];
    
    NSArray *fetchedSector= [context executeFetchRequest:requestSector error:&error];
    
    sector = [[ComboSector alloc] init];
    [sector setComboData:fetchedSector];
    [self.view addSubview:sector.view];
    sector.view.frame = CGRectMake(10, 450, 302, 31);

}

-(void)cargaSubsector: (NSArray*)array{
    sub=[[NSArray alloc] init];
    sub=array;
}

-(void)viewWillAppear:(BOOL)animated{
    subsector=[[ComboSector alloc]init];
    [subsector setComboData:sub];
    [self.view addSubview:subsector.view];
    subsector.view.frame = CGRectMake(10, 490, 302, 31);
}

//ocultar teclado
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([textField.text length] == 0) {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelar:(id)sender {
    
    self.perfil.delegate=self;
    [self presentViewController:self.perfil animated:YES completion:nil];
   


}

- (IBAction)Aceptar:(id)sender{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSError *error;
    NSLog(@"Context: %@", context);
    NSEntityDescription *sector = [NSEntityDescription entityForName:@"Subsector" inManagedObjectContext:context];
    Publicacion *insertarPublicacion = [NSEntityDescription insertNewObjectForEntityForName:@"Publicacion" inManagedObjectContext:context];
    [fetchRequest setEntity:insertarPublicacion];
    NSArray *fetchedPublicacion = [context executeFetchRequest:fetchRequest error:&error];
    insertarPublicacion.titulo=self.tituloTxt.text;
    insertarPublicacion.descripcion=self.DescripcionTxt.text;
    /*
    NSManagedObject *newPublicacion = [[NSManagedObject alloc]initWithEntity:entitydesc insertIntoManagedObjectContext:context];
    [newPublicacion setValue:self.tituloTxt.text forKey:@"tituloTxt"];
    [newPublicacion setValue:self.DescripcionTxt.text forKey:@"DescripcionTxt"];
    
    NSError *error;
    [context save:&error];
    self.displayLabel.text = @"Person added.";*/
    
    
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext=[delegate managedObjectContext];
    NSManagedObjectContext *context=[self managedObjectContext];
    //NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]init];
   // NSError *error;
    
    Publicacion *insertPublicacion=[NSEntityDescription insertNewObjectForEntityForName:@"Publicacion" inManagedObjectContext:context];
    
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Publicacion" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    insertPublicacion.fecha=nil;
    insertPublicacion.titulo=self.tituloTxt.text;
    insertPublicacion.descripcion=self.DescripcionTxt.text;
    
    
    
   /* NSDateFormatter *dataFormat=[[NSDateFormatter alloc]init];
    [dataFormat setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *timeFormat=[[NSDateFormatter alloc]init];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    NSDate *now=[[NSDate alloc]init];
    NSString *theDate=[dataFormat stringFromDate:now];
    NSString *theTime=[timeFormat stringFromDate:now]; */
    
    //  insertPublicacion.anexo=self.anexoTxt.text;
    
    [self.DescripcionTxt becomeFirstResponder];
    
    //insertPublicacion.fecha=[NSString stringWithFormat:theDate,theTime];
    
    
    
    
    //insertar imagen
    //escribe imagen en disco (mover este pedaso de codigo para que no escriba la imagen en disco cada que la seleccionamos)
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 1);
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *nombreImagen = self.tituloTxt.text;
    path = [path stringByAppendingString:@"/yourLocalImage.jpg"];
    [imageData writeToFile:path atomically:YES];
    //escribe imagen en disco (mover este pedaso de codigo para que no escriba la imagen en disco cada que la seleccionamos)
    
    
    
    NSString *pathDos = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *dirContents = [fileMgr contentsOfDirectoryAtPath:pathDos error:nil];
    NSPredicate *extFilter = [NSPredicate predicateWithFormat:@"self ENDSWITH '.jpg'"];
    NSArray *onlyJPGs = [dirContents filteredArrayUsingPredicate:extFilter];
    
    for(NSString* fname in onlyJPGs)
    {
        
        //[self insertNewObject:fname];
        insertPublicacion.urlPath =[self getPath:fname];
        insertPublicacion.nameImg = fname;
        insertPublicacion.img = [self getImageBinary:fname];
        //revisar logica del codigo, es necesario q solo busque la imagen en especifico
    }
    //insertar imagen
    
    //    //test con modelos
    //
    //    Publicacion *nuevaPublicacion=[NSEntityDescription insertNewObjectForEntityForName:@"Publicacion" inManagedObjectContext:context];
    //    NSEntityDescription *entityTest=[NSEntityDescription entityForName:@"Publicacion" inManagedObjectContext:context];
    //    nuevaPublicacion.titulo = self.tituloTxt.text;
    //    nuevaPublicacion.fecha = nil;
    //    nuevaPublicacion.descripcion = self.descripcionTxt.text;
    //    [nuevaPublicacion insertPublicacionDatos];
    //
    //    //test con modelos
    self.muro.delegate=self;
    [self presentViewController:self.muro animated:YES completion:nil];
}

- (IBAction)cargarImagen:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
    [self.cargarImagenButton setBackgroundColor:[UIColor blueColor]]; //mejorar el diseño
}

- (IBAction)Invitar:(id)sender {
    self.invitar.delegate=self;
    [self presentViewController:self.invitar animated:YES completion:nil];
}

- (IBAction)Recomendar:(id)sender {
}

- (IBAction)CargarArchivo:(id)sender {
}

- (IBAction)Fecha:(id)sender {
    self.selfecha.delegate=self;
    [self presentViewController:self.selfecha animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    CGSize newSize = CGSizeMake(80.0,80.0);
    UIGraphicsBeginImageContext(newSize);
    [chosenImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //agregar imagen a un uiimage fuera de la pantalla para despues poder recuperarlo
    self.imageView.image = newImage;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.frame = CGRectMake(120, 140, 80, 80);
    //agregar imagen a un uiimage fuera de la pantalla para despues poder recuperarlo
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self.cargarImagenButton setBackgroundColor:[UIColor whiteColor]];
}

//- (void)insertNewObject:(NSString *)fileName{
//    NSManagedObject *publicacion = [NSEntityDescription
//                                    insertNewObjectForEntityForName:@"Publicacion"
//                                    inManagedObjectContext:º];
//    [publicacion setValue:[self getPath:fileName] forKey:@"urlPath"];
//    [publicacion setValue:[self getImageBinary:fileName] forKey:@"img"];
//    [publicacion setValue:fileName forKey:@"nameImg"];
//    [publicacion setValue:nil forKey:@"descripcion"];
//    [publicacion setValue:nil forKey:@"fecha"];
//    //[publicacion setValue:nil forKey:@"id"];
//    [publicacion setValue:nil forKey:@"titulo"];
//    NSLog(@"insercion realizada");
//    //insert
//    // Save the context.
//    NSError *error = nil;
//    if (![self.context save:&error]) {
//        // Replace this implementation with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    //NSString *direccion = [self getPath:fileName];
//}

-(NSString *)getPath:(NSString *)fileName{
    NSString *root = [[NSBundle mainBundle] bundlePath];
    NSURL *imageURL = [[NSURL alloc] initFileURLWithPath:[root stringByAppendingString:[@"/" stringByAppendingString:fileName]]];
    [imageURL absoluteURL];
    NSString *path= [imageURL absoluteString];
    NSLog(@"%@",path);
    return path;
}

-(NSData *)getImageBinary:(NSString *)fileName{
    NSString *root = [[NSBundle mainBundle] bundlePath];
    NSString *filePath = [[NSString alloc] initWithString:[root stringByAppendingString:[@"/"stringByAppendingString:fileName]]];
    NSLog(@"%@",filePath);
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:[root stringByAppendingString:[@"/"stringByAppendingString:fileName]]];
    NSData *imgData = UIImageJPEGRepresentation(img, 1.0);
    return imgData;
}
@end
