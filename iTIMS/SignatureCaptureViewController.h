//
//  SignatureCaptureViewController.h
//  iTIMS
//
//  Created by John Laxson on 6/3/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SignatureCaptureView;

@interface SignatureCaptureViewController : UIViewController <UIActionSheetDelegate> {
    
}

@property (retain) IBOutlet UIBarButtonItem *doneButton;
@property (retain) IBOutlet SignatureCaptureView *signatureView;
@property (copy) void (^completionHandler)(SignatureCaptureViewController *vc, UIImage *image);

- (IBAction)doneButton:(id)sender;

@end
