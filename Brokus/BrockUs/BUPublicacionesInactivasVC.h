//
//  BUPublicacionesInactivasVC.h
//  BrockUs
//
//  Created by Nodus12 on 11/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Publicacion.h"

@interface BUPublicacionesInactivasVC : UITableViewController

@property (strong) Publicacion *pub;
-(void)reloadTable;

@end
