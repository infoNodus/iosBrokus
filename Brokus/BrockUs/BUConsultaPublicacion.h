//
//  BUConsultaPublicacion.h
//  BrockUs
//
//  Created by Nodus3 on 03/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Sector;
@class Persona;
@class Empresa;
@class Circulo;

@interface BUConsultaPublicacion : NSObject

- (NSMutableArray*) recuperaPublicacionPor:(Sector*)toSector context:(NSManagedObjectContext*) context;
- (Persona*) recuperaPersona:(NSString*)toUsuario :(NSManagedObjectContext*) context;
- (NSArray*) recuperaPublicacionPorEmpresa:(Empresa*)toEmpresa toContext:(NSManagedObjectContext*) context;
- (NSArray*) recuperaPersonasCirculoPorPersona:(Persona*)toCirculo toContext:(NSManagedObjectContext*) context;
- (void) desactivaPublicacionesCaducadastoContext:(NSManagedObjectContext*) context;
- (NSArray*) recuperaConsultasPorPersona:(Persona*)toPersona;
@end
