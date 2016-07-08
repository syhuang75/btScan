//
//  btManager.m
//  btScan
//
//  Created by baron on 2016/7/8.
//  Copyright © 2016年 baron. All rights reserved.
//

#import "btManager.h"

@implementation btManager {
    NSTimer *timer;
}

+ (instancetype)sharedInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^
                  {
                      sharedInstance = [self new];
                  });
    
    return sharedInstance;
}

- (id)init
{
    
    self = [super init];
    if (self) {
        if (_array_btlist == nil) {
            _array_btlist = [[NSMutableArray alloc] init];
            _CM= [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        }
    }
    return self;
}

//Check BT HW status
-(void)centralManagerDidUpdateState:(CBCentralManager*)cManager
{
    NSMutableString* nsmstring=[NSMutableString stringWithString:@"BT status:"];
    BOOL isDisconnect = NO;;
    BOOL isWork=FALSE;
    switch (cManager.state) {
        case CBCentralManagerStateUnknown:
            [nsmstring appendString:@"Unknown"];
            break;
        case CBCentralManagerStateUnsupported:
            [nsmstring appendString:@"Unsupported"];
            break;
        case CBCentralManagerStateUnauthorized:
            [nsmstring appendString:@"Unauthorized"];
            break;
        case CBCentralManagerStateResetting:
            [nsmstring appendString:@"Resetting"];
            break;
        case CBCentralManagerStatePoweredOff:
            [nsmstring appendString:@"PoweredOff"];
            isDisconnect = YES;
            break;
        case CBCentralManagerStatePoweredOn:
            [nsmstring appendString:@"PoweredOn"];
            isWork=TRUE;
            break;
        default:
            [nsmstring appendString:@"none"];
            break;
    }
    NSLog(@"[btManager] BT HW Status : %@",nsmstring);
}

#pragma mark - CBCentralManagerDelegate and CBPeripheralDelegate
// Get BT device
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    //NSLog(@"[btManager] peripheral\n%@\n",peripheral);
    //NSLog(@"[btManager] advertisementData\n%@\n",advertisementData);
    //NSLog(@"[btManager] RSSI\n%@\n",RSSI);
    
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    
    NSLog(@"[btManager] localName:%@",localName);
    NSLog(@"[btManager] UUID:%@",peripheral.identifier.UUIDString);
    
    if (![_array_btlist containsObject:peripheral]) {
        [_array_btlist addObject:peripheral];
    }
}

// connect callback
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"[btManager] connected. Connect To Peripheral with name: %@\nwith UUID:%@\n",peripheral.name,peripheral.identifier.UUIDString);
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(nonnull CBPeripheral *)peripheral error:(nullable NSError *)error {
    NSLog(@"[btManager] Fail to connect err : %@", error);
}


//disconnect BT
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"[btManager] disconnect.");
    
    UIAlertView *alertView =
    [[UIAlertView alloc] initWithTitle:@""
                               message:@"藍芽已中斷連線"
                              delegate:self
                     cancelButtonTitle:@"確定"
                     otherButtonTitles:nil, nil];
    [alertView show];
}


// search services after connect.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if( peripheral.identifier == NULL  ) return; // zach ios6 added
    if (!error) {
        for (CBService *p in peripheral.services){
            NSLog(@"[btManager] Service found with UUID: %@\n", p.UUID);
            [peripheral discoverCharacteristics:nil forService:p];
        }
    }
    else {
        NSLog(@"[btManager] Service discovery was unsuccessfull !\n");
    }
}

// search characteristics after get services.
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    CBService *s = [peripheral.services objectAtIndex:(peripheral.services.count - 1)];
    if (!error) {
        NSLog(@"[btManager] =========== %ld Characteristics of %@ service ",(long)service.characteristics.count,service.UUID);
        
        for(CBCharacteristic *c in service.characteristics){
            
            if(service.UUID == NULL || s.UUID == NULL) return;
        }
        NSLog(@"[btManager] === Finished set notification ===\n");
    } else {
        NSLog(@"[btManager] Characteristic discorvery unsuccessfull !\n");
    }
}

//write function callback
- (void)peripheral:(CBPeripheral *)peripheral
didWriteValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    if (error == nil) {
    }
    else {
        NSLog(@"Error writing characteristic %@",error);
    }
}

//read function callback
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error == nil) {
        NSLog(@"[btManager] get value : %@", characteristic.value);
    }
    else {
        NSLog(@"[btManager] Error reading characteristic %@",error);
    }
}


#pragma mark - Event
//need to set deletage. use to call callback function.
- (void)scan {
    [_CM stopScan];
    [_array_btlist removeAllObjects];
    if (_CM.state != CBCentralManagerStatePoweredOn) {
        
    } else {
        [_CM scanForPeripheralsWithServices:nil options:nil];
        timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(scanTimeout:) userInfo:nil repeats:NO];
        
        NSLog(@"[btManager] Scan");
    }
}

- (void)connect:(CBPeripheral*)peripheral {
    [_CM stopScan];
    [_CM connectPeripheral:peripheral options:nil];
    
    NSLog(@"[btManager] try to connect : %@",peripheral.name);
}


- (void)stopConnection {
    NSLog(@"[btManager] call stopConnection");
    [_CM stopScan];
    [timer invalidate];
    timer = nil;
}

#pragma mark - private function
- (void) scanTimeout:(NSTimer*)timer
{
    if (_CM!=NULL){
        [_CM stopScan];
        if ([_array_btlist count] > 0) {
            [_delegate scanCallback];
        }
    }else{
        NSLog(@"[btManager] CM is Null!");
    }
    NSLog(@"[btManager] scanTimeout");
}

@end
