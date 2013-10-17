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

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *empresaTxt;
@property (strong, nonatomic) IBOutlet UILabel *usuarioTxt;
@property (strong, nonatomic) IBOutlet UILabel *cargoTxt;

@end
