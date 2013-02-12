//
//  AddMapViewController.h
//  SimpleTableApp
//
//  Created by ITC on 31.01.13.
//  Copyright (c) 2013 ITC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AddMapViewController : UIViewController<MKMapViewDelegate>

- (CLLocationCoordinate2D)getCoordinate;

@end
