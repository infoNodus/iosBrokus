//
//  BUPerfilePersonalViewController.m
//  BrockUs
//
//  Created by Nodus9 on 04/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import "BUPerfilePersonalViewController.h"
#import "BUPerfilEmpresaViewController.h"

@interface BUPerfilePersonalViewController ()
@property BUPerfilEmpresaViewController *regresar;

@end

@implementation BUPerfilePersonalViewController

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
    self.regresar=[[BUPerfilEmpresaViewController alloc]initWithNibName:@"BUPerfilEmpresaViewController" bundle:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)AgregarMisCirculos:(id)sender {
      NSLog(@"hdjfhdjf");
}

- (IBAction)EnviarMensaje:(id)sender {
      NSLog(@"hdjfhdjf");
}

- (IBAction)salir:(id)sender {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    [UIView commitAnimations];
    self.regresar.delegate =(id)self;
    [self presentViewController:self.regresar animated:YES completion:nil];
    NSLog(@"hdjfhdjf");
}
@end
