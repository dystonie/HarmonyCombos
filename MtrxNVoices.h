//
//  MtrxNVoices.h
//  NoteGrid
//
//  Created by Guido Ronchetti on 2/5/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "AlgorithmHeader.h"

@interface MtrxNVoices : NSObject <NSCoding, NSCopying> {
	NSMutableArray *voices;
	NSString *mtrxName;
}
@end

@interface MtrxNVoices (Setters)
-(MtrxNVoices *) initWithName: (NSString *)name andArray: (NSMutableArray *)array;
@end

@interface MtrxNVoices (Getters)
-(NSString *) getIDLabel;
-(int) getNumberOfVoices;
-(int) maxNoteEntries;
@end

@interface MtrxNVoices (Utilities)
-(Note *) returnNoteFromVoice: (int)numVox atIndex: (int)n;
-(NSString *) returnVoiceLabelfrom: (int)numVox;
-(NSMutableArray *) mtrxToChordArrayConvert;
@end

@interface MtrxNVoices (Destructors)
-(void) dealloc;
@end