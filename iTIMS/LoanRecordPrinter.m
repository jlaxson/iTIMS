//
//  LoanRecordPrinter.m
//  iTIMS
//
//  Created by John Laxson on 5/31/11.
//  Copyright 2011 SOS Technologies, Inc. All rights reserved.
//

#import "LoanRecordPrinter.h"
#import "MGTemplateEngine.h"
#import "ICUTemplateMatcher.h"

@implementation LoanRecordPrinter

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)printAssignment:(Assignment *)assignment
{
    NSError *e;
    MGTemplateEngine *engine = [MGTemplateEngine templateEngine];
    [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
    NSString *template = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"LoanTemplate" withExtension:@"html"] encoding:NSUTF8StringEncoding error:&e];
    NSMutableDictionary *variables = [NSMutableDictionary dictionary];
    [variables setObject:assignment forKey:@"assignment"];
    [variables setObject:@"DR491-11 Alabama 4/11 Tornadoes" forKey:@"droName"];
    
    NSString *layout = [engine processTemplate:template withVariables:variables];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
    webView.dataDetectorTypes = UIDataDetectorTypeNone;
    
    [webView loadHTMLString:layout baseURL:[[NSBundle mainBundle] resourceURL]];
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    UIViewPrintFormatter *printFormatter = webView.viewPrintFormatter;
    UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
    
    printController.printFormatter = printFormatter;
    
    [printController presentAnimated:YES completionHandler:^(UIPrintInteractionController *printInteractionController, BOOL completed, NSError *error) {
    }];
}

@end
