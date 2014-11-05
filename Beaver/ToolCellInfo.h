//
//  ToolCellInfo.h
//  Beaver
//
//  Created by xuzhaocheng on 14/11/5.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolCellInfo : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *icon;

- (id)initWithTitle:(NSString *)title icon:(NSString *)icon;

@end
