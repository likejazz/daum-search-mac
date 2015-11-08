//
//  AppDelegate.h
//  Daum Search
//
//  Copyright © 2015 Sang-Kil Park Some rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSWindow *window;

@property (weak) IBOutlet WebView *webView;
@property (weak) IBOutlet NSSearchField *searchField;
@property (weak) IBOutlet NSButton *btnNew;

- (IBAction)search:(id)sender;

@end

