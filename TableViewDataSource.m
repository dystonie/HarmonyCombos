//
//  TableViewDataSource.m
//  Harmony Combos
//
//  Created by Guido Ronchetti on 3/3/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import "TableViewDataSource.h"

@implementation TableViewDataSource

-(id) initWithChord: (Chord *)chord {
	self = [super init];
	if (self) {
		Note *bassoNote, *tenoreNote, *altoNote, *sopranoNote;
		bassoNote = [chord getNoteFrom:[NSString stringWithUTF8String:BASSO]];
		tenoreNote =  [chord getNoteFrom:[NSString stringWithUTF8String:TENORE]];
		altoNote = [chord getNoteFrom:[NSString stringWithUTF8String:ALTO]];
		sopranoNote = [chord getNoteFrom:[NSString stringWithUTF8String:SOPRANO]];
		if (bassoNote)
			bassoTableObj = [bassoNote getNoteName];
		else
			bassoTableObj = @"" ;
		if (tenoreNote)
			tenoreTableObj = [tenoreNote getNoteName];
		else
			tenoreTableObj = @"";
		if (altoNote)
			altoTableObj = [altoNote getNoteName];
		else
			altoTableObj = @"" ;
		if (sopranoNote)
			sopranoTableObj = [sopranoNote getNoteName];
		else
			sopranoTableObj = @"";
	}
	return self;
}

-(id) initEmptyRow {
	[super init];
	if (self) {
		bassoTableObj = @"" ;
		tenoreTableObj = @"";
		altoTableObj = @"" ;
		sopranoTableObj = @"";
	}
	return self;	
}

-(void) dealloc {
	[bassoTableObj release];
	[tenoreTableObj release];
	[altoTableObj release];
	[sopranoTableObj release];
	[super dealloc];
}

@synthesize bassoTableObj;
@synthesize tenoreTableObj;
@synthesize altoTableObj;
@synthesize sopranoTableObj;  
						   
@end