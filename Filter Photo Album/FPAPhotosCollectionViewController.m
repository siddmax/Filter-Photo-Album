//
//  FPAPhotosCollectionViewController.m
//  Filter Photo Album
//
//  Created by Siddharth Sharma on 3/30/15.
//  Copyright (c) 2015 Siddharth Sharma. All rights reserved.
//

#import "FPAPhotosCollectionViewController.h"
#import "FPAPhotoCollectionViewCell.h"
#import "Photo.h"
#import "FPAPictureDataTransformer.h"
#import "FPACoreDataHelper.h"
#import "FPAPhotoDetailViewController.h"

@interface FPAPhotosCollectionViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray *photos; //array of photo objects

@end

@implementation FPAPhotosCollectionViewController

static NSString * const reuseIdentifier = @"Photo Cell";

- (NSMutableArray *)photos
{
  if (!_photos) {
    _photos = [[NSMutableArray alloc] init];
  }
  return _photos;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  NSMutableArray *rightBtns = [[NSMutableArray alloc] init];
  
  UIBarButtonItem *galleryBtn =
  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                target:self
                                                action:@selector(galleryBarButtonItemPressed)];
  [rightBtns addObject:galleryBtn];
  UIBarButtonItem *cameraBtn =
  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                target:self
                                                action:@selector(cameraBarButtonItemPressed)];
  [rightBtns addObject:cameraBtn];
  
  [self.navigationItem setRightBarButtonItems:rightBtns animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:YES];
  
  UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  
  CGRect viewrect = [[UIScreen mainScreen] bounds];
  
  activityIndicator.center = CGPointMake(viewrect.size.width/2,viewrect.size.height/2);
  
  activityIndicator.layer.zPosition = MAXFLOAT;
  
  [self.view addSubview:activityIndicator];
  
  [activityIndicator startAnimating];
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    NSSet *unorderedPhotos = self.album.photos;
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    NSArray *sortedPhotos = [unorderedPhotos sortedArrayUsingDescriptors:@[dateDescriptor]];
    self.photos = [sortedPhotos mutableCopy];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.collectionView reloadData];
      [activityIndicator stopAnimating];
    });
  });
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
  NSLog(@"Received Memory Warning");
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"Detail Segue"])
  {
    if ([segue.destinationViewController isKindOfClass:[FPAPhotoDetailViewController class]])
    {
      NSIndexPath *path = [[self.collectionView indexPathsForSelectedItems] lastObject];
      FPAPhotoDetailViewController *targetVC = segue.destinationViewController;
      
      targetVC.photo = self.photos[path.row];
    }
  }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  FPAPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
  
  Photo *photo = self.photos[indexPath.row];
  
  // Configure the cell
  cell.imageView.image = photo.image;
  cell.backgroundColor = [UIColor whiteColor];
  [cell.activityIndicator stopAnimating];
  
  return cell;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGSize retval = CGSizeMake(.48*screenRect.size.width, .48*screenRect.size.width);
  return retval;
}

#pragma mark <UICollectionViewDelegate>

#pragma mark - Bar Button Actions

- (void)galleryBarButtonItemPressed
{
  UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  
  CGRect viewrect = [[UIScreen mainScreen] bounds];
  
  activityIndicator.center = CGPointMake(viewrect.size.width/2,viewrect.size.height/2);
  
  activityIndicator.layer.zPosition = MAXFLOAT;
  activityIndicator.backgroundColor = [UIColor blackColor];
  
  [self.view addSubview:activityIndicator];
  
  [activityIndicator startAnimating];
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
      picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [self presentViewController:picker animated:YES completion:nil];
      [activityIndicator stopAnimating];
    });
  });
}

- (void)cameraBarButtonItemPressed
{
  UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  
  CGRect viewrect = [[UIScreen mainScreen] bounds];
  
  activityIndicator.center = CGPointMake(viewrect.size.width/2,viewrect.size.height/2);
  
  activityIndicator.layer.zPosition = MAXFLOAT;
  activityIndicator.backgroundColor = [UIColor blackColor];
  
  [self.view addSubview:activityIndicator];
  
  [activityIndicator startAnimating];
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
      picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [self presentViewController:picker animated:YES completion:nil];
      [activityIndicator stopAnimating];
    });
  });
}


#pragma mark - Helper Methods

-(Photo *)photoFromImage:(UIImage *)image
{
  Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[FPACoreDataHelper managedObjectContext]];
  photo.image = image;
  photo.originalImage = nil;
  photo.previousImage = nil;
  photo.date = [NSDate date];
  photo.albumBook = self.album;
  
  NSError *error = nil;
  
  if (![[photo managedObjectContext] save:&error])
  {
    NSLog(@"Error in saving: %@", error);
  }
  
  return photo;
}

#pragma mark - UIImage Picker Controller Delegates

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  UIImage *image = info[UIImagePickerControllerEditedImage];
  if (!image) image = info[UIImagePickerControllerOriginalImage];
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    [self.photos addObject:[self photoFromImage:image]];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.collectionView reloadData];
      [self dismissViewControllerAnimated:YES completion:nil];
    });
  });
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [self dismissViewControllerAnimated:YES completion:nil];
}
@end
