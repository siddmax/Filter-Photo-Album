//
//  FPAPhotoCollectionViewCell.m
//  Filter Photo Album
//
//  Created by Siddharth Sharma on 3/30/15.
//  Copyright (c) 2015 Siddharth Sharma. All rights reserved.
//

#import "FPAPhotoCollectionViewCell.h"
#define IMAGEVIEW_BORDER_LENGTH 5

@implementation FPAPhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  
  if (self)
  {
    [self setup];
  }
  
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  
  if (self)
  {
    [self setup];
  }
  
  return self;
}

- (void)setup
{
  self.imageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds,
                                                                  IMAGEVIEW_BORDER_LENGTH,
                                                                  IMAGEVIEW_BORDER_LENGTH)];
  self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
  [self createActivitySpinner];
  
  [self.activityIndicator startAnimating];
  
  [self.contentView addSubview:self.imageView];
}

-(void)createActivitySpinner
{
  self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  
  CGRect viewrect = [[UIScreen mainScreen] bounds];
  
  self.activityIndicator.center = CGPointMake(.48*viewrect.size.width/2,.48*viewrect.size.width/2);
  
  self.activityIndicator.layer.zPosition = MAXFLOAT;
  
  [self.imageView addSubview:self.activityIndicator];
}

@end
