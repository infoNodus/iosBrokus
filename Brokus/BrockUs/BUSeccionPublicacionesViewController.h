//
//  BUSeccionPublicacionesViewController.h
//  BrockUs
//
//  Created by Nodus5 on 10/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BUPublicacionesActivasVC.h"
#import "BUPerfilEmpresaViewController.h"
#import "BUSeccionPublicacionesViewController.h"
#import "BUPublicacionesInactivasVC.h"

@protocol BUSeccionPublicacionesDelegate;//asignamos una delegado para las publicaciones

@interface BUSeccionPublicacionesViewController : UIViewController
@property (strong, nonatomic) BUPublicacionesActivasVC *presentaActivas;//propiedad para acceder al controlador de publicaciones activas
@property (strong) BUPublicacionesInactivasVC *presentaInactivas;//propiedad para acceder al controlador de publicaciones inactivas
@property (strong, nonatomic) IBOutlet UIView *publicacionesActivas;//propiedad para acceder a las publicaciones activas
@property (strong, nonatomic) IBOutlet UIView *publicacionesInactivas;//propiedad para acceder a las publicaciones inactivas
@property (weak) id <BUSeccionPublicacionesDelegate> delegate;//propiedad para acceder a un delegado
- (IBAction)canceltapped:(id)sender;

- (IBAction)optionsTapped:(id)sender;


@end
