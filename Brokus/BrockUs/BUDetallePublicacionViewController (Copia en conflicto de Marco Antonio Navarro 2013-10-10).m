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
#import "Persona.h"
#import "Empresa.h"
#import "Publicacion.h"

@interface BUDetallePublicacionViewController ()

@end

@implementation BUDetallePublicacionViewController

-(id) initWithPublicacion:(Publicacion *)publicacion {
    self = [super initWithNibName:@"BUDetallePublicacionViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.publicacion = publicacion;
        self.title=self.publicacion.titulo;
        self.oEmail.titleLabel.text = self.publicacion.toPersona.usuario;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.oDetalle.text = self.publicacion.descripcion;
    self.oSector.text = self.publicacion.toSubsector.toSector.nombre;
    if(self.publicacion.img != nil) {
        self.oImagen.image = [[UIImage alloc] initWithData:self.publicacion.img];
    }
    self.oPersona.text = self.publicacion.toPersona.nombre;
    self.oSubsector.text = self.publicacion.toSubsector.nombre;
    self.oEmpresa.text = self.publicacion.toPersona.toEmpresa.nombre;
    //self.oEmail.textInputContextIdentifier = self.publicacion.toPersona.usuario;
    [self.oEmail setTitle:self.publicacion.toPersona.usuario forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
