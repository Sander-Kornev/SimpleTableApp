//
//  ViewController.m
//  SimpleTableApp
//
//  Created by ITC on 17.01.13.
//  Copyright (c) 2013 ITC. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation ViewController

- (id)init
{
    self = [super init];
    FullMapViewController* fullMVC = [[FullMapViewController alloc]init];
    fullMVC.store = self.store;
    UITabBarItem* theItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:0];
    theItem.title = @"TableView";
    self.tabBarItem = theItem;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
	self.navigationItem.rightBarButtonItem = addBarButtonItem;    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.title = @"Continents";
    
}

- (void)viewWillAppear:(BOOL)animated
{    
    [super viewWillAppear:animated];
    [self.table reloadData];
}

- (IBAction)addAction:(id)sender 
{
    AddViewController* addVC = [[AddViewController alloc]init];
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:addVC];
    addVC.store = self.store;
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.store continentAtSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.store numberOfContinents];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.store contriesAtSection:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cacheIdentifier = @"CellCacheIdent";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cacheIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cacheIdentifier];
    }
    cell.textLabel.text = [self.store countryNameAtIndexPath:indexPath];
    return cell;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.table setEditing:editing animated:YES];
    if (editing) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
         self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

#pragma mark - Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CountryViewController* countryVC = [[CountryViewController alloc] init];
    countryVC.country = [self.store countryAtIndexPath:indexPath];
    [self.navigationController  pushViewController:countryVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.table beginUpdates];
        if ([self.store needDeleteSectionAtIndexPath:(NSIndexPath*)indexPath]) {
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:YES];
        }
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        [self.store deleteCountryAtIndexPath:(NSIndexPath*)indexPath];
        [self.table endUpdates];
    } else if (editingStyle == UITableViewCellEditingStyleInsert){
        //editional action
    }
}

@end