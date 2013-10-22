//
//  BUPerfilEmpresaDesconocidoViewController.h
//  BrockUs
//
//  Created by Nodus9 on 08/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class Persona;//incluimos la clase persona

@interface BUPerfilEmpresaDesconocidoViewController : UIViewController <MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>


@property (strong) Persona *persona;//creamos una propiedad para acceder a un objeto persona

@property (strong, nonatomic) IBOutlet UILabel *personaTxt;//creamos una propiedad para acceder al label persona
@property (strong, nonatomic) IBOutlet UILabel *empresaTxt;//creamos una propiedad para acceder al label empresa
@property (strong, nonatomic) IBOutlet UILabel *puestoTxt;//creamos una propiedad para acceder al label puesto
@property (strong, nonatomic) IBOutlet UILabel *subsectorTxt;//creamos una propiedad para acceder al label subsector
@property (strong, nonatomic) IBOutlet UILabel *sectorTxt;//creamos una propiedad para acceder al label sector
@property (weak, nonatomic) IBOutlet UIImageView *oImagen;//creamos una propiedad para acceder a la imagen

-(id) initWithPersona:(Persona *)persona;//funcion para inicializar con un objeto persona


@end
