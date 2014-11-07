//
//  NoAnimationSegue.m
//  Beaver
//
//  Created by xuzhaocheng on 14/11/7.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "NoAnimationSegue.h"

@implementation NoAnimationSegue

- (void)perform
{
    [[self.sourceViewController navigationController] pushViewController:self.destinationViewController animated:NO];
}

@end
