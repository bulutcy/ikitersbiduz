//
//  Dice.h
//  tavla
//
//  Created by Bulut Korkmaz on 14/01/14.
//  Copyright (c) 2014 bulutcy. All rights reserved.
//

#import "cocos2d.h"


@interface Dice : CCSprite
@property (nonatomic, assign) int value;
@property (nonatomic, strong) CCLabelTTF * diceText;
@property (nonatomic, assign) BOOL used;

-(void)roll;

@end


