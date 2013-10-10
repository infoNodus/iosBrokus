//
//  Persona.h
//  BrockUs
//
//  Created by Nodus3 on 08/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Circulo, Empresa, Notificacion, Publicacion;

@interface Persona : NSManagedObject

@property (nonatomic, retain) NSString * contrasena;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSData * img;
@property (nonatomic, retain) NSString * nameImg;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * puesto;
@property (nonatomic, retain) NSString * urlPath;
@property (nonatomic, retain) NSString * usuario;
@property (nonatomic, retain) NSString * Sector;
@property (nonatomic, retain) NSSet *toCirculo;
@property (nonatomic, retain) Empresa *toEmpresa;
@property (nonatomic, retain) NSSet *toNotificaciones;
@property (nonatomic, retain) NSSet *toPublicacion;
@end

@interface Persona (CoreDataGeneratedAccessors)

- (void)addToCirculoObject:(Circulo *)value;
- (void)removeToCirculoObject:(Circulo *)value;
- (void)addToCirculo:(NSSet *)values;
- (void)removeToCirculo:(NSSet *)values;

- (void)addToNotificacionesObject:(Notificacion *)value;
- (void)removeToNotificacionesObject:(Notificacion *)value;
- (void)addToNotificaciones:(NSSet *)values;
- (void)removeToNotificaciones:(NSSet *)values;

- (void)addToPublicacionObject:(Publicacion *)value;
- (void)removeToPublicacionObject:(Publicacion *)value;
- (void)addToPublicacion:(NSSet *)values;
- (void)removeToPublicacion:(NSSet *)values;

@end
//Hola mundo