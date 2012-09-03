//
//  Harmony_CombosAppDelegate.m
//  Harmony Combos
//
//  Created by Guido Ronchetti on 3/3/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import "Harmony_CombosAppDelegate.h"

@implementation Harmony_CombosAppDelegate

@synthesize window;

-(void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	//Operazione da compiere al momento della apertura della applicazione	
	Note *tmpConv;
	tmpConv = [[Note alloc] initWithNoteNumber:BASS_MIN];
	[bassoMin setStringValue:[tmpConv getNoteName]];
	[tmpConv release];
	tmpConv = [[Note alloc] initWithNoteNumber:BASS_MAX];
	[bassoMax setStringValue:[tmpConv getNoteName]];
	[tmpConv release];
	tmpConv = [[Note alloc] initWithNoteNumber:TENO_MIN];
	[tenoreMin setStringValue:[tmpConv getNoteName]];
	[tmpConv release];
	tmpConv = [[Note alloc] initWithNoteNumber:TENO_MAX];
	[tenoreMax setStringValue:[tmpConv getNoteName]];
	[tmpConv release];
	tmpConv = [[Note alloc] initWithNoteNumber:ALTO_MIN];
	[altoMin setStringValue:[tmpConv getNoteName]];
	[tmpConv release];
	tmpConv = [[Note alloc] initWithNoteNumber:ALTO_MAX];
	[altoMax setStringValue:[tmpConv getNoteName]];
	[tmpConv release];
	tmpConv = [[Note alloc] initWithNoteNumber:SOPR_MIN];
	[sopranoMin setStringValue:[tmpConv getNoteName]];
	[tmpConv release];
	tmpConv = [[Note alloc] initWithNoteNumber:SOPR_MAX];
	[sopranoMax setStringValue:[tmpConv getNoteName]];
	[tmpConv release];
	//Definisce di default la tonalità selezionata come Do magg
	[popUpButton selectItemWithTitle:@"C"]; 
	//Definisce la tab visualizzata all'avvio
	[tabView selectTabViewItemAtIndex:2];
    playInterface = [[Midi_Interface alloc] init];
    lilyInstance = [[lilyInterface alloc] init];
    //Menu che mostra la finestra principale se chiusa
    NSString *path = [[NSBundle mainBundle] pathForResource:@"InterfaceStrings" ofType:@"plist"];
    interfaceStrings = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMenuItem *wndItem = [[NSApp menu] itemWithTitle:[interfaceStrings objectForKey:@"MenuItem.WindowMenu.Title"]];
    showMainWndMenu = [[NSMenuItem alloc] initWithTitle:[interfaceStrings objectForKey:@"MenuItem.ShowMainWnd.Title"] action:@selector(showMainWindow:) keyEquivalent:@""];
    [[wndItem submenu] insertItem:showMainWndMenu atIndex:[[wndItem submenu] numberOfItems]];
    [showMainWndMenu setHidden:YES];
    //Fine gestione menu
}

-(void)showMainWindow:(id)sender {
    [window setIsVisible:YES];
    [showMainWndMenu setHidden:YES];
    NSMenuItem *wndItem = [[NSApp menu] itemWithTitle:[interfaceStrings objectForKey:@"MenuItem.WindowMenu.Title"]];
    NSInteger spaceIndex = ([[wndItem submenu] indexOfItemWithTitle:[interfaceStrings objectForKey:@"MenuItem.ShowMainWnd.Title"]] - 1);
    [[[wndItem submenu] itemAtIndex:spaceIndex] setHidden:YES];    
}

-(BOOL) application:(NSApplication *)sender openFile:(NSString *)filename {
	//Crea un messaggio per tutte le classi in ascolto che avvisa dell'apertura file
    NSDictionary *fileData = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:filename, nil] 
                                                           forKeys:[[NSArray alloc] initWithObjects:@"File_Name", nil]];
    NSNotification *notifyFileOpen = [NSNotification notificationWithName:@"File_Name" object:self userInfo:fileData];
    [[NSNotificationCenter defaultCenter] postNotification:notifyFileOpen];
	return TRUE;
    [notifyFileOpen release];
    [fileData release];
}

-(void)windowWillClose:(id)sender {
    [showMainWndMenu setHidden:NO];
    NSMenuItem *wndItem = [[NSApp menu] itemWithTitle:[interfaceStrings objectForKey:@"MenuItem.WindowMenu.Title"]];
    NSInteger spaceIndex = ([[wndItem submenu] indexOfItemWithTitle:[interfaceStrings objectForKey:@"MenuItem.ShowMainWnd.Title"]] - 1);
    [[[wndItem submenu] itemAtIndex:spaceIndex] setHidden:NO];
}
	
-(void) applicationWillTerminate:(NSNotification *)notification {
    [showMainWndMenu release];
    showMainWndMenu = nil;
    [playInterface release];
    [lilyInstance release];
}
@end