//
//  ViewController.m
//  imagePicker
//
//  Created by ify on 2017/10/26.
//  Copyright © 2017年 kingsheng. All rights reserved.
//

#import "ViewController.h"
#import "IfyAddPhoto.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    IfyAddPhoto *photo = [[IfyAddPhoto alloc] initWithFrame:CGRectMake(0, 50, 400, 300)];
    photo.backgroundColor = [UIColor redColor];
    [self.view addSubview:photo];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
