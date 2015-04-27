//
//  FPAFiltersCollectionViewController.m
//  Filter Photo Album
//
//  Created by Siddharth Sharma on 4/1/15.
//  Copyright (c) 2015 Siddharth Sharma. All rights reserved.
//

#import "FPAFiltersCollectionViewController.h"
#import "FPAPhotoCollectionViewCell.h"
#import "Photo.h"
#import "FPAPhotoDetailViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface FPAFiltersCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray *filters;
@property (strong, nonatomic) CIContext *context;
@property (strong, nonatomic) NSOperationQueue *filtrationQueue;
@property (strong, nonatomic) __block NSBlockOperation *operation;

@end

@implementation FPAFiltersCollectionViewController

static NSString * const reuseIdentifier = @"Photo Cell";

-(NSMutableArray *)filters
{
  if (!_filters) _filters = [[NSMutableArray alloc] init];
  
  return _filters;
}

-(CIContext *)context
{
  if (!_context) _context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}];
  
  return _context;
}

-(NSOperationQueue *)filtrationQueue
{
  if (!_filtrationQueue) _filtrationQueue = [[NSOperationQueue alloc] init];
  
  return _filtrationQueue;
}

-(NSBlockOperation *)operation
{
  if (!_operation) _operation = [[NSBlockOperation alloc] init];
  
  return _operation;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Do any additional setup after loading the view.
  self.filters = [[[self class] photoFilters] mutableCopy];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [self.filtrationQueue cancelAllOperations];
  self.filters = nil;
  self.photo = nil;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  NSLog(@"Received Memory Warning %@", self);
  // Dispose of any resources that can be recreated.
  [self.filtrationQueue cancelAllOperations];
  self.filters = nil;
  self.photo = nil;
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Helpers

+ (NSArray *)photoFilters;
{
  CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: nil];
  
  CIFilter *instant = [CIFilter filterWithName:@"CIPhotoEffectInstant" keysAndValues: nil];
  
  CIFilter *noir = [CIFilter filterWithName:@"CIPhotoEffectNoir" keysAndValues: nil];
  
  CIFilter *colorControl = [CIFilter filterWithName:@"CIColorControls" keysAndValues: kCIInputSaturationKey, @0.5, nil];
  
  CIFilter *transfer = [CIFilter filterWithName:@"CIPhotoEffectTransfer" keysAndValues: nil];
  
  CIFilter *monochrome = [CIFilter filterWithName:@"CIPhotoEffectMono" keysAndValues: nil];
  
  CIFilter *redMatrix = [CIFilter filterWithName:@"CIColorMatrix" keysAndValues:@"inputRVector", [CIVector vectorWithX:1 Y:1 Z:1 W:0], @"inputGVector", [CIVector vectorWithX:0 Y:0 Z:1 W:0], nil];
  
  CIFilter *blueMatrix = [CIFilter filterWithName:@"CIColorMatrix" keysAndValues:@"inputBVector", [CIVector vectorWithX:1 Y:1 Z:1 W:0], @"inputAVector", [CIVector vectorWithX:0 Y:0 Z:0 W:1], nil];
  
  NSArray *allFilters = @[sepia, instant, noir, colorControl, transfer, monochrome, redMatrix, blueMatrix];
  
  return allFilters;
}

//create filtered low res UIImage
- (UIImage *)filteredLowResImageFromImage:(UIImage *)image andFilter:(CIFilter *)filter
{
  CIImage *unfilteredImage = [[CIImage alloc] initWithCGImage:[self decreaseResolution:image].CGImage]; //convert UIImage into CIImage
  
  if (self.operation.cancelled) {
    unfilteredImage = nil;
    return nil;
  }
  
  [filter setValue:unfilteredImage forKey:kCIInputImageKey]; //apply filter
  CIImage *filteredImage = [filter outputImage]; //create CIImage from filtered image
  
  if (self.operation.cancelled) {
    unfilteredImage = nil;
    filteredImage = nil;
    return nil;
  }
  
  CGRect extent = [filteredImage extent]; //set bounds for image
  
  CGImageRef cgImage = [self.context createCGImage:filteredImage fromRect:extent]; //get CG image ref
  
  if (self.operation.cancelled) {
    CGImageRelease(cgImage);
    return nil;
  }
  
  UIImage *finalImage = [UIImage imageWithCGImage:cgImage scale:image.scale orientation:image.imageOrientation]; //create UIImage from CG image ref
  CGImageRelease(cgImage);
  return finalImage;
}

//create filtered normal UIImage
- (UIImage *)filteredImageFromImage:(UIImage *)image andFilter:(CIFilter *)filter
{
  CIImage *unfilteredImage = [[CIImage alloc] initWithCGImage:image.CGImage]; //convert UIImage into CIImage
  
  if (self.operation.cancelled) {
    unfilteredImage = nil;
    return nil;
  }
  
  [filter setValue:unfilteredImage forKey:kCIInputImageKey]; //apply filter
  CIImage *filteredImage = [filter outputImage]; //create CIImage from filtered image
  
  if (self.operation.cancelled) {
    unfilteredImage = nil;
    filteredImage = nil;
    return nil;
  }
  
  CGRect extent = [filteredImage extent]; //set bounds for image
  
  CGImageRef cgImage = [self.context createCGImage:filteredImage fromRect:extent]; //get CG image ref
  
  if (self.operation.cancelled) {
    CGImageRelease(cgImage);
    return nil;
  }
  
  UIImage *finalImage = [UIImage imageWithCGImage:cgImage scale:image.scale orientation:image.imageOrientation]; //create UIImage from CG image ref
  CGImageRelease(cgImage);
  return finalImage;
}

- (UIImage *)decreaseResolution:(UIImage *)image
{
  UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
  
  /* Capture the screen shoot at native resolution */
//  UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, imageView.opaque, 0.0);
//  [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
//  UIImage * screenshot = UIGraphicsGetImageFromCurrentImageContext();
//  UIGraphicsEndImageContext();
  
  /* Render the screen shot at custom resolution */
  CGRect cropRect = CGRectMake(0 ,0 ,250 ,250);
  UIGraphicsBeginImageContextWithOptions(cropRect.size, imageView.opaque, 1.0f);
  [image drawInRect:cropRect];
  UIImage * customScreenShot = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return customScreenShot;
}

- (FPAPhotoDetailViewController *)backViewController {
  NSArray * stack = self.navigationController.viewControllers;
  
  for (int i=(int)stack.count-1; i > 0; --i)
    if (stack[i] == self)
      return stack[i-1];
  
  return nil;
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return [self.filters count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  FPAPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
  
  cell.imageView.image = nil;
  
  // Configure the cell
  __weak __typeof (self) weakSelf = self;
  
  self.operation = [NSBlockOperation blockOperationWithBlock:^{
    if (weakSelf.operation.cancelled) {
      [cell.activityIndicator stopAnimating];
      return;
    }
    UIImage *filterLowResImage = [weakSelf filteredLowResImageFromImage:weakSelf.photo.image andFilter:weakSelf.filters[indexPath.row]];
    
    if (weakSelf.operation.cancelled) {
      [cell.activityIndicator stopAnimating];
      return;
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      if (weakSelf.operation.cancelled) {
        [cell.activityIndicator stopAnimating];
        return;
      }
      cell.imageView.image = filterLowResImage;
      cell.backgroundColor = [UIColor whiteColor];
      [cell.activityIndicator stopAnimating];
      if (weakSelf.operation.cancelled) {
        return;
      }
    }];
  }];
  
  [self.filtrationQueue addOperation:self.operation];
  
  return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  [self.filtrationQueue cancelAllOperations];
  
  dispatch_async(dispatch_get_main_queue(), ^{
    
    FPAPhotoDetailViewController *targetVC = [self backViewController];
    
    targetVC.isPictureChanged = true;
    
    self.photo.previousImage = self.photo.image;
    self.photo.image = [self filteredImageFromImage:self.photo.image andFilter:self.filters[indexPath.row]];
    
    if (self.photo.originalImage == nil)
    {
      self.photo.originalImage = self.photo.previousImage;
    }
    
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

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGSize retval = CGSizeMake(.48*screenRect.size.width, .48*screenRect.size.width);
  return retval;
}

@end
