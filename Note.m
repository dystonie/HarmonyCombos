//
//  Note.m
//  CadenzeObjC
//
//  Created by Guido Ronchetti on 1/31/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import "Note.h"

@implementation Note
-(Note *) copyWithZone:(NSZone *)zone {
	Note *newNote = [[Note allocWithZone:zone] initWithNoteNumber:[midiNumber intValue]];
	return newNote;
}

-(void) encodeWithCoder: (NSCoder *)encoder {
	if ([encoder allowsKeyedCoding]) {
		[encoder encodeObject:midiNumber forKey:@"MIDI_Number"];
		[encoder encodeObject:noteName forKey:@"Note_Name"];
	}
	else {
		[encoder encodeObject:midiNumber];
		[encoder encodeObject:noteName];
	}
}

-(id) initWithCoder: (NSCoder *)decoder {
	if ([decoder allowsKeyedCoding]) {
		midiNumber = [[decoder decodeObjectForKey:@"MIDI_Number"] retain];
		noteName = [[decoder decodeObjectForKey:@"Note_Name"] retain];
	}
	else {
		midiNumber = [[decoder decodeObject] retain];
		noteName = [[decoder decodeObject] retain];
	}
	return self;
}
@end

@implementation Note (Setters)
-(Note *) initWithNoteNumber:(int)n {
	self = [super init];
	if (self) {
		midiNumber = [[NSNumber alloc] initWithInt: n];
		[self defineNoteName];
	}
	return self;
}
@end

@implementation Note (Getters)
-(NSNumber *) getMidiNumber {
	return midiNumber;
}

-(NSString *) getNoteName {
	return [noteName copy];
}
@end

@implementation Note (Utilities)
-(void) defineNoteName {
	
	NSArray *noteNames = [[NSArray alloc] initWithObjects:@"A", @"A#/Bb", @"B", @"C", @"C#/Db", 
						  @"D", @"D#/Eb", @"E", @"F", @"F#/Gb", @"G", @"G#/Ab", nil];
	
	int midiValue = [midiNumber intValue];
	//Definisco i valori numerici per l'identificazine
	int multipleCoeff = (int) ((float)(midiValue - MIN_MIDI_NOTE)/OCTAVE_GAP);
	int switchExpression = (midiValue - MIN_MIDI_NOTE) - (OCTAVE_GAP * multipleCoeff);
	//L'aggiunta di 9 permette di allineare le ottave al C
	int octaveCoeff = (int) ((float) ((midiValue + 9) - MIN_MIDI_NOTE)/OCTAVE_GAP);
	
	for (int i=0; i<12; i++) {
		if (switchExpression == i) {
			noteName = [NSString stringWithFormat:@"%@%@",[noteNames objectAtIndex:i], [NSNumber numberWithInt:(octaveCoeff)]];
		}
	}
	[noteNames release];
}

-(NSComparisonResult) compareNoteNumbers: (id)element {
	return [midiNumber compare:[element getMidiNumber]];
}
@end

@implementation Note (Destructors)
-(void) dealloc {
	[super dealloc];
}
@end