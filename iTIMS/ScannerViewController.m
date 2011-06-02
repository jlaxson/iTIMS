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

@synthesize readerView, locationButton, commBoxButton, scanAction, manualButton;

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
    
    self.navigationItem.rightBarButtonItem = self.manualButton;
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
    
    while (barcode.length < 6) {
        barcode = [@"0" stringByAppendingString:barcode];
    }
    
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

- (void)manualEntry:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Look Up Item" message:@"\n\n\n"
                                                           delegate:self cancelButtonTitle: @"Cancel"otherButtonTitles:@"OK", nil];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,40,260,25)];
    passwordLabel.font = [UIFont systemFontOfSize:16];
    passwordLabel.textColor = [UIColor whiteColor];
    passwordLabel.backgroundColor = [UIColor clearColor];
    passwordLabel.shadowColor = [UIColor blackColor];
    passwordLabel.shadowOffset = CGSizeMake(0,-1);
    passwordLabel.textAlignment = UITextAlignmentCenter;
    passwordLabel.text = @"Asset or Reference Number";
    [alert addSubview:passwordLabel];
    
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(16,83,252,25)];
    field.font = [UIFont systemFontOfSize:18];
    field.backgroundColor = [UIColor whiteColor];
    field.keyboardAppearance = UIKeyboardAppearanceAlert;
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    field.delegate = self;
    field.returnKeyType = UIReturnKeySearch;
    [field becomeFirstResponder];
    [alert addSubview:field];
    
    alertView = alert;
    [alert show];
    [alert release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [alertView dismissWithClickedButtonIndex:1 animated:YES];
    return YES;
}

- (void)alertView:(UIAlertView *)av didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // find subview that is a text field
        UITextField *f = nil;
        for (UIView *view in alertView.subviews) {
            if ([view isKindOfClass:[UITextField class]])  {
                f = (UITextField *)view;
                break;
            }
        }
        [self processBarcode:[f.text uppercaseString]];
    }
    av = nil;
}

@end
