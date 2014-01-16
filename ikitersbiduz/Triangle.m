//
//  Triangle.m
//  tavla
//
//  Created by Bulut Korkmaz on 12/01/14.
//  Copyright (c) 2014 bulutcy. All rights reserved.
//

#import "Triangle.h"


@implementation Triangle 
- (id)init:(int)triangleNumber{
   
    if ((self = [super initWithFile:@"triangle.png"])) {
        self.chips = [[NSMutableArray alloc] init];
        self.chipCount = 0;
        self.triangleNumber = triangleNumber;
    }
  
    return self;
}
//Adds given chip to triagnle
-(void)pushChip:(Chip *)chip{
    CGPoint point;
    if(self.rotation==0.0) //upper or lower triangle
       point= ccp(self.position.x,self.position.y-60+(self.chipCount*10));
    else
      point= ccp(self.position.x,self.position.y+60-(self.chipCount*10));
    
    //some small move effect
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:0.2
                                                position:point];
    
    [chip runAction:[CCSequence actions:actionMove, nil, nil]];
    
    [self.chips addObject:chip];
    self.chipCount++;
    self.chipColor=chip.chipColor;
    

}
//Removes chip from triangle
-(void)popChip{
   Chip* chip= [self.chips lastObject];
    [chip removeDraggableCalculations]; //since the chip is in a new location, remove old triangle drop locations
   [self.chips removeLastObject];
    self.chipCount--;

}
//Pointer to last upper level chip
-(Chip *)lastChip{

   return  [self.chips lastObject];
    
}
//Shine effect for draggable triangle
-(void)shine{
    self.blendFunc = (ccBlendFunc) { GL_ONE, GL_ONE };
    self.color = ccc3(200, 200, 200);
    
}
//Shine-Out
-(void)unShine{
    self.blendFunc = (ccBlendFunc) { GL_ONE, GL_ONE_MINUS_SRC_ALPHA };
    self.color = ccc3(255, 255, 255);
    
}





@end
