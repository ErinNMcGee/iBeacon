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

@property (weak, nonatomic) IBOutlet UITextView *quoteText;
@property (weak, nonatomic) IBOutlet UIImageView *quoteImage;

@property (strong, nonatomic) AVAudioPlayer *playerBG;
@end

@implementation iBeaconViewController

static int kitchenNumberOfTimes=0;
static int purpleNumberOfTimes=0;
static int garyNumberOfTimes=0;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *simpsonsYellow = [UIColor colorWithRed:255.0f/255.0f green:217.0f/255.0f blue:15.0f/255.0f alpha:1.0f];
    
    self.view.backgroundColor=simpsonsYellow;
    self.quoteText.backgroundColor=simpsonsYellow;
    
    [self.quoteText setHidden:YES];
    [self.quoteImage setHidden:YES];
    
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
    int arrayValue=0 + arc4random() % (4 - 0 + 1);
    NSString *notificationString;
    NSArray *quotes = @[@"Principal Skinner: Uh oh. Two independent thought alarms in one day. The students are overstimulated.", @"Billy Corgan: Billy Corgan, Smashing Pumpkins. \n\nHomer: Homer Simpson, smiling politely", @"Roadie: Aw man, there goes Peter Frampton's big finale. He's gonna be pissed off.\n\nPeter Frampton: You're damn right I'm gonna be pissed off! I bought that pig at Pink Floyd's yard sale!", @"Homer: I am so smart! I am so smart! I am so smart! S-M-R-T... I mean S-M-A-R-T!", @"Homer: No TV and no beer make Homer... something something... \n\nMarge: Go crazy? \n\nHomer: Don’t mind if I do!"];
    
    NSArray *audio=@[@"ITA",@"SmilingPolitely",@"Frampton",@"SMRT",@"NoTV"];
    [self.quoteImage setHidden:NO];
    
    if([region.identifier isEqualToString:@"KitchenRegionIdentifier"])
    {
        NSArray *kitchenQuotes = @[@"Homer: When you have a rib-eye steak, you must floss it. Oh, that meatloaf tasted great, you must floss it! Now, floss it! Floss it good!", @"Homer: Ooh!  Floor pie!", @"Homer, Bart, and Marge: You don't win friends with salad! You don't win friends with salad!You don't win friends with salad! You don't win friends with salad!", @"Lisa: Dad! Those all come from the same animal! \n\nHomer: Yeah, right, Lisa. A wonderful, magical animal!", @"Lisa: Do you have any fruit? \n\nHomer: This has purple stuff inside, purple is a fruit."];
        
        NSArray *kitchenAudio=@[@"FlossIt",@"FloorPie",@"Salad",@"MagicalAnimal",@"PurpleIsAFruit"];
        kitchenNumberOfTimes++;
        notificationString=[NSString stringWithFormat:@"You've walked by the kitchen %d time(s)!",kitchenNumberOfTimes];
        AVAudioPlayer *pp1 = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:kitchenAudio[arrayValue] ofType:@"wav"]] error:nil];
        self.playerBG = pp1;
        [pp1 prepareToPlay];
        [self.playerBG play];
        self.quoteText.text = kitchenQuotes[arrayValue];
        [self.quoteText setHidden:NO];
        [self.beaconManager stopMonitoringForRegion:self.kitchenBeaconRegion];
        [self.beaconManager startMonitoringForRegion:self.kitchenBeaconRegion];
    }
    else if([region.identifier isEqualToString:@"PurpleRegionIdentifier"])
    {
        purpleNumberOfTimes++;
        notificationString=[NSString stringWithFormat:@"You've walked by the purple beacon %d times!",purpleNumberOfTimes];
        AVAudioPlayer *pp1 = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:audio[arrayValue] ofType:@"wav"]] error:nil];
        self.playerBG = pp1;
        [pp1 prepareToPlay];
        [self.playerBG play];
        self.quoteText.text = quotes[arrayValue];
        [self.quoteText setHidden:NO];
        [self.beaconManager stopMonitoringForRegion:self.purpleBeaconRegion];
        [self.beaconManager startMonitoringForRegion:self.purpleBeaconRegion];
    }
    else if([region.identifier isEqualToString:@"GaryRegionIdentifier"])
    {
        garyNumberOfTimes++;
        notificationString=[NSString stringWithFormat:@"You've walked by Gary %d time(s)!",garyNumberOfTimes];
        AVAudioPlayer *pp1 = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:audio[arrayValue] ofType:@"wav"]] error:nil];
        self.playerBG = pp1;
        [pp1 prepareToPlay];
        [self.playerBG play];
        self.quoteText.text = quotes[arrayValue];
        [self.quoteText setHidden:NO];
        [self.beaconManager stopMonitoringForRegion:self.garyBeaconRegion];
        [self.beaconManager startMonitoringForRegion:self.garyBeaconRegion];
    }
    
    notification = [UILocalNotification new];
    notification.alertBody=notificationString;
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
