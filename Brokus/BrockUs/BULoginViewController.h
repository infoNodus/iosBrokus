//
//  BULoginViewController.h
//  BrockUs
//
//  Created by HUB 3C 2 on 25/09/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BULoginViewControllerDelegate;
@interface BULoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *UsertInputText;
@property (weak, nonatomic) IBOutlet UITextField *PassInputText;

@property (weak) id <BULoginViewControllerDelegate> delegate;
 
- (IBAction)LoginBtnTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *ErrrorLabel;
 
- (IBAction)RegisterBtnTapped:(id)sender;
- (BOOL) validateEmail: (NSString *) candidate;

- (BOOL) validaPass: (NSString *) pass;
@end
