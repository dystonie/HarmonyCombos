//
//  lilyInterface.h
//  Harmony Combos
//
//  Created by Guido Ronchetti on 4/7/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "GlobalVariables.h"
#import "Cadenza.h"
#import "Note.h"


@interface lilyInterface : NSObject {
    @private
    NSMutableArray *bassoLabels, *tenoreLabels, *altoLabels, *sopranoLabels;
    NSDictionary *chordNotes;
    NSMutableString *printableString;
    NSMutableArray *arrayVoicingLabels;
    int tonalita;
}
-(id) init;

@property (retain, readonly) NSMutableArray *arrayVoicingLabels;

@end

@interface lilyInterface (Translators)
-(NSString *)translate: (NSString *)str;
@end

@interface lilyInterface (MessageResponders)
-(void) exportNotes: (NSNotification *)notification;
-(void) setTonalita: (NSNotification *)notification;
-(void) setVoicingLabel: (NSNotification *)notification;
-(void) generateLilyPondFile: (NSNotification *)notification;
-(void) clearLilyPondBuffer: (NSNotification *)notification;
@end

@interface lilyInterface (Destructors)
-(void) dealloc;
@end
