//
//  CountryStore.m
//  SimpleTableApp
//
//  Created by ITC on 18.01.13.
//  Copyright (c) 2013 ITC. All rights reserved.
//

#import "CountryStore.h"


@interface CountryStore ()
@property NSMutableArray* allContinents;
@property NSMutableArray* counries;
@property (nonatomic) NSString* archivePath;
@end

@implementation CountryStore

- (id)init
{
    self = [super init];
    [self loadConstants];
    [self loadData];
    self.allContinents = [self allContinents:self.counries];
    return self;
}

- (void)loadConstants
{
    self.counries = [NSMutableArray array];
    
}

- (NSString*)archivePath
{
    if (!_archivePath) {
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        _archivePath = [rootPath stringByAppendingPathComponent:@"CountryStore.plist"];
    }
    return _archivePath;
}

- (void)loadData
{
    if (![self fileExistInPath]){
        [self loadFromPlist];
    } else {
        [self loadFromArchive];
    }
}

- (BOOL)fileExistInPath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.archivePath]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)loadFromPlist
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
        NSString* myContinent = [inner valueForKey:@"Continent"];
        NSString* myCountryName = [inner valueForKey:@"Country"];
        NSString* myLanguage = [inner valueForKey:@"Language"];
        int myPopulation = [[inner valueForKey:@"Population"] intValue];
        int myArea = [[inner valueForKey:@"Area"] intValue];
        float latitude = [[inner valueForKey:@"Latitude"] floatValue];
        float longitude = [[inner valueForKey:@"Longitude"] floatValue];
        CLLocationCoordinate2D myCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        Country* newCountry =[Country createCountryWithContinent:myContinent countryName:myCountryName language:myLanguage population:myPopulation area:myArea coordinate:myCoordinate];
        [self addAndSaveObject:newCountry];
    }
}

- (void)loadFromArchive
{
    self.counries = [NSKeyedUnarchiver unarchiveObjectWithFile:self.archivePath];
}

- (NSInteger)numberOfContinents
{
    return self.allContinents.count;
}

- (NSString*)continentAtSection:(int)section
{
    return self.allContinents[section];
}

- (NSMutableArray*)allContinents:(NSMutableArray*)contries
{
    NSMutableArray* notRepeatContryName = [[NSMutableArray alloc] init];
    for (Country* contry in contries) {
        if (![notRepeatContryName containsObject:contry.continent] ) {
            [notRepeatContryName addObject:contry.continent];
        }
    }
    return notRepeatContryName;
}

- (NSMutableArray*)contriesAtSection:(NSInteger)section
{
    NSMutableArray* countriesOfSection = [[NSMutableArray alloc] init];
    for (Country* contry in self.counries) {
        if ([contry.continent isEqualToString:self.allContinents[section]]) {
                [countriesOfSection addObject:contry];
        }
    }
    return countriesOfSection;
}

- (NSString*)countryNameAtIndexPath:(NSIndexPath*)indexPath
{
    Country* country = [[self contriesAtSection:indexPath.section] objectAtIndex:indexPath.row];
    return country.countryName;
}

- (Country*)countryAtIndexPath:(NSIndexPath*)indexPath
{
    Country* country = [[self contriesAtSection:indexPath.section] objectAtIndex:indexPath.row];
    return country;
}

- (void)addAndSaveObject:(Country*)object
{
    [self.counries addObject:object];
    [self save];
    self.allContinents = [self allContinents:self.counries];
}

- (void)save
{
    [NSKeyedArchiver archiveRootObject:self.counries toFile:self.archivePath];
}

- (void)deleteCountryAtIndexPath:(NSIndexPath*)indexPath
{
    [self.counries removeObject:[self countryAtIndexPath:indexPath]];
    [self save];
    self.allContinents = [self allContinents:self.counries];
}

- (BOOL)needDeleteSectionAtIndexPath:(NSIndexPath*)indexPath
{
    if ([self contriesAtSection:indexPath.section].count == 1) {
        return YES;
    } else {
        return NO;
    }
}

- (NSMutableArray*)countriesWithCoordinates
{
    NSMutableArray* countriesWithCordinates = [[NSMutableArray alloc] init];
    for (Country* country in self.counries) {
        if (!(country.coordinate.latitude == 0 && country.coordinate.latitude == 0)) {
            [countriesWithCordinates addObject:country];
        }
    }
    return countriesWithCordinates;
}


@end
