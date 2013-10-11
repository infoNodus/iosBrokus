//
//  BUInvitarPersonaViewController.h
//  BrockUs
//
//  Created by Nodus5 on 26/09/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BUInvitarPersonaDelegate;
@interface BUInvitarPersonaViewController : UIViewController

@property (weak) id <BUInvitarPersonaDelegate> delegate;

@end
