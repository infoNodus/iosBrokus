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


@property (strong) Persona *persona;

@property (strong, nonatomic) IBOutlet UILabel *personaTxt;
@property (strong, nonatomic) IBOutlet UILabel *empresaTxt;
@property (strong, nonatomic) IBOutlet UILabel *puestoTxt;
@property (strong, nonatomic) IBOutlet UILabel *subsectorTxt;
@property (strong, nonatomic) IBOutlet UILabel *sectorTxt;
@property (weak, nonatomic) IBOutlet UIImageView *oImagen;

-(id) initWithPersona:(Persona *)persona;


@end
