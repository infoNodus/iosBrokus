//
//  BUMinVistaViewController.h
//  BrockUs
//
//  Created by Nodus9 on 04/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BUMinVistaViewController : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *txtTitulo;
@property (weak, nonatomic) IBOutlet UITextView *txtDescripcion;
@property (weak, nonatomic) IBOutlet UILabel *txtSector;
@property (weak, nonatomic) IBOutlet UIImageView *imgImagen;

@end
