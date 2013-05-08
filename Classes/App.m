#import "App.h"

#import "NSURL+L0URLParsing.h"

@implementation App

-(void)awakeFromNib {
    NSAppleEventManager *appleEventManager = [NSAppleEventManager sharedAppleEventManager];
    [appleEventManager
        setEventHandler:self
        andSelector:@selector(handleGetURLEvent:withReplyEvent:)
        forEventClass:kInternetEventClass
        andEventID:kAEGetURL
    ];
}

-(void)handleGetURLEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
    NSURL *url = [NSURL URLWithString:[[event paramDescriptorForKeyword:keyDirectObject] stringValue]];

    if (url && [[url host] isEqualToString:@"open"]) {
        NSDictionary *params = [url dictionaryByDecodingQueryString];
        NSURL *file_url = [NSURL URLWithString:[params objectForKey:@"url"]];

        if (file_url && [[file_url scheme] isEqualToString:@"file"]) {
            NSString *file = [file_url path];

            if (file) {
                NSTask *task = [[NSTask alloc] init];
                [task setLaunchPath: @"/usr/bin/open"];
                [task setArguments:[NSArray arrayWithObjects: @"-a", @"MacVIM", file, nil]];
                
                [task launch];
                [task release];
            }
        }
    }
}

@end
