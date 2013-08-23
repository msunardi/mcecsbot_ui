//
//  NewWebViewController.m
//  NavTest
//
//  Created by Mathias Sunardi on 8/5/13.
//  Copyright (c) 2013 Mathias Sunardi. All rights reserved.
//
/* todo: Add read ip address to send to kinect senderthread program to stream video:
 http://stackoverflow.com/questions/7072989/iphone-ipad-how-to-get-my-ip-address-programmatically
 */

#import "NewWebViewController.h"
#import "GCDAsyncUdpSocket.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
///// ===== OPENEARS STUFF ======== /////
#import <OpenEars/LanguageModelGenerator.h>

LanguageModelGenerator *lmGenerator;
NSArray *words;
NSString *name;
NSError *err;
NSDictionary *languageGeneratorResults;
NSString *lmPath;
NSString *dicPath;

///// ======= END OF OPENEARS STUFF ===== ////

@interface NewWebViewController () {
    NSMutableString *log;
    GCDAsyncUdpSocket *udpSocket;
}

@end

@implementation NewWebViewController

@synthesize pocketsphinxController;
@synthesize openEarsEventsObserver;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    //theWebView = [[UIWebView alloc] initWithFrame:CGRectMake(30, 610, 240, 128)];
    [theWebView setDelegate:self];
    NSString *htmlString =  [NSString stringWithFormat:@"<html><body><h1>WebView html String Example</h1><p>My first paragraph.</p></body></html>"];
    [theWebView loadHTMLString:htmlString baseURL:nil];
    
    [self.view addSubview:theWebView];
    
    // Do any additional setup after loading the view.
    if (udpSocket == nil)
	{
		[self setupSocket];
	}

    
    //[self initNetworkCommunication:[NSString stringWithFormat:@"jeeves.dnsdynamic.com"]];
    //[self initNetworkCommunication:[NSString stringWithFormat:@"localhost"]];
    
    @try {
        
        lmGenerator = [[LanguageModelGenerator alloc]init];
        words = [NSArray arrayWithObjects:@"HELLO", @"HELLO WORLD", @"COMPUTER", @"COFFEE", @"GOOD MORNING", @"ROBOTICS LAB", @"PORTLAND", @"I AM HAPPY", @"INTERESTING", @"I DO NOT KNOW", @"THE DEAN", @"RUNNING AROUND", @"ONE TWO THREE FOUR FIVE SIX SEVEN EIGHT NINE TEN", @"I BEG YOUR PARDON", nil];
        name = @"MyLanguageModelFile";
        err = [lmGenerator generateLanguageModelFromArray:words withFilesNamed:name];
        languageGeneratorResults = nil;
        lmPath = nil;
        dicPath = nil;
        
        if ([err code] == noErr) {
            languageGeneratorResults = [err userInfo];
            lmPath = [languageGeneratorResults objectForKey:@"LMPath"];
            dicPath = [languageGeneratorResults objectForKey:@"DictionaryPath"];
        } else {
            NSLog(@"Error: %@",[err localizedDescription]);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Error during load: %@",exception);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setVideoFrame:nil];
    theWebView = nil;
    [self setHandDetectedLight:nil];
    [self setHandFollowingLight:nil];
    [self setObstacleLight:nil];
    [self setBaseMovementLabel:nil];
    [self setInstructionLabel:nil];
    [self setPersonDetectedLight:nil];
    [self setSpeechRecognitionSwitch:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    //[self initNetworkCommunication:[NSString stringWithFormat:@"jeeves.dnsdynamic.com"]];
    //[self initNetworkCommunication:[NSString stringWithFormat:@"10.39.243.151"]];
    [self initNetworkCommunication:[NSString stringWithFormat:@"127.0.0.1"]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)orientationChanged:(NSNotification *)notification
{
}

-(void)didRotate:(NSNotification *)notification
{
    NSLog(@"didrotate!");
    NSString *htmlString =  [NSString stringWithFormat:@"<html><body><h1><font color=\"#7798EE\">Webview did rotate!</font></h1></body></html>"];
    [theWebView loadHTMLString:htmlString baseURL:nil];
    //[self logInfo:@"Webview did rotate!"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	
    NSLog(@"webView:didFailLoadWithError: %@", error);
    
    if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -999)
        return;
    
    if ([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102)
        return;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	NSString *scrollToBottom = @"window.scrollTo(document.body.scrollWidth, document.body.scrollHeight);";
	
    [webView stringByEvaluatingJavaScriptFromString:scrollToBottom];
    NSLog(@"Stop browsing");
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"Start webview");
    
}

- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    // Determine if we want the system to handle it.
    /*NSURL *url = request.URL;
     if (![url.scheme isEqual:@"http"] && ![url.scheme isEqual:@"https"]) {
     if ([[UIApplication sharedApplication]canOpenURL:url]) {
     [[UIApplication sharedApplication]openURL:url];
     return NO;
     }
     }*/
    NSLog(@"Path:%@",request.URL.path);
    return YES;
}

/*- (void)logError:(NSString *)msg
{
	NSString *prefix = @"<font color=\"#B40404\">";
	NSString *suffix = @"</font><br>";
	
	[log appendFormat:@"%@%@%@\n", prefix, msg, suffix];
	
	NSString *html = [NSString stringWithFormat:@"<html><body>\n%@\n</body></html>", log];
	[theWebView loadHTMLString:html baseURL:nil];
}

- (void)logInfo:(NSString *)msg
{
	//NSString *prefix = @"<font color=\"#6A0888\">";
    NSString *prefix = @"<font color=\"#BADEAA\">";
	NSString *suffix = @"</font><br>";
	
	//[log appendFormat:@"%@%@%@\n", prefix, msg, suffix];
	NSLog(@"LogInfo");
	NSString *html = [NSString stringWithFormat:@"<html><body>\n%@%@%@\n</body></html>", prefix,log,suffix];
	[theWebView loadHTMLString:html baseURL:nil];
}

- (void)logMessage:(NSString *)msg
{
	NSString *prefix = @"<font color=\"#000000\">";
	NSString *suffix = @"</font><br>";
	
	//[log appendFormat:@"%@%@%@\n", prefix, msg, suffix];
	
	NSString *html = [NSString stringWithFormat:@"<html><body>%@%@%@</body></html>", prefix,log,suffix];
	[theWebView loadHTMLString:html baseURL:nil];
}*/

- (void)formatHTML:(NSString *)msg
{
    NSString *html = [NSString stringWithFormat:@"<html><body>\n<font color=\"#888888\">%@</font></body></html>", msg];
    [theWebView loadHTMLString:html baseURL:nil];
}

// NSStream methods
// Network stream methods
- (void)initNetworkCommunication:(NSString *) serverName{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    //CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"localhost", 80, &readStream, &writeStream);
    // Server port number is fixed here ... maybe need to be modifiable
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)CFBridgingRetain(serverName), 8008, &readStream, &writeStream);
    // ARC version
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    // Non-ARC version
    //inputStream = (NSInputStream *)readStream;
    //outputStream = (NSOutputStream *)writeStream;
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
    NSString *ipAddress = [self getIPAddress];
    NSString *response = [NSString stringWithFormat:@"iam:ipad"];//:%@", ipAddress];
    NSLog(@"Response: %@", response);
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
    
    // Then greet user
    //NSString *welcome = [NSString stringWithFormat:@"msg:Hello, %@",self.userName];
    //NSData *newdata = [[NSData alloc] initWithData:[welcome dataUsingEncoding:NSASCIIStringEncoding]];
    //[outputStream write:[newdata bytes] maxLength:[newdata length]];
    
    //[self messageReceived:[NSString stringWithFormat:@"Jeeves: Hello, %@.", self.userName]];
    
}

- (NSString *)formatOutput:(NSString *)input {
    NSString *formattedOutput = [NSString stringWithFormat:@"<html>\n \
                                 <body>\n \
                                    <font color='#9999FF' face='courier new'><strong>%@</strong></font>\n \
                                 </body>\n</html>",input];
    return formattedOutput;
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)eventCode {
    NSError* error;
    
    NSLog(@"stream event %i", eventCode);
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened.");
            break;
            
        case NSStreamEventHasBytesAvailable:
            if (theStream == inputStream) {
                uint8_t buffer[1024];
                int len;
                
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (output != nil) {
                            /* GET RID OF THIS COMMENTED PART IF THE JSON PARSER IS WORKING */
                            //[self messageReceived:output];
                            //[self logInfo:[NSString stringWithFormat:@"Message: %@", output]];
                            //[theWebView loadHTMLString:[self formatOutput:output] baseURL:nil];
                            //NSString *dummy = [NSString stringWithFormat:@"{\"loans\":[{\"id\":\"123\",\"name\":\"blahah\"},]}"];
                            //NSData *data = [dummy dataUsingEncoding:NSUTF8StringEncoding];
                            /*NSArray* latestLoans = [json objectForKey:@"loans"]; //2
                             
                             NSLog(@"loans: %@", latestLoans); //3
                             
                             // Parse JSON
                             // 1) Get the latest loan
                             NSDictionary* loan = [latestLoans objectAtIndex:0];
                             NSString *message = [NSString stringWithFormat:@"id: %@, name: %@", [loan objectForKey:@"id"],[loan objectForKey:@"name"]];*/
                            NSLog(@"Server said: %@", output);
                                                        
                            NSData *data = [output dataUsingEncoding:NSUTF8StringEncoding];
                            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                    error:&error];
                            
                            
                            
                            NSString *botclient = [json objectForKey:@"client"]; //2                            
                            
                            NSLog(@"client: %@", botclient); //3
                            
                            if (botclient == (NSString*)[NSNull null]) {
                                [theWebView loadHTMLString:[self formatOutput:output] baseURL:nil];
                            } else {
                            
                                /*// Parse JSON
                                // JSON format: {"client" : "kinect",
                                                 "status" : [
                                                                {"obstacle" : [
                                                                                {"detected" : "true/false", "source" : "sonar/kinect"}
                                                                              ]
                                                                },
                                                                {"trackhand" : "true/false"},
                                                                {"kinect_flag" : "true/false"},
                                                                {"speech_flag" : "true/false"},
                                                                {"current_action" : "trackhand/idle/searching/tooclose/roaming/wallfollowing"},
                                                                {"followhand_flag" : "true/false"},
                                                                {"playmusic_flag" : "true/false"},
                                                                {"rgb_flag" : "true/false"},
                                                                {"followwall_flag" : "true/false"},
                                                                {"base_cmd" : "none/stop/forward/reverse/left/right/strafeleft/straferight"},
                                                            ]
                                                }
                                //*/
                                BOOL trackhandbool = NO;
                                BOOL obstaclebool = NO;
                                NSArray* status_array = [json objectForKey:@"status"];
                                
                                // Check for obstacle status
                                NSDictionary* status_obstacle = [status_array objectAtIndex:0];
                                NSArray* obstacle_array = [status_obstacle objectForKey:@"obstacle"];
                                NSDictionary* obstacle_content = [obstacle_array objectAtIndex:0];
                                NSString* obstacle_detected = [obstacle_content objectForKey:@"detected"];
                                if ([obstacle_detected isEqualToString:@"false"]) {
                                    obstacle_detected = @"No obstacle detected";
                                    [[self obstacleLight] setImage:[UIImage imageNamed:@"stop_sign_off.png"]];
                                } else {
                                    obstacle_detected = @"Something is too close - I need space";
                                    obstaclebool = YES;
                                    [[self obstacleLight] setImage:[UIImage imageNamed:@"stop_sign.png"]];
                                    [[self instructionLabel] setText:@"I detected an obstacle nearby.\nI won't move until it is cleared"];
                                }
                                
                                // Hand-tracking status
                                NSDictionary* status_trackhand = [status_array objectAtIndex:1];
                                NSString* trackhand = [status_trackhand objectForKey:@"track_hand"];
                                if ([trackhand isEqualToString:@"false"]) {
                                    trackhand = @"Not tracking hand";
                                    [[self handDetectedLight] setImage:[UIImage imageNamed:@"hand_icons_trackhand_off.png"]];
                                } else {
                                    trackhand = @"Kinect is tracking hand";
                                    trackhandbool = YES;
                                    [[self handDetectedLight] setImage:[UIImage imageNamed:@"hand_icons_trackhand_on.png"]];
                                    [[self instructionLabel] setText:@"A hand has been detected.\nHover hand over buttons Into interact."];
                                }
                                //NSLog(@"trackinghand: %@", trackhand);
                                
                                // Input mode status (kinect vs. speech vs. tablet(not implemented yet!))
                                NSDictionary* status_kinectflag = [status_array objectAtIndex:2];
                                NSString* kinectflag = [status_kinectflag objectForKey:@"kinect_flag"];
                                
                                NSDictionary* status_speechflag = [status_array objectAtIndex:3];
                                NSString* speechflag = [status_speechflag objectForKey:@"speech_flag"];
                                
                                NSString* inputMode = [[NSString alloc] init];
                                
                                if ([kinectflag isEqualToString:@"true"] || trackhandbool) {
                                    inputMode = @"Kinect is active";
                                } else if ([speechflag isEqualToString:@"true"]) {
                                    inputMode = @"Speech is active";
                                } else {
                                    inputMode = @"No input detected. Say \"Hello\" or raise a hand to interact.";
                                }
                                
                                // Current action status of robot
                                NSDictionary* status_currentaction = [status_array objectAtIndex:4];
                                NSString* currentaction = [status_currentaction objectForKey:@"current_action"];
                                
                                if ([currentaction isEqualToString:@"idle"]) {
                                    [[self instructionLabel] setText:@"Raise a hand to start interaction"];
                                }
                                
                                
                                // Hand-following (robot moves to follow hand) mode status
                                NSDictionary* status_followhandflag = [status_array objectAtIndex:5];
                                NSString* followhandflag = [status_followhandflag objectForKey:@"followhand_flag"];
                                
                                if ([followhandflag isEqualToString:@"true"]) {
                                    followhandflag = @"Jeeves will now track your hand.\nMove your hand to lead Jeeves";
                                    [[self handFollowingLight] setImage:[UIImage imageNamed:@"hand_icons_followhand_on.png"]];
                                    [[self instructionLabel] setText:followhandflag];
                                } else {
                                    followhandflag = @"Jeeves is not following your hand";
                                    [[self handFollowingLight] setImage:[UIImage imageNamed:@"hand_icons_followhand_off.png"]];
                                }
                                
                                // Is playing music?
                                NSDictionary* status_playmusicflag = [status_array objectAtIndex:6];
                                NSString* playmusicflag = [status_playmusicflag objectForKey:@"playmusic_flag"];
                                
                                if ([playmusicflag isEqualToString:@"true"]) {
                                    playmusicflag = @"Jeeves is playing music!";
                                } else {
                                    if (trackhandbool) {
                                        playmusicflag = @"No music is playing currently ...";
                                    } else {
                                        playmusicflag = @"Did you know you can tell Jeeves to play music?<br>Try hitting the \"Play Music\" button";
                                    }
                                }

                                
                                // RGB mode?
                                NSDictionary* status_rgbflag = [status_array objectAtIndex:7];
                                NSString* rgbflag = [status_rgbflag objectForKey:@"rgb_flag"];
                                
                                if ([rgbflag isEqualToString:@"false"]) {
                                    rgbflag = @"seeing in full color";
                                } else {
                                    rgbflag = @"showing depth map";
                                }
                                
                                NSDictionary* status_followwallflag = [status_array objectAtIndex:8];
                                NSString *followwallflag = [status_followwallflag objectForKey:@"followwall_flag"];
                                
                                if ([followwallflag isEqualToString:@"true"]) {
                                    [[self instructionLabel] setText:@"WARNING: Automatic navigation engaged.\nPlease stay clear off my path or feel my wrath. Thank you."];
                                }
                                
                                // Check for user detection status
                                NSDictionary* status_users = [status_array objectAtIndex:9];
                                NSArray* users_array = [status_users objectForKey:@"users"];
                                NSDictionary* users_content = [users_array objectAtIndex:0];
                                NSString* users_detected = [users_content objectForKey:@"detected"];
                                NSLog(@"user flag: %@\n",users_detected);
                                if ([users_detected isEqualToString:@"true"]) {
                                    //users_detected = @"No obstacle detected";
                                    
                                    NSString *multiple_users_detected = [users_content objectForKey:@"multiple"];
                                    NSLog(@"multple users flag: %@\n",multiple_users_detected);
                                    if ([multiple_users_detected isEqualToString:@"true"]) {
                                        [[self personDetectedLight] setImage:[UIImage imageNamed:@"head_icon_multi2_on.png"]];
                                        [[self instructionLabel] setText:@"Now this is a party!"];
                                    } else 
                                        [[self personDetectedLight] setImage:[UIImage imageNamed:@"head_icon_multi1_on.png"]];
                                        [[self instructionLabel] setText:@"I see someone ..."];
                                } else {
                                    [[self personDetectedLight] setImage:[UIImage imageNamed:@"head_icon_multi2_off.png"]];
                                    [[self instructionLabel] setText:@"Where is everybody?"];
                                }
                                
                                // Base movement
                                NSDictionary* status_basecmd = [status_array objectAtIndex:10];
                                NSString* basecmd = [status_basecmd objectForKey:@"base_cmd"];
                                if ([basecmd isEqualToString:@"stop"] || [basecmd isEqualToString:@"none"]) {
                                    basecmd = @"stopped";
                                }
                                [[self baseMovementLabel] setText:[basecmd uppercaseString]];
                                
                                /*NSString *message = [NSString stringWithFormat:@"Robot is currently %@<br> \
                                                     %@<br>\
                                                     %@<br> \
                                                     %@<br> \
                                                     %@<br> \
                                                     Jeeves is %@<br> \
                                                     Base is going %@",
                                                     currentaction, obstacle_detected, trackhand, inputMode, playmusicflag, rgbflag, basecmd];
                                [theWebView loadHTMLString:[self formatOutput:message] baseURL:nil];*/
                            }
                        
                        }
                    }
                }
            }
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"Cannot connect to the host!");
            break;
            
        case NSStreamEventEndEncountered:
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            
        default:
            NSLog(@"Unknown event detected ...");
    }
            
}

- (void)setupSocket
{
	// Setup our socket.
	// The socket will invoke our delegate methods using the usual delegate paradigm.
	// However, it will invoke the delegate methods on a specified GCD delegate dispatch queue.
	//
	// Now we can configure the delegate dispatch queues however we want.
	// We could simply use the main dispatc queue, so the delegate methods are invoked on the main thread.
	// Or we could use a dedicated dispatch queue, which could be helpful if we were doing a lot of processing.
	//
	// The best approach for your application will depend upon convenience, requirements and performance.
	//
	// For this simple example, we're just going to use the main thread.
	
	udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	
	NSError *error = nil;
	[udpSocket setMaxReceiveIPv4BufferSize:65535]; //increase buffer size
    [udpSocket setMaxReceiveIPv6BufferSize:65535];
    
	if (![udpSocket bindToPort:9100 error:&error])
	{
		//[self logError:FORMAT(@"Error binding: %@", error)];
        NSLog(@"Error binding: %@",error);
		return;
	}
	if (![udpSocket beginReceiving:&error])
	{
		//[self logError:FORMAT(@"Error receiving: %@", error)];
        NSLog(@"Error receiving: %@", error);
		return;
	}
	
	//[self logInfo:@"Ready"];
    [self formatHTML:@"Ready"];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
	[self formatHTML:[NSString stringWithFormat:@"Received data: %u bytes", data.length]];
    NSLog(@"Received Data: %u",data.length);
	/*NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (msg)
    {
        [self formatHTML:[NSString stringWithFormat:@"RECVx: %@", msg]];
    }
    else
    {
        //NSString *host = [NSString stringWithFormat:@"192.168.5.173"];
        NSString *host = nil;
        uint16_t port = 0;
        [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
        
        [self formatHTML:[NSString stringWithFormat:@"RECV: Unknown message from: %@:%hu", host, port]];
    }*/
    
    UIImage *newImage = [[UIImage alloc]initWithData:data];
    [self.videoFrame setBounds:CGRectMake(0, 0, 640, 480)];
    [self.videoFrame setImage:newImage];
    newImage = nil;
    //[newImage autorelease];
}

// Get IP Address
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}

#pragma mark OpenEars methods
- (IBAction)speechRecognitionSwitchFlip:(id)sender {
    if (self.speechRecognitionSwitch.on) {
        
        NSLog(@"Flipped on!");
        
        self.speechRecognitionSwitch.enabled = NO; // Disable switch while pocketsphinx is loading
        [self.openEarsEventsObserver setDelegate:self];
        
        [self.pocketsphinxController startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath languageModelIsJSGF:NO];
    } else {
        NSLog(@"Flipped off!");
        [self.pocketsphinxController stopListening];
        [self.pocketsphinxController stopVoiceRecognitionThread];
        [self.openEarsEventsObserver setDelegate:nil];
        [self.speechStatus setText:@"Speech Recognition is off."];
        [self.textLabel setText:@"..."];
    }
}

- (PocketsphinxController *)pocketsphinxController {
    if (pocketsphinxController == nil) {
        pocketsphinxController = [[PocketsphinxController alloc]init];
    }
    return pocketsphinxController;
}

- (OpenEarsEventsObserver *)openEarsEventsObserver {
    if (openEarsEventsObserver == nil) {
        openEarsEventsObserver = [[OpenEarsEventsObserver alloc]init];
    }
    return openEarsEventsObserver;
}

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
	NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
    [self.speechStatus setText:@"I think you said:"];
    
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"self contains[cd] %@",hypothesis];
    
    if ([predicate evaluateWithObject:@"I AM HAPPY"]) {
        [self.textLabel setText:@"YOU DON'T SAY!"];
    }
    else if ([predicate evaluateWithObject:@"I BEG YOUR PARDON"]) {
        [self.textLabel setText:[NSString stringWithFormat:@"%@?",hypothesis]];
    }
    else {
        [self.textLabel setText:hypothesis];
    }
}

- (void) pocketsphinxDidStartCalibration {
	NSLog(@"Pocketsphinx calibration has started.");
    [self.speechStatus setText:@"Calibrating Pocketsphinx ..."];
}

- (void) pocketsphinxDidCompleteCalibration {
	NSLog(@"Pocketsphinx calibration is complete.");
    [self.speechStatus setText:@"Calibration complete!"];
}

- (void) pocketsphinxDidStartListening {
	NSLog(@"Pocketsphinx is now listening.");
    [self.speechStatus setText:@"Go ahead. I'm listening ..."];
    self.speechRecognitionSwitch.enabled = YES;
}


- (void) pocketsphinxDidDetectSpeech {
	NSLog(@"Pocketsphinx has detected speech.");
    [self.speechStatus setText:@"Did somone say something?"];
}

- (void) pocketsphinxDidDetectFinishedSpeech {
	NSLog(@"Pocketsphinx has detected a period of silence, concluding an utterance.");
}

- (void) pocketsphinxDidStopListening {
	NSLog(@"Pocketsphinx has stopped listening.");
}

- (void) pocketsphinxDidSuspendRecognition {
	NSLog(@"Pocketsphinx has suspended recognition.");
}

- (void) pocketsphinxDidResumeRecognition {
	NSLog(@"Pocketsphinx has resumed recognition.");
}

- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
	NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
}

- (void) pocketSphinxContinuousSetupDidFail { // This can let you know that something went wrong with the recognition loop startup. Turn on OPENEARSLOGGING to learn why.
	NSLog(@"Setting up the continuous recognition loop has failed for some reason, please turn on OpenEarsLogging to learn more.");
}



@end
