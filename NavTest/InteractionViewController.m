//
//  InteractionViewController.m
//  NavTest
//
//  Created by Mathias Sunardi on 8/2/13.
//  Copyright (c) 2013 Mathias Sunardi. All rights reserved.
//

#import "InteractionViewController.h"
#import "GCDAsyncUdpSocket.h"

#define FORMAT(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]

@interface InteractionViewController () {
    BOOL isShowingLandscapeView;
    
    long tag;
	GCDAsyncUdpSocket *udpSocket;
    
    NSMutableString *log;
	
}

@end

@implementation InteractionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    //if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
	//{
        // Custom initialization
        
    }
    return self;
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
		[self logError:FORMAT(@"Error binding: %@", error)];
		return;
	}
	if (![udpSocket beginReceiving:&error])
	{
		[self logError:FORMAT(@"Error receiving: %@", error)];
		return;
	}
	
	[self logInfo:@"Ready"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(30, 610, 240, 128)];
    [webView setDelegate:self];
    NSString *htmlString =  [NSString stringWithFormat:@"<html><body><h1>WebView html String Example</h1><p>My first paragraph.</p></body></html>"];
    [webView loadHTMLString:htmlString baseURL:nil];   
    
    [self.view addSubview:webView];
    
    
	// Do any additional setup after loading the view.
    if (udpSocket == nil)
	{
		[self setupSocket];
	}
	
    //[self initNetworkCommunication:[NSString stringWithFormat:@"jeeves.dnsdynamic.com"]];
    [self initNetworkCommunication:[NSString stringWithFormat:@"localhost"]];
}

- (void)viewDidUnload {

    [self setImageView:nil];
    
    webView = nil;
    webView = nil;
	[super viewDidUnload];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    @try {
        [inputStream close];
        [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [outputStream close];
        [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [inputStream setDelegate:nil];
        inputStream = nil;
        [outputStream setDelegate:nil];
        outputStream = nil;
        //[messages removeAllObjects];
    }
    @catch (NSException *e) {
        NSLog(@"Error unloading view: %@",e.reason);
    }
    

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

- (void)orientationChanged:(NSNotification *)notification
{
}

-(void)didRotate:(NSNotification *)notification
{
    NSLog(@"didrotate!");
}


- (IBAction)stopButton:(id)sender {
}

- (IBAction)speechSwitch:(id)sender {
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
	[self logInfo:FORMAT(@"Data: %u", data.length)];
    NSLog(@"Received Data: %u",data.length);
	NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (msg)
    {
        [self logMessage:FORMAT(@"RECVx: %@", msg)];
    }
    else
    {
        //NSString *host = [NSString stringWithFormat:@"192.168.5.173"];
        NSString *host = nil;
        uint16_t port = 0;
        [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
         
        [self logInfo:FORMAT(@"RECV: Unknown message from: %@:%hu", host, port)];
    }
    
    UIImage *newImage = [[UIImage alloc]initWithData:data];
    [self.imageView setBounds:CGRectMake(0, 0, 640, 480)];
    [self.imageView setImage:newImage];
    newImage = nil;
    //[newImage autorelease];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	
    NSLog(@"webView:didFailLoadWithError: %@", error);
    
    if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -999)
        return;
    
    if ([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102)
        return;
}

- (void)webViewDidFinishLoad:(UIWebView *)webview
{
	NSString *scrollToBottom = @"window.scrollTo(document.body.scrollWidth, document.body.scrollHeight);";
	
    [webView stringByEvaluatingJavaScriptFromString:scrollToBottom];
    NSLog(@"Stop browsing");
}

- (void)webViewDidStartLoad:(UIWebView *)webview
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

- (void)logError:(NSString *)msg
{
	NSString *prefix = @"<font color=\"#B40404\">";
	NSString *suffix = @"</font><br>";
	
	[log appendFormat:@"%@%@%@\n", prefix, msg, suffix];
	
	NSString *html = [NSString stringWithFormat:@"<html><body>\n%@\n</body></html>", log];
	[webView loadHTMLString:html baseURL:nil];
}

- (void)logInfo:(NSString *)msg
{
	//NSString *prefix = @"<font color=\"#6A0888\">";
    NSString *prefix = @"<font color=\"#BADEAA\">";
	NSString *suffix = @"</font><br>";
	
	[log appendFormat:@"%@%@%@\n", prefix, msg, suffix];
	NSLog(@"LogInfo");
	NSString *html = [NSString stringWithFormat:@"<html><body>\n%@\n</body></html>", log];
	[webView loadHTMLString:html baseURL:nil];
}

- (void)logMessage:(NSString *)msg
{
	NSString *prefix = @"<font color=\"#000000\">";
	NSString *suffix = @"</font><br>";
	
	[log appendFormat:@"%@%@%@\n", prefix, msg, suffix];
	
	NSString *html = [NSString stringWithFormat:@"<html><body>%@</body></html>", log];
	[webView loadHTMLString:html baseURL:nil];
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
    NSString *response = [NSString stringWithFormat:@"iam:ipad"];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
    
    // Then greet user
    //NSString *welcome = [NSString stringWithFormat:@"msg:Hello, %@",self.userName];
    //NSData *newdata = [[NSData alloc] initWithData:[welcome dataUsingEncoding:NSASCIIStringEncoding]];
    //[outputStream write:[newdata bytes] maxLength:[newdata length]];
    
    //[self messageReceived:[NSString stringWithFormat:@"Jeeves: Hello, %@.", self.userName]];

}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)eventCode {
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
                            NSLog(@"Server said: %@", output);
                            //[self messageReceived:output];
                            //[self logInfo:[NSString stringWithFormat:@"Message: %@", output]];
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
@end
