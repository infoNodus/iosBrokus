//
//  BUMuroPublicacionesViewController.h
//  BrockUs
//
//  Created by Nodus5 on 26/09/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BUMuroPublicacionesDelegate ;

@interface BUMuroPublicacionesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak) id <BUMuroPublicacionesDelegate> delegate;
- (IBAction)CancelarTapped:(id)sender;


@end
