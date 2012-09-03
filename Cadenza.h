//
//  Cadenza.h
//  NoteGrid
//
//  Created by Guido Ronchetti on 3/1/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "Chord.h"

@interface Cadenza : NSObject <NSCoding, NSCopying> {
	Chord *fromChord, *toChord;
    NSString *typeOfPartiDominante;
    NSString *typeOfPartiTonica;
}

@property (retain, readonly) NSString *typeOfPartiDominante;
@property (retain, readonly) NSString *typeOfPartiTonica;

-(BOOL)isEqualTo:(Cadenza *)aCadenza;

@end

@interface Cadenza (Setters)
-(Cadenza *) initWithChord: (Chord *)fromCh andChord: (Chord *)toCh andStringTypeDominante:(NSString *)aStrA andStringTypeTonica:(NSString *)aStrB;
@end

@interface Cadenza (Getters)
-(Chord *) getFromChord;
-(Chord *) getToChord;
@end

@interface Cadenza (RegoleStatiche)
-(Cadenza *) ilBassoHaLaFondamentale: (Chord *)tonalChord;
-(Cadenza *) presenzaTerzaQuinta: (Chord *)tonalChord;
-(Cadenza *) accordiPartiLateOStrette;
-(Cadenza *) noIncrociInterniVoci;
@end

@interface Cadenza (RegoleTransizione)
-(Cadenza *) nonIncrocianoParti;
-(Cadenza *) noQuinteOttaveParallele: (Chord *)tonalChord;
-(Cadenza *) clausolaCantizans: (Chord *)tonalChord;
-(Cadenza *) noClausolaFuggitaSulleVociEsterne: (Chord *)tonalChord;
-(Cadenza *) noMovimentiEccessivi;
@end

@interface Cadenza (Destructors)
-(void) dealloc;
@end