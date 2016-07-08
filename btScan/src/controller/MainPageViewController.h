//
//  MainPageViewController.h
//  btScan
//
//  Created by baron on 2016/7/7.
//  Copyright © 2016年 baron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *label_version;
@property (weak, nonatomic) IBOutlet UIButton *btn_scan;
- (IBAction)pressed_btn_scan:(id)sender;

@end
