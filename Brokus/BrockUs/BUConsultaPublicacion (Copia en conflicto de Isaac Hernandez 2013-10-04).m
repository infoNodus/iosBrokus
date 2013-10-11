//
//  BUConsultaPublicacion.m
//  BrockUs
//
//  Created by Nodus3 on 03/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import "BUConsultaPublicacion.h"
#import "Publicacion.h"
#import "Sector.h"
#import "Empresa.h"
#import "Persona.h"

@implementation BUConsultaPublicacion

/* recupera las publicaciones segun un sector especifico */
- (NSArray*) recuperaPublicacionPor:(Sector*)toSector :(NSManagedObjectContext*) context {
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Publicacion" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:entityDescription];
    
    // Ordenando de forma descendente segun la fecha.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fecha" ascending:NO];
    
    [request setSortDescriptors:@[sortDescriptor]];
    
    // Filtrando por el sector.
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"toSubsector.toSector = %@", toSector];
    
    // En dado caso de que no acepte un objeto para la busqueda....
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:
//                              @"toSubsector.toSector.id = %i", [toSector.id intValue]];
    
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if(error!=nil){
        NSLog(@"Regresando nil. Error al realizar consulta: %@", [error description]);
        return nil;
    }
    return array;
}


/* Busca una persona segun su usuario. */
- (Persona*) recuperaPersona:(NSString*)toUsuario :(NSManagedObjectContext*) context {
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Persona" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:entityDescription];
    
    // Filtrando por el sector.
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"usuario = %@", toUsuario];
    
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if(error!=nil){
        NSLog(@"Regresando nil. Error al realizar consulta: %@", [error description]);
        return nil;
    }
    if([array count] < 1) {
        NSLog(@"Regresando nil. No se encontro usuario: %@.", toUsuario);
        return nil;
    }
    return (Persona*)[array objectAtIndex:0];
}

/* Busca las publicaciones de la empresa. */
- (NSArray*) recuperaPublicacionPorEmpresa:(Empresa*)toEmpresa toContext:(NSManagedObjectContext*) context{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Persona" inManagedObjectContext:context];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"toEmpresa = %@", toEmpresa];
    [request setPredicate:predicate];
    
    NSError *error;
    
    NSArray *listaPersonas = [context executeFetchRequest:request error:&error];
    
    if(error != nil){
        NSLog(@"Regresando nil. Error al realizar consulta: %@", [error description]);
        return nil;
    }
    if([listaPersonas count] < 1) {
      //  NSLog(@"Regresando nil. No se encontro usuario: %@.", toUsuario);
        return nil;
    }
    return nil;
}

@end
