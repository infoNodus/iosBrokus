//
//  BUDetallePublicacionViewController.h
//  BrockUs
//
//  Created by Nodus3 on 04/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Publicacion;

@interface BUDetallePublicacionViewController : UIViewController

@property (strong) Publicacion *publicacion;
@property (weak, nonatomic) IBOutlet UIImageView *imgImagen;
@property (weak, nonatomic) IBOutlet UILabel *txtSector;
@property (weak, nonatomic) IBOutlet UITextView *txtDetalle;

-(id) initWithPublicacion:(Publicacion *)publicacion;
@end
