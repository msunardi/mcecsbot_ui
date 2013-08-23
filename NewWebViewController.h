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

@interface NewWebViewController : UIViewController <UIWebViewDelegate, NSStreamDelegate, OpenEarsEventsObserverDelegate> {
    NSInputStream * inputStream;
    NSOutputStream * outputStream;
    IBOutlet UIWebView *theWebView;
    
    PocketsphinxController *pocketsphinxController;
    OpenEarsEventsObserver *openEarsEventsObserver;
}

@property (assign, nonatomic) IBOutlet UIImageView *videoFrame;
@property (strong, nonatomic) IBOutlet UIImageView *handDetectedLight;
@property (strong, nonatomic) IBOutlet UIImageView *handFollowingLight;
@property (strong, nonatomic) IBOutlet UIImageView *obstacleLight;
@property (strong, nonatomic) IBOutlet UIImageView *personDetectedLight;
@property (strong, nonatomic) IBOutlet UILabel *baseMovementLabel;
@property (strong, nonatomic) IBOutlet UILabel *instructionLabel;

- (IBAction)speechRecognitionSwitchFlip:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *speechRecognitionSwitch;
@property (strong,nonatomic) PocketsphinxController *pocketsphinxController;
@property (strong,nonatomic) OpenEarsEventsObserver *openEarsEventsObserver;
@property (weak, nonatomic) IBOutlet UILabel *speechStatus;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end
