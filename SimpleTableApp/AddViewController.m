//
//  AddViewController.m
//  SimpleTableApp
//
//  Created by ITC on 21.01.13.
//  Copyright (c) 2013 ITC. All rights reserved.
//

#import "AddViewController.h"


@interface AddViewController ()
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak) IBOutlet UITextField *fieldLanguage;
@property (weak) IBOutlet UITextField *fieldPopulation;
@property (weak) IBOutlet UITextField *fieldCountry;
@property (weak, nonatomic) IBOutlet UITextField *fieldCode;
@property (weak, nonatomic) IBOutlet UITextField *fieldArea;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (strong) NSArray* textFields;
@property BOOL keyboardShow;
@property (weak) UITextField* responder;
@property (strong) AddMapViewController* addMVC;
@property (strong) NSArray* continents;
@property (weak, nonatomic) IBOutlet UIImageView *flagImage;
@property DownloadManager* downloadManager;

@end

@implementation AddViewController

#pragma mark -  AddViewController

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
    [self loadDefault];
    // Do any additional setup after loading the view from its nib.
   
}

- (void)loadDefault
{
    NSString* imageMapPath = [[NSBundle mainBundle] pathForResource:@"map" ofType:@"jpg"];
    [self.mapButton setImage:[UIImage imageWithContentsOfFile:imageMapPath] forState:UIControlStateNormal];
    self.keyboardShow = NO;
    self.title = @"new country";
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    self.navigationItem.rightBarButtonItem = addBarButtonItem;
    UIBarButtonItem *returnBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = returnBarButtonItem;
    CGSize rect = CGSizeMake(320, 632);
    self.scrollView.contentSize = rect;
    self.textFields = @[self.fieldCountry, self.fieldCode, self.fieldLanguage, self.fieldPopulation, self.fieldArea];
    self.addMVC = [[AddMapViewController alloc] init];
    self.downloadManager = [[DownloadManager alloc] init];
    [self continentsFetchRequest];
}

- (void)continentsFetchRequest
{
    self.continents = [[NSArray alloc] init];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Continent"];
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortByName];
    NSError *error;
    self.continents = [[NSManagedObjectContext mainContext] executeFetchRequest:request error:&error];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NotificationCenter

- (void)showKeyboard:(NSNotification*) notif
{
    if (!self.keyboardShow) {
        NSDictionary *info = [notif userInfo];
        NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
        CGFloat keyboardTop = keyboardRect.origin.y;
        CGRect viewFrame = self.view.bounds;
        viewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
        self.scrollView.frame = viewFrame;
        self.keyboardShow = YES;
    }
}

- (void)hideKeyboard:(NSNotification*) notif
{
    self.keyboardShow = NO;
    self.scrollView.frame = self.view.bounds;
}

-(void)dismissKeyboard
{
    [self.responder resignFirstResponder];
}

#pragma mark - FieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.responder = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.fieldCode]) {
       
        [self.downloadManager imageForCode:self.fieldCode.text toImageView:self.flagImage];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    int indexTextField = [self.textFields indexOfObject:textField];
    int countTextFields = self.textFields.count;
    if (indexTextField == countTextFields - 1) {
        [[self.textFields objectAtIndex:0] becomeFirstResponder];
    } else {
        indexTextField++;
        [[self.textFields objectAtIndex:indexTextField] becomeFirstResponder];
    }
    return NO;
}

#pragma mark - Actions

- (IBAction)doneAction:(id)sender
{
    Contry* contry = [Contry insertContry];
    
    contry.countryName = self.fieldCountry.text;
    contry.language =  self.fieldLanguage.text;
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    contry.population = [numberFormatter numberFromString:self.fieldPopulation.text];
    contry.area = [numberFormatter numberFromString:self.fieldArea.text];
    [self.downloadManager getDataforCountry:contry];
    contry.code = self.fieldCode.text;
        //write coordinates
    contry.longitude = [NSNumber numberWithFloat:[self.addMVC getCoordinate].longitude];
    contry.latitude = [NSNumber numberWithFloat:[self.addMVC getCoordinate].latitude];
        //add ralations
    int numberOfContinent = [self.picker selectedRowInComponent:0];
    Continent* continent = [self.continents objectAtIndex:numberOfContinent];
    [continent addConuntriesObject:contry];
    [contry setContinent:continent];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressMap:(id)sender
{
    [self.navigationController pushViewController:self.addMVC animated:YES];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self.continents objectAtIndex:row] name];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 60;
}

#pragma mark- UIPickerViewDataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return  1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.continents.count;
}

@end
