//
//  Sector.h
//  BrockUs
//
//  Created by Nodus3 on 03/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Subsector;

@interface Sector : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSSet *toSubsector;
@end

@interface Sector (CoreDataGeneratedAccessors)

- (void)addToSubsectorObject:(Subsector *)value;
- (void)removeToSubsectorObject:(Subsector *)value;
- (void)addToSubsector:(NSSet *)values;
- (void)removeToSubsector:(NSSet *)values;

@end
