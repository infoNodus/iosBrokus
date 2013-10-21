//
//  BUCirculoConfianzaViewController.h
//  BrockUs
//
//  Created by Nodus5 on 10/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BUCirculoConfianzaDelegate;

@interface BUCirculoConfianzaViewController : UIViewController

@property (weak) id <BUCirculoConfianzaDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *ImageUser;
@property (weak, nonatomic) IBOutlet UILabel *EnterpriseUser;
@property (weak, nonatomic) IBOutlet UILabel *UserNameBrockus;
@property (weak, nonatomic) IBOutlet UILabel *PuestoUser;
@property (weak, nonatomic) IBOutlet UILabel *MailUser;
@property (weak, nonatomic) IBOutlet UILabel *Sector;

- (IBAction)Salir:(id)sender;

@end
