//
//  btManager.h
//  btScan
//
//  Created by baron on 2016/7/8.
//  Copyright © 2016年 baron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>

@class btManager;
@protocol btManagerDelegate <NSObject>
@optional
- (void)scanCallback;
@end

@interface btManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>
+ (instancetype)sharedInstance;
@property (nonatomic, assign) id <btManagerDelegate> delegate;
@property (strong, nonatomic) CBCentralManager *CM;
@property (strong, nonatomic) NSMutableArray *array_btlist;

- (void)scan;
@end
