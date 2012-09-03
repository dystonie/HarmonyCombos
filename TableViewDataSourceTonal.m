//
//  TableViewDataSourceTonal.m
//  Harmony Combos
//
//  Created by Guido Ronchetti on 3/5/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import "TableViewDataSourceTonal.h"

@implementation TableViewDataSourceTonal

-(id) initWithChord: (Chord *)chord {
	[super init];
	if (self) {
		Note *tonicaNote, *terzaNote, *quintaNote;
		tonicaNote = [chord getNoteFrom:[NSString stringWithUTF8String:TONICA]];
		terzaNote = [chord getNoteFrom:[NSString stringWithUTF8String:TERZA]];
		quintaNote = [chord getNoteFrom:[NSString stringWithUTF8String:QUINTA]];
		labelTableObj = [chord getChordLabel];
		if (tonicaNote)
			tonicaTableObj =[tonicaNote getNoteName];
		else
			tonicaTableObj = @"";
		if (terzaNote)
			terzaTableObj = [terzaNote getNoteName];
		else 
			terzaTableObj = @"";
		if (quintaNote)
			quintaTableObj = [quintaNote getNoteName];
		else
			quintaTableObj = @"";
	}
	return self;	
}

-(id) initEmptyRow {
	[super init];
	if (self) {
		tonicaTableObj = @"" ;
		terzaTableObj = @"";
		quintaTableObj = @"" ;
		quintaTableObj = @"";
	}
	return self;	
}

-(void) dealloc {
	[terzaTableObj release];
	[tonicaTableObj release];
	[quintaTableObj release];
	[labelTableObj release];
	[super dealloc];
}

@synthesize terzaTableObj;
@synthesize tonicaTableObj;
@synthesize quintaTableObj;
@synthesize labelTableObj;

@end
