//  CreatedScene.m
//  ByoHazard
//
//  Created by goodsmile on 2013/12/24.
//  Copyright (c) 2013年 goodsmile. All rights reserved.
//

#import "CreatedScene.h"

@implementation CreatedScene

@dynamic timeStamp;
@dynamic levelTitle;
@dynamic skNodes;

@end

@implementation skNodes

+ (Class)transformedValueClass
{
    return [NSArray class];
}


+ (BOOL)allowsReverseTransformation
{
    return YES;
}


- (id)transformedValue:(id)value
{
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}


- (id)reverseTransformedValue:(id)value
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end


@implementation screenCapture

+ (Class)transformedValueClass
{
    return [UIImage class];
}


+ (BOOL)allowsReverseTransformation
{
    return YES;
}


- (id)transformedValue:(id)value
{
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}


- (id)reverseTransformedValue:(id)value
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end