//
//  BUSeccionPublicacionesViewController.m
//  BrockUs
//
//  Created by Nodus5 on 10/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
// proyecto

#import "BUSeccionPublicacionesViewController.h"
#import "BUPerfilEmpresaViewController.h"
#import "BUConsultaPublicacion.h"
#import "BUAppDelegate.h"

@interface BUSeccionPublicacionesViewController (){
    
}

@property (strong) BUPerfilEmpresaViewController *perfil;

@end

@implementation BUSeccionPublicacionesViewController
@synthesize presentaActivas;
@synthesize presentaInactivas;
@synthesize publicacionesActivas;
@synthesize publicacionesInactivas;

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
    
    
    [self presentaPublicacionesActivas];
    self.perfil=[[BUPerfilEmpresaViewController alloc]initWithNibName:@"BUPerfilEmpresaViewController" bundle:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)presentaPublicacionesActivas{
    presentaActivas=[[BUPublicacionesActivasVC alloc]init];
    [self addChildViewController:presentaActivas];
    presentaActivas.view.frame=CGRectMake(0, 44, 320, 504);
    [self.view addSubview:presentaActivas.view];
    
}


-(void)presentaPublicacionesInactivas{
    presentaInactivas=[[BUPublicacionesInactivasVC alloc]init];
    [self addChildViewController:presentaInactivas];
    presentaInactivas.view.frame=CGRectMake(0, 44, 320, 504);
    [self.view addSubview:presentaInactivas.view];
}

- (IBAction)canceltapped:(id)sender {
    self.perfil.delegate=(id)self;
    BUAppDelegate *buappdelegate=[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context =[buappdelegate managedObjectContext];
    [[[BUConsultaPublicacion alloc] init] desactivaPublicacionesCaducadastoContext:context];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.perfil];
    [self presentViewController:nc animated:YES completion:nil];
    
      [presentaActivas dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)optionsTapped:(id)sender {
    UISegmentedControl *segmentedc=(UISegmentedControl *)sender;
    if(segmentedc.selectedSegmentIndex==0){
        [presentaActivas reloadTable];
        [self presentaPublicacionesActivas];
    }else{
        [presentaInactivas reloadTable];
        [self presentaPublicacionesInactivas];
    }
}



@end

