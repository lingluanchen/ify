//
//  IfyHelp.h
//  
//
//  Created by ify on 2017/10/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IfyHelp : NSObject
/**
 获取当前控制器
 */
UIViewController *CurrentViewController(UIView *currentView);

/**
 压图片质量
 
 @param image image
 @return Data
 */
+ (NSData *)zipImageWithImage:(UIImage *)image maxSize:(CGFloat)size;

/**
 *  等比缩放本图片大小
 *
 *  @param newImageWidth 缩放后图片宽度，像素为单位
 *
 *  @return self-->(image)
 */
+ (UIImage *)compressImage:(UIImage *)image newWidth:(CGFloat)newImageWidth;
@end
