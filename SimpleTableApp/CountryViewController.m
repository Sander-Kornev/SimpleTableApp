//
//  Country.m
//  SimpleTableApp
//
//  Created by ITC on 18.01.13.
//  Copyright (c) 2013 ITC. All rights reserved.
//

#import "CountryViewController.h"

@interface CountryViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelContinent;
@property (weak, nonatomic) IBOutlet UILabel *labelLanguage;
@property (weak, nonatomic) IBOutlet UILabel *labelPopulation;
@property (weak, nonatomic) IBOutlet UILabel *labelArea;
@end

@implementation CountryViewController

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
    // Do any additional setup after loading the view from its nib.
    self.title = self.country.countryName;
    self.labelArea.text = [NSString stringWithFormat:@"%i",self.country.area];
    self.labelContinent.text = self.country.continent;
    self.labelLanguage.text = self.country.language;
    self.labelPopulation.text = [NSString stringWithFormat:@"%i",self.country.population];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
