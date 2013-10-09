//
//  BUDetallePublicacionViewController.m
//  BrockUs
//
//  Created by Nodus3 on 04/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import "BUDetallePublicacionViewController.h"
#import "Sector.h"
#import "Subsector.h"
#import "Publicacion.h"

@interface BUDetallePublicacionViewController ()

@end

@implementation BUDetallePublicacionViewController

-(id) initWithPublicacion:(Publicacion *)publicacion {
    self = [super initWithNibName:@"BUDetallePublicacionViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.publicacion = publicacion;
        self.navigationController.title=self.publicacion.titulo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.txtDetalle.text = self.publicacion.descripcion;
    self.txtSector.text = self.publicacion.toSubsector.toSector.nombre;
    if(self.publicacion.img != nil) {
        self.imgImagen.image = [[UIImage alloc] initWithData:self.publicacion.img];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
