//
//  BUPerfilEmpresaDesconocidoViewController.h
//  BrockUs
//
//  Created by Nodus9 on 08/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Persona;

@interface BUPerfilEmpresaDesconocidoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (strong) Persona *persona;

@property (strong, nonatomic) IBOutlet UILabel *personaTxt;
@property (strong, nonatomic) IBOutlet UILabel *empresaTxt;
@property (strong, nonatomic) IBOutlet UILabel *puestoTxt;
@property (strong, nonatomic) IBOutlet UILabel *subsectorTxt;
@property (strong, nonatomic) IBOutlet UILabel *sectorTxt;

-(id) initWithPersona:(Persona *)persona;


@end
