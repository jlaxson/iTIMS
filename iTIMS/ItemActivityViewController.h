//
//  ItemPositionViewController.h
//  iTIMS
//
//  Created by John Laxson on 5/25/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemActivityViewController;

typedef void (^ActivityCompletionHandler)(ItemActivityViewController *vc, Activity *position) ;

@interface ItemActivityViewController : UITableViewController {
    NSDictionary *positions;
    NSArray *groups;
}

- (id)initWithCompletionHandler:(ActivityCompletionHandler)handler;

@property (retain) Activity *activity;
@property (copy) ActivityCompletionHandler completedAction;

@end
