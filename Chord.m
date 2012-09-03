//
//  Chord.m
//  NoteGrid
//
//  Created by Guido Ronchetti on 2/5/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import "Chord.h"

@implementation Chord
-(Chord *) copyWithZone: (NSZone *)zone {
	Chord *newChord = [[Chord allocWithZone:zone] initEmptyWithName:chordName];
	NSEnumerator *keyEnum = [chordNotes keyEnumerator];
	NSString *key;
	
	while ((key = [keyEnum nextObject]) != nil) {
		[newChord addNote:[chordNotes objectForKey:key] asGrade:key];
	}
	return newChord;
	
	[keyEnum release];
	[key release];
}

-(void) encodeWithCoder: (NSCoder *)encoder {
	if ([encoder allowsKeyedCoding]) {
		[encoder encodeObject:chordName forKey:@"Chord_Name"];
		[encoder encodeObject:chordNotes forKey:@"Notes_Dictionary"];
	}
	else {
		[encoder encodeObject:chordName];
		[encoder encodeObject:chordNotes];
	}
}

-(id) initWithCoder: (NSCoder *)decoder {
	if ([decoder allowsKeyedCoding]) {
		chordName = [[decoder decodeObjectForKey:@"Chord_Name"] retain];
		chordNotes = [[decoder decodeObjectForKey:@"Notes_Dictionary"] retain];
	}
	else {
		chordName = [[decoder decodeObject] retain];
		chordNotes = [[decoder decodeObject] retain];
	}
	return self;
}

-(BOOL)isEqualTo:(Chord *)aChord {
    BOOL result = TRUE;
    NSArray *keys = [chordNotes allKeys];
    NSMutableArray *boolResults = [NSMutableArray arrayWithCapacity:[keys count]];
    for (NSInteger i=0; i<[keys count]; i++) {
        [boolResults addObject:[NSNumber numberWithBool:[[[chordNotes objectForKey:[keys objectAtIndex:i]] getNoteName] 
                                                         isEqualTo:[[[aChord getDictionary] objectForKey:[keys objectAtIndex:i]] getNoteName]]]];
    }
    for (NSInteger i=0; i<[boolResults count]; i++) {
        if (result == TRUE && ([[boolResults objectAtIndex:i] boolValue] == TRUE))
            result = TRUE;
        else
            result = FALSE;
    }
    return result;    
}

@end

@implementation Chord (Setters)
-(Chord *) initEmptyWithName: (NSString *)name {
	self = [super init];
	if (self) {
		chordName = [NSString stringWithString: name];
		chordNotes = [NSMutableDictionary dictionary];
	}
	return self;
}

-(void) addNote: (Note *)note asGrade: (NSString *)gradeLabel {
	[chordNotes setObject:note forKey:gradeLabel];
}
@end

@implementation Chord (Getters)
-(NSString *) getChordLabel {
	return chordName;
}

-(Note *) getNoteFrom: (NSString *)gradeLabel {
	return [chordNotes objectForKey:gradeLabel];
}

-(NSDictionary *) getDictionary {
    return [NSDictionary dictionaryWithDictionary:chordNotes];
}

-(NSEnumerator *) keyEnumerator {
	return [chordNotes keyEnumerator];
}

-(BOOL) isEmpty {
	NSEnumerator *keyEnum = [chordNotes keyEnumerator];
	NSString *key;
	if ((key = [keyEnum nextObject]) != nil) {
		return FALSE;
	}
	else {
		return TRUE;
	}
	
	[keyEnum release];
	[key release];
}
@end

@implementation Chord (Destructors)
-(void) dealloc {
	[super dealloc];
}
@end