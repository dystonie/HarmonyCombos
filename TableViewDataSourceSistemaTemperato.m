//
//  TableViewDataSourceSistemaTemperato.m
//  Harmony Combos
//
//  Created by Guido Ronchetti on 3/6/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import "TableViewDataSourceSistemaTemperato.h"


@implementation TableViewDataSourceSistemaTemperato

-(id) initWithNote: (Note *)note {
	[super init];
	if (self) {
		noteNameObj = [note getNoteName];
		midiNumberObj = [note getMidiNumber];
	}
	return self;
}

-(void) dealloc {
	[noteNameObj release];
	[midiNumberObj release];
	[super dealloc];
}

@synthesize noteNameObj;
@synthesize midiNumberObj;

@end