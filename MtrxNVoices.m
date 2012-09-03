//
//  MtrxNVoices.m
//  NoteGrid
//
//  Created by Guido Ronchetti on 2/5/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import "MtrxNVoices.h"

@implementation MtrxNVoices
-(MtrxNVoices *) copyWithZone:(NSZone *)zone {
	MtrxNVoices *newInsieme = [[MtrxNVoices allocWithZone:zone] initWithName:mtrxName andArray:voices];
	return newInsieme;
}

-(void) encodeWithCoder: (NSCoder *)encoder {
	if ([encoder allowsKeyedCoding]) {
		[encoder encodeObject:mtrxName forKey:@"Mtrx_Name"];
		[encoder encodeObject:voices forKey:@"Mtrx_Array"];
	}
	else {
		[encoder encodeObject:mtrxName];
		[encoder encodeObject:voices];
	}
}

-(id) initWithCoder: (NSCoder *)decoder {
	if ([decoder allowsKeyedCoding]) {
		mtrxName = [[decoder decodeObjectForKey:@"Mtrx_Name"] retain];
		voices = [[decoder decodeObjectForKey:@"Mtrx_Array"] retain];
	}
	else {
		mtrxName = [[decoder decodeObject] retain];
		voices = [[decoder decodeObject] retain];
	}
	return self;
}
@end

@implementation MtrxNVoices (Setters)
-(MtrxNVoices *) initWithName: (NSString *)name andArray: (NSMutableArray *)array;{
	self = [super init];
	if (self) {
		mtrxName = [NSString stringWithString: name];
		voices = [[NSMutableArray alloc] initWithArray:array];
	}
	return self;
}
@end

@implementation MtrxNVoices (Getters)
-(NSString *) getIDLabel {
	return mtrxName;
}

-(int) getNumberOfVoices {
	return [voices count];
}

-(int) maxNoteEntries {
	int maxN = 0;
	for (int i=0; i<[voices count]; i++) {
		if ([[voices objectAtIndex:i] entries] > maxN) {
			maxN = [[voices objectAtIndex:i] entries];
		}
		else {
			maxN = maxN;
		}
	}
	return maxN;
}	
@end

@implementation MtrxNVoices (Utilities)
-(Note *) returnNoteFromVoice: (int)numVox atIndex: (int)n {
	if (numVox < [voices count]) {
		return [[voices objectAtIndex:numVox] lookForNote:n];
	}
	else {
		return nil;
	}
}

-(NSString *) returnVoiceLabelfrom: (int)numVox {
	if (numVox < [voices count]) {
		return [[voices objectAtIndex:numVox] getIDLabel];
	}
	else {
		return nil;
	}
}

-(NSMutableArray *) mtrxToChordArrayConvert {
	NSMutableArray *output = [[NSMutableArray alloc] initWithObjects:nil];
	NSData *data;
	Chord *tmp;
	for (int i=0; i<[self maxNoteEntries]; i++) {
		tmp = [[Chord alloc] initEmptyWithName:mtrxName];
		for (int n=0; n<[self getNumberOfVoices]; n++) {			
			if ([[voices objectAtIndex:n] lookForNote:i]) {
				[tmp addNote:[[voices objectAtIndex:n] lookForNote:i] asGrade:[[voices objectAtIndex:n] getIDLabel]];
			}
		}
		data = [NSArchiver archivedDataWithRootObject:tmp];
		[output addObject:[NSUnarchiver unarchiveObjectWithData:data]];
		[tmp release];
	}
	return output;
}	
@end

@implementation MtrxNVoices (Destructors)
-(void) dealloc {
	[voices release];
	[mtrxName release];
	[super dealloc];
}
@end