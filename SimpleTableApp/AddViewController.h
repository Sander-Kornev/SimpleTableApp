//
//  AddViewController.h
//  SimpleTableApp
//
//  Created by ITC on 21.01.13.
//  Copyright (c) 2013 ITC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryStore.h"
#import "ViewController.h"
#import "Country.h"
#import "AddMapViewController.h"

@interface AddViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>

@property CountryStore* store;
@property CLLocationCoordinate2D coordinate;

@end
