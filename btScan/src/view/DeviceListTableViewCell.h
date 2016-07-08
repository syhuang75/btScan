//
//  DeviceListTableViewCell.h
//  btScan
//
//  Created by baron on 2016/7/7.
//  Copyright © 2016年 baron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label_uuid;
@property (weak, nonatomic) IBOutlet UILabel *label_rssi;

@end
