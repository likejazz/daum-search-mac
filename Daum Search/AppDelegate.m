//
//  AppDelegate.m
//  Daum Search
//
//  Copyright © 2015 Sang-Kil Park Some rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

NSString *_DEFAULT_URL = @"http://m.daum.net";
NSString *_SEARCH_URL = @"https://m.search.daum.net/search?w=tot&q=";

/* -- */

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    [self.window setTitle:@"Daum 검색"];
    [self loadBrowser:_DEFAULT_URL];

    // Event handler for keyboard shortcut
    NSEvent *(^monitorHandler)(NSEvent *);
    monitorHandler = ^NSEvent *(NSEvent *theEvent) {

        // Focus on search box when press `Command + L`
        if ([theEvent modifierFlags] & NSCommandKeyMask && [theEvent keyCode] == 0x25) {
            [self setFocus];

            // Prevent the unnecessary event
            return nil;
        }

        // Return the event, a new event, or, to stop
        // the event from being dispatched, nil
        return theEvent;
    };

    // Creates an object we do not own, but must keep track of so that
    // it can be "removed" when we're done; therefore, put it in an ivar.
    [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:monitorHandler];

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {}

/* -- */

- (void)setFocus {
    [[self window] makeFirstResponder:self.searchField];
}

// Load WebKit viewer with specific URL
- (void)loadBrowser:(NSString *)url {
    NSURL *urlNS = [NSURL URLWithString:url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:urlNS];
    [[[self webView] mainFrame] loadRequest:urlRequest];

    // For change the text on the window.title
    [_webView setFrameLoadDelegate:self];
}

/* -- */

- (IBAction)search:(id)sender {
    NSString *q = [_searchField stringValue];

    if ([q length] != 0) {
        [self loadBrowser:[NSString stringWithFormat:@"%@%@",
                        _SEARCH_URL,
                        [q stringByAddingPercentEncodingWithAllowedCharacters: // Query encoding for HTTP request
                                [NSCharacterSet URLHostAllowedCharacterSet]]
        ]];
    }
}

- (IBAction)newWindow:(id)sender {
    // Extract current URL from WebView
    NSString *currentURL = [[[[[_webView mainFrame] dataSource] request] URL] absoluteString];
    // Open link in external default browser
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:currentURL]];
}

/* -- */

// Change the text on the window.title
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
    // Extract document's title from rendered HTML
    NSString *title = [[self webView] stringByEvaluatingJavaScriptFromString:@"document.title"];

    [self.window setTitle:title];
}

@end