//
//  TextTableCell.h
//  iTIMS
//
//  Created by John Laxson on 6/2/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TextTableCell : UITableViewCell {
    
}

@property (retain) UITextField *textField;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
