//
//  BUCirculoConfianzaViewController.h
//  BrockUs
//
//  Created by Nodus5 on 10/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BUCirculoConfianzaDelegate;//asignamos una delegado para el circulo de confianza

@interface BUCirculoConfianzaViewController : UIViewController

@property (weak) id <BUCirculoConfianzaDelegate> delegate;//propiedad para acceder a un delegado
@property (weak, nonatomic) IBOutlet UIImageView *ImageUser;//propiedad para acceder a la imagen
@property (weak, nonatomic) IBOutlet UILabel *EnterpriseUser;//propiedad para acceder a la empresa
@property (weak, nonatomic) IBOutlet UILabel *UserNameBrockus;//propiedad para acceder al usuario
@property (weak, nonatomic) IBOutlet UILabel *PuestoUser;//propiedad para acceder al puesto
@property (weak, nonatomic) IBOutlet UILabel *MailUser;//propiedad para acceder al mail
@property (weak, nonatomic) IBOutlet UILabel *Sector;//propiedad para acceder al sector

- (IBAction)Salir:(id)sender;

@end
