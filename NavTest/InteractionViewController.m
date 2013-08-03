//
//  InteractionViewController.m
//  NavTest
//
//  Created by Mathias Sunardi on 8/2/13.
//  Copyright (c) 2013 Mathias Sunardi. All rights reserved.
//

#import "InteractionViewController.h"

@interface InteractionViewController () {
    BOOL isShowingLandscapeView;
}

@end

@implementation InteractionViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

/*- (void)awakeFromNib
{
    isShowingLandscapeView = NO;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}*/

- (void)orientationChanged:(NSNotification *)notification
{
    /*UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation) &&
        !isShowingLandscapeView)
    {
        [self performSegueWithIdentifier:@"InteractionAlternateView" sender:self];
        isShowingLandscapeView = YES;
    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation) &&
             isShowingLandscapeView)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        isShowingLandscapeView = NO;
    }*/
}

-(void)didRotate:(NSNotification *)notification
{
    /*UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if ((orientation == UIDeviceOrientationLandscapeLeft) || (orientation == UIDeviceOrientationLandscapeRight))
    {
        self.portraitView.hidden = YES;
        self.landscapeView.hidden = NO;
    }
    else if (orientation == UIDeviceOrientationPortrait)
    {
        self.portraitView.hidden = NO;
        self.landscapeView.hidden = YES;
    }*/
    NSLog(@"didrotate!");
}

- (void)viewDidUnload {
    [self setPortraitView:nil];
    [self setLandscapeView:nil];
    [super viewDidUnload];
}
@end
