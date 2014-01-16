//
//  Dice.m
//  tavla
//
//  Created by Bulut Korkmaz on 14/01/14.
//  Copyright (c) 2014 bulutcy. All rights reserved.
//

#import "Dice.h"

@implementation Dice
- (id)init{
    
    if ((self = [super initWithFile:@"dice.png"])) {
       //put dice label on it
        self.value = 6;
        self.diceText =  [CCLabelTTF labelWithString:@"6" fontName:@"Helvetica" fontSize:20];
        self.diceText.color = ccc3(0, 0, 0);
        self.diceText.position =  ccp([self boundingBox].size.width/2,[self boundingBox].size.height /2);
        [self addChild:self.diceText ];
        

    }
    
    return self;
}
-(void)roll{
    
    int val =  arc4random_uniform(5) + 1; // arc random will seed itself
    self.value = val;
    self.used = NO;
    [self.diceText setString:[@(val) stringValue]];
    
}

@end
