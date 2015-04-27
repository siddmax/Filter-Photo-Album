//
//  FPAPhotoDetailViewController.m
//  Filter Photo Album
//
//  Created by Siddharth Sharma on 3/31/15.
//  Copyright (c) 2015 Siddharth Sharma. All rights reserved.
//

#import "FPAPhotoDetailViewController.h"
#import "Photo.h"
#import "FPAFiltersCollectionViewController.h"
#import "FPAPhotosCollectionViewController.h"
#import "AppDelegate.h"

@interface FPAPhotoDetailViewController ()

@end

@implementation FPAPhotoDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:YES];
  
  self.imageView.image = self.photo.image;
  
  if (self.photo.previousImage == nil)
  {
    [self.editBarButtonItem setEnabled:NO];
  }
  else
  {
    [self.editBarButtonItem setEnabled:YES];
  }
  
  if (!self.isPictureChanged)
  {
    [self.undoBarButtonItem setEnabled:NO];
  }
  else
  {
    [self.undoBarButtonItem setEnabled:YES];
  }
  
  if (self.photo.originalImage == nil)
  {
    [self.resetBarButtonItem setEnabled:NO];
  }
  else
  {
    [self.resetBarButtonItem setEnabled:YES];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
  NSLog(@"Received Memory Warning %@", self);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"Add Filter Segue"])
  {
    if ([segue.destinationViewController isKindOfClass:[FPAFiltersCollectionViewController class]])
    {
      FPAFiltersCollectionViewController *targetVC = segue.destinationViewController;
      
      targetVC.photo = self.photo;
    }
  }
  
  if ([segue.identifier isEqualToString:@"Edit Filter Segue"])
  {
    if ([segue.destinationViewController isKindOfClass:[FPAFiltersCollectionViewController class]])
    {
      FPAFiltersCollectionViewController *targetVC = segue.destinationViewController;
      
      self.photo.image = self.photo.previousImage;
      
      targetVC.photo = self.photo;
    }
  }
}

- (BOOL)shouldAutorotate
{
  return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
  return UIInterfaceOrientationMaskPortrait;
}

- (FPAPhotosCollectionViewController *)backViewController {
  NSArray * stack = self.navigationController.viewControllers;
  
  for (int i=(int)stack.count-1; i > 0; --i)
    if (stack[i] == self)
      return stack[i-1];
  
  return nil;
}

#pragma mark - IBActions

- (IBAction)resetBarButtonPressed:(UIBarButtonItem *)sender
{
  dispatch_async(dispatch_get_main_queue(), ^{
    self.photo.image = self.photo.originalImage;
    self.photo.previousImage = nil;
    self.photo.originalImage = nil;
    
    FPAPhotosCollectionViewController *targetVC = [self backViewController];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
      NSError *error = nil;
      
      if (![[self.photo managedObjectContext] save:&error])
      {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Your Change was not Saved!"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", @"Ok button") style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
        
        [alert addAction:okAction];
        dispatch_async(dispatch_get_main_queue(), ^{
          [targetVC presentViewController:alert animated:YES completion:nil];
        });
      }
    });
    [self.navigationController popViewControllerAnimated:YES];
  });
}

- (IBAction)trashBarButtonPressed:(UIBarButtonItem *)sender
{
  [[self.photo managedObjectContext] deleteObject:self.photo];
  
  FPAPhotosCollectionViewController *targetVC = [self backViewController];
  
  [self.navigationController popViewControllerAnimated:YES];
  AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    NSError *error = nil;
    if (![[appDelegate managedObjectContext] save:&error])
    {
      UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Your Change was not Saved!"
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];
      
      UIAlertAction* okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", @"Ok button") style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {}];
      
      [alert addAction:okAction];
      dispatch_async(dispatch_get_main_queue(), ^{
        [targetVC presentViewController:alert animated:YES completion:nil];
      });
    }
  });
}

- (IBAction)editBarButtonPressed:(UIBarButtonItem *)sender
{
}

- (IBAction)undoBarButtonPressed:(UIBarButtonItem *)sender
{
  self.photo.image = self.photo.previousImage;
  self.photo.previousImage = nil;
  if (self.photo.image == self.photo.originalImage)
  {
    self.photo.originalImage = nil;
  }
  
  FPAPhotosCollectionViewController *targetVC = [self backViewController];
  
  [self.navigationController popViewControllerAnimated:YES];
  AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    NSError *error = nil;
    if (![[appDelegate managedObjectContext] save:&error])
    {
      UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Your Change was not Saved!"
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];
      
      UIAlertAction* okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", @"Ok button") style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {}];
      
      [alert addAction:okAction];
      dispatch_async(dispatch_get_main_queue(), ^{
        [targetVC presentViewController:alert animated:YES completion:nil];
      });
    }
  });
}

@end
