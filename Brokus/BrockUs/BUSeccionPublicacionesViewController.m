//
//  BUSeccionPublicacionesViewController.m
//  BrockUs
//
//  Created by Nodus5 on 10/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import "BUSeccionPublicacionesViewController.h"
#import "BUPerfilEmpresaViewController.h"
@interface BUSeccionPublicacionesViewController (){
    
}



@end

@implementation BUSeccionPublicacionesViewController
@synthesize presenterVC;
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
    presenterVC=[[BUPublicacionesActivasVC alloc]init];
    [self presentaPublicacionesActivas];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)presentaPublicacionesActivas{
    [self addChildViewController:presenterVC];
    presenterVC.view.frame=CGRectMake(0, 44, 320, 504);
    [self.view addSubview:presenterVC.view];
    /*publicacionesActivas.frame=CGRectMake(0, 44, 320, 504);
     [presenterVC reloadTable];
     [publicacionesActivas addSubview:presenterVC.view];
     [self.view addSubview:publicacionesActivas];*/
    
}

-(void)presentaPublicacionesInActivas{
    publicacionesInactivas.frame=CGRectMake(0, 44, 320, 504);
    
    [self.view addSubview:publicacionesInactivas];
    
}

-(void)presentaPublicacionesInactivas{
    
}

- (IBAction)optionsTapped:(id)sender {
    UISegmentedControl *segmentedc=(UISegmentedControl *)sender;
    if(segmentedc.selectedSegmentIndex==0){
        [self presentaPublicacionesActivas];
    }else{
        
        [self presentaPublicacionesInActivas];
    }
}

- (IBAction)cancelarTapped:(id)sender {
    [presenterVC dismissViewControllerAnimated:YES completion:nil];
}
@end

