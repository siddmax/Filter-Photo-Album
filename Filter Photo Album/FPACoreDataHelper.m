//
//  FPACoreDataHelper.m
//  Filter Photo Album
//
//  Created by Siddharth Sharma on 3/30/15.
//  Copyright (c) 2015 Siddharth Sharma. All rights reserved.
//

#import "FPACoreDataHelper.h"
#import "AppDelegate.h"

@implementation FPACoreDataHelper

+(NSManagedObjectContext *)managedObjectContext
{
  NSManagedObjectContext *context = nil;
  
  id delegate = [[UIApplication sharedApplication] delegate];
  
  if ([delegate performSelector:@selector(managedObjectContext)])
  {
    context = [delegate managedObjectContext];
  }
  
  return context;
}

@end
