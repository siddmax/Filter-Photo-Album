//
//  FPAPictureDataTransformer.m
//  Filter Photo Album
//
//  Created by Siddharth Sharma on 3/31/15.
//  Copyright (c) 2015 Siddharth Sharma. All rights reserved.
//

#import "FPAPictureDataTransformer.h"

@implementation FPAPictureDataTransformer

+(Class)transformedValueClass;
{
  return [NSData class];
}

+(BOOL)allowsReverseTransformation
{
  return YES;
}

-(id)transformedValue:(id)value
{
  if (value == nil) return nil;
  
  return UIImagePNGRepresentation(value);
}

-(id)reverseTransformedValue:(id)value
{
  return [UIImage imageWithData:value];
}

@end
