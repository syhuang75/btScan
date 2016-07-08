//
//  MainPageViewController.m
//  btScan
//
//  Created by baron on 2016/7/7.
//  Copyright © 2016年 baron. All rights reserved.
//

#import "MainPageViewController.h"
#import "DeviceListViewController.h"
#import "btManager.h"

@interface MainPageViewController ()

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setData];
    [self setView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setData {
    [btManager sharedInstance];
}

- (void)setView {
    _label_version.text = [NSString stringWithFormat:@"version(git) : %@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CommitVersion"]];
}

- (IBAction)pressed_btn_scan:(id)sender {
    [btManager sharedInstance].delegate = self;
    [[btManager sharedInstance] scan];
}

- (void)scanCallback {
    NSMutableArray *array_temp = [btManager sharedInstance].array_btlist;
    if ([array_temp count] > 0) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle: nil];
        DeviceListViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"DeviceListViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"沒有找到device." preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
