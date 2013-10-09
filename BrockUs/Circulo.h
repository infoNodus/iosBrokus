//
//  Circulo.h
//  BrockUs
//
//  Created by Nodus3 on 03/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Persona;

@interface Circulo : NSManagedObject

@property (nonatomic, retain) NSNumber * isAceptado;
@property (nonatomic, retain) Persona *toAmigo;
@property (nonatomic, retain) Persona *toPersona;

@end
