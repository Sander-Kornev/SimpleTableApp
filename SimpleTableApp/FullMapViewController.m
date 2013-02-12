//
//  FullMapViewController.m
//  SimpleTableApp
//
//  Created by ITC on 31.01.13.
//  Copyright (c) 2013 ITC. All rights reserved.
//

#import "FullMapViewController.h"

@interface FullMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *myMap;
@property (strong) NSMutableArray* annotations;
@end

@implementation FullMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem* item = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:0];
        item.title = @"Map";
        self.tabBarItem = item;
        self.annotations = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *returnBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = returnBarButtonItem;
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
	self.navigationItem.rightBarButtonItem = addBarButtonItem;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self paintContries];
}

- (void)paintContries
{
    NSArray* countries = [Contry fetchWithPredicate:nil];
    for (Contry* country in countries) {
        if ( [country.latitude floatValue] != 0 ) {
            [self drowCountry:country];
        }
    }
}

- (void)drowCountry:(Contry*)country
{
    MKPointAnnotation* annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D coordinte = CLLocationCoordinate2DMake([country.latitude doubleValue], [country.longitude doubleValue]);
    annotation.coordinate = coordinte;
    annotation.title = country.countryName;
    [self.myMap addAnnotation:annotation];
    [self.annotations addObject:annotation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.myMap removeAnnotations:self.annotations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
