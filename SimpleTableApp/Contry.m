//
//  Contry.m
//  SimpleTableApp
//
//  Created by ITC on 07.02.13.
//  Copyright (c) 2013 ITC. All rights reserved.
//

#import "Contry.h"


@implementation Contry

@dynamic area;
@dynamic countryName;
@dynamic language;
@dynamic latitude;
@dynamic longitude;
@dynamic population;
@dynamic continent;
@dynamic code;
@dynamic flagImage;

+ (Contry*)insertContry
{
    NSManagedObjectContext* context = [NSManagedObjectContext mainContext];
    Contry* contry = [NSEntityDescription insertNewObjectForEntityForName:@"Contry"
                                                         inManagedObjectContext:context];
    return contry;
}

@end
