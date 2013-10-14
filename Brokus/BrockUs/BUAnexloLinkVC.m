//
//  BUAnexloLinkVC.m
//  BrockUs
//
//  Created by Nodus3 on 14/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import "BUAnexloLinkVC.h"

@interface BUAnexloLinkVC ()
@property (weak, nonatomic) IBOutlet UIWebView *oAnexo;
@property (strong) NSString *urlStr;
@end

@implementation BUAnexloLinkVC

- (id)initWithURL:(NSString *)urlStr;
{
    self = [super initWithNibName:@"BUAnexloLinkVC" bundle:nil];
    if (self) {
        self.urlStr = urlStr;
        self.title = @"Link Anexo";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.oAnexo loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
