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
    //O ideal seria fazer isso em uma classe separada. Não é responsabilidade do ViewController buscar dados no banco.
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
    
    //isso é desnecessário
//    memory = [[NSMutableArray alloc] initWithObjects:@"Unexpected Visit", @"Laughing at a movie", @"Sharing news", nil];
//    person = [[NSMutableArray alloc] initWithObjects:@"Girlfriend", @"Sister", @"Aunt", nil];
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
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.memory.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"customCell";
    SmallThingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
//    NSString *memoryData = [self.memory objectAtIndex:indexPath.row];
    NSManagedObject *memoryData = [self.memory objectAtIndex:indexPath.row]; //seria melhor usar a classe persistente em vez de NSManagedObject
//    NSString *personData = [self.person objectAtIndex:indexPath.row];
    NSManagedObject *personData = [self.person objectAtIndex:indexPath.row]; //idem
    
    UIImage *image = [UIImage imageNamed:@"txt.png"];
    UIImage *image2 = [UIImage imageNamed:@"micro.png"];
    [cell configureCellWithImage:image andTitle:[memoryData valueForKey:@"title"] andSubtitle:[personData valueForKey:@"name"] WithImage2:image2];
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
