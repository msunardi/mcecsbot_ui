//
//  MainMenuViewController.h
//  NavTest
//
//  Created by Mathias Sunardi on 3/1/13.
//  Copyright (c) 2013 Mathias Sunardi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenuViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *backgroundSwitchOutlet;
- (IBAction)backgroundSwitch:(id)sender;

@end
