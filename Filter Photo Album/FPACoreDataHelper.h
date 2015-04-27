//
//  FPACoreDataHelper.h
//  Filter Photo Album
//
//  Created by Siddharth Sharma on 3/30/15.
//  Copyright (c) 2015 Siddharth Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Album.h"

@interface FPACoreDataHelper : NSObject

+(NSManagedObjectContext *)managedObjectContext;

@end
