//
//  GameLayer.m
//  tavla
//
//  Created by Bulut Korkmaz on 12/01/14.
//  Copyright bulutcy 2014. All rights reserved.
//


// Import the interfaces
#import "GameLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "Triangle.h"
#import "Chip.h"
#import "Dice.h"

#pragma mark - GameLayer

// GameLayer implementation
@implementation GameLayer
 const BOOL WHITE = YES;
 const BOOL BLACK = NO;
// Helper class method that creates a Scene with the GameLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(id) init
{
    if ((self = [super initWithColor:ccc4(255,255,255,255)])) {
        
        //initialize
        CGSize winSize = [CCDirector sharedDirector].winSize;
        _triangles = [[NSMutableArray alloc] init];
        _movableSprites = [[NSMutableArray alloc] init]; //initialized but never used, for future use
        
        //Draw Background
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
        _background = [CCSprite spriteWithFile:@"background.png"];
        _background.anchorPoint = ccp(0,0);
        [self addChild:_background];
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_Default];
        
        //init and draw dice
        _dice1 =[[Dice alloc] init];
        _dice1.position = ccp(winSize.width-35,winSize.height/2);
        [self addChild:_dice1];
        _dice2 =[[Dice alloc] init];
        _dice2.position = ccp(winSize.width-90,winSize.height/2);
        [self addChild:_dice2];
        
        _player1TurnLabel =  [CCLabelTTF labelWithString:@"Your Turn!" fontName:@"Helvetica" fontSize:20];
        _player1TurnLabel.color = ccc3(0, 0, 0);
        _player1TurnLabel.position =  ccp(winSize.width-60,winSize.height/4);
        [self addChild:_player1TurnLabel];
        
        _player2TurnLabel =  [CCLabelTTF labelWithString:@"Your Turn!" fontName:@"Helvetica" fontSize:20];
        _player2TurnLabel.color = ccc3(0, 0, 0);
        _player2TurnLabel.rotation = 180.0;
        _player2TurnLabel.position =  ccp(winSize.width-60,(winSize.height*3)/4);
        [self addChild:_player2TurnLabel];
        
        
        //Draw triangles that will be placed on backgammon field
        //These would help us chip drag detection
        CCSprite *triangleProto = [CCSprite spriteWithFile:@"triangle.png"];
        int triangleWidth = [triangleProto boundingBox].size.width;
        int triangleHeigth = [triangleProto boundingBox].size.height;
        triangleProto = nil;
        int currentXpos=418+triangleWidth/2;
        int currentYpos=winSize.height-(triangleHeigth/2)-12;
        
        for(int i=0;i<=23;i++){
            Triangle * triangle = [[Triangle alloc] init:i];
            if(i<12){ //will start drawing from most top right
                currentXpos -=triangleWidth;
                triangle.rotation = 180.0;
                if(i==6)
                    currentXpos -=22;
            }
            else if (i==12) //Swicth drawing to bottom part
                currentYpos= (triangleHeigth/2) + 12;
            else{ //continue ti draw botom part
                currentXpos +=triangleWidth;
                if(i==18)
                    currentXpos +=22;
                
            }
            triangle.position = ccp(currentXpos,currentYpos);
            //will hold all triangles in an object
            [_triangles addObject:triangle];
            [self addChild:triangle];
            
        }
        
        // plist reading for initial placement of chips. see resources/triangles.plist
        NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"triangles" ofType:@"plist"];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        if ([dictionary objectForKey:@"Triangles" ] != nil ){
            NSMutableArray *array = [dictionary objectForKey:@"Triangles"];
            for(int i = 0; i < [array count]; i++){
                NSMutableDictionary *triangleInfo = [array objectAtIndex:i];
                //read chip count and color information of triangle and add them
                for(int chipCount = 0; chipCount < [[triangleInfo objectForKey:@"chipCount"] intValue]; chipCount++){
                    Chip *chip = nil;
                    Triangle * currentTriangle=[_triangles objectAtIndex:i];
                    if([[triangleInfo objectForKey:@"chipColor"] boolValue])
                        chip = [[WhiteChip alloc] init];
                    else
                        chip = [[BlackChip alloc] init];
                    
                    [_movableSprites addObject:chip];
                    [currentTriangle pushChip:chip];
                    [self addChild:chip];
                    [self reorderChild:chip z:currentTriangle.chipCount]; // move to top most z index
                }
                
                
            }
        }
        
        
    }
    //ready for touch events
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    //roll for first move, currently white player starts always
    [self rollDice];
    return self;
    
}
// Game related functions starts
- (void)rollDice{
    //roll dices, a couple of times
    [_dice1 roll];
    [_dice2 roll];
    [_dice1 roll];
    [_dice2 roll];
    [_dice2 roll];
    
    if(_dice1.value==_dice2.value)
        _totalDiceValue = _dice1.value * 4;
    else
        _totalDiceValue = _dice1.value + _dice2.value;
    //change player
    _playerDirection = !_playerDirection;
    
    if(_playerDirection){
        _player1TurnLabel.visible = YES;
        _player2TurnLabel.visible = NO;
        _dice1.rotation = 0;
        _dice2.rotation = 0;
    }else{
        _player1TurnLabel.visible = NO;
        _player2TurnLabel.visible = YES;
        _dice1.rotation = 180.0;
        _dice2.rotation = 180.0;
    }
}
//Returns if current selected chip can be dragged to that triangle
-(BOOL)isDragable:(Triangle *)triangle{
    
    return (CGRectContainsPoint(triangle.boundingBox, _selectedChip.position)
            && [_selectedChip canDragTo:triangle]);
}

- (void)selectChipForTouch:(CGPoint)touchLocation {
    Chip * newChip = nil;
    for (Triangle *triangle in _triangles) {//_movableSprites may be in future
        if (triangle.chipColor==_playerDirection &&
            CGRectContainsPoint(triangle.boundingBox, touchLocation)) {
            _oldTriangle=triangle;
            newChip = [triangle lastChip];
        
            break;
        }
    }
    
    _selectedChip = newChip;
    //if user touches to a chip, pre-calculate possible drop locations
    if (_selectedChip) {
        if(_dice1.value!=_dice2.value){
            //calculate all possible movements
            BOOL isDice1Draggable = NO, isDice2Draggable = NO;
            if(!_dice1.used)
                isDice1Draggable = [_selectedChip calculateDraggableTriangles:_triangles currentTriangle:_oldTriangle playerDirection:_playerDirection diceValue:_dice1.value];
            if(!_dice2.used)
                isDice2Draggable = [_selectedChip calculateDraggableTriangles:_triangles currentTriangle:_oldTriangle playerDirection:_playerDirection diceValue:_dice2.value];
            if((isDice1Draggable || isDice2Draggable) && !_dice1.used && !_dice2.used ){
                [_selectedChip calculateDraggableTriangles:_triangles currentTriangle:_oldTriangle playerDirection:_playerDirection diceValue:_dice1.value+_dice2.value];
            }
        }else{ // both dize values are same
            int i=1;
            while(i<=4 && _dice1.value*i<=_totalDiceValue &&
                  [_selectedChip calculateDraggableTriangles:_triangles currentTriangle:_oldTriangle playerDirection:_playerDirection diceValue:_dice1.value*i]){
                i++;
            }
        }
        
        int adjust=45; //will adjust chip location so that chip will be visible under player's finger
        if(!_playerDirection) // for black chip user
            adjust = -45;
        _selectedChip.position = ccp(_selectedChip.position.x,touchLocation.y+adjust);
        [self reorderChild:_selectedChip z:30];
       
    }

}

// Touch releated bindings start

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectChipForTouch:touchLocation];
    return TRUE;
}
// helper function for finger movement while holding the chip
- (void)panForTranslation:(CGPoint)translation {
    if (_selectedChip) {
        CGPoint newPos = ccpAdd(_selectedChip.position, translation);
        _selectedChip.position = newPos;
        
        for (Triangle *triangle in _triangles) {//_movableSprites
           if  ([self isDragable:triangle]){
                [triangle shine];
            }else{
                [triangle unShine];
            }
        }
        
    }

}
// Translate selected chip to new finger location
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    [self panForTranslation:translation];
    
}
// Finger up, so update view if the chip is dropable

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if (_selectedChip) {
        BOOL moved = NO;
        for (Triangle *triangle in _triangles) {//_movableSprites
            if  ([self isDragable:triangle]){
                //calculate remaining dice values
                int diff= abs(_oldTriangle.triangleNumber - triangle.triangleNumber);
                if(diff==_dice1.value)
                    _dice1.used = YES;
                else
                    _dice2.used = YES;
                _totalDiceValue -= diff;
                //pop chip from old triangle object and push to new one
                [_oldTriangle popChip];
                [triangle pushChip:_selectedChip];
                [self reorderChild:_selectedChip z:triangle.chipCount];
                [triangle unShine];
                moved = YES;
                
                break;
            }
        }
        if(moved){
            //if other players turn
            if(_totalDiceValue==0)
                [self rollDice];
        }
        else{ // if the user just try to drop the chip to non valid location, just put the chip back
            [_oldTriangle popChip];
            [_oldTriangle pushChip:_selectedChip];
        }
    }
    
}

- (void) dealloc // ARC helps here
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	
}
@end
