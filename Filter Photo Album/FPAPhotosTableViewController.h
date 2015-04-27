//
//  FPAPhotosTableViewController.h
//  Filter Photo Album
//
//  Created by Siddharth Sharma on 3/30/15.
//  Copyright (c) 2015 Siddharth Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPAPhotosTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *albums;

- (IBAction)addAlbumBarButtonItemPressed:(UIBarButtonItem *)sender;

@end
