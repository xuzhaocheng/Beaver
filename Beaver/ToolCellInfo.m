//
//  ToolCellInfo.m
//  Beaver
//
//  Created by xuzhaocheng on 14/11/5.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "ToolCellInfo.h"

@implementation ToolCellInfo
- (id)initWithTitle:(NSString *)title icon:(NSString *)icon
{
    self = [super init];
    if (self) {
        self.title = title;
        self.icon = icon;
    }
    return self;
}
@end
