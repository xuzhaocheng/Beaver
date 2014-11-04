//
//  ViewController.m
//  Beaver
//
//  Created by xuzhaocheng on 14/11/4.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "ViewController.h"
#import "Logs.h"
#import "ImageCell.h"

@import AssetsLibrary;


@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *recentPhotos;
@end

@implementation ViewController

#pragma mark - Properties
- (void)setRecentPhotos:(NSArray *)recentPhotos
{
    _recentPhotos = recentPhotos;
    [self.collectionView reloadData];
}

- (void)fetchRecentPhotos
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                           usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
           if (group) {
               [group setAssetsFilter:[ALAssetsFilter allPhotos]];
               
               if (group.numberOfAssets > 0) {
                   [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:group.numberOfAssets - 1]
                                           options:0
                                        usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                            if (index <= 10) {
                                                ALAssetRepresentation *representation = [result defaultRepresentation];
                                                UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];
                                                [photos addObject:latestPhoto];
                                            } else {
                                                *stop = YES;
                                            }
                                        }];
                   self.recentPhotos = photos;
               }
           }
       } failureBlock:^(NSError *error) {
           ELog(error);
           ULog(@"不能访问相册!");
    }];
}

#pragma mark - View Controller

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fetchRecentPhotos];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.recentPhotos ? self.recentPhotos.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Image Cell" forIndexPath:indexPath];
    [cell configureForImage:self.recentPhotos[indexPath.row]];
    return cell;
}



@end
