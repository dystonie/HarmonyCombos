//
//  Cadenza.m
//  NoteGrid
//
//  Created by Guido Ronchetti on 3/1/11.
//  Copyright 2011 Dysto Productions. All rights reserved.
//
#import "Cadenza.h"
//Debug
//#define DEBUGX

@implementation Cadenza

@synthesize typeOfPartiDominante;
@synthesize typeOfPartiTonica;

-(Cadenza *) copyWithZone:(NSZone *)zone {
	Cadenza *newCadenza = [[Cadenza allocWithZone:zone] initWithChord: fromChord andChord: toChord andStringTypeDominante:typeOfPartiDominante andStringTypeTonica:typeOfPartiTonica];
	return newCadenza;
}

-(void) encodeWithCoder: (NSCoder *)encoder {
	if ([encoder allowsKeyedCoding]) {
		[encoder encodeObject:fromChord forKey:@"From_Chord"];
		[encoder encodeObject:toChord forKey:@"To_Chord"];
        [encoder encodeObject:typeOfPartiDominante forKey:@"Type_Of_Dominante"];
        [encoder encodeObject:typeOfPartiTonica forKey:@"Type_Of_Tonica"];
	}
	else {
		[encoder encodeObject:fromChord];
		[encoder encodeObject:toChord];
        [encoder encodeObject:typeOfPartiDominante];
        [encoder encodeObject:typeOfPartiTonica];
	}
}

-(id) initWithCoder: (NSCoder *)decoder {
	if ([decoder allowsKeyedCoding]) {
		fromChord = [[decoder decodeObjectForKey:@"From_Chord"] retain];
		toChord = [[decoder decodeObjectForKey:@"To_Chord"] retain];
        typeOfPartiDominante = [[decoder decodeObjectForKey:@"Type_Of_Dominante"] retain];
        typeOfPartiTonica = [[decoder decodeObjectForKey:@"Type_Of_Tonica"] retain];
	}
	else {
		fromChord = [[decoder decodeObject] retain];
		toChord = [[decoder decodeObject] retain];
        typeOfPartiDominante = [[decoder decodeObject] retain];
        typeOfPartiTonica = [[decoder decodeObject] retain];
	}
	return self;
}

-(BOOL)isEqualTo:(Cadenza *)aCadenza {
    if ([fromChord isEqualTo:[aCadenza getFromChord]] == YES && [toChord isEqualTo:[aCadenza getToChord]] == YES)
        return YES;
    else
        return NO;
}

@end

@implementation Cadenza (Setters)
-(Cadenza *) initWithChord: (Chord *)fromCh andChord: (Chord *)toCh andStringTypeDominante:(NSString *)aStrA andStringTypeTonica:(NSString *)aStrB{
	self = [super init];
	if (self) {
		fromChord = fromCh;
		toChord = toCh;
        if (aStrA && aStrB) {
            typeOfPartiDominante = [aStrA retain];
            typeOfPartiTonica = [aStrB retain];
        }
        else {
            typeOfPartiDominante = @"";
            typeOfPartiTonica = @"";
        }
	}
	return self;
}
@end

@implementation Cadenza (Getters)
-(Chord *) getFromChord {
	return fromChord;
}

-(Chord *) getToChord {
	return toChord;
}
@end

@implementation Cadenza (RegoleStatiche)
-(Cadenza *) ilBassoHaLaFondamentale: (Chord *)tonalChord {
	BOOL resultD, resultT; 
	Note *bassoD, *bassoT;
	int refT, refD;
	bassoD = [fromChord getNoteFrom:[NSString stringWithUTF8String:BASSO]];
	bassoT = [toChord getNoteFrom:[NSString stringWithUTF8String:BASSO]];
	refT = [[[tonalChord getNoteFrom:[NSString stringWithUTF8String:TONICA]] getMidiNumber] intValue];
	refD = refT + INT_QUINTA_G;	
	for (int octave=0; octave<8; octave++) {
		if ([[bassoT getMidiNumber] intValue] == (refT + (OCTAVE_GAP * octave)))
			resultT = TRUE;
		if ([[bassoD getMidiNumber] intValue] == (refD + (OCTAVE_GAP * octave)))
			resultD = TRUE;
	}
	if ((resultT == TRUE) && (resultD == TRUE)) {
		return self;
	}
	else {
		return nil;
	}
}

-(Cadenza *) presenzaTerzaQuinta: (Chord *)tonalChord  {
	int refTerzaT, refTerzaD, refQuintaT, refQuintaD;
	//Inizializzo dei contatori per tener traccia di quante terze e quinte vengono trovate
	int terzeCountT = 0, quinteCountT = 0, terzeCountD = 0, quinteCountD = 0;
	refTerzaT = [[[tonalChord getNoteFrom:[NSString stringWithUTF8String:TERZA]] getMidiNumber] intValue];
	refQuintaT = [[[tonalChord getNoteFrom:[NSString stringWithUTF8String:QUINTA]] getMidiNumber] intValue];
	refTerzaD = refTerzaT + INT_QUINTA_G;
	refQuintaD = refQuintaT + INT_QUINTA_G;
	for (int octave=0; octave<8; octave++) {
		NSEnumerator *keyEnumT = [toChord keyEnumerator];
		NSEnumerator *keyEnumD = [fromChord keyEnumerator];
		NSString *keyT;
		NSString *keyD;
		
		while ((keyT = [keyEnumT nextObject]) != nil) {
			if ([[[toChord getNoteFrom:keyT] getMidiNumber] intValue] == (refTerzaT + (OCTAVE_GAP * octave))) {
				terzeCountT++;
			}
			if ([[[toChord getNoteFrom:keyT] getMidiNumber] intValue] == (refQuintaT + (OCTAVE_GAP * octave))) {
				quinteCountT++;
			}
		}
		while ((keyD = [keyEnumD nextObject]) != nil) {
			if ([[[fromChord getNoteFrom:keyD] getMidiNumber] intValue] == (refTerzaD + (OCTAVE_GAP * octave))) {
				terzeCountD++;
			}
			if ([[[fromChord getNoteFrom:keyD] getMidiNumber] intValue] == (refQuintaD + (OCTAVE_GAP * octave))) {
				quinteCountD++;
			}
		}
		[keyT release];
		[keyD release];
	}
	if	((terzeCountT == N_MAX_TERZE_ACC_T) && (quinteCountT == N_MAX_QUINTE_ACC_T) && (terzeCountD == N_MAX_TERZE_ACC_D) && (quinteCountD == N_MAX_QUINTE_ACC_D)) {
		return self;
	}
	else {
		return nil;
	}
}

-(Cadenza *) accordiPartiLateOStrette {
	BOOL isDominanteStretta = FALSE;
    BOOL isDominanteLata = FALSE;
    BOOL isTonicaStretta = FALSE;
    BOOL isTonicaLata = FALSE;
	//Considero tutte le cadenze composte da accordi o a parti late o a parti sterette
	int noteNumberBassoD, noteNumberTenoreD, noteNumberAltoD, noteNumberSopranoD;
	int noteNumberBassoT, noteNumberTenoreT, noteNumberAltoT, noteNumberSopranoT;
    //Le note degli accordi Dominante
    Note *tmpNoteDBasso = [fromChord getNoteFrom:[NSString stringWithUTF8String:BASSO]];
    Note *tmpNoteDTenore = [fromChord getNoteFrom:[NSString stringWithUTF8String:TENORE]];
    Note *tmpNoteDAlto = [fromChord getNoteFrom:[NSString stringWithUTF8String:ALTO]];
    Note *tmpNoteDSoprano = [fromChord getNoteFrom:[NSString stringWithUTF8String:SOPRANO]];
    //Le note degli accordi Tonica
    Note *tmpNoteTBasso = [toChord getNoteFrom:[NSString stringWithUTF8String:BASSO]];
    Note *tmpNoteTTenore = [toChord getNoteFrom:[NSString stringWithUTF8String:TENORE]];
    Note *tmpNoteTAlto = [toChord getNoteFrom:[NSString stringWithUTF8String:ALTO]];
    Note *tmpNoteTSoprano = [toChord getNoteFrom:[NSString stringWithUTF8String:SOPRANO]];
	//Determino il midi number delle voci della dominante
	noteNumberBassoD = [[tmpNoteDBasso getMidiNumber] intValue];
	noteNumberTenoreD = [[tmpNoteDTenore getMidiNumber] intValue];
	noteNumberAltoD = [[tmpNoteDAlto getMidiNumber] intValue];
	noteNumberSopranoD = [[tmpNoteDSoprano getMidiNumber] intValue];
	//Determino il midi number delle voci della tonica
	noteNumberBassoT = [[tmpNoteTBasso getMidiNumber] intValue];
	noteNumberTenoreT = [[tmpNoteTTenore getMidiNumber] intValue];
	noteNumberAltoT = [[tmpNoteTAlto getMidiNumber] intValue];
	noteNumberSopranoT = [[tmpNoteTSoprano getMidiNumber] intValue];
    //Genero le variabili per verificare la suddivisione delle note all'interno dei gruppi stretti o lati
    //Dominante    
    NSString *noteTypeDBasso = [[tmpNoteDBasso getNoteName] substringToIndex:1];
    NSString *noteTypeDTenore = [[tmpNoteDTenore getNoteName] substringToIndex:1];
    NSString *noteTypeDAlto = [[tmpNoteDAlto getNoteName] substringToIndex:1];
    NSString *noteTypeDSoprano = [[tmpNoteDSoprano getNoteName] substringToIndex:1];
    //Tonica
    NSString *noteTypeTBasso = [[tmpNoteTBasso getNoteName] substringToIndex:1];
    NSString *noteTypeTTenore = [[tmpNoteTTenore getNoteName] substringToIndex:1];
    NSString *noteTypeTAlto = [[tmpNoteTAlto getNoteName] substringToIndex:1];
    NSString *noteTypeTSoprano = [[tmpNoteTSoprano getNoteName] substringToIndex:1];
	//Verifico la distanza tra le voci di dominante
	//Considero come parti strette una distanza massima tra soprano, alto e tenore di una quarta giusta, oltre parti late
	int sa_D, at_D, tb_D;
	sa_D = abs(noteNumberSopranoD - noteNumberAltoD);
	at_D = abs(noteNumberAltoD - noteNumberTenoreD);
	tb_D = abs(noteNumberTenoreD - noteNumberBassoD);
	//
    //  Dominante Stretta
    //
    if (sa_D < PARTI_MIN && at_D < PARTI_MIN && tb_D < PARTI_MIN) {
        isDominanteStretta = TRUE;
        isDominanteLata = FALSE;
        typeOfPartiDominante = GET_STR(@"str.dominante.stretteA");
    }
    else if (sa_D < PARTI_MIN && at_D < PARTI_MIN && tb_D >= PARTI_MIN 
             && ([noteTypeDBasso isEqualToString:noteTypeDTenore] == YES || [noteTypeDBasso isEqualToString:noteTypeDAlto] == YES || [noteTypeDBasso isEqualToString:noteTypeDSoprano] == YES)) {
        isDominanteStretta = TRUE;
        isDominanteLata = FALSE;
        typeOfPartiDominante = GET_STR(@"str.dominante.stretteB");
    }
    //  
    //  Dominante Lata:
    //
	else if (sa_D >= PARTI_MIN && at_D >= PARTI_MIN && sa_D < PARTI_MAX && at_D < PARTI_MAX && tb_D < PARTI_MAX) {
        isDominanteLata = TRUE;
        isDominanteStretta = FALSE;
        typeOfPartiDominante = GET_STR(@"str.dominante.late");
    }
    else if (sa_D >= PARTI_MIN && at_D >= PARTI_MIN && sa_D < PARTI_MAX && at_D < PARTI_MAX && tb_D >= PARTI_MAX 
             && ([noteTypeDBasso isEqualToString:noteTypeDTenore] == YES || [noteTypeDBasso isEqualToString:noteTypeDAlto] == YES || [noteTypeDBasso isEqualToString:noteTypeDSoprano] == YES)) {
        isDominanteLata = TRUE;
        isDominanteStretta = FALSE;
        typeOfPartiDominante = GET_STR(@"str.dominante.late");
    }
    else if (tb_D >= PARTI_MIN && at_D >= PARTI_MIN && tb_D < PARTI_MAX && at_D < PARTI_MAX && sa_D < PARTI_MAX) {
        isDominanteLata = TRUE;
        isDominanteStretta = FALSE;
        typeOfPartiDominante = GET_STR(@"str.dominante.late");
    }
    else {
        isDominanteLata = FALSE;
        isDominanteStretta = FALSE;
        typeOfPartiDominante = GET_STR(@"str.dominante.any");
    }
    //
	//  Verifico la distanza tra le voci di tonica
	int sa_T, at_T, tb_T;
	sa_T = abs(noteNumberSopranoT - noteNumberAltoT);
	at_T = abs(noteNumberAltoT - noteNumberTenoreT);
	tb_T = abs(noteNumberTenoreT - noteNumberBassoT);
	//
    //  Tonica Stretta
    //
    if (sa_T < PARTI_MIN && at_T < PARTI_MIN && tb_T < PARTI_MIN) {
        isTonicaStretta = TRUE;
        isTonicaLata = FALSE;
        typeOfPartiTonica = GET_STR(@"str.tonica.stretteA");
    }
    else if (sa_T < PARTI_MIN && at_T < PARTI_MIN && tb_T >= PARTI_MIN 
             && ([noteTypeTBasso isEqualToString:noteTypeTTenore] == YES || [noteTypeTBasso isEqualToString:noteTypeTAlto] == YES || [noteTypeTBasso isEqualToString:noteTypeTSoprano] == YES)) {
        isTonicaStretta = TRUE;
        isTonicaLata = FALSE;
        typeOfPartiTonica = GET_STR(@"str.tonica.stretteB");
    }
    else if (tb_T < PARTI_MIN && at_T < PARTI_MIN && sa_T < PARTI_MIN) {
        isTonicaStretta = TRUE;
        isTonicaLata = FALSE;
        typeOfPartiTonica = GET_STR(@"str.tonica.stretteA");
    }
    //
    //  Tonica Lata:
	//
    else if (sa_T >= PARTI_MIN && at_T >= PARTI_MIN && sa_T < PARTI_MAX && at_T < PARTI_MAX && tb_T < PARTI_MAX) {
        isTonicaLata = TRUE;
        isTonicaStretta = FALSE;
        typeOfPartiTonica = GET_STR(@"str.tonica.late");
    }
    else if (sa_T >= PARTI_MIN && at_T >= PARTI_MIN && sa_T < PARTI_MAX && at_T < PARTI_MAX && tb_T >= PARTI_MAX 
             && ([noteTypeTBasso isEqualToString:noteTypeTTenore] == YES || [noteTypeTBasso isEqualToString:noteTypeTAlto] == YES || [noteTypeTBasso isEqualToString:noteTypeTSoprano] == YES)) {
        isTonicaLata = TRUE;
        isTonicaStretta = FALSE;
        typeOfPartiTonica = GET_STR(@"str.tonica.late");
    }
    else if (tb_T >= PARTI_MIN && at_T >= PARTI_MIN && tb_T < PARTI_MAX && at_T < PARTI_MAX && sa_T < PARTI_MAX) {
        isTonicaLata = TRUE;
        isTonicaStretta = FALSE;
        typeOfPartiTonica = GET_STR(@"str.tonica.late");
    }
    else {
        isTonicaLata = FALSE;
        isTonicaStretta = FALSE;
        typeOfPartiTonica = GET_STR(@"str.tonica.any");
    }
    //Release con Garbage Collector
    //Dominante
    [tmpNoteDBasso release];
    tmpNoteDBasso = nil;
    [tmpNoteDTenore release];
    tmpNoteDTenore = nil;
    [tmpNoteDAlto release];
    tmpNoteDAlto = nil;
    [tmpNoteDSoprano release];
    tmpNoteDSoprano = nil;
    [noteTypeDBasso release];
    noteTypeDBasso = nil;
    [noteTypeDTenore release];
    noteTypeDTenore = nil;
    [noteTypeDAlto release];
    noteTypeDAlto = nil;
    [noteTypeDSoprano release];
    noteTypeDSoprano = nil;
    //Tonica
    [tmpNoteTBasso release];
    tmpNoteTBasso = nil;
    [tmpNoteTTenore release];
    tmpNoteTTenore = nil;
    [tmpNoteTAlto release];
    tmpNoteTAlto = nil;
    [tmpNoteTSoprano release];
    tmpNoteTSoprano = nil;
    [noteTypeTBasso release];
    noteTypeTBasso = nil;
    [noteTypeTTenore release];
    noteTypeTTenore = nil;
    [noteTypeTAlto release];
    noteTypeTAlto = nil;
    [noteTypeTSoprano release];
    noteTypeTSoprano = nil;
	//Verifico lo stato degli accordi in funzione della definizione di costante
#ifdef HAS_TO_BE_BOTH_PARTS_OPEN_OR_CLOSED
    if ((isDominanteLata == TRUE) && (isTonicaLata == TRUE)) {
        return self;
	}
	if ((isDominanteStretta == TRUE) && (isTonicaStretta == TRUE)) {
        return self;
	}
	else {
        return nil;
	}
    //Se la costante non è definita tengo buono sia il caso siano entrambe late o stratte che siano miste
#else
    if (((isDominanteLata == TRUE) && (isTonicaLata == TRUE)) || ((isDominanteLata == TRUE) && (isTonicaStretta == TRUE))) {
		return self;
	}
	if (((isDominanteStretta == TRUE) && (isTonicaStretta == TRUE)) || ((isDominanteStretta == TRUE) && (isTonicaLata == TRUE))) {
		return self;
	}
	else {
		return nil;
	}
#endif
}

-(Cadenza *) noIncrociInterniVoci {
    BOOL tonicaOK, dominanteOK;
    int sopranoMidiValueT = [[[toChord getNoteFrom:[NSString stringWithUTF8String:SOPRANO]] getMidiNumber] intValue];
	int altoMidiValueT = [[[toChord getNoteFrom:[NSString stringWithUTF8String:ALTO]] getMidiNumber] intValue];
	int tenoreMidiValueT = [[[toChord getNoteFrom:[NSString stringWithUTF8String:TENORE]] getMidiNumber] intValue];
	int bassoMidiValueT = [[[toChord getNoteFrom:[NSString stringWithUTF8String:BASSO]] getMidiNumber] intValue];
	int sopranoMidiValueD = [[[fromChord getNoteFrom:[NSString stringWithUTF8String:SOPRANO]] getMidiNumber] intValue];
	int altoMidiValueD = [[[fromChord getNoteFrom:[NSString stringWithUTF8String:ALTO]] getMidiNumber] intValue];
	int tenoreMidiValueD = [[[fromChord getNoteFrom:[NSString stringWithUTF8String:TENORE]] getMidiNumber] intValue];
	int bassoMidiValueD = [[[fromChord getNoteFrom:[NSString stringWithUTF8String:BASSO]] getMidiNumber] intValue];
    
    if ((sopranoMidiValueD > (altoMidiValueD - CAN_BE_THE_SAME)) && (altoMidiValueD > (tenoreMidiValueD - CAN_BE_THE_SAME)) 
        && (tenoreMidiValueD > (bassoMidiValueD - CAN_BE_THE_SAME))) {
        dominanteOK = TRUE;
    }
    else
        dominanteOK = FALSE;
    if ((sopranoMidiValueT > (altoMidiValueT - CAN_BE_THE_SAME)) && (altoMidiValueT > (tenoreMidiValueT - CAN_BE_THE_SAME)) 
        && (tenoreMidiValueT > (bassoMidiValueT - CAN_BE_THE_SAME))) {
        tonicaOK = TRUE;
    }
    else
        tonicaOK = FALSE;
    
    if (tonicaOK == TRUE && dominanteOK == TRUE) {
        return self;
    }
    else
        return nil;
}
@end

@implementation Cadenza (RegoleTransizione)
-(Cadenza *) nonIncrocianoParti {
	BOOL sopranoOK, altoOK, tenoreOK;
	int sopranoMidiValueT = [[[toChord getNoteFrom:[NSString stringWithUTF8String:SOPRANO]] getMidiNumber] intValue];
	int altoMidiValueT = [[[toChord getNoteFrom:[NSString stringWithUTF8String:ALTO]] getMidiNumber] intValue];
	int tenoreMidiValueT = [[[toChord getNoteFrom:[NSString stringWithUTF8String:TENORE]] getMidiNumber] intValue];
	int bassoMidiValueT = [[[toChord getNoteFrom:[NSString stringWithUTF8String:BASSO]] getMidiNumber] intValue];
	int sopranoMidiValueD = [[[fromChord getNoteFrom:[NSString stringWithUTF8String:SOPRANO]] getMidiNumber] intValue];
	int altoMidiValueD = [[[fromChord getNoteFrom:[NSString stringWithUTF8String:ALTO]] getMidiNumber] intValue];
	int tenoreMidiValueD = [[[fromChord getNoteFrom:[NSString stringWithUTF8String:TENORE]] getMidiNumber] intValue];
	int bassoMidiValueD = [[[fromChord getNoteFrom:[NSString stringWithUTF8String:BASSO]] getMidiNumber] intValue];
	
	if ((sopranoMidiValueT > (altoMidiValueT - CAN_BE_THE_SAME)) && (sopranoMidiValueD > (altoMidiValueD -CAN_BE_THE_SAME))) {
		sopranoOK = TRUE;
	}
	if ((altoMidiValueT > (tenoreMidiValueT - CAN_BE_THE_SAME)) && (altoMidiValueD > (tenoreMidiValueD -CAN_BE_THE_SAME))){
		altoOK = TRUE;
	}
	if ((tenoreMidiValueT > (bassoMidiValueT - CAN_BE_THE_SAME)) && (tenoreMidiValueD > (bassoMidiValueD -CAN_BE_THE_SAME))) {
		tenoreOK = TRUE;
	}
	
	if ((sopranoOK == TRUE) && (altoOK == TRUE) && (tenoreOK == TRUE)) {
		return self;
	}
	else {
		return nil;
	}
}

-(Cadenza *) noQuinteOttaveParallele: (Chord *)tonalChord {
	BOOL resultQuinta, resultOttava;
	int refQuintaT, refQuintaD, refOttavaT, refOttavaD;
	//Inizializzo dei puntatori per tener traccia delle quinte e ottave che vengono trovate
	Note *quintaT, *ottavaT, *quintaD, *ottavaD;
	NSMutableArray *quinteArrayT, *ottaveArrayT, *quinteArrayD, *ottaveArrayD;
	quinteArrayT = [[NSMutableArray alloc] initWithObjects:nil];
	ottaveArrayT = [[NSMutableArray alloc] initWithObjects:nil];
	quinteArrayD = [[NSMutableArray alloc] initWithObjects:nil];
	ottaveArrayD = [[NSMutableArray alloc] initWithObjects:nil];
	refQuintaT = [[[tonalChord getNoteFrom:[NSString stringWithUTF8String:QUINTA]] getMidiNumber] intValue];
	refOttavaT = [[[tonalChord getNoteFrom:[NSString stringWithUTF8String:TONICA]] getMidiNumber] intValue];
	refQuintaD = refQuintaT + INT_QUINTA_G;
	refOttavaD = refOttavaT + INT_QUINTA_G;	
	for (int octave=0; octave<8; octave++) {
		NSData *data;
		NSEnumerator *keyEnumT = [toChord keyEnumerator];
		NSEnumerator *keyEnumD = [fromChord keyEnumerator];
		NSString *keyT;
		NSString *keyD;
		
		while ((keyT = [keyEnumT nextObject]) != nil) {
			if ([[[toChord getNoteFrom:keyT] getMidiNumber] intValue] == (refQuintaT + (OCTAVE_GAP * octave))) {
				quintaT = [toChord getNoteFrom:keyT];
				data = [NSArchiver archivedDataWithRootObject:quintaT];
				[quinteArrayT addObject:[NSUnarchiver unarchiveObjectWithData:data]];
			}
			if ([[[toChord getNoteFrom:keyT] getMidiNumber] intValue] == (refOttavaT + (OCTAVE_GAP * octave))) {
				ottavaT = [toChord getNoteFrom:keyT];
				data = [NSArchiver archivedDataWithRootObject:ottavaT];
				[ottaveArrayT addObject:[NSUnarchiver unarchiveObjectWithData:data]];
			}
		}
		while ((keyD = [keyEnumD nextObject]) != nil) {
			if ([[[fromChord getNoteFrom:keyD] getMidiNumber] intValue] == (refQuintaD + (OCTAVE_GAP * octave))) {
				quintaD = [toChord getNoteFrom:keyD];
				data = [NSArchiver archivedDataWithRootObject:quintaD];
				[quinteArrayD addObject:[NSUnarchiver unarchiveObjectWithData:data]];
				
			}
			if ([[[fromChord getNoteFrom:keyD] getMidiNumber] intValue] == (refOttavaD + (OCTAVE_GAP * octave))) {
				ottavaD = [toChord getNoteFrom:keyD];
				data = [NSArchiver archivedDataWithRootObject:ottavaD];
				[ottaveArrayD addObject:[NSUnarchiver unarchiveObjectWithData:data]];
			}
		}
		
		[keyT release];
		[keyD release];
	}
	
	int minCount;
	if (([ottaveArrayT count] > 1) && ([ottaveArrayD count] > 1)) {
		if ([ottaveArrayT count] < [ottaveArrayD count]) {
			minCount = [ottaveArrayT count];
		}
		else {
			minCount = [ottaveArrayD count];
		}
		int parallelism = 0;
		for (int i=0; i<minCount; i++) {
			int midiValueOttavaT = [[[ottaveArrayT objectAtIndex:i] getMidiNumber] intValue];
			int midiValueOttavaD = [[[ottaveArrayD objectAtIndex:i] getMidiNumber] intValue];
			parallelism = (midiValueOttavaT - (midiValueOttavaD) - parallelism);
		}
		if (parallelism == 0) {
			resultOttava = FALSE;
		}
		else {
			resultOttava = TRUE;
		}
	}
	if (([quinteArrayT count] > 0) && ([quinteArrayD count] > 0)) {
		if ([quinteArrayT count] < [quinteArrayD count]) {
			minCount = [quinteArrayT count];
		}
		else {
			minCount = [quinteArrayD count];
		}
		int parallelism = 0;
		for (int i=0; i<minCount; i++) {
			int midiValueQuintaT = [[[quinteArrayT objectAtIndex:i] getMidiNumber] intValue];
			int midiValueQuintaD = [[[quinteArrayD objectAtIndex:i] getMidiNumber] intValue];
			parallelism = (midiValueQuintaT - (midiValueQuintaD) - parallelism);
		}
		if (parallelism == 0) {
			resultQuinta = FALSE;
		}
		else {
			resultQuinta = TRUE;
		}
	}
	
	if ((resultOttava == FALSE) || (resultQuinta == FALSE)) {
		return nil;
	}
	if ((resultOttava == FALSE) && (resultQuinta == FALSE)) {
		return nil;
	}
	else {
		return self;
	}
	[quinteArrayT release];
	[quinteArrayD release];
	[ottaveArrayT release];
	[ottaveArrayD release];
}
//Verifica le parentesi nelle condizioni del ciclo for
-(Cadenza *) clausolaCantizans:(Chord *)tonalChord {
	
    Note *tonica = [toChord getNoteFrom:[NSString stringWithUTF8String:SOPRANO]];
    Note *dominante = [fromChord getNoteFrom:[NSString stringWithUTF8String:SOPRANO]];
    
    //Recupero dei valori MIDI delle note
    NSInteger sopranoMidiValueT = [[tonica getMidiNumber] intValue];
	NSInteger sopranoMidiValueD = [[dominante getMidiNumber] intValue];
    
    //Controllo Soprano
    NSInteger sopranoDelta = sopranoMidiValueD - sopranoMidiValueT;

    #ifdef DEBUGX
    NSLog(@"%s - %ld",__FUNCTION__, sopranoDelta);
    #endif
    
    NSInteger refOttavaT = [[[tonalChord getNoteFrom:[NSString stringWithUTF8String:TONICA]] getMidiNumber] intValue];
	NSInteger refTerzaD = ([[[tonalChord getNoteFrom:[NSString stringWithUTF8String:TERZA]] getMidiNumber] intValue]+ INT_QUINTA_G);
	
    NSInteger foundedCorrespondanceT = 0;
    NSInteger foundedCorrespondanceD = 0;
    
    for (int octave=0; octave<8; octave++) {
		
        if (sopranoMidiValueD == (refTerzaD + (OCTAVE_GAP * octave)))
            foundedCorrespondanceD++;
        
        if (sopranoMidiValueT == (refOttavaT + (OCTAVE_GAP * octave)))
            foundedCorrespondanceT++;
    
    }
    
    #ifdef DEBUGX
    NSLog(@"%s - T:%ld D:%ld",__FUNCTION__, foundedCorrespondanceT, foundedCorrespondanceD);
    #endif
    
    //Check finale che da 7 grado passi a 8 (-1 differenza)
    if (sopranoDelta == DISTANZA_CANTIZANS && foundedCorrespondanceT > 0 && foundedCorrespondanceD > 0)
        return self;
    else
        return nil;
}

-(Cadenza *) noClausolaFuggitaSulleVociEsterne: (Chord *)tonalChord {
    
    Note *tonicaSoprano = [toChord getNoteFrom:[NSString stringWithUTF8String:SOPRANO]];
    Note *dominanteSoprano = [fromChord getNoteFrom:[NSString stringWithUTF8String:SOPRANO]];
    Note *tonicaBasso = [toChord getNoteFrom:[NSString stringWithUTF8String:BASSO]];
    Note *dominanteBasso = [fromChord getNoteFrom:[NSString stringWithUTF8String:BASSO]];
    
    //Recupero dei valori MIDI delle note
    NSInteger sopranoMidiValueT = [[tonicaSoprano getMidiNumber] intValue];
	NSInteger sopranoMidiValueD = [[dominanteSoprano getMidiNumber] intValue];
    NSInteger bassoMidiValueT = [[tonicaBasso getMidiNumber] intValue];
	NSInteger bassoMidiValueD = [[dominanteBasso getMidiNumber] intValue];
    
    //Controllo Soprano
    NSInteger sopranoDelta = sopranoMidiValueD - sopranoMidiValueT;
    NSInteger bassoDelta = bassoMidiValueD - bassoMidiValueT;
    
    NSInteger refQuintaT = [[[tonalChord getNoteFrom:[NSString stringWithUTF8String:QUINTA]] getMidiNumber] intValue];
	NSInteger refTerzaD = ([[[tonalChord getNoteFrom:[NSString stringWithUTF8String:TERZA]] getMidiNumber] intValue]+ INT_QUINTA_G);
	
    NSInteger foundedCorrespondanceST = 0;
    NSInteger foundedCorrespondanceSD = 0;
    NSInteger foundedCorrespondanceBT = 0;
    NSInteger foundedCorrespondanceBD = 0;
    
    for (int octave=0; octave<8; octave++) {
		
        if (sopranoMidiValueD == (refTerzaD + (OCTAVE_GAP * octave)))
            foundedCorrespondanceSD++;
        
        if (sopranoMidiValueT == (refQuintaT + (OCTAVE_GAP * octave)))
            foundedCorrespondanceST++;
        
        if (bassoMidiValueD == (refTerzaD + (OCTAVE_GAP * octave)))
            foundedCorrespondanceBD++;
        
        if (bassoMidiValueT == (refQuintaT + (OCTAVE_GAP * octave)))
            foundedCorrespondanceBT++;
        
    }
    
    #ifdef DEBUGX
    NSLog(@"%s - %ld ref: %d\nSoprano>T:%ld D:%ld Basso>T:%ld D:%ld",__FUNCTION__, sopranoDelta, INT_TERZA_M, foundedCorrespondanceST, foundedCorrespondanceSD, 
          foundedCorrespondanceBT, foundedCorrespondanceBD);
    #endif
    
    //Check che non ci siano salti 7 5 sulla voce del soprano o basso
    if (abs(sopranoDelta) == INT_TERZA_M && foundedCorrespondanceST > 0 && foundedCorrespondanceSD > 0)
        return nil;
    else if (abs(bassoDelta) == INT_TERZA_M && foundedCorrespondanceBT > 0 && foundedCorrespondanceBD > 0)
        return nil;
    else
        return self;
}

-(Cadenza *) noMovimentiEccessivi {
    BOOL bassoOK, tenoreOK, altoOK, sopranoOK;
    int sopranoMidiValueT = [[[toChord getNoteFrom:[NSString stringWithUTF8String:SOPRANO]] getMidiNumber] intValue];
	int altoMidiValueT = [[[toChord getNoteFrom:[NSString stringWithUTF8String:ALTO]] getMidiNumber] intValue];
	int tenoreMidiValueT = [[[toChord getNoteFrom:[NSString stringWithUTF8String:TENORE]] getMidiNumber] intValue];
	int bassoMidiValueT = [[[toChord getNoteFrom:[NSString stringWithUTF8String:BASSO]] getMidiNumber] intValue];
	int sopranoMidiValueD = [[[fromChord getNoteFrom:[NSString stringWithUTF8String:SOPRANO]] getMidiNumber] intValue];
	int altoMidiValueD = [[[fromChord getNoteFrom:[NSString stringWithUTF8String:ALTO]] getMidiNumber] intValue];
	int tenoreMidiValueD = [[[fromChord getNoteFrom:[NSString stringWithUTF8String:TENORE]] getMidiNumber] intValue];
	int bassoMidiValueD = [[[fromChord getNoteFrom:[NSString stringWithUTF8String:BASSO]] getMidiNumber] intValue];
    //Verifica che tra una accordo e l'altro le voci non effettuino un salto maggiore di SALTO_MAX
    if (abs(bassoMidiValueD - bassoMidiValueT) <= SALTO_MAX)
        bassoOK = TRUE;
    else
        bassoOK = FALSE;
    if (abs(tenoreMidiValueD - tenoreMidiValueT) <= SALTO_MAX)
        tenoreOK = TRUE;
    else
        tenoreOK = FALSE;
    if (abs(altoMidiValueD - altoMidiValueT) <= SALTO_MAX)
        altoOK = TRUE;
    else
        altoOK = FALSE;
    if (abs(sopranoMidiValueD - sopranoMidiValueT) <= SALTO_MAX)
        sopranoOK = TRUE;
    else
        sopranoOK = FALSE;
    //Verifica se restituire l'oggetto o scartarlo
    if (bassoOK == TRUE && tenoreOK == TRUE && altoOK == TRUE && sopranoOK == TRUE)
        return self;
    else
        return nil;
}
@end

@implementation Cadenza (Destructors)
-(void) dealloc {
    [typeOfPartiDominante release];
    typeOfPartiDominante = nil;
    [typeOfPartiTonica release];
    typeOfPartiTonica = nil;
	[fromChord release];
    fromChord = nil;
	[toChord release];
    toChord = nil;
	[super dealloc];
}
@end