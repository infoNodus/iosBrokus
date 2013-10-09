//
//  BUFechaViewController.h
//  BrockUs
//
//  Created by Nodus5 on 03/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BUFechaDelegate;
@interface BUFechaViewController : UIViewController
{
    //DATE PICKER
    UIDatePicker *datepick;
    IBOutlet UILabel *label;
    IBOutlet UITextField *textfield;
}
- (IBAction)button;
@property (nonatomic, retain)IBOutlet UIDatePicker *datepick;
//////////////

@end
