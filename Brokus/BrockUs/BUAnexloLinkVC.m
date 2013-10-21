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

// Se inicializa con una url
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
    // Se crea la peticion
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    
    NSHTTPURLResponse *response;
    NSError *error;
    
    // Se realiza la peticion
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
    NSString *mensajeError = @"";
    // Verificamos si ocurrio un error al momento de la peticion. si es asi mostramos el mensaje del error.
    if(error) {
        mensajeError = error.description;
        if (error.code == -1002) {
            mensajeError = [NSString stringWithFormat:@"Error de la peticion a la pagina: %@", self.urlStr];
        } else if (error.code == -1009) {
            mensajeError = @"No existe conexión a internet";
        }
        NSLog(@"%@",error);
        NSString *titleError = [NSString stringWithFormat:@"Error %i",error.code];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:titleError message:mensajeError delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    

    // Mostramos contenido de la peticion.
    [self.oAnexo loadData:responseData MIMEType:[response MIMEType]
          textEncodingName:[response textEncodingName]
                   baseURL:[response URL]];
}

@end
