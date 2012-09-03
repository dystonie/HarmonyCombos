//
//  Chord.h
//  NoteGrid
//
//  Created by Guido Ronchetti on 2/5/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "Note.h"

@interface Chord : NSObject <NSCoding, NSCopying> {
	NSString *chordName;
	NSMutableDictionary *chordNotes;
}
-(BOOL)isEqualTo:(Chord *)aChord;
@end

@interface Chord (Setters)
-(Chord *) initEmptyWithName: (NSString *)name;
-(void) addNote: (Note*)note asGrade: (NSString *)gradeLabel;
@end

@interface Chord (Getters)
-(NSString *) getChordLabel;
-(Note *) getNoteFrom: (NSString *)gradeLabel;
-(NSDictionary *) getDictionary;
-(NSEnumerator *) keyEnumerator;
-(BOOL) isEmpty;
@end

@interface Chord (Destructors)
-(void) dealloc;
@end