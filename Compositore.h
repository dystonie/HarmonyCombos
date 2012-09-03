//
//  Compositore.h
//  NoteGrid
//
//  Created by Guido Ronchetti on 2/2/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "GlobalVariables.h"
#import "Cadenza.h"
#import "InsiemeNote.h"

@interface Compositore : NSObject {
	int voiceCount;
	//Variabili che determinano l'applicazione delle limitazioni
	BOOL flagBassoFondamentale;
	BOOL flagTerzaEQuinta;
	BOOL flagPartiStretteLate;
    BOOL flagNoIncrociInterniAccordo;
	BOOL flagIncrociParti;
	BOOL flagQuinteOttaveParallele;
    BOOL flagNoMovimentiEccessivi;
    BOOL flagClausolaCantizans;
    BOOL flagNoClausolaFuggitaInBS;
	//Accodo di tonalita
	@public Chord *tonalChord;
	NSMutableArray *noteArray;
	//Variabili coinvolte nell'algoritmo di combinazione:
	int nVoices;
	NSMutableArray *inputArray, *outputArray;
	NSMutableArray *counterNum, *number;
}

@property (assign, readwrite) Chord *tonalChord;
@property BOOL flagBassoFondamentale;
@property BOOL flagTerzaEQuinta;
@property BOOL flagPartiStretteLate;
@property BOOL flagNoIncrociInterniAccordo;
@property BOOL flagIncrociParti;
@property BOOL flagQuinteOttaveParallele;
@property BOOL flagNoMovimentiEccessivi;
@property BOOL flagClausolaCantizans;
@property BOOL flagNoClausolaFuggitaInBS;
@end

@interface Compositore (Generatori)
-(Compositore *) initWithNVoices: (int)voices;
-(void) fillWithSistemaTemperato: (InsiemeNote *) array;
@end

@interface Compositore (Limitatori)
-(InsiemeNote *) applyVoicesLimitsTo: (InsiemeNote *)array minValue: (int)min andMaxValue: (int)max andLabel: (NSString *)str;
-(InsiemeNote *) applyTonalLimitsTo: (InsiemeNote *)array withGrades: (Chord *)chord andLabel: (NSString *)str;
@end

@interface Compositore (Combinatori)
-(int) combine:(int)n;
-(NSMutableArray *) combineArraysIntoCadenze: (NSMutableArray *)fromInput andArray: (NSMutableArray *)toInput;
@end

@interface Compositore (Verificatore)
-(id) verifyObject: (id)objct forCondition: (SEL)condition;
@end

@interface Compositore (Destructors)
-(void) dealloc;
@end