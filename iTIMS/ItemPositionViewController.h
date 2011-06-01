//
//  ItemPositionViewController.h
//  iTIMS
//
//  Created by John Laxson on 5/25/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ItemPositionViewController : UITableViewController {
    NSDictionary *positions;
    NSArray *groups;
}

@property (copy) NSString *group, *activity;

@end
