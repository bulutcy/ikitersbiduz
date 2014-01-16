//
//  Chip.m
//  tavla
//
//  Created by Bulut Korkmaz on 12/01/14.
//  Copyright (c) 2014 bulutcy. All rights reserved.
//

#import "Chip.h"
#import "Triangle.h"

@implementation Chip
- (id)initWithFile:(NSString *)file chipColor:(BOOL)chipColor {

    if ((self = [super initWithFile:file])) {
        self.chipColor = chipColor;
        self.draggableTriangles = [[NSMutableArray alloc] init];

        
    }
    
    return self;
    
}
-(BOOL)calculateDraggableTriangles:(NSMutableArray *)triangles currentTriangle:(Triangle *)currentTriangle playerDirection:(BOOL)playerDirection  diceValue:(int)diceValue{
    //rotate dice value for current user
    if(!playerDirection)
        diceValue=-diceValue;
    //new possible triangle location
    int newTriangleLocation =currentTriangle.triangleNumber + diceValue;
    //boundary check
    if(newTriangleLocation<0 || newTriangleLocation>23 )
        return NO;
    else{
        //check for color and current chips
        Triangle * possibleNewTriangle = [triangles objectAtIndex:newTriangleLocation];
        if(possibleNewTriangle.chipColor==currentTriangle.chipColor || possibleNewTriangle.chipCount==0 ){
            [self.draggableTriangles addObject:possibleNewTriangle];
            return YES;
            
        }
        else
            return NO;
            
    }
    
}
//checks if the given triangle is in draggables
-(BOOL)canDragTo:(Triangle *)newTriangle{
    for(int i=0;i<[self.draggableTriangles count];i++){
        Triangle * triangle=[self.draggableTriangles objectAtIndex:i];
        if(triangle.triangleNumber==newTriangle.triangleNumber)
            return YES;
    }
    return NO;
}



//Removes previous calculated draggable triangles from chip
-(void) removeDraggableCalculations{
    [self.draggableTriangles removeAllObjects];
}


@end

//Child classes for different chip colors

@implementation WhiteChip : Chip

- (id)init {
    if ((self = [super initWithFile:@"chip-white-hd.png" chipColor:YES])) {
    }
    return self;
}

@end

@implementation BlackChip : Chip
- (id)init {
    if ((self = [super initWithFile:@"chip-black-hd.png" chipColor:NO])) {
    }
    return self;
}
@end