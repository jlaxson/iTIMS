//
//  ScannerViewController.m
//  iTIMS
//
//  Created by John Laxson on 5/24/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import "ScannerViewController.h"
#import "LocationViewController.h"
#import "ItemViewController.h"
#import "iTIMSAppDelegate.h"
#import "ItemLayer.h"

#import <QuartzCore/QuartzCore.h>

@implementation ScannerViewController

@synthesize readerView, locationButton, commBoxButton, scanAction;

@synthesize location, activity, area;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [ZBarReaderView class];
        
        AudioServicesCreateSystemSoundID((CFURLRef)[[NSBundle mainBundle] URLForResource:@"Glass" withExtension:@"aiff"], &scanSound);
    }
    return self;
}

- (void)dealloc
{
    AudioServicesDisposeSystemSoundID(scanSound);
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)updateButtonTitles
{
    NSString *locTitle = [NSString stringWithFormat:@"%@ - %@", self.location, self.activity];
    [self.locationButton setTitle:locTitle forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    ZBarImageScanner *scanner = [[[ZBarImageScanner alloc] init] autorelease];
    
    [scanner setSymbology:0 config:ZBAR_CFG_ENABLE to:0];
    [scanner setSymbology:ZBAR_CODE39 config:ZBAR_CFG_ENABLE to:1];
    [scanner setSymbology:ZBAR_CODE128 config:ZBAR_CFG_ENABLE to:1];
    
    [scanner setSymbology:0 config:ZBAR_CFG_X_DENSITY to:1];
    [scanner setSymbology:0 config:ZBAR_CFG_Y_DENSITY to:1];
    
    self.readerView = [[[ZBarReaderView alloc] initWithImageScanner:scanner] autorelease]; //]WithFrame:CGRectMake(0, 0, 320, 350)];
    //[self.readerView _initWithImageScanner:scanner];
    self.readerView.torchMode = AVCaptureTorchModeOff;
    self.readerView.showsFPS = YES;
    self.readerView.frame = CGRectMake(0, 0, 320, 306);
    //
    self.readerView.bounds = self.readerView.frame;
    
    self.readerView.readerDelegate = self;
    
    //self.readerView.session.sessionPreset = AVCaptureSessionPresetHigh;
    
    [self.view addSubview:self.readerView];
    
    itemLayer = [[ItemLayer alloc] init];
    itemLayer.frame = CGRectMake(20, 20, 280, 80);
    itemLayer.opacity = 0.0;
    
    [self.view.layer addSublayer:itemLayer];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.readerView = nil;
    [self.readerView stop];
    
    [itemLayer release];
    itemLayer = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateButtonTitles];
}

- (void)viewDidAppear:(BOOL)animated
{
    [readerView start];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [readerView stop];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)editLocation:(id)sender
{
    LocationViewController *vc = [[LocationViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    vc.location = self.location;
    vc.area = self.area;
    vc.position = self.activity;
    
    vc.onComplete = ^(LocationViewController *lvc) {
        self.location = lvc.location;
        self.activity = lvc.position;
        self.area = lvc.area;
        
        [self updateButtonTitles];
    };
    
    [self presentModalViewController:nc animated:YES];
}

- (void)hideItemLayer
{
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:2] forKey:kCATransactionAnimationDuration];
    [CATransaction setValue:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn] forKey:kCATransactionAnimationTimingFunction];
    
    itemLayer.opacity = 0.0;
    [CATransaction commit];
}

- (void)processBarcode:(NSString *)barcode {
    AudioServicesPlaySystemSound(scanSound);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    
    if (self.scanAction) {
        self.scanAction(self, barcode);
    }
}

- (void)showBanner:(NSString *)title subtitle:(NSString *)subtitle duration:(NSTimeInterval)ti
{
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:.5] forKey:kCATransactionAnimationDuration];
    itemLayer.opacity = 1.0;
    itemLayer.title = title;
    itemLayer.subtitle = subtitle;
    [CATransaction commit];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hideItemLayer) userInfo:nil repeats:NO];
}

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    for (ZBarSymbol *sym in symbols) {
        NSLog(@"Got Barcode %@ with quality %d", sym.data, sym.quality);
        //self.navigationItem.title = sym.data;
        [self processBarcode:sym.data];
    }
}

@end
