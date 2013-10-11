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

@protocol BUSeccionPublicacionesDelegate;

@interface BUSeccionPublicacionesViewController : UIViewController
@property (strong, nonatomic) BUPublicacionesActivasVC *presenterVC;
@property (strong, nonatomic) IBOutlet UIView *publicacionesActivas;
@property (strong, nonatomic) IBOutlet UIView *publicacionesInactivas;
@property (weak) id <BUSeccionPublicacionesDelegate> delegate;

- (IBAction)optionsTapped:(id)sender;

- (IBAction)cancelarTapped:(id)sender;

@end
