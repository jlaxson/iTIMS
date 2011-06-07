//
//  LocationViewController.h
//  iTIMS
//
//  Created by John Laxson on 5/25/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LocationViewController : UITableViewController {
    UIBarButtonItem *closeButton;
}

@property (retain) NSString *location, *area, *activity, *position;

@property (copy) void (^onComplete)(LocationViewController *vc);

@end
