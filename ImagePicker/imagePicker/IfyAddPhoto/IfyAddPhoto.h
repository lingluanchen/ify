//
//  KSAddPhoto.h
//  ParkSpace
//
//  Created by ify on 2017/10/25.
//  Copyright © 2017年 深圳市金盛智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PhotosUI/PhotosUI.h>

@protocol KSAddPhotoDelegate <NSObject>

//frame改变会调用
- (void)ifyPhotoChangeSize:(CGSize)currentSize;


//处理完数据会调用
- (void)ifyPhotoBigImgDataArray:(NSArray *)imagesData;
- (void)ifyPhotoThumbnail:(NSArray *)smallImages;

@optional

@end

@interface IfyAddPhoto : UIView

@property (nonatomic, assign) id<KSAddPhotoDelegate> delegate;
@property (nonatomic, assign) CGFloat maxImageSize;
@property (nonatomic, assign) CGSize cellSize;

//主动获取选中的所有图片信息
- (NSArray*)getBigImageArray;
- (NSArray*)getPHAssetArray;

//尽量不要使用，因为是耗时操作可能为空
- (NSArray*)getSmallImageArray;
- (NSArray*)getImagesData;


@end
