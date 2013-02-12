//
//  AddMapViewController.m
//  SimpleTableApp
//
//  Created by ITC on 31.01.13.
//  Copyright (c) 2013 ITC. All rights reserved.
//

#import "AddMapViewController.h"

@interface AddMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *myMap;
@property (strong) MKPointAnnotation* annotation;
@property BOOL annotationShow;

@end

@implementation AddMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCountry:)];
    [self.view addGestureRecognizer:tap];
    self.title = @"show new country";
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    self.navigationItem.rightBarButtonItem = addBarButtonItem;
    UIBarButtonItem *returnBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = returnBarButtonItem;
    self.annotationShow = NO;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)showCountry:(UITapGestureRecognizer*) tap
{
    if (!self.annotationShow) {
        self.annotation = [[MKPointAnnotation alloc] init];
        CGPoint point = [tap locationInView:self.myMap];
        CLLocationCoordinate2D coordinate = [self.myMap convertPoint:point toCoordinateFromView:self.myMap];
        self.annotation.coordinate = coordinate;
        self.annotation.title = @"New country?";
        //self.annotation.subtitle = @"What are you doing here?";
        [self.myMap addAnnotation:self.annotation];
        self.annotationShow = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CLLocationCoordinate2D)getCoordinate
{
    return self.annotation.coordinate;
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    {
        // If it's the user location, just return nil.
        if ([annotation isKindOfClass:[MKUserLocation class]])
            return nil;
        
        // Handle any custom annotations.
        if ([annotation isKindOfClass:[MKPointAnnotation class]])
        {
            // Try to dequeue an existing pin view first.
            MKPinAnnotationView*    pinView = (MKPinAnnotationView*)[mapView
                                                dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
            if (!pinView)
            {
                // If an existing pin view was not available, create one.
                pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:@"CustomPinAnnotationView"];
                pinView.pinColor = MKPinAnnotationColorGreen;
                //pinView =
                pinView.draggable = YES;
                pinView.animatesDrop = YES;
                pinView.canShowCallout = YES;
                
                // Add a detail disclosure button to the callout.
            } else {
                pinView.annotation = annotation;
            }
            return pinView;
        }
        return nil;
    }
}

@end
