//
//  InsiemeNote.m
//  CadenzeObjC
//
//  Created by Guido Ronchetti on 2/1/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import "InsiemeNote.h"

@implementation InsiemeNote
-(InsiemeNote *) copyWithZone:(NSZone *)zone {
	InsiemeNote *newInsieme = [[InsiemeNote allocWithZone:zone] initWithName:idLabel];
	for (int i=0; i<[self entries]; i++) {
		[newInsieme addNote:[noteGroup objectAtIndex:i]];
	}
	return newInsieme;
}

-(void) encodeWithCoder: (NSCoder *)encoder {
	if ([encoder allowsKeyedCoding]) {
		[encoder encodeObject:idLabel forKey:@"Insieme_Name"];
		[encoder encodeObject:noteGroup forKey:@"Insieme_Array"];
	}
	else {
		[encoder encodeObject:idLabel];
		[encoder encodeObject:noteGroup];
	}
}

-(id) initWithCoder: (NSCoder *)decoder {
	if ([decoder allowsKeyedCoding]) {
		idLabel = [[decoder decodeObjectForKey:@"Insieme_Name"] retain];
		noteGroup = [[decoder decodeObjectForKey:@"Insieme_Array"] retain];
	}
	else {
		idLabel = [[decoder decodeObject] retain];
		noteGroup = [[decoder decodeObject] retain];
	}
	return self;
}
@end

@implementation InsiemeNote (Setters)
-(InsiemeNote *) initWithName: (NSString *)name {
	self = [super init];
	if (self) {
		idLabel = [NSString stringWithString: name];
		noteGroup = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void) addNote: (Note *)note {
	if (self) {
		[noteGroup addObject:note];
	}
}
@end

@implementation InsiemeNote (Getters)
-(int) entries {
	return [noteGroup count];
}

-(NSString *) getIDLabel {
	return idLabel;
}
@end

@implementation InsiemeNote (Utilities)
-(void) sort {
	[noteGroup sortUsingSelector:@selector(compareNoteNumbers:)];
}

-(Note *) lookForNote: (int)n {
	if (n<[self entries]) {
		return [noteGroup objectAtIndex:n];
	}
	else {
		return nil;
	}
}
@end

@implementation InsiemeNote (Destructors)
-(void) removeNote:(int)n {
	[noteGroup removeObjectAtIndex:n];
}

-(void) clearInsieme {
	[noteGroup removeAllObjects];
}

-(void) dealloc {
	[noteGroup release];
	[idLabel release];
	[super dealloc];
}
@end