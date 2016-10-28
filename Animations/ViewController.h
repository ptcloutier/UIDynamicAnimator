//
//  ViewController.h
//  Animations
//
//  Created by perrin cloutier on 10/24/16.
//  Copyright © 2016 ptcloutier. All rights reserved.
//
#import "CircularObject.h"
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
 
@interface ViewController : UIViewController<UICollisionBehaviorDelegate>

@property(nonatomic)NSTimer *startTimer;
@property(nonatomic)NSTimer *playTimer;
@property(nonatomic)NSTimer *playLoopTimer;
@property(nonatomic)int game;
@property(nonatomic)int score;
@property(nonatomic)int highScore;
@property(nonatomic)BOOL gameOver;
@property(nonatomic)BOOL loopDetected;
@property(nonatomic, strong)NSMutableArray *xPositions;
@property(nonatomic, strong)UIButton *startButton;
@property(nonatomic, strong)UILabel *scoreBoard;
@property(nonatomic, strong)UIImageView *scoreBoardImageView;
@property (strong, nonatomic) IBOutlet UIImageView *gridBoard;
@property (nonatomic, strong) IBOutlet CircularObject *fallingItem;
@property(nonatomic, strong) IBOutlet CircularObject *bottomItem;
@property(nonatomic, strong)UIDynamicAnimator *animator;
@property(nonatomic, strong)UICollisionBehavior *collisionBehavior;
@property(nonatomic, strong)UIPushBehavior *pushBehavior;
@property(nonatomic, strong)UIAttachmentBehavior *attachmentBehavior;
@property(nonatomic, strong)UIGravityBehavior *gravityBehavior;
@property(nonatomic, strong)UIDynamicItemBehavior *itemBehavior;
@property(nonatomic, strong)UIDynamicItemBehavior *fallingItemDynamicProperties;
@property(nonatomic, strong)UIDynamicItemBehavior *bottomItemDynamicProperties;
@property(nonatomic, strong)UISnapBehavior *snapBehavior;
@property(nonatomic, strong)UIButton *resetButton;
@property (nonatomic) CGFloat bottomItemPosition;

-(void)startGame:(id)sender;
 
 
@end

