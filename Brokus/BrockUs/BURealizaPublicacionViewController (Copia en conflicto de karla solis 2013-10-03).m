//
//  BURealizaPublicacionViewController.m
//  BrockUs
//
//  Created by Nodus5 on 02/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import "BURealizaPublicacionViewController.h"
#import "Publicacion.h"
#import "BUAppDelegate.h"
#import "BUPerfilEmpresaViewController.h"
#import "Sector.h"
#import "Subsector.h"

@interface BURealizaPublicacionViewController ()
    NSManagedObjectContext *context;
@property (strong) BURegistroViewController *registro;

@end

@implementation BURealizaPublicacionViewController

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
    //self.registro=[[ alloc] initWithNibName:@"BULoginViewController" bundle:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)aceptartapped:(id)sender {
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext=[delegate managedObjectContext];
    NSManagedObjectContext *context=[self managedObjectContext];
    NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]init];
    NSError *error;
    
    Publicacion *insertPublicacion=[NSEntityDescription insertNewObjectForEntityForName:@"Publicacion" inManagedObjectContext:context];
    
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Publicacion" inManagedObjectContext:context];
    
    
    [fetchRequest setEntity:entity];
    
    NSDateFormatter *dataFormat=[[NSDateFormatter alloc]init];
    [dataFormat setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *timeFormat=[[NSDateFormatter alloc]init];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    NSDate *now=[[NSDate alloc]init];
    NSString *theDate=[dataFormat stringFromDate:now];
    NSString *theTime=[timeFormat stringFromDate:now];
    
    //  insertPublicacion.anexo=self.anexoTxt.text;
    insertPublicacion.descripcion=self.descripcionTxt.text;
    insertPublicacion.fecha=[NSString stringWithFormat:theDate,theTime];
    insertPublicacion.titulo=self.tituloTxt.text;
}

- (IBAction)canceltapped:(id)sender {
}

- (IBAction)CargarImagenBtn:(id)sender {
}
- (IBAction)InvitarBtn:(id)sender {
}

- (IBAction)CargarArchivoBtn:(id)sender {
}

- (IBAction)RecomendarBtn:(id)sender {
}

- (IBAction)FechaBtn:(id)sender {
    self.registro.delegate=self;
    [self presentViewController:self.registro animated:YES completion:nil];
   
    
}
//
//- (IBAction)InvitarBtn:(id)sender {
//}
@end
