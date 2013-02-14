//
//  Country1.m
//  SimpleTableApp
//
//  Created by ITC on 21.01.13.
//  Copyright (c) 2013 ITC. All rights reserved.
//

#import "Country.h"

@interface Country()

@end

@implementation Country

+ (id) createCountryWithContinent:(NSString*)continent countryName:(NSString*)countryName language:(NSString*)language population:(int)population area:(int)area coordinate:(CLLocationCoordinate2D)coordinate
{
    Country *theCountry = [[Country alloc] init];
    theCountry.continent = continent;
    theCountry.countryName = countryName;
    theCountry.language = language;
    theCountry.population = population;
    theCountry.area = area;
    theCountry.coordinate = coordinate;
    return theCountry;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.continent forKey:@"Continent"];
    [coder encodeObject:self.countryName forKey:@"Country"];
    [coder encodeObject:self.language forKey:@"Language"];
    NSNumber* population = [NSNumber numberWithInt:self.population] ;
    [coder encodeObject:population forKey:@"Population"];
    NSNumber* area = [NSNumber numberWithInt:self.area] ;
    [coder encodeObject:area forKey:@"Area"];
    NSNumber* latitude = [NSNumber numberWithFloat:self.coordinate.latitude] ;
    [coder encodeObject:latitude forKey:@"Latitude"];
    NSNumber* longitude = [NSNumber numberWithFloat:self.coordinate.longitude] ;
    [coder encodeObject:longitude forKey:@"Longitude"];
}

 - (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _continent = [coder decodeObjectForKey:@"Continent"];
        _countryName = [coder decodeObjectForKey:@"Country"];
        _language = [coder decodeObjectForKey:@"Language"];
        _population = [[coder decodeObjectForKey:@"Population"] integerValue];
        _area = [[coder decodeObjectForKey:@"Area"] integerValue];
        float latitude = [[coder decodeObjectForKey:@"Latitude"] floatValue];
        float longitude = [[coder decodeObjectForKey:@"Longitude"] floatValue];
        _coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        }
    return self;
}

@end
