//
//  EditBaseViewController.m
//  Beaver
//
//  Created by xuzhaocheng on 14/11/10.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "EditBaseViewController.h"

@interface EditBaseViewController ()

@end

@implementation EditBaseViewController

- (UIBarButtonItem *)leftBarButtonItem
{
    return self.navigationItem.leftBarButtonItem;
}

- (UIBarButtonItem *)rightBarButtonItem
{
    return self.navigationItem.rightBarButtonItem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                          target:self
                                                                          action:@selector(cancelAction:)];
    [left setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.leftBarButtonItem = left;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(applyAction:)];
}

- (void)cancelAction:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:NULL];
}

- (void)applyAction:(id)sender
{
    
}

@end
