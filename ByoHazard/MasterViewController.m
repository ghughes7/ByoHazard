//
//  MasterViewController.m
//  ByoHazard
//
//  Created by goodsmile on 2013/12/11.
//  Copyright (c) 2013年 goodsmile. All rights reserved.
//

#define PI              3.14159265359
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "GameViewController.h"
#import "GSAppDelegate.h"
#import "CreatedScene.h"
#import "GameScene.h"


@interface MasterViewController ()

- (void)configureCell:(UITableView *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

static MasterViewController *sharedInstance = nil;

@implementation MasterViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize detailViewController = _detailViewController;
@synthesize gameViewController = _gameViewController;
@synthesize sceneInfos = _sceneInfos;
@synthesize savedImage = _savedImage;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"レベル";
    self.navigationItem.prompt = @"レベルを選んで下さい。または「＋」を押してオリジナルステージが作れます。";
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
//    GSAppDelegate *appDelegate = (GSAppDelegate *)[[UIApplication sharedApplication]delegate];
    
//    NSLog(@"initboolo: %hhd", appDelegate.initialized);
//    appDelegate.initialized = YES;
    
    NSInteger i = [[NSUserDefaults standardUserDefaults] integerForKey:@"numOfLCalls"];
    [[NSUserDefaults standardUserDefaults] setInteger:i+1 forKey:@"numOfLCalls"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (i == 0) {
        [self preLoadData];
    }
    
    
}

- (BOOL)isInitialRun
{
    NSNumber *bRun = [[NSUserDefaults standardUserDefaults] valueForKey:@"initialRun"];
    if (!bRun) { return YES; }
    return [bRun boolValue];
}

-(void)setIsInitialRun:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:@"initialRun"];
}

#pragma mark - Singleton setup

+ (MasterViewController *)sharedMasterViewController
{
    @synchronized(self) {
        if (sharedInstance == nil)
            [[self alloc] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}

- (id)init
{
    @synchronized(self){
        self = [super init];
        return self;
    }
}

#pragma mark - File operation Save and Load

- (void)insertNewObject:(id)sender
{
    //Hides navigation bar
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    //Shows navigation bar
//    [[self navigationController] setNavigationBarHidden:NO animated:YES];

    _gameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"levelCreator"];
//    NSLog(@"lets see: %@", _gameViewController);
    [self.navigationController pushViewController:_gameViewController animated:YES];

}


- (void)saveOption:(NSString *)title
{
//    NSLog(@"saveOption");
//    NSLog(@"gameVC is %@", _gameViewController);
//    NSLog(@"The level title is %@", title);
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    CreatedScene *createdScene = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    
//    NSLog(@"Visible View Controller is %@", self.navigationController.visibleViewController);
    
    
    SKView *skView = (SKView *)_gameViewController.view;
    GameScene *scene = (GameScene *)skView.scene;
    
    NSArray *myNodes =[NSArray arrayWithArray:[scene saveScene]];
    
// An alert dialog that comes up asks for title and assigns it to this a Created Scene's levelTitle
    
    createdScene.timeStamp = [NSDate date];
    createdScene.levelTitle = title;
    createdScene.screenCapture = _savedImage;
    createdScene.skNodes = myNodes;
//    [createdScene setValue:title forKey:@"levelTitle"];
//    [createdScene setValue:[NSDate date] forKey:@"timeStamp"];
//    [createdScene setValue:myNodes forKey:@"skNodes"];
    
//    NSLog(@"CreatedScene:%@", createdScene);


    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    //This is the how the scene returns after saving itself. It borrows the gameViewController's button for the unwinding seque. 中止 on gameViewController
    UIButton *button = (UIButton *)[_gameViewController.view viewWithTag:-1];
    [button sendActionsForControlEvents:UIControlEventTouchUpInside];
//    [button addTarget:self action:@selector(cancelButtonHit:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)preLoadData
{
    //chance to implement the flyweight pattern
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    CreatedScene *createdScene1 = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    /*****************************************Scene 1***************************************************/
    createdScene1.levelTitle = @"例1";
    createdScene1.screenCapture = [UIImage imageNamed:@"scene1.png"];
    
    NSDateComponents *comps1 = [[NSDateComponents alloc] init];
    [comps1 setDay:01];
    [comps1 setMonth:01];
    [comps1 setYear:2014];
    [comps1 setHour:01];
    createdScene1.timeStamp = [[NSCalendar currentCalendar] dateFromComponents:comps1];
    
    SKColor *green = [SKColor greenColor];
    CGSize size = CGSizeMake(0, 0);
    SKSpriteNode *b1 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *b2 = [[SKSpriteNode alloc] initWithColor:green size:size];
    
    SKSpriteNode *g1  = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g2  = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g3  = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g4  = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g5  = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g6  = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g7  = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g8  = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g9  = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g10 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g11 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g12 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g13 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g14 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g15 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g16 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g17 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g18 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g19 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g20 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g21 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g22 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g23 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g24 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g25 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g26 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g27 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g28 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g29 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g30 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g31 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g32 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g33 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g34 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g35 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g36 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g37 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g38 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g39 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g40 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g41 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g42 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g43 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g44 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *g45 = [[SKSpriteNode alloc] initWithColor:green size:size];
   

    
    b1.position  = CGPointMake(285.99094, 23.45775);
    b2.position  = CGPointMake(779.00238, 23.489998);
    g1.position  = CGPointMake(330.8913, 25.751688);
    g2.position  = CGPointMake(380.87524, 25.767815);
    g3.position  = CGPointMake(431.04697, 25.758282);
    g4.position  = CGPointMake(482.21323, 25.750652);
    g5.position  = CGPointMake(533.15802, 25.761251);
    g6.position  = CGPointMake(583.38867, 25.75872);
    g7.position  = CGPointMake(633.84656, 25.752937);
    g8.position  = CGPointMake(733.8219, 25.752108);
    g9.position  = CGPointMake(683.841, 26.449926);
    g10.position = CGPointMake(356.05353, 68.881279);
    g11.position = CGPointMake(406.06757, 68.461449);
    g12.position = CGPointMake(456.397, 67.999237);
    g13.position = CGPointMake(507.44623, 68.045525);
    g14.position = CGPointMake(558.15607, 68.648018);
    g15.position = CGPointMake(608.26196, 68.266129);
    g16.position = CGPointMake(658.27954, 68.818069);
    g17.position = CGPointMake(709.4588, 69.386574);
    g18.position = CGPointMake(381.05661, 112.09186);
    g19.position = CGPointMake(431.03882, 111.0863);
    g20.position = CGPointMake(481.53143, 110.79953);
    g21.position = CGPointMake(531.75452, 110.88738);
    g22.position = CGPointMake(582.93231, 111.23116);
    g23.position = CGPointMake(632.93066, 111.54592);
    g24.position = CGPointMake(683.42316, 112.03357);
    g25.position = CGPointMake(657.78766, 154.92027);
    g26.position = CGPointMake(607.69678, 154.67201);
    g27.position = CGPointMake(557.03955, 153.16411);
    g28.position = CGPointMake(506.60297, 153.25218);
    g29.position = CGPointMake(456.28662, 153.70215);
    g30.position = CGPointMake(406.29236, 154.52927);
    g31.position = CGPointMake(431.30994, 197.254);
    g32.position = CGPointMake(481.29257, 196.35472);
    g33.position = CGPointMake(531.30786, 195.85948);
    g34.position = CGPointMake(580.93719, 196.50276);
    g35.position = CGPointMake(632.53326, 198.06676);
    g36.position = CGPointMake(605.65369, 239.96474);
    g37.position = CGPointMake(556.2356, 239.51567);
    g38.position = CGPointMake(506.72552, 238.66341);
    g39.position = CGPointMake(456.77112, 240.04878);
    g40.position = CGPointMake(481.31476, 282.75098);
    g41.position = CGPointMake(530.58081, 281.7695);
    g42.position = CGPointMake(580.73346, 283.01834);
    g43.position = CGPointMake(555.49054, 325.30853);
    g44.position = CGPointMake(505.9982, 325.66968);
    g45.position = CGPointMake(530.63074, 368.67679);

    
    
    
    b1.zRotation = 0.0;
    b2.zRotation = 0.0;
    
    b1.name  = @"block";
    b2.name  = @"block";
    g1.name  = @"germ";
    g2.name  = @"germ";
    g3.name  = @"germ";
    g4.name  = @"germ";
    g5.name  = @"germ";
    g6.name  = @"germ";
    g7.name  = @"germ";
    g8.name  = @"germ";
    g9.name  = @"germ";
    g10.name = @"germ";
    g11.name = @"germ";
    g12.name = @"germ";
    g13.name = @"germ";
    g14.name = @"germ";
    g15.name = @"germ";
    g16.name = @"germ";
    g17.name = @"germ";
    g18.name = @"germ";
    g19.name = @"germ";
    g20.name = @"germ";
    g21.name = @"germ";
    g22.name = @"germ";
    g23.name = @"germ";
    g24.name = @"germ";
    g25.name = @"germ";
    g26.name = @"germ";
    g27.name = @"germ";
    g28.name = @"germ";
    g29.name = @"germ";
    g30.name = @"germ";
    g31.name = @"germ";
    g32.name = @"germ";
    g33.name = @"germ";
    g34.name = @"germ";
    g35.name = @"germ";
    g36.name = @"germ";
    g37.name = @"germ";
    g38.name = @"germ";
    g39.name = @"germ";
    g40.name = @"germ";
    g41.name = @"germ";
    g42.name = @"germ";
    g43.name = @"germ";
    g44.name = @"germ";
    g45.name = @"germ";
    
    
    
    createdScene1.skNodes = [NSArray arrayWithObjects:b1, b2,
                             g1, g2, g3, g4, g5, g6, g7, g8, g9, g10,
                             g11, g12, g13, g14, g15, g16, g17, g18, g19, g20,
                             g21, g22, g23, g24, g25, g26, g27, g28, g29, g30,
                             g31, g32, g33, g34, g35, g36, g37, g38, g39, g40,
                             g41, g42, g43, g44, g45, nil];
    
    /*****************************************End Scene 1***************************************************/
    
    
    
    /*****************************************Scene 2*************************************************/
    
    CreatedScene *createdScene2 = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    createdScene2.levelTitle = @"例2";
    createdScene2.screenCapture = [UIImage imageNamed:@"scene2.png"];
    
    NSDateComponents *comps2 = [[NSDateComponents alloc] init];
    [comps2 setDay:01];
    [comps2 setMonth:01];
    [comps2 setYear:2014];
    [comps2 setHour:02];
    createdScene2.timeStamp = [[NSCalendar currentCalendar] dateFromComponents:comps2];
    
 
    SKSpriteNode *r1  =   [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *r2  =   [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *r3  =   [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *r4  =   [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *r5  =   [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *r6  =   [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *r7  =   [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *r8  =   [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *r9  =   [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *r10 =   [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *r11 =   [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *r12 =   [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *r13 =   [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *r14 =   [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *r15 =   [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *r16 =   [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *r17 =   [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *r18 =   [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *germ1 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *germ2 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *germ3 = [[SKSpriteNode alloc] initWithColor:green size:size];
    
    
    
    //tower 1
    r1.position = CGPointMake(252.0838, 51.930191);
    r2.position = CGPointMake(254.1068, 107.77821);
    r3.position = CGPointMake(222.59042, 163.57111);
    r4.position = CGPointMake(281.93802, 163.83038);
    r5.position = CGPointMake(251.97772, 220.22626);
    
    //tower 2
    r6.position  = CGPointMake(528.9491, 51.948189);
    r7.position  = CGPointMake(529.91144, 154.20976);
    r8.position  = CGPointMake(530.70715, 210.75381);
    r9.position  = CGPointMake(497.02301, 267.14508);
    r10.position = CGPointMake(558.34503, 267.33017);
    r11.position = CGPointMake(526.9939, 323.06201);
    
    //tower 3
    r12.position = CGPointMake(807.00464, 53.992638);
    r13.position = CGPointMake(807.01654, 156.26105);
    r14.position = CGPointMake(806.93243, 258.5354);
    r15.position = CGPointMake(809.97998, 314.54901);
    r16.position = CGPointMake(774.31158, 370.71304);
    r17.position = CGPointMake(835.04907, 370.28998);
    r18.position = CGPointMake(805.06763, 426.39798);

    germ1.position = CGPointMake(252.11864, 138.16182);
    germ2.position = CGPointMake(527.8000, 240.96501);
    germ3.position = CGPointMake(806.02826, 344.98264);
    
    r1.zRotation  = 1.57;
    r2.zRotation  = 0.00;
    r3.zRotation  = 1.57;
    r4.zRotation  = 1.56;
    r5.zRotation  = 0.00;
    
    r6.zRotation  = 1.57;
    r7.zRotation  = 1.57;
    r8.zRotation  = 0.00;
    r9.zRotation  = 1.58;
    r10.zRotation = 1.58;
    r11.zRotation = 0.00;
    
    r12.zRotation = 1.57;
    r13.zRotation = 1.57;
    r14.zRotation = 1.57;
    r15.zRotation = -0.01;
    r16.zRotation = 1.56;
    r17.zRotation = 1.61;
    r18.zRotation = -0.00;
    
    germ1.name = @"germ";
    germ2.name = @"germ";
    germ3.name = @"germ";
    r1.name    = @"rect";
    r2.name    = @"rect";
    r3.name    = @"rect";
    r4.name    = @"rect";
    r5.name    = @"rect";
    r6.name    = @"rect";
    r7.name    = @"rect";
    r8.name    = @"rect";
    r9.name    = @"rect";
    r10.name   = @"rect";
    r11.name   = @"rect";
    r12.name   = @"rect";
    r13.name   = @"rect";
    r14.name   = @"rect";
    r15.name   = @"rect";
    r16.name   = @"rect";
    r17.name   = @"rect";
    r18.name   = @"rect";
    
    createdScene2.skNodes = [NSArray arrayWithObjects:
                             r1,r2,/*r3,r4,r5,*/ r6,r7,r8,/*r9,r10,
                             r11,*/r12,r13,r14,r15,/*r16,r17,r18,*/
                             germ1, germ2, germ3, nil];
    
    
   /*****************************************End Scene 2*************************************************
    
    
    
    /*****************************************Scene 3*************************************************/
    
    CreatedScene *createdScene3 = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    createdScene3.levelTitle = @"例3";
    createdScene3.screenCapture = [UIImage imageNamed:@"scene3.png"];
    
    NSDateComponents *comps3 = [[NSDateComponents alloc] init];
    [comps3 setDay:01];
    [comps3 setMonth:01];
    [comps3 setYear:2014];
    [comps3 setHour:03];
    createdScene3.timeStamp = [[NSCalendar currentCalendar] dateFromComponents:comps3];
    
    SKSpriteNode *stone1 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *stone2 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *stone3 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *stone4 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *stone5 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *stone6 = [[SKSpriteNode alloc] initWithColor:green size:size];
    SKSpriteNode *germ4  = [[SKSpriteNode alloc] initWithColor:green size:size];
    
    stone1.position = CGPointMake(412, 23.475927);
    stone2.position = CGPointMake(412, 64.691704);
    stone3.position = CGPointMake(412, 105.9481);
    stone4.position = CGPointMake(515, 23.341198);
    stone5.position = CGPointMake(515, 64.616936);
    stone6.position = CGPointMake(515, 105.65362);
    germ4.position  = CGPointMake(460.00003, 26.483696);
    
    
    stone1.name = @"square";
    stone2.name = @"square";
    stone3.name = @"square";
    stone4.name = @"square";
    stone5.name = @"square";
    stone6.name = @"square";
    germ4.name  = @"germ";
    
    createdScene3.skNodes = [NSArray arrayWithObjects:stone1, stone2, stone3, stone4, stone5, stone6, germ4, nil];

    
    /*****************************************End Scene 3*************************************************/
    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem: (CreatedScene *)object];
    }
}

- (IBAction)unwindToMaster:(UIStoryboardSegue *)unwindSeque
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    GSAppDelegate *appDelegate = (GSAppDelegate *)[[UIApplication sharedApplication]delegate];
    _managedObjectContext = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CreatedScenes" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[object valueForKey:@"levelTitle"] description];
    cell.detailTextLabel.text =[[object valueForKey:@"timeStamp"] description];
//    CreatedScene *info = [_sceneInfos objectAtIndex:indexPath.row];
//    cell.textLabel.text = info.levelTitle;
//    cell.detailTextLabel.text = @"I am the detail.";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
