//
//  InsiemeNote.h
//  CadenzeObjC
//
//  Created by Guido Ronchetti on 2/1/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "Note.h"

@interface InsiemeNote : NSObject <NSCoding, NSCopying> {
	NSString *idLabel;
	NSMutableArray *noteGroup;
}
@end

@interface InsiemeNote (Setters)
-(InsiemeNote *) initWithName: (NSString *)name;
-(void) addNote: (Note*)note;
@end

@interface InsiemeNote (Getters)
-(int) entries;
-(NSString *) getIDLabel;
@end

@interface InsiemeNote (Utilities)
-(void) sort;
-(Note *) lookForNote: (int)n;
@end

@interface InsiemeNote (Destructors)
-(void) removeNote: (int) n;
-(void) clearInsieme;
-(void) dealloc;
@end