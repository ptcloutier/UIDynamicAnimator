//
//  FallingItem.m
//  Animations
//
//  Created by perrin cloutier on 10/26/16.
//  Copyright © 2016 ptcloutier. All rights reserved.
//

#import "CircularObject.h"

@implementation CircularObject


- (UIDynamicItemCollisionBoundsType)collisionBoundsType{
    return UIDynamicItemCollisionBoundsTypeEllipse;
}

- (void)addAngularVelocity:(CGFloat)velocity forItem:(id<UIDynamicItem>)item {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
