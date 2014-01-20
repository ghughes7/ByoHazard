//
//  DetailViewController.h
//  ByoHazard
//
//  Created by goodsmile on 2013/12/11.
//  Copyright (c) 2013年 goodsmile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreatedScene.h"
#import "LevelViewController.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *stageTitle;
@property (strong, nonatomic) LevelViewController *levelViewController;

-(IBAction)loadButtonHit:(id)sender;


@end
