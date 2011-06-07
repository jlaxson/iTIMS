//
//  ItemPositionViewController.h
//  iTIMS
//
//  Created by John Laxson on 6/4/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ItemPositionViewController : UITableViewController {
    NSArray *positions;
}

@property (retain) Position *position;
@property (copy) void (^completedAction)(ItemPositionViewController *vc, Position *location);

@end
