//
//  Empresa.h
//  BrockUs
//
//  Created by Nodus3 on 03/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Persona, Subsector;

@interface Empresa : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSSet *toPersona;
@property (nonatomic, retain) Subsector *toSubsector;
@end

@interface Empresa (CoreDataGeneratedAccessors)

- (void)addToPersonaObject:(Persona *)value;
- (void)removeToPersonaObject:(Persona *)value;
- (void)addToPersona:(NSSet *)values;
- (void)removeToPersona:(NSSet *)values;

@end
