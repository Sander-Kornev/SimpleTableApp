//
//  ViewController.m
//  SimpleTableApp
//
//  Created by ITC on 17.01.13.
//  Copyright (c) 2013 ITC. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation ViewController

#pragma mark - ViewController

- (id)init
{
    self = [super init];
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
    CountryStore* store = [[CountryStore alloc] init];
    //store.viewController = self;
}

- (IBAction)addAction:(id)sender
{
    AddViewController* addVC = [[AddViewController alloc]init];
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:addVC];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.managedObjectContext saveNested];
    self.fetchedResultsController = [self fetchedResultsController];
    [self.table reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTable:) name:@"loadComplete" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.fetchedResultsController = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    _managedObjectContext = [NSManagedObjectContext mainContext];
    return _managedObjectContext;
}

- (NSFetchedResultsController*)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntity:[Contry class]];
    [fetchRequest setFetchBatchSize:20];
    [fetchRequest sortByKey:@"continent" ascending:YES];
    [fetchRequest sortByKey:@"countryName" ascending:YES];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"continent" cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return self.fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.table beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.table insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.table deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.table;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.table endUpdates];
}


#pragma mark - DataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:section];
    Contry* country = [self.fetchedResultsController objectAtIndexPath:path];
    return  country.continent.name;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cacheIdentifier = @"CellCacheIdent";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cacheIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cacheIdentifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Contry *country = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = country.countryName;
    BOOL value = country.code == Nil;
    if (!value) {
        UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(250,10, 50, 30)];
        UIImage* flag = [UIImage imageWithData:country.flagImage];
        imv.image=flag;
        [cell.contentView addSubview:imv];
    }
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
    countryVC.country = [self.fetchedResultsController objectAtIndexPath:indexPath];
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
        // Delete the managed object for the given index path
        [self.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        [self.managedObjectContext saveNested];
    }
}

- (void)reloadTable:(NSNotification*)notification
{
    [self.table reloadData];
}

@end