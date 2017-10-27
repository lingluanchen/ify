//
//  KSAddPhoto.m
//  ParkSpace
//
//  Created by ify on 2017/10/25.
//  Copyright © 2017年 深圳市金盛智能科技有限公司. All rights reserved.
//

#import "IfyAddPhoto.h"
#import "IfyTools.h"
#import "IfyHelp.h"
#import "IfyImageCCCollectionViewCell.h"
#import "ZLPhotoActionSheet.h"

@interface IfyAddPhoto ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) ZLPhotoActionSheet *actionSheet;
@property (nonatomic, strong) UICollectionView *pickerCollectionView;
//方形压缩图image 数组
@property(nonatomic,strong) NSMutableArray * imageArray;

//大图image 数组
@property(nonatomic,strong) NSMutableArray * bigImageArray;

//大图image 二进制
@property(nonatomic,strong) NSMutableArray * bigImgDataArray;

//大图image 二进制
@property(nonatomic,strong) NSMutableArray<PHAsset *> * assets;

//图片总数量限制
@property(nonatomic,assign) NSInteger maxCount;

@property(nonatomic,assign) BOOL isOriginal;


@end

@implementation IfyAddPhoto
{
    CGRect _selfFrame;
    NSString *pushImageName;
}

static NSString * const reuseIdentifier = @"IfyImageCCCollectionViewCell";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selfFrame = frame;
        [self initialization];
        [self initPickerView:frame];
        [self changeCollectionViewHeight];
    }
    return self;
}

- (void)initialization {
    _imageArray = [NSMutableArray array];
    [_imageArray addObject:@{@"image":@"WYYFW_icon_add-to"}];
    _assets = [NSMutableArray array];
    _bigImgDataArray = [NSMutableArray array];
    _bigImageArray = [NSMutableArray array];
}

/** 初始化collectionView */
-(void)initPickerView:(CGRect)pickerRect{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;//设置最小行间距
    layout.minimumInteritemSpacing = 5;//item间距(最小值)
    self.pickerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, pickerRect.size.width, pickerRect.size.height) collectionViewLayout:layout];
    [self.pickerCollectionView registerClass:[IfyImageCCCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.pickerCollectionView.delegate = self;
    self.pickerCollectionView.dataSource = self;
    self.pickerCollectionView.backgroundColor = [UIColor whiteColor];
    _pickerCollectionView.scrollEnabled = NO;
    [self addSubview:self.pickerCollectionView];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IfyImageCCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell refreshWithData:self.imageArray[indexPath.row]];
    
    cell.closeBlock = ^(id obj) {
        [self deletePhoto:obj];
    };
    if (indexPath.row == 0) {
        cell.close.hidden = YES;
    } else {
        cell.close.hidden = NO;
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}
#pragma mark <UICollectionViewDelegate>
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((_selfFrame.size.width-20)/4.0 ,(_selfFrame.size.width-20)/4.0);
}


//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self addNewImg];
    } else {
        [self previewSelectImage:indexPath];
    }
}


- (ZLPhotoActionSheet *)actionSheet {
    if (!_actionSheet) {
        _actionSheet = [[ZLPhotoActionSheet alloc] init];
        //设置照片最大预览数
        _actionSheet.maxPreviewCount = 7;
        //设置照片最大选择数
        _actionSheet.maxSelectCount = 7;
        zl_weakify(self);
        [_actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
            zl_strongify(weakSelf);
            [strongSelf handleImage:images assets:assets isOriginal:isOriginal];
        }];
    }
    _actionSheet.sender = CurrentViewController(self);  /**< 必须放外面 */
    return _actionSheet;
}

#pragma mark - 选择图片
- (void)addNewImg{
    //调用相册
    self.actionSheet.arrSelectedAssets = self.assets;
    [self.actionSheet showPreviewAnimated:YES sender:CurrentViewController(self)];
    
}

- (void)handleImage:(NSArray *)images assets:(NSArray<PHAsset *> *)assets isOriginal:(BOOL)isOriginal {
    self.isOriginal = isOriginal;
    [self.bigImageArray removeAllObjects];
    [self.bigImageArray addObjectsFromArray:images];
    [self.assets removeAllObjects];
    [self.assets addObjectsFromArray:assets];
    //处理data数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!_maxImageSize||_maxImageSize > 5) {
            _maxImageSize = 5.0;
        }
        [self.bigImgDataArray removeAllObjects];
        for (UIImage *item in images) {
            NSData *imageData = [IfyHelp zipImageWithImage:item maxSize:_maxImageSize];
            [self.bigImgDataArray addObject:imageData];
        }
        if ([self.delegate respondsToSelector:@selector(ifyPhotoBigImgDataArray:)]) {
            [self.delegate ifyPhotoBigImgDataArray:[self getImagesData]];
        }
    });
    
    //处理图片数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        id obj = self.imageArray[0];
        [self.imageArray removeAllObjects];
        [self.imageArray addObject:obj];
        for (UIImage *item in images) {
            UIImage *smallImage = [IfyHelp compressImage:item newWidth:80];
            [self.imageArray addObject:@{@"image":smallImage}];
        }
        if ([self.delegate respondsToSelector:@selector(ifyPhotoThumbnail:)]) {
            [self.delegate ifyPhotoThumbnail:[self getSmallImageArray]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self changeCollectionViewHeight];
            [self.pickerCollectionView reloadData];

        });
    });
}

#pragma mark 预览照片
- (void)previewSelectImage:(NSIndexPath *)indexPath {
    
    [self.actionSheet previewSelectedPhotos:self.bigImageArray assets:self.assets index:indexPath.row-1 isOriginal:self.isOriginal];
}


#pragma mark - 删除照片
- (void)deletePhoto:(id)obj{
    NSInteger index = [_imageArray indexOfObject:obj];
    [_imageArray removeObjectAtIndex:index];
    [_bigImageArray removeObjectAtIndex:index-1];
    [_bigImgDataArray removeObjectAtIndex:index-1];
    [_assets removeObjectAtIndex:index-1];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.pickerCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    [self changeCollectionViewHeight];
}

#pragma mark - 改变view，collectionView高度
- (void)changeCollectionViewHeight{
    CGFloat cellH = (_selfFrame.size.width-15)/4.0;
    CGFloat cellHCount = (self.imageArray.count-1)/4+1;
    
    CGSize currentSize = CGSizeMake(_selfFrame.size.width,(cellH+5)*cellHCount-5);
    if (currentSize.height == _selfFrame.size.height) {
        return;
    }
    _selfFrame = CGRectMake(_selfFrame.origin.x, _selfFrame.origin.y, currentSize.width, currentSize.height);
    
    [UIView animateWithDuration:0.25 animations:^{
        _pickerCollectionView.frame = CGRectMake(0, 0, currentSize.width, currentSize.height);
        self.frame = _selfFrame;
    }];
    if ([self.delegate respondsToSelector:@selector(ifyPhotoChangeSize:)]) {
        [self.delegate ifyPhotoChangeSize:_selfFrame];
    }
}


- (NSArray*)getBigImageArray {
    return [_bigImgDataArray copy];
}

- (NSArray*)getPHAssetArray {
    return [_assets copy];
}

- (NSArray*)getSmallImageArray {
    return [_imageArray copy];
}
- (NSArray*)getImagesData {
    return [_bigImgDataArray copy];
}

#pragma mark - UIGestureRecognizerDelegate
/**
 解决cell 点击事件被屏蔽问题
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UICollectionView class]]){
        return YES;
    }
    return NO;
}

@end
