//
//  InteractionViewController.h
//  NavTest
//
//  Created by Mathias Sunardi on 8/2/13.
//  Copyright (c) 2013 Mathias Sunardi. All rights reserved.
//

#import <UIKit/UIKit.h>
NSInputStream * inputStream;
NSOutputStream * outputStream;

@interface InteractionViewController : UIViewController <NSStreamDelegate, UIWebViewDelegate> {
    //UIWebView *webView;
    IBOutlet UIWebView *webView;
}

@property (assign, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)stopButton:(id)sender;
- (IBAction)speechSwitch:(id)sender;
@property (assign, nonatomic) NSString *chatServer;

@end
