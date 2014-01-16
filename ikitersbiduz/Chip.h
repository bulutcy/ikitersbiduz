//
//  Chip.h
//  tavla
//
//  Created by Bulut Korkmaz on 12/01/14.
//  Copyright (c) 2014 bulutcy. All rights reserved.
//

#import "cocos2d.h"
#import "Dice.h"
@class Triangle;
@class GameLayer;


@interface Chip : CCSprite


@property (assign,nonatomic) BOOL chipColor; //hold color of chip
@property (strong, nonatomic) NSMutableArray * draggableTriangles; //holds draggable triangles after calculation
- (id)initWithFile:(NSString *)file chipColor:(BOOL)chipColor;
-(void) removeDraggableCalculations; //refreshes the chip calcualtions
-(BOOL)calculateDraggableTriangles:(NSMutableArray *)triangles currentTriangle:(Triangle *)currentTriangle playerDirection:(BOOL)playerDirection  diceValue:(int)diceValue; // pre-calculation of draggables
-(BOOL)canDragTo:(Triangle *)newTriangle; // for checking the triangle is in draggables
@end

@interface WhiteChip : Chip
@end

@interface BlackChip : Chip
@end