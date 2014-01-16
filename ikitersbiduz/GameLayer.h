//
//  GameLayer.h
//  tavla
//
//  Created by Bulut Korkmaz on 12/01/14.
//  Copyright bulutcy 2014. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Chip.h"
#import "Triangle.h"
#import "Dice.h"

// GameLayer
@interface GameLayer : CCLayerColor <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
     NSMutableArray * _triangles;
     Chip * _selectedChip;
     Triangle * _oldTriangle;
     CCSprite * _background;
     NSMutableArray * _movableSprites;
     Dice * _dice1;
     Dice * _dice2;
     CCLabelTTF * _player1TurnLabel;
     CCLabelTTF * _player2TurnLabel;
     BOOL _playerDirection;
     int _totalDiceValue;
}
extern const BOOL WHITE;
extern const BOOL BLACK;
// returns a CCScene that contains the GameLayer as the only child
+(CCScene *) scene;

@end
