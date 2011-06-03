//
//  TextTableCell.m
//  iTIMS
//
//  Created by John Laxson on 6/2/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import "TextTableCell.h"


@implementation TextTableCell

@synthesize textField;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 30)];
        field.font = [UIFont systemFontOfSize:24];
        
        [self.contentView insertSubview:field aboveSubview:self.textLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textField = field;
        [field release];
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
