//
//  FPAPhotoDetailViewController.h
//  Filter Photo Album
//
//  Created by Siddharth Sharma on 3/31/15.
//  Copyright (c) 2015 Siddharth Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo;

@interface FPAPhotoDetailViewController : UIViewController

@property (strong, nonatomic) Photo *photo;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *undoBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *resetBarButtonItem;
@property (nonatomic) BOOL isPictureChanged;

- (IBAction)resetBarButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)trashBarButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)editBarButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)undoBarButtonPressed:(UIBarButtonItem *)sender;

@end
