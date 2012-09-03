//
//  Compositore.m
//  NoteGrid
//
//  Created by Guido Ronchetti on 2/2/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import "Compositore.h"

@implementation Compositore

@synthesize tonalChord;
@synthesize flagBassoFondamentale;
@synthesize flagTerzaEQuinta;
@synthesize flagPartiStretteLate;
@synthesize flagNoIncrociInterniAccordo;
@synthesize flagIncrociParti;
@synthesize flagQuinteOttaveParallele;
@synthesize flagNoMovimentiEccessivi;
@synthesize flagClausolaCantizans;
@synthesize flagNoClausolaFuggitaInBS;
@end

@implementation Compositore (Generatori)
-(Compositore *) initWithNVoices:(int)voices {
	self = [super init];
	if (self) {
		nVoices = voices;
	}
	return self;
}

-(void) fillWithSistemaTemperato: (InsiemeNote *) array {
	//Ciclo for creazione Sistema temperato
	noteArray = [[NSMutableArray alloc] initWithObjects:nil];
	//NSData *data;
	for (int i=0; i<=NUM_NOTES; i++) {
        /*
		data = [NSArchiver archivedDataWithRootObject:[[Note alloc] initWithNoteNumber:(MIN_MIDI_NOTE+i)]];
		[noteArray addObject:[NSUnarchiver unarchiveObjectWithData:data]];
		[array addNote:[noteArray objectAtIndex:i]];
         */
        Note *tmpNote = [[Note alloc] initWithNoteNumber:(MIN_MIDI_NOTE+i)];
        [noteArray addObject:[tmpNote retain]];
        [array addNote:[tmpNote retain]];
        [tmpNote release];
        tmpNote = nil;
	}
}
@end

@implementation Compositore (Limitatori)
-(InsiemeNote *) applyVoicesLimitsTo: (InsiemeNote *)array minValue: (int)min andMaxValue: (int)max andLabel: (NSString *)str {
	Note *tmpNote;
	InsiemeNote *tmpArray = [[InsiemeNote alloc] initWithName:str];
	for (int i=0; i<[array entries]; i++) {
		tmpNote = [array lookForNote: i];
		if ([[tmpNote getMidiNumber] intValue]>=min && [[tmpNote getMidiNumber] intValue]<=max) {
			[tmpArray addNote:tmpNote];
		}
	}
	[tmpArray sort];
	return tmpArray;
	//Libero gli oggetti temporanei
	[tmpArray release]; 
}

-(InsiemeNote *) applyTonalLimitsTo: (InsiemeNote *)array withGrades: (Chord *)chord andLabel: (NSString *)str {
	//Creo una nota e un Array temporanei in cui salvare i risultati
	Note *tmpNote;
	InsiemeNote *tmpArray = [[InsiemeNote alloc] initWithName:str];
	NSEnumerator *keyEnum = [chord keyEnumerator];
	NSString *key;
	if ([chord isEmpty] != TRUE) {
		//Ciclo for per esaminare l'array contenente i gradi della scala da selezionare
		while ((key = [keyEnum nextObject]) != nil) {
			//Ciclo for per analizzare l'array passato come argomento
			for (int i=0; i<[array entries]; i++) {
				//Definisco la nota da analizzare
				tmpNote = [array lookForNote:i];
				int numNote = [[tmpNote getMidiNumber] intValue];
				//Ciclo for per confrontare un numero midi in tutte le ottave
				for (int octave=0; octave<8; octave++) {
					if (numNote == ([[[chord getNoteFrom:key] getMidiNumber] intValue] + (OCTAVE_GAP * octave)))
						[tmpArray addNote:[array lookForNote:i]];
				}
			}
		}
		[tmpArray sort];
		return tmpArray;
	}	
	else
		return nil;
	//Libero gli oggetti temporanei
	[tmpArray release];
}
@end

@implementation Compositore (Combinatori)
-(int) combine: (int)n {
	//Inizializza le variabili
	int counter = n;
	int maxCombo = 1;
	//Calcola il numero di combinazioni che si producono
	for (int i=0; i<nVoices; i++) {
		maxCombo = maxCombo * ([[number objectAtIndex:i] intValue] + 1);
	}
	//Condizione di uscita dalle recursione
	if (counter == maxCombo) {
		return counter;
	}
	//Condizione di incremento per gli oggetti centrali
	if ([[counterNum objectAtIndex:(nVoices - 1)] intValue] == [[number objectAtIndex:(nVoices - 1)] intValue] 
		|| [[counterNum objectAtIndex:(nVoices - 1)] intValue] > [[number objectAtIndex:(nVoices - 1)] intValue]) {
		[counterNum	 replaceObjectAtIndex:(nVoices - 1) withObject:[NSNumber numberWithInt:0]];
		[counterNum replaceObjectAtIndex:(nVoices - 2) withObject:[NSNumber numberWithInt:([[counterNum objectAtIndex:(nVoices - 2)] intValue] + 1)]];
		for (int i=(nVoices - 2); i > 0 ; i--) {
			if ([[counterNum objectAtIndex:i] intValue] > [[number objectAtIndex:i] intValue]) {
				[counterNum replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
				[counterNum replaceObjectAtIndex:(i - 1) withObject:[NSNumber numberWithInt:([[counterNum objectAtIndex:(i - 1)] intValue] + 1)]];
			}
		}
		if ([[counterNum objectAtIndex:0] intValue] > [[number objectAtIndex:0] intValue]) {
			[counterNum replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:0]];
		}
		
		counter++;
		
		Chord *tmp = [[Chord alloc] initEmptyWithName:@"Combo Chord"];
		
		for (int n=0; n<nVoices; n++) {
			NSString *label;
			//Parte dipendente dalle voci prescelte
			if (n == 0)
				label = [NSString stringWithUTF8String:BASSO];
			if (n == 1)
				label = [NSString stringWithUTF8String:TENORE];
			if (n == 2)
				label = [NSString stringWithUTF8String:ALTO];
			if (n == 3)
				label = [NSString stringWithUTF8String:SOPRANO];
			
			[tmp addNote:[[inputArray objectAtIndex:n] lookForNote:[[counterNum objectAtIndex:n]intValue]] asGrade: label];
		}			
		
		[outputArray addObject:[tmp copy]];
		return [self combine:counter];
		[tmp release];
	}
	//Altrimenti
	else {
		[counterNum replaceObjectAtIndex:(nVoices - 1) withObject:[NSNumber numberWithInt:([[counterNum objectAtIndex:(nVoices - 1)] intValue] + 1)]];
		counter++;
		
		Chord *tmp = [[Chord alloc] initEmptyWithName:@"Combo Chord"];
		
		for (int n=0; n<nVoices; n++) {
			NSString *label;
			//Parte dipendente dalle voci prescelte
			if (n == 0)
				label = [NSString stringWithUTF8String:BASSO];
			if (n == 1)
				label = [NSString stringWithUTF8String:TENORE];
			if (n == 2)
				label = [NSString stringWithUTF8String:ALTO];
			if (n == 3)
				label = [NSString stringWithUTF8String:SOPRANO];
			if ([[inputArray objectAtIndex:n] lookForNote:[[counterNum objectAtIndex:n] intValue]]) {
				[tmp addNote:[[inputArray objectAtIndex:n] lookForNote:[[counterNum objectAtIndex:n] intValue]] asGrade: label];
			}
		}			
		
		[outputArray addObject:[tmp copy]];
		return [self combine:counter];
		[tmp release];
	}	
}
//Chiamata al metodo recursivo e inizializzazione variabili
-(NSMutableArray *) combineArraysIntoCadenze: (NSMutableArray *)fromInput andArray: (NSMutableArray *)toInput {
	//Inizializzo due array risultato per i due accordi della cadenza
	NSMutableArray *fromResult, *toResult;
	//Assegno le variabili
	inputArray = toInput;
	outputArray = [[NSMutableArray alloc] initWithObjects: nil];
	
	counterNum = [[NSMutableArray alloc] initWithObjects:nil];
	number = [[NSMutableArray alloc] initWithObjects:nil];
	//Inizializza i contatori
	for (int i=0; i<nVoices; i++) {
		[counterNum addObject:[NSNumber numberWithInt:0]];
		[number addObject:[NSNumber numberWithInt:([[inputArray objectAtIndex:i] entries] - 1)]];
	}
	
	[self combine:0];
	toResult = [outputArray copy];
	//Ripulisco le variabili
	[outputArray release];
	[counterNum release];
	[number release];
	
	inputArray = fromInput;
	outputArray = [[NSMutableArray alloc] initWithObjects: nil];
	counterNum = [[NSMutableArray alloc] initWithObjects:nil];
	number = [[NSMutableArray alloc] initWithObjects:nil];
	//Inizializza i contatori
	for (int i=0; i<nVoices; i++) {
		[counterNum addObject:[NSNumber numberWithInt:0]];
		[number addObject:[NSNumber numberWithInt:([[inputArray objectAtIndex:i] entries] - 1)]];
	}
	
	[self combine:0];
	fromResult = [outputArray copy];
	[outputArray release];
	[counterNum release];
	[number	 release];
	
	outputArray = [[NSMutableArray alloc] initWithObjects: nil];
	
	for (int i=0; i<[fromResult count]; i++) {
		for (int n=0; n<[toResult count]; n++) {
			Cadenza *tmp = [[Cadenza alloc] initWithChord:[fromResult objectAtIndex:i] andChord:[toResult objectAtIndex:n] andStringTypeDominante:nil andStringTypeTonica:nil];
			if (flagBassoFondamentale == TRUE && (tmp))
				tmp = [tmp ilBassoHaLaFondamentale:tonalChord];
			if (flagTerzaEQuinta == TRUE && (tmp))
				tmp = [tmp presenzaTerzaQuinta:tonalChord];
			if (flagPartiStretteLate == TRUE && (tmp))
				tmp = [tmp accordiPartiLateOStrette];
            if (flagNoIncrociInterniAccordo)
                tmp = [tmp noIncrociInterniVoci];
			if (flagIncrociParti == TRUE && (tmp))
				tmp = [tmp nonIncrocianoParti];
			if (flagQuinteOttaveParallele == TRUE && (tmp))
				tmp = [tmp noQuinteOttaveParallele:tonalChord];
            if (flagNoMovimentiEccessivi)
                tmp = [tmp noMovimentiEccessivi];
            if (flagNoClausolaFuggitaInBS)
                tmp = [tmp noClausolaFuggitaSulleVociEsterne:tonalChord];
            if (flagClausolaCantizans)
                tmp = [tmp clausolaCantizans:tonalChord];
			if (tmp) {
				[outputArray addObject:[tmp copy]];
			}
			[tmp release];		
		}
	}
	return [outputArray copy];
	[outputArray release];
}
@end

@implementation Compositore (Verificatore)
-(id) verifyObject: (id)objct forCondition: (SEL)condition {
	if ([objct respondsToSelector:condition] == YES) {
		return [objct performSelector:condition];		
	}
	else {
		return objct;
	}
}
@end

@implementation Compositore (Destructors)
-(void) dealloc {
	[noteArray release];
	[tonalChord release];
	[super dealloc];
}
@end