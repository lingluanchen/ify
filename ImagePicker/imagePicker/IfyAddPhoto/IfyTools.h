//
//  IfyTools.h
//  imagePicker
//
//  Created by ify on 2017/10/26.
//  Copyright © 2017年 kingsheng. All rights reserved.
//

#ifndef IfyTools_h
#define IfyTools_h
#define IMG(name) [UIImage imageNamed:name]
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define WeakSelf(type)  __weak typeof(type) ws = type;
#define StrongSelf(type)  __strong typeof(type) ss = type;

#endif /* IfyTools_h */
