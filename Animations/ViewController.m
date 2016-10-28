//
//  ViewController.m
//  Animations
//
//  Created by perrin cloutier on 10/24/16.
//  Copyright © 2016 ptcloutier. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

{
    BOOL _restart;
    CGVector _firstPlayDirection;
    CGVector _secondPlayDirection;
    CGVector _thirdPlayDirection;
    CGVector _fourthPlayDirection;
    CGVector _fifthPlayDirection;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //directions for starting play
    _firstPlayDirection = CGVectorMake(0.0, 0.6);
    _secondPlayDirection = CGVectorMake(-0.5, 1.0);
    _thirdPlayDirection = CGVectorMake(0.2, 1.0);
    _fourthPlayDirection = CGVectorMake(-0.5, 1.0);
    _fifthPlayDirection = CGVectorMake(0.9, 1.0);
    
    //set initial scores
    self.game = 1;
    self.score = 0;
    self.highScore = 0;
    [self makeLabels];
    //pan gesture to recognize screen touch
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(movedItem:)];
    [self.bottomItem addGestureRecognizer:panGestureRecognizer];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([[userDefaults valueForKey:@"highScore"]isEqual:nil]){
    NSInteger highScoreNum = (NSInteger)self.highScore;
    [userDefaults setInteger:highScoreNum forKey:@"highScore"];
    }
    [self showHighScoreBoard];
}


-(void)makeLabels {

    UIImage *color1 = [UIImage imageNamed:@"color1.png"];
 
    //create label for current game's score
    self.scoreBoard = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 150.0, 25.0)];
    self.scoreBoard.text = [NSString stringWithFormat:@"Score : %i", self.score];
    self.scoreBoard.font = [UIFont systemFontOfSize:20 weight:UIFontWeightLight];
    self.scoreBoard.textColor = [UIColor whiteColor];
    [self.view addSubview:self.scoreBoard];
    
    //start button will start the game/ start the gravity
    UIColor *tronBlue = [UIColor colorWithRed:17.0 green:31.0 blue:246.0 alpha:1.0];
    CGRect startButtonFrame = CGRectMake(122.0, 45.0, 130.0, 48.0);
    self.startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.startButton setFrame:startButtonFrame];
    [self.startButton setBackgroundImage:color1 forState:UIControlStateNormal];
    [self.startButton setTitle: @"Start" forState:UIControlStateNormal];
    [self.startButton.titleLabel setFont:[UIFont systemFontOfSize:27 weight:UIFontWeightLight]];
    [self.startButton setTitleColor:tronBlue forState:UIControlStateNormal ];
    self.startButton.layer.masksToBounds = YES;
    self.startButton.layer.cornerRadius = 24;
    [self.startButton addTarget:self action:@selector(startGame:) forControlEvents:UIControlEventTouchUpInside];
    self.startButton.hidden = false;
    [self.view addSubview:self.startButton];

}


#pragma mark - Start Game


-(void)startGame:(id)sender {
     [self initAnimation];
    if(_restart == false){
        self.gameOver = false;
        [self.startButton setTitle:@"Ready..." forState:UIControlStateNormal];
        self.score =0;
        self.scoreBoard.text = [NSString stringWithFormat:@"Score : %i",self.score];
        self.playTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(startPlayTimer)
                                                        userInfo:nil
                                                         repeats:NO];
    }else{
        [self startOver];
    }
}


-(void)startPlayTimer {
    
    self.xPositions = [[NSMutableArray alloc]init];
    [self.startButton setTitle:@"PLAY!" forState:UIControlStateNormal];
    self.startTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(playGame)
                                                     userInfo:nil
                                                      repeats:NO];
    self.playLoopTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                        target:self
                                                        selector:@selector(detectLoop)
                                                        userInfo:nil
                                                         repeats:YES];
                          
}


-(void)detectLoop {
    
    //track the falling object's position on the x axis to determine if the loop is occurring
    NSNumber *xPosition = [NSNumber numberWithFloat:self.fallingItem.center.x];
    [self.xPositions addObject:xPosition];
    NSLog(@"object x position - %.2f", self.fallingItem.center.x);
     if(self.xPositions.count == 2){
        int compare1 = [[self.xPositions objectAtIndex:0]intValue];
        int compare2 = [[self.xPositions objectAtIndex:1]intValue];
        if(compare1 == compare2){
            NSLog(@"loop detected");
            self.loopDetected = true;
            [self.xPositions removeAllObjects];
        }else{
            [self.xPositions removeAllObjects];
        }
    }
}




-(void)playGame {
    
    self.startButton.hidden = true;
    
    //for a more pong-like effect start the items off with a push
    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.fallingItem] mode:UIPushBehaviorModeInstantaneous];
    [self changeDirection];
    self.pushBehavior.magnitude = 1.0;
    self.pushBehavior.active = YES;
    [self.animator addBehavior:self.pushBehavior];
    
    //start by dropping the item wit a little gravity
    self.gravityBehavior = [[UIGravityBehavior alloc]initWithItems:@[self.fallingItem]];
    self.gravityBehavior.magnitude = 0.3;
    [self.animator addBehavior:self.gravityBehavior];
    _restart = true;
}


-(void)initAnimation {
    
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    //create a invisible bottom barrier
    UIView *barrier = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame), [[UIScreen mainScreen]bounds].size.width, 5)];
    barrier.backgroundColor = [UIColor redColor];
    [self.view addSubview:barrier];
    
    //configure falling item's dynamic properties
    self.fallingItemDynamicProperties = [[UIDynamicItemBehavior alloc]initWithItems:@[self.fallingItem]];
    self.fallingItemDynamicProperties.allowsRotation = NO;
    self.fallingItemDynamicProperties.elasticity = 0.99f;
    self.fallingItemDynamicProperties.friction = 0.0;
    self.fallingItemDynamicProperties.resistance = 0.0;
    self.fallingItemDynamicProperties.angularResistance = 0.0;
    [self.fallingItem collisionBoundsType];
    [self.animator addBehavior:self.fallingItemDynamicProperties];
    
    //configure bottom item's dynamic properties
    self.bottomItemDynamicProperties = [[UIDynamicItemBehavior alloc] initWithItems:@[self.bottomItem]];
    self.bottomItemDynamicProperties.allowsRotation = NO;
    self.bottomItemDynamicProperties.density = 3000.0f;
    [self.bottomItem collisionBoundsType];
    [self.animator addBehavior:self.bottomItemDynamicProperties];
    [self addCollisionBehavior];
}


#pragma mark - Game Play Reactions


-(void)changeDirection {
    
    if(self.game>5){
        self.game = 1;
    }
    switch (self.game) {
        case 1:
            self.pushBehavior.pushDirection = _firstPlayDirection;
            self.game++;
            break;
        case 2:
            self.pushBehavior.pushDirection = _secondPlayDirection;
            self.game++;
            break;
        case 3 :
            self.pushBehavior.pushDirection = _thirdPlayDirection;
            self.game++;
            break;
        case 4:
            self.pushBehavior.pushDirection = _fourthPlayDirection;
            self.game++;
            break;
        case 5:
            self.pushBehavior.pushDirection = _fifthPlayDirection;
            self.game++;
        default:
            break;
    }
}


#pragma mark - Collision Behavior Delegate Methods


-(void)addCollisionBehavior {
 
    self.collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[self.fallingItem,self.bottomItem ]];
    CGFloat bottomY = CGRectGetMaxY(self.view.frame);
    CGFloat leftX = CGRectGetMinX(self.view.frame);
    CGFloat rightX = CGRectGetMaxX(self.view.frame);
    CGPoint bottomLeftCorner = CGPointMake(leftX, bottomY);
    CGPoint bottomRightCorner = CGPointMake(rightX, bottomY);
    [self.collisionBehavior addBoundaryWithIdentifier:@"barrier" fromPoint:bottomLeftCorner toPoint:bottomRightCorner];
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    self.collisionBehavior.collisionDelegate = self;
    [self.animator addBehavior:self.collisionBehavior];
}


- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item
   withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    
    NSString *hitBarrier = [NSString stringWithFormat:@"%@", identifier];
     if([item isEqual:self.fallingItem] && [hitBarrier isEqualToString:@"barrier"]){
        [self gameOverAlert];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self startOver];
        [self.startTimer invalidate];
        [self.playLoopTimer invalidate];
        [self.playTimer invalidate];
     }
}


-(void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 {
    
    
    if ((item1 == self.fallingItem && item2 == self.bottomItem) || (item1 == self.bottomItem && item2 == self.fallingItem)) {
        if(self.gameOver == false){
            self.score++;
            if(self.loopDetected == true){
                UIPushBehavior *push = [[UIPushBehavior alloc]initWithItems:@[self.fallingItem] mode:UIPushBehaviorModeInstantaneous];
                push.magnitude = 1.0;
                push.angle = 0.3;
                [self.animator addBehavior:push];
            }
        }
        self.scoreBoard.text = [NSString stringWithFormat:@"Score : %i",self.score];
    }
}


#pragma mark - User Actions


- (void)movedItem:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint point = [recognizer locationInView:self.view];
    int padding = 33;
    
    if(self.bottomItemPosition == 0){
        self.bottomItemPosition = self.bottomItem.center.y;
    }
    
    //Only allow movement up to within 100 pixels of the right bound of the screen
    if((point.x < [UIScreen mainScreen].bounds.size.width - padding)&&(point.x > padding)) {
        
        recognizer.view.center = CGPointMake(point.x, self.bottomItemPosition);
    }
    [self.animator updateItemUsingCurrentState:self.bottomItem];
}


#pragma mark - Game Over

-(void)gameOverAlert {
    self.gameOver = true;
    NSString *message;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.highScore = [[userDefaults valueForKey:@"highScore"]intValue];
    if(self.highScore<self.score){
        message = @"You got a new high score!";
    }else{
        message = @"";
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"GAME OVER!"  message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"PLAY AGAIN" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self showHighScoreBoard];
        [self.startButton setTitle:@"Start"forState:UIControlStateNormal];
        self.startButton.hidden = false;
        self.fallingItem.frame = CGRectMake(167.0, 125.0, 40.0, 40.0);
        self.bottomItem.frame = CGRectMake(132.0,CGRectGetMaxY(self.view.frame)-110, 110.0, 110.0);
        [self initAnimation];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
     
     
-(void)showHighScoreBoard {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.highScore = [[userDefaults valueForKey:@"highScore"]intValue];

    if(self.highScore<self.score){
        self.highScore = self.score;
        NSInteger highScoreNum = (NSInteger)self.highScore;
        [userDefaults setInteger:highScoreNum forKey:@"highScore"];
         }
    self.scoreBoard.text = [NSString stringWithFormat:@"High Score : %i", self.highScore];
}


- (void)startOver {
    
    _restart = false;
    self.loopDetected = false;
    [self.animator removeAllBehaviors];
    self.collisionBehavior = nil;
    self.pushBehavior = nil;
    self.fallingItemDynamicProperties = nil;
    self.bottomItemDynamicProperties = nil;
    self.attachmentBehavior = nil;
}


@end
