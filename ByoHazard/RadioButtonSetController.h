//
//  RadioButtonSetController.h
//  ByoHazard
//
//  Created by goodsmile on 2013/12/09.
//  Copyright (c) 2013年 goodsmile. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RadioButtonSetControllerDelegate;

@interface RadioButtonSetController : NSObject

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *buttons;
@property (nonatomic, weak) IBOutlet id<RadioButtonSetControllerDelegate> delegate;

@property (nonatomic) NSUInteger selectedIndex;

@end
/*
@protocol RadioButtonSetControllerDelegate <NSObject>
- (void)radioButtonSetController:(RadioButtonSetController *)controller
          didSelectButtonAtIndex:(NSUInteger)selectedIndex;
@end
*/