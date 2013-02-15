//
//  CountryStore.m
//  SimpleTableApp
//
//  Created by ITC on 18.01.13.
//  Copyright (c) 2013 ITC. All rights reserved.
//

#import "CountryStore.h"


@interface CountryStore ()


@end

@implementation CountryStore

- (id)init
{
    self = [super init];
    [self LoadSettings];
    return self;
}

- (void) LoadSettings
{
	if (![[NSUserDefaults standardUserDefaults] boolForKey: @"plistLoaded"])
	{
        [self loadContinents];
        [self loadCountries];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"plistLoaded"];
    }
}

- (void)loadContinents
{
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Continents" ofType:@"plist"];
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSArray *temp = (NSArray *)[NSPropertyListSerialization
                                propertyListFromData:plistXML
                                mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                format:&format
                                errorDescription:&errorDesc];
    for (NSString* name in temp) {
        Continent* continent = [Continent insertContinent];
        continent.name = name;
    }
    [[NSManagedObjectContext mainContext] saveNested];
}

- (void)loadCountries
{
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"CountryStore" ofType:@"plist"];
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSArray *temp = (NSArray *)[NSPropertyListSerialization
                                propertyListFromData:plistXML
                                mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                format:&format
                                errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    for (NSDictionary* inner in temp) {
        Contry* contry = [Contry insertContry];
        NSString* myContinent = [inner valueForKey:@"Continent"];
        NSPredicate* continentName = [NSPredicate predicateWithFormat:@"name = %@",myContinent];
        Continent* continent = [Continent fetchSingleWithPredicate:continentName];
        [continent addConuntriesObject:contry];
        [contry setContinent:continent];
        NSString* code = [inner valueForKey:@"Code"];
        contry.code = code;
        DownloadManager* downloadManager = [[DownloadManager alloc] init];
        [downloadManager imageForCode:code forCountry:contry];
        contry.countryName = [inner valueForKey:@"Country"];
        contry.language = [inner valueForKey:@"Language"];
        contry.population = [inner valueForKey:@"Population"];
        contry.area = [inner valueForKey:@"Area"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        contry.longitude = [inner valueForKey:@"Longitude"];
        contry.latitude = [inner valueForKey:@"Latitude"];
    }
    [[NSManagedObjectContext mainContext] saveNested];
}

@end
