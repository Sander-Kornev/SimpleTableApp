//
//  ViewController.h
//  SimpleTableApp
//
//  Created by ITC on 17.01.13.
//  Copyright (c) 2013 ITC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryStore.h"
#import "CountryViewController.h"
#import "AddViewController.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@end
