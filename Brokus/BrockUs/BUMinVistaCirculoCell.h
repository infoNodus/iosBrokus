//
//  BUMinVistaCirculoCell.h
//  BrockUs
//
//  Created by Nodus3 on 11/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BUMinVistaCirculoCell.h"
#import "BUCirculoConfianzaViewController.h"

@interface BUMinVistaCirculoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;//propiedad para acceder a la imagen
@property (strong, nonatomic) IBOutlet UILabel *empresaTxt;//propiedad para acceder a empresaTxt
@property (strong, nonatomic) IBOutlet UILabel *usuarioTxt;//propiedad para acceder a usuarioTxt
@property (strong, nonatomic) IBOutlet UILabel *cargoTxt;//propiedad para acceder a cargoTxt

@end
