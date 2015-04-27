//
//  FPAPhotosTableViewController.m
//  Filter Photo Album
//
//  Created by Siddharth Sharma on 3/30/15.
//  Copyright (c) 2015 Siddharth Sharma. All rights reserved.
//

#import "FPAPhotosTableViewController.h"
#import "FPAPhotosCollectionViewController.h"
#import "Album.h"
#import "FPACoreDataHelper.h"

@interface FPAPhotosTableViewController ()

@end

@implementation FPAPhotosTableViewController

-(NSMutableArray *) albums
{
  if (!_albums) _albums = [[NSMutableArray alloc] init];
  
  return _albums;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
}
- (void)viewDidAppear:(BOOL)animated
{
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
  fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
  
  NSError *error = nil;
  
  NSArray *fetchedAlbums = [[FPACoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
  
  self.albums = [fetchedAlbums mutableCopy];
  
  [self.tableView reloadData];
}

#pragma mark - IBActions

- (IBAction)addAlbumBarButtonItemPressed:(UIBarButtonItem *)sender
{
  UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Enter New Album Name"
                                                                 message:nil
                                                          preferredStyle:UIAlertControllerStyleAlert];
  
  [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
   {
     textField.placeholder = NSLocalizedString(@"Album Name", @"Name");
   }];
  
  UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel button") style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * action) {}];
  
  UIAlertAction* addAlbumAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Add", @"Add button") style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                           UITextField *textField = alert.textFields[0];
                                                           
                                                           NSString *alertText = textField.text;
                                                           
                                                           [self.albums addObject:[self insertAlbumWithName:alertText]];
                                                           [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.albums count]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
                                                         }];
  
  [alert addAction:cancelAction];
  [alert addAction:addAlbumAction];
  
  [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
  NSLog(@"Received Memory Warning %@", self);
}

#pragma mark - Helper Methods
-(Album *)insertAlbumWithName:(NSString *)name
{
  NSManagedObjectContext *context = [FPACoreDataHelper managedObjectContext];
  
  Album *album = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:context];
  album.name = name;
  album.date = [NSDate date];
  
  NSError *error = nil;
  if (![context save:&error])
  {
    NSLog(@"We have save error: %@", error);
  }
  
  return album;
}


#pragma mark - Table View Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.albums count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIndentifier = @"cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier forIndexPath:indexPath];
  
  //configure cell
  Album *selectedAlbum = self.albums[indexPath.row];
  cell.textLabel.text = selectedAlbum.name;
  
  return cell;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete)
  {
    // Delete the row from the data source
    Album *selectedAlbum = self.albums[indexPath.row];
    
    [self.albums removeObject:self.albums[indexPath.row]];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
      [[selectedAlbum managedObjectContext] deleteObject:selectedAlbum];
      NSError *error = nil;
      if (![[selectedAlbum managedObjectContext] save:&error])
      {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Your Change was not Saved!"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", @"Ok button") style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
        
        [alert addAction:okAction];
        dispatch_async(dispatch_get_main_queue(), ^{
          [self presentViewController:alert animated:YES completion:nil];
        });
      }
    });
  }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"Album Chosen"])
  {
    if ([segue.destinationViewController isKindOfClass:[FPAPhotosCollectionViewController class]])
    {
      NSIndexPath *path = [self.tableView indexPathForSelectedRow];
      FPAPhotosCollectionViewController *targetVC = segue.destinationViewController;
      
      targetVC.album = self.albums[path.row];
    }
  }
}


@end
