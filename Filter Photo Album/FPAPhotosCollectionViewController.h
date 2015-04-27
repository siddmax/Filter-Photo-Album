//
//  FPAPhotosCollectionViewController.h
//  Filter Photo Album
//
//  Created by Siddharth Sharma on 3/30/15.
//  Copyright (c) 2015 Siddharth Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"

@interface FPAPhotosCollectionViewController : UICollectionViewController

@property (strong, nonatomic) Album *album;

@end
