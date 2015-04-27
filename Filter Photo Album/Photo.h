//
//  Photo.h
//  Filter Photo Album
//
//  Created by Siddharth Sharma on 4/2/15.
//  Copyright (c) 2015 Siddharth Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Album;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) id originalImage;
@property (nonatomic, retain) id previousImage;
@property (nonatomic, retain) Album *albumBook;

@end
