//
//  LoanRecordPrinter.h
//  iTIMS
//
//  Created by John Laxson on 5/31/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LoanRecordPrinter : NSObject <UIWebViewDelegate> {
    
}

- (void)printAssignment:(Assignment *)assignment;

@end
