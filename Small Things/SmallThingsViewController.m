//
//  SmallThingsViewController.m
//  Small Things
//
//  Created by Leonardo S Rangel on 7/14/15.
//  Copyright © 2015 Leonardo S Rangel. All rights reserved.
//

#import "SmallThingsViewController.h"
#import "SmallThingTableViewCell.h"
#import "SmallThing+CoreDataProperties.h"
#import "Person+CoreDataProperties.h"

@interface SmallThingsViewController ()

@end

@implementation SmallThingsViewController
@synthesize memory;
@synthesize person;

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //Fetch data from persistence
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SmallThing"];
    NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    self.memory = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
    self.person = [[managedObjectContext executeFetchRequest:fetchRequest2 error:nil]mutableCopy];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    memory = [[NSMutableArray alloc] initWithObjects:@"Unexpected Visit", @"Laughing at a movie", @"Sharing news", nil];
    person = [[NSMutableArray alloc] initWithObjects:@"Girlfriend", @"Sister", @"Aunt", nil];
}

- (IBAction)unwindToSTVC:(UIStoryboardSegue *)sender {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - Table View Data Source
- (NSInteger) tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.memory.count;
}

- (UITableViewCell *) tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString* identifier = @"customCell";
    SmallThingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    //NSString *memoryData = [self.memory objectAtIndex:indexPath.row];
    NSManagedObject *memoryData = [self.memory objectAtIndex:indexPath.row];
    //NSString *personData = [self.person objectAtIndex:indexPath.row];
    NSManagedObject *personData = [self.person objectAtIndex:indexPath.row];
    UIImage *image = [UIImage imageNamed:@"txt.png"];
    UIImage *image2 = [UIImage imageNamed:@"micro.png"];
    [cell configureCellWithImage:image andTitle:[NSString stringWithFormat:@"%@", [memoryData valueForKey:@"title"]] andSubtitle:[NSString stringWithFormat:@"%@", [personData valueForKey:@"name"]] WithImage2:image2];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
