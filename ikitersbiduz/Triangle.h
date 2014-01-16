//
//  Triangle.h
//  tavla
//
//  Created by Bulut Korkmaz on 12/01/14.
//  Copyright (c) 2014 bulutcy. All rights reserved.
//

#import "cocos2d.h"
#import "Chip.h"

@interface Triangle : CCSprite

@property (nonatomic, assign) int triangleNumber; //current index of triangle
@property (nonatomic, assign) int chipCount;    //current chip count for easy access
@property (nonatomic, assign) BOOL chipColor;   //current chip color for easy access
@property (nonatomic, strong) NSMutableArray * chips; //chips on triangle

- (id)init:(int)triangleNumber;
-(void)pushChip:(Chip *)chip;
-(void)popChip;
-(Chip *)lastChip;
-(void)shine;
-(void)unShine;
@end
