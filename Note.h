//
//  Note.h
//  CadenzeObjC
//
//  Created by Guido Ronchetti on 1/31/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "GlobalVariables.h"

@interface Note : NSObject <NSCoding, NSCopying> {
	NSNumber *midiNumber;
	NSString *noteName;
}
@end

@interface Note (Setters)
-(Note *) initWithNoteNumber: (int) n;
@end

@interface Note (Getters)
-(NSNumber *) getMidiNumber;
-(NSString *) getNoteName;
@end

@interface Note (Utilities)
-(void) defineNoteName;
-(NSComparisonResult) compareNoteNumbers: (id)element;
@end

@interface Note (Destructors)
-(void) dealloc;
@end