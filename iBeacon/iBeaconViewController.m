//
//  iBeaconViewController.m
//  iBeacon
//
//  Created by Erin McGee on 5/12/14.
//  Copyright (c) 2014 Erin McGee. All rights reserved.
//

#import "iBeaconViewController.h"
#import "ESTBeaconManager.h"

@interface iBeaconViewController () <ESTBeaconManagerDelegate>

@property (nonatomic, strong) ESTBeacon         *beacon;
@property (nonatomic, strong) ESTBeaconManager  *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion   *kitchenBeaconRegion;
@property (nonatomic, strong) ESTBeaconRegion   *purpleBeaconRegion;
@property (nonatomic, strong) ESTBeaconRegion   *mintBeaconRegion;

@property (nonatomic, strong) UISwitch          *enterRegionSwitch;
@property (nonatomic, strong) UISwitch          *exitRegionSwitch;

@property (nonatomic, strong)  UILabel *regionLabel;
@property (nonatomic, strong)  UILabel *kitchenEnterLabel;
@property (nonatomic, strong)  UILabel *kitchenExitLabel;
@property (nonatomic, strong)  UILabel *purpleEnterLabel;
@property (nonatomic, strong)  UILabel *purpleExitLabel;
@property (nonatomic, strong)  UILabel *mintEnterLabel;
@property (nonatomic, strong)  UILabel *mintExitLabel;
@property (nonatomic, strong)  UILabel *upCountLabel;
@end

@implementation iBeaconViewController

static int kitchenNumberOfTimes=0;
static int purpleNumberOfTimes=0;
static int mintNumberOfTimes=0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    /*
     * UI setup
     */
    self.enterRegionSwitch = [UISwitch new];
    [self.enterRegionSwitch setOn:YES animated:NO];
    [self.enterRegionSwitch setCenter:CGPointMake(self.view.frame.size.width - 40, self.view.center.y - 20)];
    [self.enterRegionSwitch addTarget:self action:@selector(switchValueChanged) forControlEvents:UIControlEventValueChanged];
    //[self.view addSubview:self.enterRegionSwitch];
    
    self.exitRegionSwitch = [UISwitch new];
    [self.exitRegionSwitch setOn:YES animated:NO];
    [self.exitRegionSwitch setCenter:CGPointMake(self.view.frame.size.width - 40, self.view.center.y + 20)];
    [self.exitRegionSwitch addTarget:self action:@selector(switchValueChanged) forControlEvents:UIControlEventValueChanged];
    //[self.view addSubview:self.exitRegionSwitch];
    
    self.regionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.enterRegionSwitch.center.y - 200, self.view.frame.size.width, 40)];
    
        self.kitchenEnterLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.enterRegionSwitch.center.y - 180, self.view.frame.size.width, 40)];
    
            self.kitchenExitLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.enterRegionSwitch.center.y - 160, self.view.frame.size.width, 40)];
    
    
    self.purpleEnterLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.enterRegionSwitch.center.y - 140, self.view.frame.size.width, 40)];
    
    self.purpleExitLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.enterRegionSwitch.center.y - 120, self.view.frame.size.width, 40)];
    
    self.mintEnterLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.enterRegionSwitch.center.y - 100, self.view.frame.size.width, 40)];
    
    self.mintExitLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.enterRegionSwitch.center.y - 80, self.view.frame.size.width, 40)];
    
    self.upCountLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, self.enterRegionSwitch.center.y - 60, self.view.frame.size.width, 40)];
    
    /*UITextView *infoTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height - 160, self.view.frame.size.width - 40, 140)];
    infoTextView.editable = NO;
    infoTextView.font = [UIFont systemFontOfSize:16];
    infoTextView.text = @"Lock the screen and go far away from the beacon until you get the exit region notification. If you come back, you will see an enter region notification.";
    [self.view addSubview:infoTextView];*/
    
    
    /*
     * BeaconManager setup.
     */
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    NSUUID *beaconuuid = [[NSUUID alloc] initWithUUIDString:@"7CE80DE3-9BFE-4BF7-8689-8BF4690EA2C0"];
    self.kitchenBeaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID: beaconuuid
                                                                 major:61819
                                                                 minor:55823
                                                            identifier:@"KitchenRegionIdentifier"];
    self.kitchenBeaconRegion.notifyOnEntry = self.enterRegionSwitch.isOn;
    self.kitchenBeaconRegion.notifyOnExit = self.exitRegionSwitch.isOn;
    
        [self.beaconManager startMonitoringForRegion:self.kitchenBeaconRegion];
    
   self.purpleBeaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID: beaconuuid
                                                                          major:28705
                                                                          minor:41613
                                                                     identifier:@"PurpleRegionIdentifier"];
    self.purpleBeaconRegion.notifyOnEntry = self.enterRegionSwitch.isOn;
    self.purpleBeaconRegion.notifyOnExit = self.exitRegionSwitch.isOn;
    
        [self.beaconManager startMonitoringForRegion:self.purpleBeaconRegion];
    
    self.mintBeaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID: beaconuuid
                                                                       major:27331
                                                                       minor:17139
                                                                  identifier:@"MintRegionIdentifier"];
    self.mintBeaconRegion.notifyOnEntry = self.enterRegionSwitch.isOn;
    self.mintBeaconRegion.notifyOnExit = self.exitRegionSwitch.isOn;
    
    [self.beaconManager startMonitoringForRegion:self.mintBeaconRegion];
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
        notification.alertBody = [NSString stringWithFormat:@"You've passed the Kitchen %d times! Yay!", kitchenNumberOfTimes];
                self.kitchenEnterLabel.text=@"";
        [self.view addSubview:self.kitchenEnterLabel];
        self.kitchenEnterLabel.text = [NSString stringWithFormat:@"You've passed the Kitchen %d times! Yay!", kitchenNumberOfTimes];
        [self.view addSubview:self.kitchenEnterLabel];
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
    else if([region.identifier isEqualToString:@"PurpleRegionIdentifier"])
    {
        notification = [UILocalNotification new];
        purpleNumberOfTimes++;
        notification.alertBody = [NSString stringWithFormat:@"You've passed the Purple %d times! Yay!", purpleNumberOfTimes];
        self.purpleEnterLabel.text=@"";
        [self.view addSubview:self.purpleEnterLabel];
        self.purpleEnterLabel.text = [NSString stringWithFormat:@"You've passed the Purple %d times! Yay!", purpleNumberOfTimes];
        [self.view addSubview:self.purpleEnterLabel];
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
    else if([region.identifier isEqualToString:@"MintRegionIdentifier"])
    {
        notification = [UILocalNotification new];
        mintNumberOfTimes++;
        notification.alertBody = [NSString stringWithFormat:@"You've passed the Mint %d times! Yay!", mintNumberOfTimes];
        self.mintEnterLabel.text=@"";
        [self.view addSubview:self.mintEnterLabel];
        self.mintEnterLabel.text = [NSString stringWithFormat:@"You've passed the Mint %d times! Yay!", mintNumberOfTimes];
        [self.view addSubview:self.mintEnterLabel];
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
    
    self.upCountLabel.text=@"";
    [self.view addSubview:self.upCountLabel];
    self.upCountLabel.text = [NSString stringWithFormat:@"You've gotten up %d times! Yay!", (kitchenNumberOfTimes+purpleNumberOfTimes+mintNumberOfTimes)];
    [self.view addSubview:self.upCountLabel];
    notification = [UILocalNotification new];
    notification.alertBody=[NSString stringWithFormat:@"You've gotten up %d times! Yay!", (kitchenNumberOfTimes+purpleNumberOfTimes+mintNumberOfTimes)];
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];

}

- (void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(ESTBeaconRegion *)region
{
    
    UILocalNotification *notification;
    UILabel *enterRegionLabel;
    
    if([region.identifier isEqualToString:@"KitchenRegionIdentifier"])
    {
        notification = [UILocalNotification new];
        kitchenNumberOfTimes++;
        notification.alertBody = @"You're out of range of the Kitchen!";
        enterRegionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.enterRegionSwitch.center.y - 90, self.view.frame.size.width, 40)];
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
        UILabel *enterRegionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.enterRegionSwitch.center.y - 70, self.view.frame.size.width, 40)];
        enterRegionLabel.text=@"";
        [self.view addSubview:enterRegionLabel];
        enterRegionLabel.text = @"You're out of range of the Purple!";
        [self.view addSubview:enterRegionLabel];
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
    else if([region.identifier isEqualToString:@"MintRegionIdentifier"])
    {
        notification = [UILocalNotification new];
        mintNumberOfTimes++;
        notification.alertBody = @"You're out of range of the Mint!";

        enterRegionLabel.text=@"";
        [self.view addSubview:enterRegionLabel];
        enterRegionLabel.text = @"You're out of range of the Mint!";
        [self.view addSubview:enterRegionLabel];
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
}

#pragma mark -

- (void)switchValueChanged
{
    [self.beaconManager stopMonitoringForRegion:self.kitchenBeaconRegion];
    
    self.kitchenBeaconRegion.notifyOnEntry = self.enterRegionSwitch.isOn;
    self.kitchenBeaconRegion.notifyOnExit = self.exitRegionSwitch.isOn;
    
    [self.beaconManager startMonitoringForRegion:self.kitchenBeaconRegion];
}

@end
