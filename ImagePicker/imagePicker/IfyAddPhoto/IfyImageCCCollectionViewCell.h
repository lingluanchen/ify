//
//  IfyImageCCCollectionViewCell.h
//  imagePicker
//
//  Created by ify on 2017/10/26.
//  Copyright © 2017年 kingsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IfyTools.h"
@interface IfyImageCCCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) void(^closeBlock)(id obj);
@property (strong, nonatomic) UIButton *close;


- (void)refreshWithData:(NSDictionary *)dic ;

@end
