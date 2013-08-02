//
//  MainMenuViewController.m
//  NavTest
//
//  Created by Mathias Sunardi on 3/1/13.
//  Copyright (c) 2013 Mathias Sunardi. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *gateTop;
@property (weak, nonatomic) IBOutlet UIImageView *gateBottom;
@property (weak, nonatomic) IBOutlet UIImageView *halImageView;
@end

@implementation MainMenuViewController

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
	// Do any additional setup after loading the view.
    UIImage *backgroundPattern = [UIImage imageNamed:@"graphene_bg_white.png"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:backgroundPattern]];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController setTitle:@"Main Menu"];
    UIImage *frame1 = [UIImage imageNamed:@"HAL9000.png"];
    UIImage *frame2 = [UIImage imageNamed:@"HAL9000_1.png"];
    UIImage *frame3 = [UIImage imageNamed:@"HAL9000_2.png"];
    UIImage *frame4 = [UIImage imageNamed:@"HAL9000_3.png"];
    UIImage *frame5 = [UIImage imageNamed:@"HAL9000_4.png"];
    UIImage *frame6 = [UIImage imageNamed:@"HAL9000_5.png"];
    UIImage *frame7 = [UIImage imageNamed:@"HAL9000_6.png"];
    UIImage *frame8 = [UIImage imageNamed:@"HAL9000_7.png"];
    UIImage *frame9 = [UIImage imageNamed:@"HAL9000_8.png"];
    UIImage *frame10 = [UIImage imageNamed:@"HAL9000_9.png"];
    
    _halImageView.animationImages = [[NSArray alloc] initWithObjects:frame1, frame1, frame2, frame3, frame4, frame5, frame6, frame7, frame8, frame9, frame10, frame10, frame10, frame10,frame9, frame8, frame7, frame6, frame5, frame4, frame3, frame2, frame1, frame1, nil];
    _halImageView.animationDuration = 3.0; // defaults is number of animation images * 1/30th of a second
    _halImageView.animationRepeatCount = 0; // default is 0, which repeats indefinitely
    [self.halImageView startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.1 green:0.3 blue:0.15 alpha:0.4];
}

- (void)viewDidAppear:(BOOL)animated {
    CGRect gateTopFrame = self.gateTop.frame;
    gateTopFrame.origin.y = -gateTopFrame.size.height;
    
    CGRect gateBottomFrame = self.gateBottom.frame;
    gateBottomFrame.origin.y = self.view.bounds.size.height;
    
    [UIView animateWithDuration:0.5
                          delay:2.0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         self.gateTop.frame = gateTopFrame;
                         self.gateBottom.frame = gateBottomFrame;
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"Done!");
                     }];
}

- (void)viewDidUnload {
    [self setGateTop:nil];
    [self setGateBottom:nil];
    [self setHalImageView:nil];
    [self setBackgroundSwitchOutlet:nil];
    [super viewDidUnload];
}
- (IBAction)backgroundSwitch:(id)sender {
    UIImage *backgroundPattern;
    if ([self.backgroundSwitchOutlet isOn]) {
        backgroundPattern = [UIImage imageNamed:@"graphene_bg_white.png"];
    } else {
        backgroundPattern = [UIImage imageNamed:@"graphene_bg.png"];
    }
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:backgroundPattern]];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end

