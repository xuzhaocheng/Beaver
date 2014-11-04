//
//  ViewController.m
//  Beaver
//
//  Created by xuzhaocheng on 14/11/4.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "ViewController.h"
#import "Logs.h"

@import AssetsLibrary;


@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

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
               
               NSLog(@"in block");
           }
       } failureBlock:^(NSError *error) {
           ELog(error);
           ULog(@"不能访问相册!");
    }];
    
    
//    PHFetchOptions *fetchOptions = [PHFetchOptions new];
//    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES],];
//    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
//    UIImage *image = fetchResult.lastObject;
}

#pragma mark - View Controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fetchRecentPhotos];
}

- (void)awakeFromNib
{
    [self updateUI];
}


- (void)updateUI
{

}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Image Cell" forIndexPath:indexPath];
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
    imageView.image = self.recentPhotos[indexPath.row];
    cell.backgroundView = imageView;
}





@end
