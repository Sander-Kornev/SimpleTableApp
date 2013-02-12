//
//  Continent.m
//  SimpleTableApp
//
//  Created by ITC on 07.02.13.
//  Copyright (c) 2013 ITC. All rights reserved.
//

#import "Continent.h"
#import "Contry.h"


@implementation Continent

@dynamic name;
@dynamic conuntries;

+ (Continent*)insertContinent
{
    NSManagedObjectContext* context = [NSManagedObjectContext mainContext];
    Continent *continent = [NSEntityDescription insertNewObjectForEntityForName:@"Continent"
                                                         inManagedObjectContext:context];
    return continent;
}

@end
