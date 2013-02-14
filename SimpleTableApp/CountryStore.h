//
//  CountryStore.h
//  SimpleTableApp
//
//  Created by ITC on 18.01.13.
//  Copyright (c) 2013 ITC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"

@interface CountryStore : NSObject <NSFileManagerDelegate>

- (NSInteger)numberOfContinents;

- (NSString*)continentAtSection:(int)section;

- (NSMutableArray*)contriesAtSection:(NSInteger)section;

- (NSString*)countryNameAtIndexPath:(NSIndexPath*)indexPath;

- (Country*)countryAtIndexPath:(NSIndexPath*)indexPath;

- (void)addAndSaveObject:(Country*)object;

- (void)deleteCountryAtIndexPath:(NSIndexPath*)indexPath;

- (BOOL)needDeleteSectionAtIndexPath:(NSIndexPath*)indexPath;

- (NSMutableArray*)countriesWithCoordinates;

@end
