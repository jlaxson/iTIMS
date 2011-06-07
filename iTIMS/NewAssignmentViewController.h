//
//  NewAssignmentViewController.h
//  iTIMS
//
//  Created by John Laxson on 6/1/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewAssignmentViewController : UITableViewController <UIActionSheetDelegate, UITextFieldDelegate> {
    
}

@property (retain) Item *item;
@property (retain) Assignment *assignment;

@end
