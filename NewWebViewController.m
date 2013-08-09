//
//  NewWebViewController.m
//  NavTest
//
//  Created by Mathias Sunardi on 8/5/13.
//  Copyright (c) 2013 Mathias Sunardi. All rights reserved.
//

#import "NewWebViewController.h"
#import "GCDAsyncUdpSocket.h"

@interface NewWebViewController () {
    NSMutableString *log;
    GCDAsyncUdpSocket *udpSocket;
}

@end

@implementation NewWebViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setVideoFrame:nil];
    theWebView = nil;
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    //[self initNetworkCommunication:[NSString stringWithFormat:@"jeeves.dnsdynamic.com"]];
    [self initNetworkCommunication:[NSString stringWithFormat:@"localhost"]];
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

- (void)logError:(NSString *)msg
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
}

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
                            [self logInfo:[NSString stringWithFormat:@"Message: %@", output]];
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


@end
