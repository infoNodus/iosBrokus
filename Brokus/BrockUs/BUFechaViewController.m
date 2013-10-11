//
//  BUFechaViewController.m
//  BrockUs
//
//  Created by Nodus5 on 03/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import "BUFechaViewController.h"

@interface BUFechaViewController ()

@end

@implementation BUFechaViewController
@synthesize datepick;
-(IBAction)button{
    NSDate *choice = [datepick date];
    NSString *words = [[NSString alloc]initWithFormat:@"The date is %@", choice];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"the title" message:words delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    
    [alert show];
  //  [alert release];
    //[words release];
    
    label.text = words;
    textfield.text = words;
}
-(void)dealloc{
    //[datepick release];
    //[super dealloc];
}
- (void)viewDidUnload
{
    self.datepick = nil;
    [super viewDidUnload];
    // Do any additional setup after loading the view from its nib.
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
