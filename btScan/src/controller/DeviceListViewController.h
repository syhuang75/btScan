//
//  DeviceListViewController.h
//  btScan
//
//  Created by baron on 2016/7/7.
//  Copyright © 2016年 baron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btManager.h"

@interface DeviceListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) NSMutableArray *array_device;
@end
