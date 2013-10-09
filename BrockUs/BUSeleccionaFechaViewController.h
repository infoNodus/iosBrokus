//
//  BUSeleccionaFechaViewController.h
//  BrockUs
//
//  Created by Nodus5 on 04/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BUPerfilEmpresaViewController.h"
#import "BUPublicacionViewController.h"

@protocol BUSeleccionarFechaDelegate;
@interface BUSeleccionaFechaViewController : UIViewController
//picker
{
    IBOutlet UILabel *dateLabel;
    IBOutlet UIDatePicker *datePicker;
}
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UILabel *datelabel;
- (IBAction)CancelarTapped:(id)sender;
- (IBAction)AcceptarTapped:(id)sender;

@property (weak) id <BUSeleccionarFechaDelegate> delegate;
///termina declaracion picker
@end
