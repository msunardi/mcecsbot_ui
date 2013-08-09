//
//  NewWebViewController.h
//  NavTest
//
//  Created by Mathias Sunardi on 8/5/13.
//  Copyright (c) 2013 Mathias Sunardi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewWebViewController : UIViewController <UIWebViewDelegate, NSStreamDelegate> {
    NSInputStream * inputStream;
    NSOutputStream * outputStream;
    IBOutlet UIWebView *theWebView;
}
@property (assign, nonatomic) IBOutlet UIImageView *videoFrame;

@end
