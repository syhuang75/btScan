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

@interface MainPageViewController () {
    MBProgressHUD *HUD;
}

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
    [self hudLoadingView];
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
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - HUD
- (void)hudLoadingView {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    
    HUD.labelText = @"searching...";
    
    // myProgressTask uses the HUD instance to update progress
    [HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
}

- (void)myProgressTask {
    // This just increases the progress indicator in a loop
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        HUD.progress = progress;
        usleep(40000);
    }
}

@end
