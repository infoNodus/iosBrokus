//
//  Publicacion.h
//  BrockUs
//
//  Created by Nodus3 on 11/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Persona, Subsector;

@interface Publicacion : NSManagedObject

@property (nonatomic, retain) NSString * descripcion;
@property (nonatomic, retain) NSDate * fecha;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSData * img;
@property (nonatomic, retain) NSString * nameImg;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * titulo;
@property (nonatomic, retain) NSString * urlPath;
@property (nonatomic, retain) NSDate * fechaIni;
@property (nonatomic, retain) Persona *toPersona;
@property (nonatomic, retain) Subsector *toSubsector;

@end
