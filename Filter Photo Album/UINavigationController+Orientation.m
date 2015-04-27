//
//  UINavigationController+Orientation.m
//  Filter Photo Album
//
//  Created by Siddharth Sharma on 4/6/15.
//  Copyright (c) 2015 Siddharth Sharma. All rights reserved.
//

#import "UINavigationController+Orientation.h"

@implementation UINavigationController (Orientation)

-(NSUInteger)supportedInterfaceOrientations
{
  return [self.topViewController supportedInterfaceOrientations];
}

-(BOOL)shouldAutorotate
{
  return YES;
}

@end
