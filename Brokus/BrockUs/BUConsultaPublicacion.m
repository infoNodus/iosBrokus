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
#import "Circulo.h"

@implementation BUConsultaPublicacion

/* recupera las publicaciones segun un sector especifico */
- (NSMutableArray*) recuperaPublicacionPor:(Sector*)toSector context:(NSManagedObjectContext*) context {
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Publicacion" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:entityDescription];
    
    // Ordenando de forma descendente segun la fecha.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fecha" ascending:NO];
    
    [request setSortDescriptors:@[sortDescriptor]];
    
    
    NSNumber *status=[[NSNumber alloc]initWithInt:1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"toSubsector.toSector = %@ AND status=%@", toSector,status];
    
     //En dado caso de que no acepte un objeto para la busqueda....
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:
//                              @"toSubsector.toSector.id = %i", [toSector.id intValue]];
    
    [request setPredicate:predicate];
    
    NSError *error;
    NSMutableArray *array=[[NSMutableArray alloc]init];
    array = [[context executeFetchRequest:request error:&error]mutableCopy];
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
        NSLog(@"Regresando nil. No se encontraron personas de la empresa: %@",toEmpresa.nombre);
        return nil;
    }
    
    NSMutableArray *listaPublicaciones = [[NSMutableArray alloc] init];
    
    for (Persona *p in listaPersonas) {
        if([p.toPublicacion count]<1) {
            continue;
        }
        for (Publicacion *pb in p.toPublicacion) {
            if([pb.status isEqualToNumber:[[NSNumber alloc] initWithInt:1]]) {
                [listaPublicaciones addObject:pb];
            }
        }
    }
    
    if([listaPublicaciones count]<1) {
        return nil;
    }
    
    return [listaPublicaciones copy];
}

/* Busca las personas de mi circulo. */
- (NSArray*) recuperaPersonasCirculoPorPersona:(Persona*)toCirculo toContext:(NSManagedObjectContext*) context{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Persona" inManagedObjectContext:context];
    [request setEntity:entityDescription];
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"toEmpresa = %@", toEmpresa];
    //[request setPredicate:predicate];
    
    NSError *error;
    
    NSArray *listaPersonas = [context executeFetchRequest:request error:&error];
    
    if(error != nil){
        NSLog(@"Regresando nil. Error al realizar consulta: %@", [error description]);
        return nil;
    }
    if([listaPersonas count] < 1) {
//        NSLog(@"Regresando nil. No se encontraron personas de la empresa: %@",toEmpresa.nombre);
        return nil;
    }
    
    //NSMutableArray *listaPublicaciones = [[NSMutableArray alloc] init];
    NSMutableArray *listaPersonasCirculo = [[NSMutableArray alloc] init];
    
    for (Persona *p in listaPersonas) {
        if([p.toCirculo count]<1) {//topublicacion
            continue;
        }
        for (Circulo *pb in p.toCirculo) {//topublicacion
            //NSLog(pb);
            [listaPersonasCirculo addObject:pb];//topublicacion
        }
    }
    
    if([listaPersonasCirculo count]<1) {
        return nil;
    }
    
    return [listaPersonasCirculo copy];
}

- (void) desactivaPublicacionesCaducadastoContext:(NSManagedObjectContext*) context{
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Publicacion" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:entityDescription];
    
    // Filtrando por el sector.
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"status = 1 and fecha <= %@", [NSDate date] ];
                              NSLog(@"Predicado: %@",predicate.description);
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if(error!=nil){
        NSLog(@"Error al realizar consulta: %@", [error description]);
    }
    error = nil;
    NSLog(@"Total: %i", [array count]);
    for (Publicacion *p in array) {
        p.status = [[NSNumber alloc] initWithInt:0];
        NSLog(@"fecha: %@", p.fecha);
        NSLog(@"status: %@", p.status);
    }
    
    [context save:&error];
    if(error!=nil){
        NSLog(@"Error al guardar la informacion: %@", [error description]);
    }
}

@end
