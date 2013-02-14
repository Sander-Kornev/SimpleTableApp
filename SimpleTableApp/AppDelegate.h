//
//  AppDelegate.h
//  SimpleTableApp
//
//  Created by ITC on 17.01.13.
//  Copyright (c) 2013 ITC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryStore.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
