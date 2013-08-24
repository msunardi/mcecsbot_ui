//
//  NewWebViewController.h
//  NavTest
//
//  Created by Mathias Sunardi on 8/5/13.
//  Copyright (c) 2013 Mathias Sunardi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenEars/PocketsphinxController.h>
#import <OpenEars/OpenEarsEventsObserver.h>
#import <Slt/Slt.h>
#import <Kal/Kal.h>
#import <Kal16/Kal16.h>
#import <Rms/Rms.h>
#import <Rms8k/Rms8k.h>
#import <Awb/Awb.h>
#import <Awb8k/Awb8k.h>
#import <OpenEars/FliteController.h>

@interface NewWebViewController : UIViewController <UIWebViewDelegate, NSStreamDelegate, OpenEarsEventsObserverDelegate> {
    NSInputStream * inputStream;
    NSOutputStream * outputStream;
    IBOutlet UIWebView *theWebView;
    
    PocketsphinxController *pocketsphinxController;
    OpenEarsEventsObserver *openEarsEventsObserver;
    
    FliteController *fliteController;
    Slt *slt;
    Kal16 *kal;
    Awb8k *awb;
    Rms *rms;

}

@property (assign, nonatomic) IBOutlet UIImageView *videoFrame;
@property (strong, nonatomic) IBOutlet UIImageView *handDetectedLight;
@property (strong, nonatomic) IBOutlet UIImageView *handFollowingLight;
@property (strong, nonatomic) IBOutlet UIImageView *obstacleLight;
@property (strong, nonatomic) IBOutlet UIImageView *personDetectedLight;
@property (strong, nonatomic) IBOutlet UIImageView *speechLight;
@property (strong, nonatomic) IBOutlet UIImageView *wallFollowingLight;
@property (strong, nonatomic) IBOutlet UILabel *baseMovementLabel;
@property (strong, nonatomic) IBOutlet UILabel *instructionLabel;

- (IBAction)speechRecognitionSwitchFlip:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *speechRecognitionSwitch;
@property (strong,nonatomic) PocketsphinxController *pocketsphinxController;
@property (strong,nonatomic) OpenEarsEventsObserver *openEarsEventsObserver;
@property (weak, nonatomic) IBOutlet UILabel *speechStatus;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (strong, nonatomic) FliteController *fliteController;
@property (strong, nonatomic) Slt *slt;
@property (strong, nonatomic) Kal16 *kal;
@property (strong, nonatomic) Awb8k *awb;
@property (strong, nonatomic) Rms *rms;



@end
