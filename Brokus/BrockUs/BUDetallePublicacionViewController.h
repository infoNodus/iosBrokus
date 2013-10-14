//
//  BUDetallePublicacionViewController.h
//  BrockUs
//
//  Created by Nodus3 on 04/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class Publicacion;

@interface BUDetallePublicacionViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (strong) Publicacion *publicacion;
@property (weak, nonatomic) IBOutlet UIImageView *oImagen;
@property (weak, nonatomic) IBOutlet UITextView *oDetalle;
@property (weak, nonatomic) IBOutlet UILabel *oPersona;
@property (weak, nonatomic) IBOutlet UILabel *oEmpresa;
@property (weak, nonatomic) IBOutlet UIButton *oEmail;
@property (weak, nonatomic) IBOutlet UIButton *oDescarga;

-(id) initWithPublicacion:(Publicacion *)publicacion;
@end
