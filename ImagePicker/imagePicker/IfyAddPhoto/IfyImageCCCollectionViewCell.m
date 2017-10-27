//
//  IfyImageCCCollectionViewCell.m
//  imagePicker
//
//  Created by ify on 2017/10/26.
//  Copyright © 2017年 kingsheng. All rights reserved.
//

#import "IfyImageCCCollectionViewCell.h"
@interface IfyImageCCCollectionViewCell()
@property (strong, nonatomic) UIImageView *imageV;
@property (nonatomic, strong) id dataObj;

@end

@implementation IfyImageCCCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI:self.bounds];
    }
    return self;
}

- (void)createUI:(CGRect)ItemRect {
    self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 10, ItemRect.size.width-10, ItemRect.size.height-10)];
    self.imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.imageV];
    self.close = [UIButton buttonWithType:UIButtonTypeCustom];
    self.close.frame = CGRectMake(0, 0, 15, 15);
    self.close.center = CGPointMake(CGRectGetMaxX(_imageV.frame), CGRectGetMinY(_imageV.frame));
    [self.close setImage:IMG(@"close") forState:UIControlStateNormal];
    [self.contentView addSubview:_close];
    [_close addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
}

- (void)refreshWithData:(NSDictionary *)dic {
    _dataObj = dic;
    if ([dic[@"image"] isKindOfClass:[NSString class]]) {
        self.imageV.image = IMG(dic[@"image"]);
    } else {
        self.imageV.image = dic[@"image"];
    }
}

//关闭动作
- (void)closeSelf {
    if (_closeBlock&&_dataObj) {
        _closeBlock(_dataObj);
    }
}


@end
