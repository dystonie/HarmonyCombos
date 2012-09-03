//
//  TableViewDataSourceCadenze.m
//  Harmony Combos
//
//  Created by Guido Ronchetti on 3/7/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import "TableViewDataSourceCadenze.h"

@implementation TableViewDataSourceCadenze

-(id) initWithCadenza: (Cadenza *)cadenza {
	[super init];
	if (self) {
		Chord *fromCh, *toCh;
		fromCh = [cadenza getFromChord];
		toCh = [cadenza getToChord];
		
		bassoDomNote = [fromCh getNoteFrom:[NSString stringWithUTF8String:BASSO]];
		tenoreDomNote = [fromCh getNoteFrom:[NSString stringWithUTF8String:TENORE]];
		altoDomNote = [fromCh getNoteFrom:[NSString stringWithUTF8String:ALTO]];
		sopranoDomNote = [fromCh getNoteFrom:[NSString stringWithUTF8String:SOPRANO]];
		
		bassoTonNote = [toCh getNoteFrom:[NSString stringWithUTF8String:BASSO]];
		tenoreTonNote = [toCh getNoteFrom:[NSString stringWithUTF8String:TENORE]];
		altoTonNote = [toCh getNoteFrom:[NSString stringWithUTF8String:ALTO]];
		sopranoTonNote = [toCh getNoteFrom:[NSString stringWithUTF8String:SOPRANO]];
				
		if (bassoDomNote)
			bassoDominanteTableObj = [bassoDomNote getNoteName];
		else
			bassoDominanteTableObj = @"" ;
		if (tenoreDomNote)
			tenoreDominanteTableObj = [tenoreDomNote getNoteName];
		else
			tenoreDominanteTableObj = @"";
		if (altoDomNote)
			altoDominanteTableObj =  [altoDomNote getNoteName];
		else
			altoDominanteTableObj = @"" ;
        if (sopranoDomNote)
			sopranoDominanteTableObj = [sopranoDomNote getNoteName];
		else 
			sopranoDominanteTableObj = @"";
		
		if (bassoTonNote)
			bassoTonicaTableObj = [bassoTonNote getNoteName];
		else
			bassoTonicaTableObj = @"" ;
		if (tenoreTonNote)
			tenoreTonicaTableObj =  [tenoreTonNote getNoteName];
		else
			tenoreTonicaTableObj = @"";
		if (altoTonNote)
			altoTonicaTableObj =  [altoTonNote getNoteName];
		else
			altoTonicaTableObj = @"" ;
		if (sopranoTonNote)
			sopranoTonicaTableObj = [sopranoTonNote getNoteName];
		else
			sopranoTonicaTableObj = @"";
	}
	return self;
}

-(id) initEmptyRow {
	[super init];
	if (self) {
		bassoDominanteTableObj = @"" ;
		tenoreDominanteTableObj = @"";
		altoDominanteTableObj = @"" ;
		sopranoDominanteTableObj = @"";
		bassoTonicaTableObj = @"" ;
		tenoreTonicaTableObj = @"";
		altoTonicaTableObj = @"" ;
		sopranoTonicaTableObj = @"";
	}
	return self;
}

-(NSMutableArray *) returnNotesTonica {
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithObjects:bassoTonNote, tenoreTonNote, altoTonNote, sopranoTonNote , nil];
    return [tmp retain];
    [tmp release];
}

-(NSMutableArray *) returnNotesDominante {
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithObjects:bassoDomNote, tenoreDomNote, altoDomNote, sopranoDomNote , nil];
    return [tmp retain];
    [tmp release];
}

-(void) dealloc {
	[bassoTonicaTableObj release];
	[tenoreTonicaTableObj release];
	[altoTonicaTableObj release];
	[sopranoTonicaTableObj release];
	[bassoDominanteTableObj release];
	[tenoreDominanteTableObj release];
	[altoDominanteTableObj release];
	[sopranoDominanteTableObj release];
    [bassoDomNote release];
    [tenoreDomNote release];
    [altoDomNote release];
    [sopranoDomNote release];
    [bassoTonNote release];
    [tenoreTonNote release];
    [altoTonNote release];
    [sopranoTonNote release];
	[super dealloc];
}

@synthesize bassoTonicaTableObj;
@synthesize tenoreTonicaTableObj;
@synthesize altoTonicaTableObj;
@synthesize sopranoTonicaTableObj;

@synthesize bassoDominanteTableObj;
@synthesize tenoreDominanteTableObj;
@synthesize altoDominanteTableObj;
@synthesize sopranoDominanteTableObj;

@end