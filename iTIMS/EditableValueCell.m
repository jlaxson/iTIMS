//
//  EditableValueCell.m
//  iTIMS
//
//  Created by John Laxson on 6/3/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import "EditableValueCell.h"


@implementation EditableValueCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGRect frame = self.textField.frame;
        frame.origin.x += 150;
        frame.size.width -= 155;
        
        self.textField.frame = frame;
        
        frame = self.textLabel.frame;
        frame.size.width -= 150;
        self.textLabel.frame = frame;
        
        self.textField.font = [UIFont systemFontOfSize:18];
        self.textField.textColor = [UIColor blueColor];
        self.textField.textAlignment = UITextAlignmentRight;
        //self.textField.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

@end
