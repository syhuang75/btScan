//
//  MainPageViewController.m
//  btScan
//
//  Created by baron on 2016/7/7.
//  Copyright © 2016年 baron. All rights reserved.
//

#import "MainPageViewController.h"
#import "DeviceListViewController.h"

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
    
}

- (void)setView {
    _label_version.text = [NSString stringWithFormat:@"version(git) : %@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CommitVersion"]];
}

- (IBAction)pressed_btn_scan:(id)sender {
    /*
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    DeviceListViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"DeviceListViewController"];
    [self.navigationController pushViewController:vc animated:YES];
     */
}
@end
