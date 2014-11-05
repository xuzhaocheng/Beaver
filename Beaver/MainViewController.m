//
//  ViewController.m
//  Beaver
//
//  Created by xuzhaocheng on 14/11/4.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "MainViewController.h"
#import "EditPhotoViewController.h"
#import "Logs.h"
#import "PhotoCell.h"

@import AssetsLibrary;


@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSArray *assets;
@end

@implementation MainViewController

#pragma mark - Properties
- (void)setAssets:(NSArray *)assets
{
    _assets = assets;
    [self.collectionView reloadData];
}

- (ALAssetsLibrary *)assetsLibrary
{
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

- (void)fetchAssets
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                           usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
           if (group) {
               [group setAssetsFilter:[ALAssetsFilter allPhotos]];
               
               if (group.numberOfAssets > 0) {
                   
                   [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                       if (result) {
                           [photos addObject:result];
                       }
                   }];
                   
                   self.assets = photos;
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
    [self fetchAssets];
}

#pragma mark - Navigation
- (void)prepareViewController:(id)vc forSegue:(NSString *)segueIdentifier fromIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = self.assets[indexPath.row];
    if ([segueIdentifier isEqualToString:@"show photo"]) {
        if ([vc isKindOfClass:[EditPhotoViewController class]]) {
            EditPhotoViewController *epvc = vc;
            epvc.photoAsset = asset;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    if ([sender isKindOfClass:[UICollectionViewCell class]]) {
        indexPath = [self.collectionView indexPathForCell:sender];
    }
    
    [self prepareViewController:segue.destinationViewController
                       forSegue:segue.identifier
                  fromIndexPath:indexPath];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets ? self.assets.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Photo Cell" forIndexPath:indexPath];
    [cell configureWithAsset:self.assets[indexPath.row]];
    return cell;
}



@end
