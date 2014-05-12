//
//  iBeaconViewController.m
//  iBeacon
//
//  Created by Erin McGee on 5/12/14.
//  Copyright (c) 2014 Erin McGee. All rights reserved.
//

#import "iBeaconViewController.h"
#import "ESTBeaconManager.h"
#import <AVFoundation/AVFoundation.h>

@interface iBeaconViewController () <ESTBeaconManagerDelegate>

@property (nonatomic, strong) ESTBeacon         *beacon;
@property (nonatomic, strong) ESTBeaconManager  *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion   *kitchenBeaconRegion;
@property (nonatomic, strong) ESTBeaconRegion   *purpleBeaconRegion;
@property (nonatomic, strong) ESTBeaconRegion   *garyBeaconRegion;

@property (nonatomic, strong)  UILabel *regionLabel;
@property (nonatomic, strong)  UILabel *kitchenEnterLabel;
@property (nonatomic, strong)  UILabel *kitchenExitLabel;
@property (nonatomic, strong)  UILabel *purpleEnterLabel;
@property (nonatomic, strong)  UILabel *purpleExitLabel;
@property (nonatomic, strong)  UILabel *garyEnterLabel;
@property (nonatomic, strong)  UILabel *garyExitLabel;
@property (nonatomic, strong)  UILabel *upCountLabel;
@property (strong, nonatomic) AVAudioPlayer *playerBG;
@end

@implementation iBeaconViewController

static int kitchenNumberOfTimes=0;
static int purpleNumberOfTimes=0;
static int garyNumberOfTimes=0;

- (void)viewDidLoad
{
    [super viewDidLoad];



    
    self.view.backgroundColor = [UIColor whiteColor];
    
    /*
     * UI setup
     */
    self.regionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.center.y - 200, self.view.frame.size.width, 40)];
    
    self.kitchenEnterLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.center.y - 180, self.view.frame.size.width, 40)];
    
    self.kitchenExitLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.center.y - 160, self.view.frame.size.width, 40)];
    
    
    self.purpleEnterLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.center.y - 140, self.view.frame.size.width, 40)];
    
    self.purpleExitLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.center.y - 120, self.view.frame.size.width, 40)];
    
    self.garyEnterLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.center.y - 100, self.view.frame.size.width, 40)];
    
    self.garyExitLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.center.y - 80, self.view.frame.size.width, 40)];
    
    self.upCountLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, self.view.center.y - 60, self.view.frame.size.width, 40)];
    
    /*
     * BeaconManager setup.
     */
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    NSUUID *beaconuuid = [[NSUUID alloc] initWithUUIDString:[[[NSBundle mainBundle] infoDictionary] valueForKey:@"BeaconID"]];
    self.kitchenBeaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID: beaconuuid
                                                                        major:61819
                                                                        minor:55823
                                                                   identifier:@"KitchenRegionIdentifier"];
    [self.beaconManager startMonitoringForRegion:self.kitchenBeaconRegion];
    
    self.purpleBeaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID: beaconuuid
                                                                       major:28705
                                                                       minor:41613
                                                                  identifier:@"PurpleRegionIdentifier"];
    [self.beaconManager startMonitoringForRegion:self.purpleBeaconRegion];
    
    self.garyBeaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID: beaconuuid
                                                                     major:27331
                                                                     minor:17139
                                                                identifier:@"GaryRegionIdentifier"];
    [self.beaconManager startMonitoringForRegion:self.garyBeaconRegion];
}

#pragma mark - ESTBeaconManager delegate

- (void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)region
{
    UILocalNotification *notification;
    self.regionLabel.text=@"";
    [self.view addSubview:self.regionLabel];
    self.regionLabel.text = region.identifier;
    [self.view addSubview:self.regionLabel];
    
    if([region.identifier isEqualToString:@"KitchenRegionIdentifier"])
    {
        notification = [UILocalNotification new];
        kitchenNumberOfTimes++;
        self.kitchenEnterLabel.text=@"";
        [self.view addSubview:self.kitchenEnterLabel];
        if(kitchenNumberOfTimes<=5)
        {
        notification.alertBody = @"When you have a rib-eye steak, you must floss it. Oh, that meatloaf tasted great, you must floss it! Now, floss it! Floss it good!";
        self.kitchenEnterLabel.text = @"When you have a rib-eye steak, you must floss it. Oh, that meatloaf tasted great, you must floss it! Now, floss it! Floss it good!";
            AVAudioPlayer *pp1 = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"FlossIt" ofType:@"wav"]] error:nil];
            self.playerBG = pp1;
            [pp1 prepareToPlay];
            [self.playerBG play];
        }
        else if(kitchenNumberOfTimes<=10)
        {
            notification.alertBody = @"Ooh!  Floor pie!";
            self.kitchenEnterLabel.text = @"Ooh!  Floor pie!";
        }
        [self.view addSubview:self.kitchenEnterLabel];
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        [self.beaconManager stopMonitoringForRegion:self.kitchenBeaconRegion];
        [self.beaconManager startMonitoringForRegion:self.kitchenBeaconRegion];
    }
    else if([region.identifier isEqualToString:@"PurpleRegionIdentifier"])
    {
        notification = [UILocalNotification new];
        purpleNumberOfTimes++;
        notification.alertBody = [NSString stringWithFormat:@"You've passed the Purple %d times!", purpleNumberOfTimes];
        self.purpleEnterLabel.text=@"";
        [self.view addSubview:self.purpleEnterLabel];
        self.purpleEnterLabel.text = [NSString stringWithFormat:@"You've passed the Purple %d times!", purpleNumberOfTimes];
        [self.view addSubview:self.purpleEnterLabel];
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        [self.beaconManager stopMonitoringForRegion:self.purpleBeaconRegion];
        [self.beaconManager startMonitoringForRegion:self.purpleBeaconRegion];
    }
    else if([region.identifier isEqualToString:@"GaryRegionIdentifier"])
    {
        notification = [UILocalNotification new];
        garyNumberOfTimes++;
        notification.alertBody = [NSString stringWithFormat:@"You've passed Gary %d times!", garyNumberOfTimes];
        self.garyEnterLabel.text=@"";
        [self.view addSubview:self.garyEnterLabel];
        self.garyEnterLabel.text = [NSString stringWithFormat:@"You've passed Gary %d times!", garyNumberOfTimes];
        [self.view addSubview:self.garyEnterLabel];
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        [self.beaconManager stopMonitoringForRegion:self.garyBeaconRegion];
        [self.beaconManager startMonitoringForRegion:self.garyBeaconRegion];
    }
    
    self.upCountLabel.text=@"";
    [self.view addSubview:self.upCountLabel];
    self.upCountLabel.text = [NSString stringWithFormat:@"You've gotten up %d times! Yay!", (kitchenNumberOfTimes+purpleNumberOfTimes+garyNumberOfTimes)];
    [self.view addSubview:self.upCountLabel];
    notification = [UILocalNotification new];
    notification.alertBody=[NSString stringWithFormat:@"You've gotten up %d times! Yay!", (kitchenNumberOfTimes+purpleNumberOfTimes+garyNumberOfTimes)];
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
}

/*- (void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(ESTBeaconRegion *)region
 {
 
 UILocalNotification *notification;
 UILabel *enterRegionLabel;
 
 if([region.identifier isEqualToString:@"KitchenRegionIdentifier"])
 {
 notification = [UILocalNotification new];
 kitchenNumberOfTimes++;
 notification.alertBody = @"You're out of range of the Kitchen!";
 enterRegionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.center.y - 90, self.view.frame.size.width, 40)];
 enterRegionLabel.text=@"";
 [self.view addSubview:enterRegionLabel];
 enterRegionLabel.text = @"You're out of range of the Kitchen!";
 [self.view addSubview:enterRegionLabel];
 [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
 }
 else if([region.identifier isEqualToString:@"PurpleRegionIdentifier"])
 {
 notification = [UILocalNotification new];
 purpleNumberOfTimes++;
 notification.alertBody = @"You're out of range of the Purple!";
 UILabel *enterRegionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.center.y - 70, self.view.frame.size.width, 40)];
 enterRegionLabel.text=@"";
 [self.view addSubview:enterRegionLabel];
 enterRegionLabel.text = @"You're out of range of the Purple!";
 [self.view addSubview:enterRegionLabel];
 [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
 }
 else if([region.identifier isEqualToString:@"GaryRegionIdentifier"])
 {
 notification = [UILocalNotification new];
 garyNumberOfTimes++;
 notification.alertBody = @"You're out of range of the Gary!";
 
 enterRegionLabel.text=@"";
 [self.view addSubview:enterRegionLabel];
 enterRegionLabel.text = @"You're out of range of the Gary!";
 [self.view addSubview:enterRegionLabel];
 [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
 }
 }*/

#pragma mark -

@end
