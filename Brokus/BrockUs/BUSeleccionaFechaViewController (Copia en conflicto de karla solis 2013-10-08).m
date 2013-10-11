//
//  BUSeleccionaFechaViewController.m
//  BrockUs
//
//  Created by Nodus5 on 04/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import "BUSeleccionaFechaViewController.h"
#import "BUPublicacionViewController.h"
#import "BUAppDelegate.h"
#import "Publicacion.h"
#import "BUPerfilEmpresaViewController.h"
@interface BUSeleccionaFechaViewController (){
    NSManagedObjectContext *context;
}
@property (strong) BUPublicacionViewController *publicacion;

@end

@implementation BUSeleccionaFechaViewController
//declaracion de picker para fecha
@synthesize datePicker;
@synthesize datelabel;
- (void) dealloc{
   
}
- (void)LabelChange:(id)sender{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    dateLabel.text = [NSString stringWithFormat:@"%@",
                      [df stringFromDate:datePicker.date]];
    
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
//Terminan metodos y codigo de picker


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
    //se hace la conexion a la base de datos
    BUAppDelegate * buappdelegate=[[UIApplication sharedApplication]delegate];
    context = [buappdelegate managedObjectContext];
    
    
    //codigo para la fecha
    dateLabel = [[UILabel alloc] init];
    dateLabel.frame = CGRectMake(10, 200, 300, 40);
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.font = [UIFont fontWithName:@"Verdana-Bold" size: 20.0];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    dateLabel.text = [NSString stringWithFormat:@"%@",
                      [df stringFromDate:[NSDate date]]];
    
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 250, 325, 300)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.hidden = NO;
    datePicker.date = [NSDate date];
    
    [datePicker addTarget:self
                   action:@selector(LabelChange:)
         forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
//    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *componentes = [gregorian components:NSYearCalendarUnit fromDate:];
//    NSInteger year = [componentes year];
//    int mindt = year -18;
//    int maxdt = year -100;
//    //NSDate * MaxDate = [componentes year] - 100;
//    //self.datePicker.maximumDate = MaxDate;
    
    //termina codigo picker fecha
    
    self.publicacion=[[BUPublicacionViewController alloc]initWithNibName:@"BUPublicacionViewController" bundle:nil];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)CancelarTapped:(id)sender {
    self.publicacion.delegate=(id)self;
    [self presentViewController:self.publicacion animated:YES completion:nil];
}

- (IBAction)AcceptarTapped:(id)sender {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSError *error;
    NSLog(@"Context: %@", context);
    
    //Consulta insert
    Publicacion *insertarFecha = [NSEntityDescription insertNewObjectForEntityForName:@"Publicacion" inManagedObjectContext:context];
    
    //Consulta select
    NSEntityDescription *fecha = [NSEntityDescription entityForName:@"Publicacion" inManagedObjectContext:context];
    //se asigna el resultado
    [fetchRequest setEntity:fecha];
    insertarFecha.fecha=self.datePicker.date;
    
    //NSArray *fetchedEmpresa = [context executeFetchRequest:fetchRequest error:&error];
    
    self.publicacion.delegate=(id)self;
    [self presentViewController:self.publicacion animated:YES completion:nil];
}
@end
