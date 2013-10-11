//
//  Subsector.h
//  BrockUs
//
//  Created by Nodus3 on 03/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Empresa, Publicacion, Sector;

@interface Subsector : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSSet *toEmpresa;
@property (nonatomic, retain) NSSet *toPublicacion;
@property (nonatomic, retain) Sector *toSector;
@end

@interface Subsector (CoreDataGeneratedAccessors)

- (void)addToEmpresaObject:(Empresa *)value;
- (void)removeToEmpresaObject:(Empresa *)value;
- (void)addToEmpresa:(NSSet *)values;
- (void)removeToEmpresa:(NSSet *)values;

- (void)addToPublicacionObject:(Publicacion *)value;
- (void)removeToPublicacionObject:(Publicacion *)value;
- (void)addToPublicacion:(NSSet *)values;
- (void)removeToPublicacion:(NSSet *)values;

@end
