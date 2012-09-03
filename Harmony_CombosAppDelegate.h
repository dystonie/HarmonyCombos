//
//  Harmony_CombosAppDelegate.h
//  Harmony Combos
//
//  Created by Guido Ronchetti on 3/3/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import "Headers.h"

@interface Harmony_CombosAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    Midi_Interface *playInterface;
    lilyInterface *lilyInstance;
    NSMenuItem *showMainWndMenu;
    NSDictionary *interfaceStrings;
	IBOutlet NSTextField *bassoMin, *bassoMax, *tenoreMin, *tenoreMax, *altoMin, *altoMax, *sopranoMin, *sopranoMax;
	IBOutlet NSPopUpButton *popUpButton;
	IBOutlet NSTabView *tabView;
}
@property (assign) IBOutlet NSWindow *window;
-(void)showMainWindow:(id)sender;
@end
