//
//  Contry.h
//  SimpleTableApp
//
//  Created by ITC on 07.02.13.
//  Copyright (c) 2013 ITC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class Continent;


@interface Contry : NSManagedObject

@property (nonatomic, retain) NSNumber * area;
@property (nonatomic, retain) NSString * countryName;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * population;
@property (nonatomic, retain) Continent * continent;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSData * flagImage;

+ (Contry*) insertContry;

@end
