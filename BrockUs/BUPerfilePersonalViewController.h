//
//  BUPerfilePersonalViewController.h
//  BrockUs
//
//  Created by Nodus9 on 04/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BUPerfilePersonalViewControllerDelegate;
@interface BUPerfilePersonalViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *ImagePerfil;
@property (weak, nonatomic) IBOutlet UILabel *EmpresaLabel;
@property (weak, nonatomic) IBOutlet UILabel *NombrePersonaLabel;
@property (weak, nonatomic) IBOutlet UILabel *puestoPersonaLabel;
@property (weak, nonatomic) IBOutlet UILabel *CorreoLabel;
@property (weak, nonatomic) IBOutlet UILabel *PersonaSectorLabel;
@property (weak, nonatomic) IBOutlet UILabel *PersonaSubsectorLabel;

- (IBAction)AgregarMisCirculos:(id)sender;
- (IBAction)EnviarMensaje:(id)sender;
- (IBAction)salir:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *EnviarMensaje;
@property (weak) id <BUPerfilePersonalViewControllerDelegate> delegate;
@end
 