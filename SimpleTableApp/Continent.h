//
//  Continent.h
//  SimpleTableApp
//
//  Created by ITC on 07.02.13.
//  Copyright (c) 2013 ITC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contry;

@interface Continent : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *conuntries;

+ (Continent* )insertContinent;

@end

@interface Continent (CoreDataGeneratedAccessors)

- (void)addConuntriesObject:(Contry *)value;
- (void)removeConuntriesObject:(Contry *)value;
- (void)addConuntries:(NSSet *)values;
- (void)removeConuntries:(NSSet *)values;

@end
