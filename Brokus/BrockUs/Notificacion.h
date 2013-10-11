//
//  Notificacion.h
//  BrockUs
//
//  Created by Nodus3 on 03/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Persona;

@interface Notificacion : NSManagedObject

@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSString * mensaje;
@property (nonatomic, retain) Persona *toPersona;

@end
