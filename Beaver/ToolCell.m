//
//  ToolCell.m
//  Beaver
//
//  Created by xuzhaocheng on 14/11/5.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "ToolCell.h"

@interface ToolCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ToolCell

- (void)configureCellWithTitle:(NSString *)title image:(UIImage *)image
{
    self.titleLabel.text = title;
    self.imageView.image = image;
}
@end
