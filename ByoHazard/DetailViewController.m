//
//  DetailViewController.m
//  ByoHazard
//
//  Created by goodsmile on 2013/12/11.
//  Copyright (c) 2013年 goodsmile. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize stageTitle = _stageTitle;
@synthesize picture = _picture;
@synthesize levelViewController = _levelViewController;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        
       
        self.picture.image = [self.detailItem valueForKey:@"screenCapture"];
        NSDate *dateCreated = [self.detailItem valueForKey:@"timeStamp"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY年MM月dd日 'at' HH:mm"];
        
        NSString *formattedDateString = [dateFormatter stringFromDate:dateCreated];
        
//        NSLog(@"formattedDateString: %@", formattedDateString);
        self.stageTitle.text = formattedDateString;
        
        
        
        NSArray *tempNodes = [self.detailItem valueForKey:@"skNodes"];
        _levelViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"createdLevel"];
        _levelViewController.nodesToLoad = tempNodes;

        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadButtonHit:(id)sender {
    
    NSArray *tempNodes = [self.detailItem valueForKey:@"skNodes"];
//    NSLog(@"tempNodes: %@", tempNodes);
    
    //might need to be mvc instead of self
    _levelViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"createdLevel"];
    _levelViewController.nodesToLoad = tempNodes;

     [self presentViewController:_levelViewController animated:YES completion:nil];
    
//    _levelViewController.levelScreen.sceneObjects = [self.detailItem valueForKey:@"skNodes"];
//    [_levelViewController.levelScreen loadScene];
     
}


@end
