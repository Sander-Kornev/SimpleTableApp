
#import <GHUnitIOS/GHUnit.h>
#import "CountryStore.h"
#import "Country.h"

@interface MyTest : GHTestCase { }
@property CountryStore* store;
@end

@implementation MyTest

- (BOOL)shouldRunOnMainThread {
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES.
    // Also an async test that calls back on the main thread, you'll probably want to return YES.
    return NO;
}

- (void)setUpClass {
    // Run at start of all tests in the class
    self.store = [[CountryStore alloc] init];
}

- (void)tearDownClass {
    // Run at end of all tests in the class
    self.store = nil;
}

- (void)setUp {
    // Run before each test method
}

- (void)tearDown {
  
}

- (void)test1Init
{
    GHAssertNotNil(self.store, @"CountryStore class did't load");
}

- (void)numberOfContinents:(int)continents
{
    int numberOfContinents = [self.store numberOfContinents];
    GHAssertEquals(continents, numberOfContinents, @"Number of continents is %i",numberOfContinents);
}

- (void)testNumberOfContinents
{
    [self numberOfContinents:2];
}

- (void)testNumberOfContinentsAdd
{
    [self addAndSaveCountry];
    [self numberOfContinents:3];
    [self deleteCountry];
    [self numberOfContinents:2];
}

- (void)addAndSaveCountry
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(0, 0);
    Country* country = [Country createCountryWithContinent:@"South America" countryName:@"Chilie" language:@"chilie" population:156778 area:45668 coordinate:coordinate];
    [self.store addAndSaveObject:country];
    NSLog(@"Country add");
}

-(void)deleteCountry
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    [self.store deleteCountryAtIndexPath:indexPath];
    NSLog(@"Country deleted");
}

- (void)numberOfContries:(int)numberOfContries
{
    int continents = [self.store numberOfContinents];
    int contries = 0;
    for (int i = 0 ; i < continents ; i++) {
        contries += [self.store contriesAtSection:i].count;
    }
    GHAssertEquals(numberOfContries, contries, @"Continent is %@ and mast be %@",numberOfContries, contries);
}

- (void)testNumberOfContries
{
    [self numberOfContries:3];
}

- (void)testNumberOfContiesAdd
{
    [self addAndSaveCountry];
    [self numberOfContries:4];
    [self deleteCountry];
    [self numberOfContries:3];
}

- (void)testContinentInSection
{
    NSArray* continents = @[@"North America",@"Europe"];
    for (int i=0; i<2; i++) {
        GHAssertEqualStrings([self.store continentAtSection:i],continents[i], @"Continent is %@ and mast be %@",
                             [self.store continentAtSection:i],continents[i]);
    }
}

- (void)testCountriesInSectionAdd
{
    [self addAndSaveCountry];
    NSArray* continents = @[@"North America",@"Europe",@"South America"];
    for (int i = 0; i < 3; i++) {
        GHAssertEqualStrings([self.store continentAtSection:i],continents[i], @"Continent is %@ and mast be %@",
                             [self.store continentAtSection:i],continents[i]);
    }
    [self deleteCountry];
}

- (void)testContryAtSectAndCountryAtIndP
{
    for (int i=0; i < 2; i++) {
        NSMutableArray* contriesAtSection = [self.store contriesAtSection:i];
        for (int j = 0; j < contriesAtSection.count; j++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            NSString* countryNameAtIndexPath = [self.store countryNameAtIndexPath:indexPath];
            GHAssertEqualStrings([contriesAtSection[j] countryName] ,countryNameAtIndexPath, @"Contry is %@ and mast be %@",
                                 [contriesAtSection[j] countryName],countryNameAtIndexPath);
            NSLog(@"section %i row %i", i, j );
        }
    }
    
}

-(void)testNeedDeleteSection
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity: 2];
    [array insertObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithBool:YES], nil] atIndex:0];
    [array insertObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO], nil] atIndex:1];
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < i + 1; j++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            BOOL metodResult = [self.store needDeleteSectionAtIndexPath:indexPath];
            BOOL arrayResult = [array[i][j] boolValue];
            GHAssertEquals(arrayResult, metodResult, @"section %i row %i",indexPath.section, indexPath.row);
        }
    }
}

@end
