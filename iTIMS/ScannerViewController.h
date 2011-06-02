//
//  ScannerViewController.h
//  iTIMS
//
//  Created by John Laxson on 5/24/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScannerViewController;
@class ItemLayer;

@interface ScannerViewController : UIViewController <ZBarReaderViewDelegate, UIAlertViewDelegate, UITextFieldDelegate> {
    ItemLayer *itemLayer;
    SystemSoundID scanSound;
    UIAlertView *alertView;
}

@property (retain) IBOutlet ZBarReaderView *readerView;
@property (retain) IBOutlet UIButton *commBoxButton, *locationButton;
@property (retain) IBOutlet UIBarButtonItem *manualButton;

@property (copy) void (^scanAction)(ScannerViewController *svc, NSString *barcode);

@property (copy) NSString *location, *area, *activity;

- (IBAction)editLocation:(id)sender;
- (IBAction)manualEntry:(id)sender;
- (void)showBanner:(NSString *)title subtitle:(NSString *)subtitle duration:(NSTimeInterval)ti;

@end
