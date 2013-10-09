//
//  BUPerfilEmpresaViewController.h
//  BrockUs
//
//  Created by HUB 3C 2 on 25/09/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BUPerfilEmpresaViewController.h"
#import "BUPublicacionViewController.h"
@protocol BUPerfilEmpresaDelegate;

@interface BUPerfilEmpresaViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak) id <BUPerfilEmpresaDelegate> delegate;

@property (weak) UIViewController *presenterVC;
@property (weak, nonatomic) IBOutlet UIImageView *ImageUser;
@property (weak, nonatomic) IBOutlet UILabel *EnterpriseUser;
@property (weak, nonatomic) IBOutlet UILabel *UserNameBrockus;
@property (weak, nonatomic) IBOutlet UILabel *PuestoUser;
@property (weak, nonatomic) IBOutlet UILabel *MailUser;
@property (weak, nonatomic) IBOutlet UILabel *Sector;


- (IBAction)SalirTapped:(id)sender;
- (IBAction)CrearPublicacionBtn:(id)sender;
- (IBAction)Busqueda:(id)sender;
- (IBAction)miperfil:(id)sender;
- (IBAction)CirculoConfianza:(id)sender;

@end
