//
//  Country1.h
//  SimpleTableApp
//
//  Created by ITC on 21.01.13.
//  Copyright (c) 2013 ITC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Country : NSObject <NSCoding>

@property (strong) NSString* continent;
@property (strong) NSString* countryName;
@property (strong) NSString* language;
@property int population,area;
@property CLLocationCoordinate2D coordinate;

+ (id) createCountryWithContinent:(NSString*)continent countryName:(NSString*)countryName language:(NSString*)language population:(int)population area:(int)area coordinate:(CLLocationCoordinate2D)coordinate;

@end
