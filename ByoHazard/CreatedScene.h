//  CreatedScene.h
//  ByoHazard

//

//  Created by goodsmile on 2013/12/24.

//  Copyright (c) 2013年 goodsmile. All rights reserved.

//



#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>





@interface CreatedScene : NSManagedObject



@property (nonatomic, retain) NSDate * timeStamp;

@property (nonatomic, retain) NSString * levelTitle;

@property (nonatomic, retain) id skNodes;

@property (nonatomic, retain) id screenCapture;

@end



@interface skNodes : NSValueTransformer



@end

@interface screenCapture : NSValueTransformer

@end

