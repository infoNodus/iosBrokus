//
//  BUPublicacionesActivasVC.h
//  BrockUs
//
//  Created by Nodus12 on 10/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Publicacion.h"

@interface BUPublicacionesActivasVC : UITableViewController

@property (strong) Publicacion *pub;
-(void)reloadTable;

@end